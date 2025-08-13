# Infrastructure as Code with Terraform on GCP

A complete 3-tier web application infrastructure deployed on Google Cloud Platform using Terraform, demonstrating enterprise-grade DevOps practices and Infrastructure as Code principles.

## 🏗️ Architecture Overview

This project implements a scalable, secure, and cost-optimized 3-tier architecture:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Presentation   │    │   Application   │    │      Data       │
│     Tier        │    │      Tier       │    │     Tier        │
│                 │    │                 │    │                 │
│ Load Balancer   │───▶│ Compute Engine  │───▶│   Cloud SQL     │
│ (Global HTTP)   │    │   Instances     │    │    (MySQL)      │
│                 │    │ (Auto-scaling)  │    │   (Private)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## ✨ Features

### 🔧 Infrastructure Components
- **Global HTTP Load Balancer** with health checks
- **Managed Instance Groups** with auto-scaling (2-5 instances)
- **Cloud SQL MySQL** database with private networking
- **VPC Network** with custom subnets and firewall rules
- **Service Networking** for secure database connectivity

### 🛡️ Security & Best Practices
- Private database with VPC peering
- Least privilege IAM policies
- Proper firewall rules (HTTP/HTTPS/SSH)
- Health check endpoints for monitoring
- Secure service account configuration

### 📈 Scalability & Performance
- Auto-scaling based on CPU utilization (70% threshold)
- Regional deployment for high availability
- Load balancing across multiple instances
- Optimized machine types (e2-micro for cost efficiency)

### 💰 Cost Optimization
- Free tier eligible resources where possible
- Scheduled instance management
- Budget monitoring and alerts
- Resource tagging for cost tracking

## 🚀 Quick Start

### Prerequisites
- Google Cloud Platform account with billing enabled
- Terraform >= 1.0 installed
- gcloud CLI configured
- Required GCP APIs enabled

### 1. Clone and Setup
```bash
git clone https://github.com/engr-usman/terraform-gcp-three-tier-app.git
cd terraform-gcp-three-tier-app
```

### 2. Configure Variables
```bash
# Copy and edit the variables file
cp terraform.tfvars.example terraform.tfvars

# Update with your project details
vim terraform.tfvars
```

### 3. Deploy Infrastructure
```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Deploy infrastructure
terraform apply
```

### 4. Access Your Application
```bash
# Get load balancer IP
LB_IP=$(terraform output -raw load_balancer_ip)
echo "Application URL: http://$LB_IP"

# Test the deployment
curl http://$LB_IP
```

## 📁 Project Structure

```
terraform-gcp-three-tier-app/
├── main.tf                 # Root configuration
├── variables.tf            # Input variables
├── outputs.tf             # Output values
├── terraform.tfvars       # Variable values
├── modules/
│   ├── network/           # VPC, subnets, firewall rules
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/           # Instances, load balancer, auto-scaling
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── database/          # Cloud SQL configuration
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── scripts/
│   └── startup-script.sh  # Instance initialization script
└── README.md
```

## 🔧 Configuration Options

### Variables
| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `project_id` | GCP Project ID | - | Yes |
| `region` | GCP Region | `us-central1` | No |
| `instance_count` | Number of instances | `2` | No |
| `machine_type` | Instance machine type | `e2-micro` | No |
| `db_password` | Database password | - | Yes |

### Customization Examples

**Scale instances:**
```hcl
instance_count = 4
machine_type = "e2-small"
```

**Change regions:**
```hcl
region = "europe-west1"
zone   = "europe-west1-a"
```

**Database configuration:**
```hcl
db_name = "production_db"
db_user = "app_user"
```

## 📊 Monitoring & Management

### Health Checks
- **Endpoint:** `/health`
- **Interval:** 30 seconds
- **Timeout:** 5 seconds
- **Auto-healing:** Enabled

### Auto-scaling Policy
- **Min instances:** 2
- **Max instances:** 5
- **CPU threshold:** 70%
- **Cool-down period:** 60 seconds

### Cost Management
```bash
# View current costs
gcloud billing budgets list

# Set up budget alerts
terraform apply -var="budget_amount=50"
```

## 🧪 Testing

### Load Testing
```bash
# Install testing tools
sudo apt-get install apache2-utils

# Generate load
ab -n 1000 -c 10 http://$(terraform output -raw load_balancer_ip)/
```

### Database Connectivity
```bash
# SSH into instance
gcloud compute ssh web-server-xxxx --zone=us-central1-a

# Test database connection
mysql -h [DB_PRIVATE_IP] -u webapp_user -p webapp_db
```

### Health Check Validation
```bash
# Check backend health
gcloud compute backend-services get-health web-server-backend --global

# Monitor auto-scaling
watch gcloud compute instance-groups managed list
```

## 🔄 CI/CD Integration

This infrastructure supports CI/CD integration:

```yaml
# Example GitHub Actions workflow
- name: Deploy Infrastructure
  run: |
    terraform init
    terraform plan
    terraform apply -auto-approve
```

## 🐛 Troubleshooting

### Common Issues

**Database connection failed:**
```bash
# Check VPC peering status
gcloud services vpc-peerings list --network=terraform-vpc

# Verify private service connection
gcloud compute addresses list --global --filter="purpose=VPC_PEERING"
```

**Load balancer not responding:**
```bash
# Check instance health
gcloud compute backend-services get-health web-server-backend --global

# View instance startup logs
gcloud compute instances get-serial-port-output INSTANCE_NAME
```

**Terraform state issues:**
```bash
# Refresh state
terraform refresh

# Import existing resources
terraform import google_compute_instance.example PROJECT_ID/ZONE/INSTANCE_NAME
```

## 💡 Best Practices Implemented

1. **Modular Design:** Reusable components for different environments
2. **Security First:** Private networking, minimal IAM permissions
3. **Scalability:** Auto-scaling with proper health checks
4. **Cost Optimization:** Right-sized resources, scheduled operations
5. **Monitoring:** Comprehensive logging and alerting
6. **Documentation:** Inline comments and comprehensive README

## 🧹 Cleanup

```bash
# Destroy all resources
terraform destroy -auto-approve

# Verify cleanup
gcloud compute instances list
gcloud sql instances list
```

## 📚 Additional Resources

- [Terraform GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Google Cloud Architecture Center](https://cloud.google.com/architecture)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♂️ Support

If you have questions or need help:
- Create an [Issue](https://github.com/engr-usman/terraform-gcp-three-tier-app)
- Connect with me on [LinkedIn](https://www.linkedin.com/in/engrusman-ahmad/)
- Check out my [Medium articles](https://medium.com/@engr-syedusmanahmad)

## ⭐ Acknowledgments

- Google Cloud Platform documentation
- Terraform community resources
- DevOps best practices from industry experts

---

**Built with ❤️ for the DevOps community**

*Star this repo if you found it helpful!* ⭐