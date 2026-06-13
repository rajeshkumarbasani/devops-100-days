# Day 6: End-to-End Pipeline Setup Guide

## Overview

This is a comprehensive end-to-end Jenkins pipeline (Day 6) that demonstrates CI/CD best practices by integrating:
- **Docker**: Application containerization and testing
- **Terraform**: Infrastructure as Code (IaC) deployment
- **Security Scanning**: Basic image inspection and validation
- **Manual Approvals**: Human-in-the-loop deployment checks

The pipeline orchestrates building a containerized Nginx application, validating it, and then provisioning cloud infrastructure using Terraform.

---

## Prerequisites

Before setting up this pipeline, ensure you have:

### Jenkins Requirements
- Jenkins server is installed and running
- Jenkins has Docker plugin installed
- Docker is installed on the Jenkins agent machine
- Terraform is installed on the Jenkins agent machine
- Git is installed and configured
- Jenkins agent has appropriate permissions to run `docker` and `terraform` commands

### Cloud Infrastructure
- AWS credentials configured on Jenkins agent (for Terraform AWS provider)
- IAM permissions to create EC2 instances, VPCs, and related resources

### Repository Access
- Access to the GitHub repository: `https://github.com/rajeshkumarbasani/devops-100-days.git`
- Jenkins SSH key or GitHub token configured for repository access

---

## Pipeline Setup Instructions

### Step 1: Create Jenkins Pipeline Job

1. Log in to your Jenkins dashboard
2. Click **New Item** in the left sidebar
3. Enter job name: `Day6-End-to-End-Pipeline`
4. Select **Pipeline** and click **OK**

### Step 2: Configure Pipeline Source

In the job configuration page:

1. Navigate to **Pipeline** section at the bottom
2. Select **Pipeline script from SCM** from the "Definition" dropdown
3. Choose **Git** as the SCM type
4. Fill in the following details:

| Field | Value |
|-------|-------|
| **Repository URL** | `https://github.com/rajeshkumarbasani/devops-100-days.git` |
| **Credentials** | Select appropriate GitHub credentials (or use Public repo) |
| **Branch Specifier** | `*/main` |
| **Script Path** | `jenkins/day6-pipeline/Jenkinsfile` |

### Step 3: Configure Additional Settings (Optional)

- **Poll SCM**: Set schedule to trigger builds automatically (e.g., `H * * * *` for hourly)
- **GitHub webhook**: Configure GitHub to automatically trigger builds on push
- **Build Triggers**: Enable "Build when a change is pushed to GitHub"

### Step 4: Save and Run

1. Click **Save** at the bottom
2. Click **Build Now** to trigger the first build
3. Monitor the build progress in the **Build History**

---

## Pipeline Stages Explained

### 1. **Checkout**
Clones the repository and checks out the specified branch (`main`)

### 2. **Docker Build**
- Builds a Docker image from `docker/day6-app/Dockerfile`
- Tags image with build number and `latest` tag
- Uses `--no-cache` flag to ensure fresh build

**Environment Variables Used:**
- `DOCKER_IMAGE`: `day6-nginx-app`

### 3. **Docker Security Check Basic**
- Inspects the built Docker image
- Reviews image history and layers
- Helps identify security issues and image size

### 4. **Docker Run Test**
- Removes any existing container with the same name
- Runs the Docker container
- Waits 5 seconds for the application to start
- Validates application health by checking HTTP endpoints:
  - `http://localhost:8086/`
  - `http://localhost:8086/health`

**Environment Variables Used:**
- `DOCKER_CONTAINER`: `day6-nginx`
- `APP_PORT`: `8086`

### 5. **Terraform Init**
Initializes Terraform working directory and downloads provider plugins

**Directory:** `terraform/day6/env/dev/`

### 6. **Terraform Format Check**
Validates that all Terraform files follow correct formatting standards

**Command:** `terraform fmt -check -recursive`

### 7. **Terraform Validate**
Checks Terraform configuration syntax and consistency

