# Configure AWS provider (replace with your region)
provider "aws" {
  region = "eu-west-1"  
  profile = "sandbox"  # Use your AWS CLI profile
}
variable "lambda_s3_key" {
  description = "Git commit SHA used for S3 object path"
  type        = string
}

# Create Lambda function from S3 ZIP
resource "aws_lambda_function" "create_task" {
  function_name = "create_task"  # Name of the Lambda function
  handler       = "create_task.lambda_handler"  # <filename>.<handler_name>
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_role.arn  # Create this role (see below)
  s3_bucket     = "lambdacicdtest0123"
  s3_key        = "lambda-zips/create_task.zip"  # Path to your ZIP in S3

  # Optional: Ensure Lambda updates when ZIP changes
#   source_code_hash = filebase64sha256("${path.module}./src/create_task/function.zip")
}
resource "aws_lambda_function" "delete_task" {
  function_name = "delete_task"  # Name of the Lambda function
  handler       = "delete_task.lambda_handler"  # <filename>.<handler_name>
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_role.arn  # Create this role (see below)
  s3_bucket     = "lambdacicdtest0123"
  s3_key        = "lambda-zips/delete_task.zip"  # Path to your ZIP in S3

  # Optional: Ensure Lambda updates when ZIP changes
#   source_code_hash = filebase64sha256("${path.module}./src/create_task/function.zip")
}

# Minimal IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Allow Lambda to write logs
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}





