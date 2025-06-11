resource "aws_lambda_function" "example-lambda-function" {
  function_name = "my-lambda-function"
  
  # Ensure you have an IAM role defined for the Lambda function
  role          = aws_iam_role.lambda_role.arn 
  
  package_type  = "Image"

  # Ensure you have built and pushed the Docker image to ECR before deploying this Lambda function
  image_uri     = "${aws_ecr_repository.lambda_repository.repository_url}:latest"

  environment {
    variables = {
      EXAMPLE_ENV_VAR = "example_value"
    }
  }

  timeout = 30 # Timeout in seconds
  memory_size = 128 # Memory size in MB
}