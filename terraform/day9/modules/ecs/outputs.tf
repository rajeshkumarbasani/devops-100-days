output "cluster_name" { value = aws_ecs_cluster.this.name }
output "service_name" { value = aws_ecs_service.app.name }
output "task_definition_arn" { value = aws_ecs_task_definition.app.arn }
output "application_url" { value = "http://${aws_lb.this.dns_name}" }
output "health_url" { value = "http://${aws_lb.this.dns_name}${var.health_check_path}" }
output "cloudwatch_log_group" { value = aws_cloudwatch_log_group.app.name }
