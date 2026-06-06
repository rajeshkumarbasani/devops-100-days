# Day 4 App Jenkins Pipeline

## Overview

This directory contains the Day 4 Docker app and the Jenkins pipeline setup instructions for building, testing, and deploying it with Terraform.

## Jenkins Pipeline Setup

1. Create a new Jenkins job:
   - New Item → Pipeline
   - Name: `Day4-Docker-Terraform-Pipeline`

2. Configure the pipeline:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository: `https://github.com/rajeshkumarbasani/devops-100-days.git`
   - Branch: `*/main`
   - Script Path: `jenkins/day4-pipeline/Jenkinsfile`

## Prerequisites

- Jenkins agent with Docker installed and running
- Jenkins agent with Terraform installed
- Git access to the repository
- Sufficient permissions to run Docker containers and Terraform actions

## Pipeline Stages

The pipeline executes the following stages:

- `Checkout`: clone the repository
- `Docker Build`: build the Docker image from `docker/day4-app`
- `Docker Test`: run the container and verify it responds on port `8084`
- `Terraform Init`: initialize Terraform in `terraform/day4-modules/env/dev`
- `Terraform Validate`: format and validate Terraform configuration
- `Terraform Plan`: create a Terraform execution plan
- `Terraform Apply`: apply the Terraform plan with `-auto-approve`

## Notes

- The Docker project is located in `docker/day4-app`
- The Jenkins pipeline definition is in `jenkins/day4-pipeline/Jenkinsfile`
- Update the job name, branch, or repository settings if your environment differs
