provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "mysabirbucket" {
  bucket = "mysabirbucket"
}
resource "aws_s3_bucket_acl" "mysabirbucket" {
  bucket = "mysabirbucket"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "mysabirbucket" {
  bucket = "${aws_s3_bucket.mysabirbucket.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "S3PolicyId1",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::mysabirbucket/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "122.169.54.0/24"
        }
      }
    }
  ]
}
EOF
}