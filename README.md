
# Deploying S3 Bucket policy using Terraform IaC

Goal of this project to create public S3 Bucket in AWS cloud and update Bucket policy to allow access to the bucket only from whitelisted public IPs.





![App Screenshot](https://i.ibb.co/PzTp9kb/public-bucket.png)


## Pre-Requisites



-AWS IAM user access key & secret key accessing S3.

-Visual Studio Code configured to develop Terraform IaC


## AWS IAM user access key & secret key accessing S3

- To create an AWS IAM user access key and secret key that can access an Amazon S3 bucket, follow these steps:

- Sign in to the AWS Management Console and navigate to the IAM dashboard.

- In the navigation pane, choose Users and then choose the name of the user you want to create an access key for.

- Choose the Security credentials tab and then choose Create access key.

- Choose Download .csv file to download the access key and secret key. The .csv file will contain the access key ID and secret access key for the user.

- Save the .csv file in a secure location, as the secret access key will not be displayed again.



## How to use Terraform

To launch an Ubuntu EC2 instance and start using Terraform with your terminal, follow these steps:

- Sign in to the AWS Management Console and navigate to the EC2 dashboard.

- Click the "Launch Instance" button to start the process of launching a new EC2 instance.

- On the "Choose an Amazon Machine Image (AMI)" page, select the "Ubuntu" AMI and choose the desired instance type.
and just go next >> next.

- Review the settings for your instance and click the "Launch" button to launch the instance.

- In the "Select an existing key pair or create a new key pair" dialog, select an existing key pair or create a new key pair and then click the "Launch Instances" button.

- Once the instance is launched, connect to it using SSH from your terminal. You will need the private key file for the key pair you selected .

- Once you are logged in to the instance, install Terraform by following the instructions in the [Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) or [This Steps](https://spacelift.io/blog/how-to-install-terraform) . You can install Terraform using a package manager (e.g., apt) or by downloading the Terraform binary from the Terraform website.

- Create a new directory for your Terraform project and navigate to that directory in the terminal.

- Initialize Terraform by running the terraform init command. This will download any necessary plugins and initialize the working directory.

- Create a Terraform configuration file with a ".tf" extension. This file should contain the configuration for the resources you want to create with Terraform. You can find documentation for the various resource types and their configuration options in the Terraform documentation.

(you can copy my code direct into that directory using vi main.tf)
#### or more easy you can ```git clone https://github.com/Sabirk8992/Devopsp-Project-S3-IAAC-IAM.git ```  cd to Devopsp-Project-S3-IAAC-IAM directory then run the Terrafom.




## Terraform Script

Here is a Terraform script that will create an S3 bucket in the us-east-1 region, enable versioning for the bucket, update the bucket ACL to allow public access, create an IAM policy that allows bucket objects only from a specific whitelisted public IP, and update the bucket policy with the IAM policy created in the previous step

Here  https://api.ipify.org add your Public IP 




```
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

```
    
## Here is a breakdown of the steps taken in this code:


Here is a breakdown of the steps taken in this code:

- The AWS provider is configured with the region "us-east-1". This specifies which region the resources in this configuration will be created in.

- The "http" data source is used to retrieve the public IP address of the system the code is being run on. This IP address is stored in the "ip" variable.

- An S3 bucket is created with the name "my-bucket" and an access control list (ACL) of "public-read".

- The same S3 bucket is modified to enable versioning.

- An IAM policy is created that allows bucket objects only from the whitelisted public IP address stored in the "ip" variable.

The bucket policy for the "my-bucket" S3 bucket is updated to use the IAM policy created in the previous step.This code will create an S3 bucket with versioning enabled, and only allow objects to be added to the bucket from a specific public IP address.

## Run the Code Now

- Run the terraform plan command to preview the changes that will be made to your infrastructure.

- If the output of the terraform plan command looks correct, run the terraform apply command to apply the changes to your infrastructure.

That's it! You should now be able to use Terraform to manage your infrastructure from the terminal on your Ubuntu EC2 instance.


## Now Let's Validate

### 1. Upload Object to Bucket using AWS CLI

To upload an object to an S3 bucket using the AWS command line interface (CLI), you can use the aws s3 cp command.

Here is the basic syntax for this command:


```aws s3 cp <LOCAL_FILE_PATH> <S3_BUCKET_NAME>```

For example, to upload a file named myfile.txt from the local machine to an S3 bucket named my-bucket, you would run the following command:


```aws s3 cp myfile.txt s3://my-bucket```

### 2. Access the Objects using Object URL from public browser(While your system has same public IP whitelisted)
### 3. Access the Objects using Object URL from public browser (While your system has different public IP, Reconnect to internet might change your public IP for testing.)

## DONE

### Congratulation you have complete The Project.
## JOIN OUR DEVOPS PROJECTS PRIVATE GROUP - Share this project Document with you friend who needs.

[JOIN TELEGRAM GROUP](https://t.me/+EVZLmMA8SpoxMjE1)

