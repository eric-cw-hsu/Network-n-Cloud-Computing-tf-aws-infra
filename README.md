# tf-aws-infra

This terraform setup include one vpc, three public subnet, three private subnet, one public route table that associate one internet gateway and public subnets, and one private route table associate private subnets.

## Setup
The following variables need to be provide in file `terraform.tfvars` to create the infra successfully
```tfvars
vpc_name      = 
vpc_cidr      = 
subnet_number = 
region        =
ami_id        =
database_password = 
certificate_arn   =
sendgrid_api_key  =
email_sender_address  =
email_sender_name     =

instance_type (optional) = 

database_instance_class (optional) = 
database_max_connections (optional) = 
database_shared_buffers (optional) =

autoscaling_low_threshold (optional) = 
autoscaling_high_threshold (optional) = 
```

## SSL Certificate (Let's Encrypt)
```bash
# Create SSL Certificate with Certbot (Let's Encrypt)
$ brew install cerbot
$ pip install certbot-dns-route53
$ certbot certonly \
  --non-interactive \
  --dns-route53 \
  --agree-tos \
  --email mail@example.com \
  --domain example.com

# Upload certificate to AWS Certificate Manager with cli
$ aws acm import-certificate \
    --certificate fileb:///etc/letsencrypt/live/example.com/cert.pem \
    --certificate-chain fileb:///etc/letsencrypt/live/example.com/chain.pem \
    --private-key fileb:///etc/letsencrypt/live/example.com/privkey.pem
```