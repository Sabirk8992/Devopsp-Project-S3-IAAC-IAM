provider "aws" {           
  region = "us-east-1"
}

# Get the public IP of the system
data "http" "ip" {
  url = "https://api.ipify.org"
}

# Create the S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket"
  acl    = "public-read"
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket"
  versioning {
    enabled = true
  }
}

# Create the IAM policy that allows bucket objects only from a specific whitelisted public IP
resource "aws_iam_policy" "my_policy" {
  name        = "my-policy"
  description = "IAM policy that allows bucket objects only from a specific whitelisted public IP"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "${data.http.ip.body}"
        }
      }
    }
  ]
}
EOF
}

# Update the bucket policy with the IAM policy created in the previous step
resource "aws_s3_bucket_policy" "my_policy" {
  bucket = "my-bucket"
  policy = "${aws_iam_policy.my_policy.arn}"
}