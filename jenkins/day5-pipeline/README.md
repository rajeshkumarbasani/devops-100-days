# Day 5 Jenkins Pipeline

## Overview

This directory contains the Jenkins pipeline configuration for Day 5, which builds and tests the Docker app at `docker/day5-app` and validates/applies Terraform in `terraform/day5/env/dev`.

## Jenkins Pipeline Setup

1. Create a new Jenkins job:
   - New Item → Pipeline
   - Name: `Day5-Docker-Terraform-Pipeline`

2. Configure the pipeline:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository: `https://github.com/rajeshkumarbasani/devops-100-days.git`
   - Branch: `*/main`
   - Script Path: `jenkins/day5-pipeline/Jenkinsfile`

## Prerequisites

- Jenkins agent with Docker installed and running
- Jenkins agent with Terraform installed
- Git access to the repository
- Permissions to run Docker containers and Terraform commands

## Pipeline Stages

The pipeline performs the following stages:

- `Checkout`: clones the repository
- `Docker Build`: builds the Docker image from `docker/day5-app`
- `Docker Test`: runs the container and verifies it responds on port `80`
- `Terraform Init`: initializes Terraform in `terraform/day5/env/dev`
- `Terraform Format`: checks Terraform formatting with `terraform fmt -check -recursive`
- `Terraform Validate`: validates the Terraform configuration
- `Terraform Plan`: creates a Terraform execution plan
- `Terraform Approve and Apply`: prompts for approval, then applies Terraform with `-auto-approve`

## Notes

- The Docker app is located at `docker/day5-app`
- The Terraform configuration is located at `terraform/day5/env/dev`
- The job uses `jenkins/day5-pipeline/Jenkinsfile` for the pipeline definition
- If your repository, branch, or job name differ, update the Jenkins job settings accordingly
