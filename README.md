# tf-aws-infra

This terraform setup include one vpc, three public subnet, three private subnet, one public route table that associate one internet gateway and public subnets, and one private route table associate private subnets.

## Setup
The following variables need to be provide in file `terraform.tfvars` to create the infra successfully
```tfvars
vpc_cidr      = 
subnet_number = 
region        =
```