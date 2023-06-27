# demedia-infra

This repo contains the source codes related to infrastructure for DeMedia project.

Refer to the following guides on how to utilize these configurations.

## Terraform

Terraform has bee used to provision the infrastructure like ec2 servers to simulate hubs and peers.

### To get started

1. Install the AWS CLI.
   You need to have AWS CLI installed in your local machine. See this guide for installing aws cli. [Click here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. Configure a profile named "demedia-IAM" in AWS cli with the AWS access key and AWS secret key for demedia AWS account.  
   Run the following command to configure the profile and enter the required inputs as prompted.  

   ```bash
   aws configure --profile demedia-IAM
   ```

3. Navigate to specific directory and apply the terraform configurations.

### Directory structure breakdown

```
├── terraform
│   ├── backend - configs used to initialize the s3 bucket for remote backend
│   ├── ec2 - configs to spin up a ec2 to host hub and peer
│   └── poc - configs for poc purposes

```
