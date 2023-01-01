
# Deploying S3 Bucket policy using Terraform IaC

Goal of this project to create public S3 Bucket in AWS cloud and update Bucket policy to allow access to the bucket only from whitelisted public IPs.





![App Screenshot](https://i.ibb.co/PzTp9kb/public-bucket.png)


## Pre-Requisites



-AWS IAM user access key & secret key accessing S3.

-Visual Studio Code configured to develop Terraform IaC (optional) or you can directly clone the file as shown below.


## AWS IAM user access key & secret key accessing S3

To create an AWS IAM user access key and secret key that can access an Amazon S3 bucket, follow these steps:

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
- Now install and connect AWS CLI from you ec2 linux to use the aws resources etc.Follow these blog  [AWS CLI configure with aws Secret Key](https://www.cyberciti.biz/faq/how-to-install-aws-cli-on-linux/)
- 

- Once you are logged in to the instance, install Terraform by following the instructions in the [Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) or [This Steps](https://spacelift.io/blog/how-to-install-terraform) . You can install Terraform using a package manager (e.g., apt) or by downloading the Terraform binary from the Terraform website.

- Create a new directory for your Terraform project and navigate to that directory in the terminal.

- Initialize Terraform by running the terraform init command. This will download any necessary plugins and initialize the working directory.

- Create a Terraform configuration file with a ".tf" extension. This file should contain the configuration for the resources you want to create with Terraform. You can find documentation for the various resource types and their configuration options in the Terraform documentation.

(you can copy my code direct into that directory using vi main.tf)
#### or more easy you can ```git clone https://github.com/Sabirk8992/Devopsp-Project-S3-IAAC-IAM.git ```  cd to Devopsp-Project-S3-IAAC-IAM directory then run the Terrafom.




## Terraform Script

#### IMPORTANT : 

Change the bucket name to your name `mysabirbucket` to `myyournamebucket` , if you use same name it will error you as name cannot be same
```
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
```

    
## Here is a breakdown of the steps taken in this code:

- The provider block declares the provider that is being used. In this case, the provider is AWS. The region attribute specifies the region in which the resources will be created.

- The aws_s3_bucket resource creates an S3 bucket with the name specified in the bucket attribute. In this case, the bucket will be named "mysabirbucket".

- The aws_s3_bucket_acl resource sets the access control list (ACL) for the S3 bucket specified in the bucket attribute. In this case, the ACL is set to "private".

- The aws_s3_bucket_policy resource sets the bucket policy for the S3 bucket specified in the bucket attribute. 

- The bucket policy is defined in the policy attribute as a string in JSON format. In this case, the policy allows any AWS principals to perform any S3 actions on the bucket, but only if the request comes from the IP address range 122.169.54.0/24.


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

