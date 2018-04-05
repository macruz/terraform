Terraform Example: Deploying CoreOS on AWS and running an image of Gollum
=========================================================================

 
The purpose of this exercise is an initial introduction to AWS deployment using terraform.

This is achieved by:
- creating a VPC with a security group, allowing SSH access, icmp and http/80 
- instantiating a VM based on latest CoreOS AMI (at this time)
- running a custom service that will pull a docker image pre-built with [Gollum](https://github.com/gollum/gollum) and run it (exposing it on port 80 for public access)

If you want to access via SSH, you need create a [key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair)  and set the `key_name` property in `main.tf` accordingly.

You will need to create the `terraform.tfvars` file with your AWS credentials in order for this to work, for example:
```
region = "eu-west-1"
access_key = "insert-your-access-key-here"
secret_key = "insert-your-secret-here"
```


The custom systemd-based service is defined in `gollum.conf` which is set on `user_data` property of the EC2 module in `main.tf`.  

Once done, you can plan your deploy with:

```
terraform plan
```

Afterwards, you can then apply your configuration:
```
terraform apply
```

This will take a bit and at end will output the result with the information you requested on `output.tf`.



You can also run Gollum locally with Docker as described [here](https://github.com/gollum/gollum/wiki/Gollum-via-Docker)
