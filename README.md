![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900)
![Infrastructure as Code](https://img.shields.io/badge/Practice-Infrastructure%20as%20Code-0A66C2)
![Cloud Security](https://img.shields.io/badge/Focus-Cloud%20Security-D13212)
![CSPM](https://img.shields.io/badge/Concept-CSPM-1D8102)

# All Things AWS — Infrastructure Deployment

This repository is a **production-grade Infrastructure as Code (IaC) security showcase**, built entirely with **Terraform**. It demonstrates how **security-first AWS infrastructure** is designed, modularised, and deployed — embedding defence-in-depth guardrails at every layer of the stack rather than bolting them on after the fact.

The project is structured around a **reusable module library** that provisions a complete, secure, multi-tier AWS environment. Each module is independently maintainable, consistently tagged, and built to reflect **real-world engineering and cloud security standards**.

---

## What This Project Deploys

A fully wired, multi-AZ AWS environment provisioned entirely through code:

| Layer | Module | What it builds |
|---|---|---|
| Network | `VPC` | VPC, public/private/database subnets across 2 AZs, IGW, NAT Gateway, public + private route tables, VPC Flow Logs → S3 |
| DNS Observability | `ROUTE-53` | Route53 Resolver Query Logging → S3 |
| Storage | `S3` | Dual S3 buckets with versioning, lifecycle tiering (Standard → IA → Glacier → Deep Archive), and cross-bucket replication |
| Security Groups | `SG` | ALB security group (HTTP/HTTPS from internet) + EC2 security group (traffic from ALB only) |
| Load Balancing | `ALB` | Internet-facing Application Load Balancer, target group, HTTP listener, access logs → S3 |
| WAF | `ALB` | WAFv2 Web ACL with AWS Managed Rules (Common, Known Bad Inputs, SQLi) + custom rate limiting (3,000 req/5 min) + URI size protection. Logs → S3 + CloudWatch (3-day retention) |
| Compute | `EC2` | Auto Scaling Group (min 1, desired 2, max 6) via Launch Template — instances in private subnets, ELB health checks, encrypted gp3 volumes, registered to ALB target group |

---

## Security Principles Applied

- **Network segmentation** — public subnets for the ALB and NAT Gateway only; EC2 instances live in private subnets and are never directly internet-facing
- **Outbound-only internet access** — private subnet instances reach the internet via NAT Gateway for package installs and updates, with no inbound exposure
- **Least privilege security groups** — EC2 instances only accept traffic from the ALB security group, not the open internet
- **WAF protection** — OWASP Top 10 coverage, SQL injection protection, Log4j/SSRF mitigation, and IP-based rate limiting out of the box
- **Encryption at rest** — all EC2 root volumes encrypted with gp3
- **Observability by default** — VPC Flow Logs, DNS Query Logs, ALB Access Logs, and WAF Logs all captured and retained in S3
- **Short-lived log retention** — WAF CloudWatch logs expire after 3 days to manage cost while preserving real-time visibility
- **Consistent tagging** — every resource carries environment, cost centre, owner, team, and repo tags for governance and cost allocation
- **S3 data durability** — lifecycle policies automatically tier objects to cheaper storage classes; replication provides cross-bucket redundancy

---

## Repository Structure

```
├── Environment/
│   └── Dev/                        # Dev environment root — run terraform here
│       ├── main.tf                 # Module composition
│       ├── variable.tf
│       ├── terraform.tfvars
│       ├── provider.tf
│       ├── backend.tf
│       └── version.tf
│
├── Modules/
│   ├── VPC/
│   ├── S3/
│   ├── ROUTE-53/
│   ├── SG/
│   ├── ALB/                        # Includes WAF, WAF rules, ALB logs, WAF logs
│   ├── EC2/                        # Launch Template + Auto Scaling Group
│   ├── RDS/                        # Planned
│   ├── CLOUDFRONT/                 # Planned
│   ├── API-GATEWAY/                # Planned
│   ├── EFS/                        # Planned
│   ├── REDIS/                      # Planned
│   ├── DYNAMO-DB/                  # Planned
│   ├── SQS-QUEUE/                  # Planned
│   ├── KINESIS/                    # Planned
│   ├── TGW/                        # Planned
│   └── GA/                         # Planned
│
└── Scripts/
    └── user-data/
        ├── techmax.sh              # TechMax web app bootstrap
        └── dev-userdata-web.sh     # Apache hello-world bootstrap
```

---

## Getting Started

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- An existing EC2 key pair in your target region

### Deploy the Dev Environment

```bash
cd Environment/Dev

# Update terraform.tfvars with your values:
#   ami_id        — Amazon Linux 2 AMI for your region
#   key_name      — your EC2 key pair name

terraform init
terraform plan
terraform apply
```

---

## Architecture Diagram

![All Things AWS Infrastructure](https://github.com/GabrielBoyowaOfficial/all-things-aws-repository-infrastructure-deployment/blob/6a0723d5707b77c5e5e56dec6a6760c66fbfab19/All-Things-AWS-Infra.drawio.svg)

---

> **Development Note:** All sensitive backend configurations and environment-specific metadata are excluded via `.gitignore` to preserve the security integrity of this repository.
