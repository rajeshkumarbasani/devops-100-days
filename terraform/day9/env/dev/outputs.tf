output "vpc_id" { value=module.network.vpc_id }
output "ecs_cluster_name" { value=module.ecs.cluster_name }
output "ecs_service_name" { value=module.ecs.service_name }
output "task_definition_arn" { value=module.ecs.task_definition_arn }
output "application_url" { value=module.ecs.application_url }
output "health_url" { value=module.ecs.health_url }
output "cloudwatch_log_group" { value=module.ecs.cloudwatch_log_group }
