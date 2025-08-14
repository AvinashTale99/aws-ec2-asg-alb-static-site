# AWS EC2 Auto Scaling Group with Load Balancer & Static Website

This project demonstrates deploying a static website on **Amazon EC2** instances managed by an **Auto Scaling Group (ASG)** and distributed via an **Application Load Balancer (ALB)**. Each instance is automatically configured using a **User Data bootstrap script**.

## Architecture Overview

- **Launch Template** — Defines EC2 configuration (AMI, instance type, security groups, and bootstrap script).
- **Auto Scaling Group** — Manages multiple EC2 instances for high availability.
- **Application Load Balancer** — Distributes traffic to healthy targets.
- **Target Group** — Registers and monitors EC2 instances via health checks.
- **Amazon Linux 2** — Base AMI used for EC2 instances.
- **Apache HTTP Server** — Hosts the static website.
- **GitHub Repo** — Stores static website content.

## Steps (AWS Console)

### 1. Create a Launch Template
1. Go to **EC2 → Launch Templates → Create launch template**.
2. Provide a template name.
3. Choose **Amazon Linux 2 AMI**.
4. Select an instance type (e.g., `t2.micro`).
5. Choose a security group allowing **HTTP (80)**, **HTTPS (443)**, and **SSH (22)**.
6. In **Advanced Details → User data**, paste the following script:

```bash
#!/bin/bash
yum update -y
yum install -y httpd git
systemctl start httpd
systemctl enable httpd
usermod -aG apache ec2-user
chmod 755 /var/www/html
cd /var/www/html
git clone https://github.com/AvinashTale99/ec2-static-website.git
cp -r aws-ec2-s3-static-website/* /var/www/html/
rm -rf aws-ec2-s3-static-website
echo "<h1>Hello from $(hostname -f) webserver</h1>" >> /var/www/html/index.html
```

### 2. Create an Auto Scaling Group
1. Go to **EC2 → Auto Scaling Groups → Create Auto Scaling group**.
2. Select your **Launch Template**.
3. Choose your **VPC** and **Subnets** (multiple AZs for high availability).
4. Configure desired capacity (e.g., min=2, max=4).
5. Attach the ASG to a **Target Group** (create it if not already existing).
6. Set health checks to **EC2 + ELB**.
7. Create the ASG.

### 3. Create a Target Group
1. Go to **EC2 → Target Groups → Create target group**.
2. Select **Instances** as the target type.
3. Choose your **VPC**.
4. Configure health checks (Path = `/`).
5. Create the target group.

### 4. Create an Application Load Balancer
1. Go to **EC2 → Load Balancers → Create Load Balancer**.
2. Select **Application Load Balancer**.
3. Set it to **Internet-facing**.
4. Add listeners (HTTP:80).
5. Choose **Subnets** in multiple AZs.
6. Select the previously created **Target Group**.
7. Create the ALB.

### 5. Verify the Setup
- Open the ALB's **DNS Name** in a browser.
- Refresh multiple times — you should see:
  ```
  Hello from <hostname> webserver
  ```
  The hostname will change as requests are routed to different EC2 instances.

### Testing Scaling
1. Lower the ASG desired capacity to 1 and see instances terminate.
2. Increase it to 3–4 and see new instances launch automatically.
3. ALB will automatically include new healthy instances.

### Cleanup
To avoid charges:
1. Delete the Auto Scaling Group.
2. Delete the Load Balancer.
3. Delete the Target Group.
4. Delete any remaining EC2 instances.
5. Delete the Launch Template.

## Author
**Avinash Tale**  
GitHub: [AvinashTale99](https://github.com/AvinashTale99)  
Email: aatale99@gmail.com
