# Creating public S3 Bucket in AWS cloud and update Bucket policy to allow access to the bucket only from whitelisted public IPs

To create a public S3 bucket in AWS and update its bucket policy to allow access from whitelisted public IPs, follow these steps:

Install and configure the AWS CLI and Terraform on your local machine.

Create a new Terraform configuration file and specify the AWS provider details.


```
provider "aws" {
  region     = "us-east-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
}


```
Create a new S3 bucket resource in your Terraform configuration file and specify the bucket properties.

```
resource "aws_s3_bucket" "example" {
  bucket        = "example-bucket"
  acl           = "public-read"
  force_destroy = true
}


```

Create a new S3 bucket policy resource in your Terraform configuration file and specify the policy properties. In this policy, you can use the aws_ip_range resource to specify the whitelisted public IP ranges that are allowed to access the bucket.



```
  resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.example.id}/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "${data.aws_ip_range.whitelist.cidr_blocks}"
        }
      }
    }
  ]
}
EOF
}

data "aws_ip_range" "whitelist" {
  cidr_blocks = ["192.0.2.0/24"]
}

```
Run the terraform apply command to create the S3 bucket and update the bucket policy.

To test the bucket policy, you can try accessing the bucket from a public IP that is not included in the whitelisted range. The access should be denied.


