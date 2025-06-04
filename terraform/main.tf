# Configure AWS provider
provider "aws" {
  region = "eu-west-1"
  profile = "sandbox"  # Uncomment if using named profile
}

# Reference an existing IAM role by name
data "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"
}

# Attach AWS-managed policy to the existing IAM role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = data.aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create Lambda function: create_task
  resource "aws_lambda_function" "create_task" {
    function_name = "create_task"
    handler       = "create_task.lambda_handler"
    runtime       = "python3.12"
    role          = data.aws_iam_role.lambda_role.arn  # Use the existing role
    s3_bucket     = "lambdacicdtest0123"
    s3_key        = "lambda-zips/create_task.zip"
  }

# Create Lambda function: delete_task
resource "aws_lambda_function" "delete_task" {
  function_name = "delete_task"
  handler       = "delete_task.lambda_handler"
  runtime       = "python3.12"
  role          = data.aws_iam_role.lambda_role.arn  # Use the existing role
  s3_bucket     = "lambdacicdtest0123"
  s3_key        = "lambda-zips/delete_task.zip"
}
