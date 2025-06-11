# AWS Lambda Containers (Python)

This repository demonstrates how to package and deploy an AWS Lambda function using a custom Docker container. This is specifically designed for systems that require ISSO-approved container images as opposed to AWS-provided container images. This repository provides a template for building serverless Python applications that require custom dependencies or system libraries not available in the standard AWS Lambda runtime.

## Purpose
- **Custom Lambda Packaging:** Build custom containers to run in AWS Lambda. This repository uses an example of building a container from a custom base image (**Python 3.11**) to be deployed in AWS Lambda.
- **Flexible Base Image:** Change the base image in the `Dockerfile` to suit your runtime or OS requirements.
- **Reproducible Deployments:** Use Docker to ensure your Lambda environment matches your local development.

## Folder Structure
- `lambda_function.py`: Your main Lambda handler code.
- `requirements.txt`: List your Python dependencies here.
- `Dockerfile`: Build instructions for your Lambda container image.

## Getting Started

### 1. Change the Base Image
Edit the `FROM` line in the `Dockerfile` to use a different base image if needed. For example:
```
FROM public.ecr.aws/lambda/python:3.11
```
You can use any AWS Lambda base image or a custom image that meets Lambda's requirements. Ensure that you login to the specified repository before attempting to build the container.

### 2. Add Python Dependencies
List any required Python packages in `requirements.txt`. For example:
```
requests
numpy
```
These will be installed during the Docker build process.

### 3. Build the Docker Image
Run the following command in the `aws-lambda-container` directory:
```powershell
docker build -t my-lambda-container .
```

### 4. Push to ECR and Deploy
1. Tag and push your image to Amazon ECR.
2. Create or update your Lambda function to use the newly created container image.

## Infrastructure for Deployment: `lambda.tf`

This file provides an example of how to define, manage, and deploy a containerized Lambda function in Terraform. Make sure to provision and push the container to an elastic container repository (ECR) in AWS before deploying infrastructure that utilizes the container.

### How to Use `lambda.tf`
1. **Configure AWS Credentials:** Ensure your AWS credentials are set up locally (via environment variables, AWS CLI, or a credentials file).
2. **Update Variables:** Edit `lambda.tf` to specify your ECR image URI, Lambda function name, IAM roles, and any other required parameters.
3. **Initialize Terraform:**
   ```powershell
   terraform init
   ```
4. **Review the Plan:**
   ```powershell
   terraform plan
   ```
5. **Apply the Configuration:**
   ```powershell
   terraform apply
   ```
   This will provision the Lambda function using your container image and any other resources defined in the file.

### Use Cases
- Automate deployment and updates of your Lambda container.
- Manage IAM roles, permissions, and environment variables as code.
- Integrate with other AWS resources (API Gateway, S3, etc.) in a reproducible way.

For more details, see the comments in `lambda.tf` and the [Terraform AWS Lambda documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function).

## Use Cases for Containerizing Lambda Functions
- Using system libraries or binaries not available in standard Lambda runtimes.
- Packaging large dependencies that exceed Lambda's deployment package size limit.
- Ensuring consistent environments between local development and production.
- Running non-Python code or multi-language applications in Lambda.

## References
- [AWS Lambda Container Images](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html)
- [AWS Lambda Base Images](https://gallery.ecr.aws/lambda)
