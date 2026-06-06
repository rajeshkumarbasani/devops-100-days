# Security Policy

## Reporting a Vulnerability

We value security for the **devops-100-days** project and urge you to report any vulnerabilities responsibly. Your efforts help us maintain the integrity and safety of this DevOps learning resource.

### How to Report

- **Preferred Method**: Create a private vulnerability report via GitHub:
  1. Navigate to the [Security tab](https://github.com/rajeshkumarbasani/devops-100-days/security) of this repository
  2. Click "Report a vulnerability"
  3. Provide a detailed description of the issue
  4. GitHub will notify the repository maintainer privately

- **Alternative Method**: Email directly to the maintainer:
  - Email: [raj358822@gmail.com]

### What to Include

When reporting a vulnerability, please provide:
- Type of vulnerability (e.g., exposed secrets, insecure configuration, dependency issue)
- Steps to reproduce the issue
- Potential impact assessment
- Suggested fix (if you have one)
- Any relevant code snippets or configuration files

### Response Timeline

- We aim to acknowledge vulnerability reports within **7 days**
- We will provide a status update within **14 days**
- Critical vulnerabilities will be addressed with priority

## Supported Versions

This security policy applies to:
- The current main branch of the repository
- All active releases (check the [Releases page](https://github.com/rajeshkumarbasani/devops-100-days/releases))

## Security Best Practices for This Project

As a DevOps-focused repository, we follow these security principles:

| Practice | Implementation |
|----------|----------------|
| **Secret Management** | Never commit AWS credentials, API keys, or passwords. Use environment variables or AWS IAM roles [web:1] |
| **Dependency Scanning** | Regularly update Terraform, Docker, and Jenkins dependencies to patch known vulnerabilities [web:1] |
| **Access Control** | Use IAM roles with minimal permissions; review cPanel/WHM user access regularly [web:1] |
| **Code Review** | All changes to infrastructure code (Terraform) require peer review before merging [web:6] |
| **CI/CD Security** | Jenkins pipelines use authenticated steps; secrets are injected via environment variables [web:1] |

## What We Don't Accept

- Vulnerability reports for obsolete versions not in the "Supported Versions" list
- Issues related to third-party services outside our control (e.g., AWS platform-level issues)
- Social engineering or physical security attacks on the maintainer

## Disclosure Policy

- We will not disclose your identity without your consent
- We may publish a summary of the vulnerability after it's resolved (with your permission)
- Critical vulnerabilities will be patched and disclosed within 30 days of resolution

---

**Project Maintainer**: Rajeshkumar Basani  
**Location**: Pune, Maharashtra, IN  
**Last Updated**: June 2026

---

### How to Add This to Your Repository

1. Navigate to your repo: [https://github.com/rajeshkumarbasani/devops-100-days](https://github.com/rajeshkumarbasani/devops-100-days.git) [web:1]
2. Click **Security** → **Policy** → **Start setup** [web:1][web:6]
3. Create `SECURITY.md` with the content above
4. Commit with message: "Add security policy for vulnerability reporting" [web:1]

This policy aligns with GitHub's official security policy guidelines and provides clear instructions for your DevOps-focused project [web:1].