### 8. **Terraform Plan**
Creates an execution plan showing what infrastructure changes will be made

**Output:** Saved to `tfplan` for later use

### 9. **Manual Approval**
⚠️ **Pipeline pauses here** - Requires manual review and approval before proceeding to infrastructure deployment

This is a critical security checkpoint where you can review the Terraform plan

### 10. **Terraform Apply**
Deploys infrastructure as planned after approval

**Command:** `terraform apply -auto-approve tfplan`

### 11. **Show Terraform Output**
Displays outputs from Terraform (IP addresses, DNS names, etc.)

### Post-Build Cleanup
- **Always**: Removes test Docker container and cleans up unused images
- **Success**: Logs successful completion
- **Failure**: Logs pipeline failure for debugging

---

## Environment Variables

The pipeline uses the following environment variables. Modify these as needed in the Jenkinsfile:

```groovy
DOCKER_IMAGE = "day6-nginx-app"      # Docker image name
DOCKER_CONTAINER = "day6-nginx"      # Docker container name
APP_PORT = "8086"                    # Application port for testing
TF_DIR = "terraform/day6/env/dev"    # Terraform working directory
```

---

## Pipeline Options Configuration

The pipeline includes the following options:

| Option | Value | Purpose |
|--------|-------|---------|
| `timestamps()` | - | Adds timestamps to console output |
| `disableConcurrentBuilds()` | - | Prevents multiple concurrent builds |
| `buildDiscarder` | Keep 10 builds | Automatically cleans old build logs |
| `timeout` | 30 minutes | Aborts build if it exceeds 30 minutes |

---

## Troubleshooting

### Build Fails at Docker Build Stage
**Problem**: Docker build fails with permission errors

**Solution**:
- Ensure Jenkins user is in the `docker` group: `usermod -aG docker jenkins`
- Restart Jenkins service: `systemctl restart jenkins`

### Terraform Apply Fails
**Problem**: AWS credentials not found or invalid

**Solution**:
- Verify AWS credentials on Jenkins agent: `aws configure`
- Check IAM permissions for the credentials
- Ensure credentials file is readable by Jenkins user

### Docker Container Health Check Fails
**Problem**: `curl -f http://localhost:8086` returns error

**Solution**:
- Verify application is properly configured in `docker/day6-app/`
- Check Docker container logs: `docker logs day6-nginx`
- Ensure port 8086 is not already in use: `netstat -an | grep 8086`

### Manual Approval Stage Never Proceeds
**Problem**: Pipeline stuck waiting for approval

**Solution**:
- Click **Input** link in Jenkins UI to review and approve/reject
- Or use Jenkins CLI: `echo 'proceed' | java -jar jenkins-cli.jar input Day6...`

---

## Best Practices

✅ **Do's:**
- Review Terraform plan before approving deployment
- Monitor build logs for warnings and deprecations
- Regularly update Docker base images for security patches
- Use appropriate AWS IAM roles with least privilege
- Keep Jenkins and plugins updated

❌ **Don'ts:**
- Don't approve Terraform changes without reviewing the plan
- Don't use hardcoded credentials in Jenkinsfile
- Don't skip security checks
- Don't run pipeline in production without thorough testing

---

## Next Steps

1. Review the Terraform configuration in `terraform/day6/`
2. Check Docker configuration in `docker/day6-app/`
3. Customize environment variables as needed
4. Test pipeline in a staging environment first
5. Set up notifications (Slack, email) for build failures

---

## Related Files

- **Jenkinsfile**: Pipeline definition and stages
- **Docker Config**: `docker/day6-app/Dockerfile`, `docker/day6-app/nginx.conf`
- **Terraform Config**: `terraform/day6/env/dev/` and `terraform/day6/modules/`

---

## Support & Documentation

For more information:
- Jenkins Pipeline Documentation: https://jenkins.io/doc/book/pipeline/
- Terraform Documentation: https://www.terraform.io/docs/
- Docker Documentation: https://docs.docker.com/