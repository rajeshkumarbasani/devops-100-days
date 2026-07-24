data "aws_region" "current" {}
locals { name = "${var.project_name}-${var.environment}" }
resource "aws_cloudwatch_log_group" "app" {
  name = "/ecs/${local.name}"
  retention_in_days = var.log_retention_days
  tags = var.tags
}
resource "aws_ecs_cluster" "this" {
  name = "${local.name}-cluster"
  setting { name = "containerInsights", value = "enabled" }
  tags = var.tags
}
resource "aws_iam_role" "execution" {
  name = "${local.name}-ecs-execution-role"
  assume_role_policy = jsonencode({Version="2012-10-17",Statement=[{Effect="Allow",Principal={Service="ecs-tasks.amazonaws.com"},Action="sts:AssumeRole"}]})
  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "execution" {
  role = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role" "task" {
  name = "${local.name}-ecs-task-role"
  assume_role_policy = jsonencode({Version="2012-10-17",Statement=[{Effect="Allow",Principal={Service="ecs-tasks.amazonaws.com"},Action="sts:AssumeRole"}]})
  tags = var.tags
}
resource "aws_security_group" "alb" {
  name_prefix = "${local.name}-alb-"
  description = "Public ALB"
  vpc_id = var.vpc_id
  ingress { description="HTTP", protocol="tcp", from_port=80, to_port=80, cidr_blocks=["0.0.0.0/0"] }
  egress { protocol="-1", from_port=0, to_port=0, cidr_blocks=["0.0.0.0/0"] }
  tags = merge(var.tags, {Name="${local.name}-alb-sg"})
  lifecycle { create_before_destroy = true }
}
resource "aws_security_group" "service" {
  name_prefix = "${local.name}-service-"
  description = "ECS traffic from ALB only"
  vpc_id = var.vpc_id
  ingress { protocol="tcp", from_port=var.container_port, to_port=var.container_port, security_groups=[aws_security_group.alb.id] }
  egress { protocol="-1", from_port=0, to_port=0, cidr_blocks=["0.0.0.0/0"] }
  tags = merge(var.tags, {Name="${local.name}-service-sg"})
  lifecycle { create_before_destroy = true }
}
resource "aws_lb" "this" {
  name = substr("${local.name}-alb",0,32)
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id]
  subnets = var.public_subnet_ids
  drop_invalid_header_fields = true
  tags = var.tags
}
resource "aws_lb_target_group" "app" {
  name = substr("${local.name}-tg",0,32)
  port = var.container_port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc_id
  deregistration_delay = 30
  health_check { enabled=true, path=var.health_check_path, matcher="200", interval=30, timeout=5, healthy_threshold=2, unhealthy_threshold=3 }
  tags = var.tags
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
  default_action { type="forward", target_group_arn=aws_lb_target_group.app.arn }
}
resource "aws_ecs_task_definition" "app" {
  family = local.name
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = tostring(var.task_cpu)
  memory = tostring(var.task_memory)
  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn = aws_iam_role.task.arn
  runtime_platform { operating_system_family="LINUX", cpu_architecture="X86_64" }
  container_definitions = jsonencode([{name="app",image=var.container_image,essential=true,readonlyRootFilesystem=true,portMappings=[{name="http",containerPort=var.container_port,hostPort=var.container_port,protocol="tcp",appProtocol="http"}],environment=[{name="NODE_ENV",value="production"},{name="PORT",value=tostring(var.container_port)},{name="APP_VERSION",value=var.container_image}],linuxParameters={initProcessEnabled=true},healthCheck={command=["CMD-SHELL","node -e \"fetch('http://127.0.0.1:${var.container_port}${var.health_check_path}').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))\""],interval=30,timeout=5,retries=3,startPeriod=20},logConfiguration={logDriver="awslogs",options={awslogs-group=aws_cloudwatch_log_group.app.name,awslogs-region=data.aws_region.current.name,awslogs-stream-prefix="app"}}}])
  tags = var.tags
}
resource "aws_ecs_service" "app" {
  name = "${local.name}-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count = var.desired_count
  launch_type = "FARGATE"
  health_check_grace_period_seconds = 60
  enable_execute_command = true
  wait_for_steady_state = true
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  deployment_circuit_breaker { enable=true, rollback=true }
  network_configuration { subnets=var.private_subnet_ids, security_groups=[aws_security_group.service.id], assign_public_ip=false }
  load_balancer { target_group_arn=aws_lb_target_group.app.arn, container_name="app", container_port=var.container_port }
  lifecycle { ignore_changes=[desired_count] }
  depends_on = [aws_lb_listener.http, aws_iam_role_policy_attachment.execution]
  tags = var.tags
}
resource "aws_appautoscaling_target" "service" {
  max_capacity=var.max_capacity
  min_capacity=var.min_capacity
  resource_id="service/${aws_ecs_cluster.this.name}/${aws_ecs_service.app.name}"
  scalable_dimension="ecs:service:DesiredCount"
  service_namespace="ecs"
}
resource "aws_appautoscaling_policy" "cpu" {
  name="${local.name}-cpu"
  policy_type="TargetTrackingScaling"
  resource_id=aws_appautoscaling_target.service.resource_id
  scalable_dimension=aws_appautoscaling_target.service.scalable_dimension
  service_namespace=aws_appautoscaling_target.service.service_namespace
  target_tracking_scaling_policy_configuration { target_value=var.cpu_target_value, scale_in_cooldown=120, scale_out_cooldown=60, predefined_metric_specification { predefined_metric_type="ECSServiceAverageCPUUtilization" } }
}
resource "aws_appautoscaling_policy" "memory" {
  name="${local.name}-memory"
  policy_type="TargetTrackingScaling"
  resource_id=aws_appautoscaling_target.service.resource_id
  scalable_dimension=aws_appautoscaling_target.service.scalable_dimension
  service_namespace=aws_appautoscaling_target.service.service_namespace
  target_tracking_scaling_policy_configuration { target_value=var.memory_target_value, scale_in_cooldown=120, scale_out_cooldown=60, predefined_metric_specification { predefined_metric_type="ECSServiceAverageMemoryUtilization" } }
}
