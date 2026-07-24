# Day 9 Challenge: ECS Fargate Production Deployment

## Outcome
- Multi-stage non-root Node.js image
- Jenkins uses `github-token`, `docker-hub-creds`, and `aws-cred`
- Immutable Docker image tags
- Trivy image scan
- Two-AZ VPC with public ALB and private ECS tasks
- NAT egress, CloudWatch Logs, Container Insights
- ECS deployment circuit breaker and automatic rollback
- CPU and memory autoscaling
- S3 remote Terraform state with lockfile

## First steps
```bash
cd docker/day9-app
npm install
npm test

git add docker/day9-app/package-lock.json
```
Create public Docker Hub repository: `raj358822/day9-ecs-app`.
Reuse the Day 8 state bucket: `raj358822-devops-100-days-tfstate`.

## Jenkins job
- Repository: `https://github.com/rajeshkumarbasani/devops-100-days.git`
- Credential: `github-token`
- Branch: `*/main`
- Script: `jenkins/day9-pipeline/Jenkinsfile`

## Manual Terraform
```bash
cd terraform/day9/env/dev
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform validate
terraform plan -var='container_image=raj358822/day9-ecs-app:manual'
```

## Cost warning
ALB, NAT Gateway, public IPv4, CloudWatch and Fargate are billable. Destroy after practice.

## Cleanup
```bash
terraform destroy -var='container_image=raj358822/day9-ecs-app:YOUR_TAG'
```
Keep the shared Terraform state bucket for future days.

## Mini Quiz
1. Why must Fargate ALB targets use IP target type?
2. Why are tasks in private subnets?
3. What does the NAT Gateway provide?
4. What does the deployment circuit breaker do?
5. Why ignore `desired_count` changes in Terraform?
6. Difference between task role and execution role?
7. Container health check vs ALB health check?
8. Why deploy an immutable image tag?

## Homework
1. Add ACM HTTPS and HTTP-to-HTTPS redirect.
2. Add Route 53 DNS.
3. Replace Docker Hub with Amazon ECR.
4. Add WAF to the ALB.
5. Add CloudWatch alarms and SNS.
6. Add ALB access logs to S3.
7. Use one NAT Gateway per AZ for production.
8. Add staging under `env/staging`.
9. Implement CodeDeploy blue/green deployment.
10. Add ECS Exec troubleshooting documentation.
