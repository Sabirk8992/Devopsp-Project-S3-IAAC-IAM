provider "aws" {           
  region = "ap-south-1"
}

# Get the public IP of the system
data "http" "ip" {
  url = "https://api.ipify.org"
}

# Create the S3 bucket
resource "aws_s3_bucket" "iaaciam" {
  bucket = "my-bucket"
  acl    = "public-read"
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket" "iaaciam1" {
  bucket = "iaaciam"
  versioning {
    enabled = true
  }
}

# Create the IAM policy that allows bucket objects only from a specific whitelisted public IP
resource "aws_iam_policy" "iaaciamp" {
  name        = "my-policy"
  description = "IAM policy that allows bucket objects only from a specific whitelisted public IP"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::iaaciam/*",
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
resource "aws_s3_bucket_policy" "iaaciamp" {
  bucket = "iaaciam1"
  policy = "${aws_iam_policy.my_policy.arn}"
}
