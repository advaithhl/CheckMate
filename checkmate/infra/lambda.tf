# Lambda Function: authRegister
resource "aws_lambda_function" "auth_register" {
  function_name = "authRegister"
  role          = aws_iam_role.auth_register_role.arn # Corresponding IAM role
  timeout       = 30                                  # Timeout set to 30 seconds

  filename         = "../backend/authRegister/my_deployment_package.zip"                   # Deployment package for the function
  source_code_hash = filebase64sha256("../backend/authRegister/my_deployment_package.zip") # Tracks code changes

  handler       = "lambda_function.lambda_handler" # Entry point in the code
  runtime       = "python3.12"                     # Runtime environment for the Lambda function
  memory_size   = 2048                             # Memory allocated to the function
  architectures = var.lambda_architecture          # CPU architecture (must be same as that of build machine)
}

# Lambda Function: authLogin
resource "aws_lambda_function" "auth_login" {
  function_name = "authLogin"
  role          = aws_iam_role.auth_login_role.arn # Corresponding IAM role
  timeout       = 30                               # Timeout set to 30 seconds

  filename         = "../backend/authLogin/my_deployment_package.zip"                   # Deployment package for the function
  source_code_hash = filebase64sha256("../backend/authLogin/my_deployment_package.zip") # Tracks code changes

  handler       = "lambda_function.lambda_handler" # Entry point in the code
  runtime       = "python3.12"                     # Runtime environment for the Lambda function
  memory_size   = 2048                             # Memory allocated to the function
  architectures = var.lambda_architecture          # CPU architecture (must be same as that of build machine)

  environment {
    variables = {
      "JWT_SECRET_KEY" = random_password.jwt_secret_key.result # JWT secret key for authentication
    }
  }
}

# Lambda Function: actionsAddItem
resource "aws_lambda_function" "actions_add_item" {
  function_name = "actionsAddItem"
  role          = aws_iam_role.actions_add_item_role.arn # Corresponding IAM role
  timeout       = 30                                     # Timeout set to 30 seconds

  filename         = "../backend/actionsAddItem/my_deployment_package.zip"                   # Deployment package for the function
  source_code_hash = filebase64sha256("../backend/actionsAddItem/my_deployment_package.zip") # Tracks code changes

  handler       = "lambda_function.lambda_handler" # Entry point in the code
  runtime       = "python3.12"                     # Runtime environment for the Lambda function
  memory_size   = 2048                             # Memory allocated to the function
  architectures = var.lambda_architecture          # CPU architecture (must be same as that of build machine)

  environment {
    variables = {
      "JWT_SECRET_KEY" = random_password.jwt_secret_key.result # JWT secret key for authentication
    }
  }
}

# Lambda Function: actionsGetItems
resource "aws_lambda_function" "actions_get_items" {
  function_name = "actionsGetItems"
  role          = aws_iam_role.actions_get_items_role.arn # Corresponding IAM role
  timeout       = 30                                      # Timeout set to 30 seconds

  filename         = "../backend/actionsGetItems/my_deployment_package.zip"                   # Deployment package for the function
  source_code_hash = filebase64sha256("../backend/actionsGetItems/my_deployment_package.zip") # Tracks code changes

  handler       = "lambda_function.lambda_handler" # Entry point in the code
  runtime       = "python3.12"                     # Runtime environment for the Lambda function
  memory_size   = 2048                             # Memory allocated to the function
  architectures = var.lambda_architecture          # CPU architecture (must be same as that of build machine)

  environment {
    variables = {
      "JWT_SECRET_KEY" = random_password.jwt_secret_key.result # JWT secret key for authentication
    }
  }
}

# Lambda Function: actionsDeleteItem
resource "aws_lambda_function" "actions_delete_item" {
  function_name = "actionsDeleteItem"
  role          = aws_iam_role.actions_delete_item_role.arn # Corresponding IAM role
  timeout       = 30                                        # Timeout set to 30 seconds

  filename         = "../backend/actionsDeleteItem/my_deployment_package.zip"                   # Deployment package for the function
  source_code_hash = filebase64sha256("../backend/actionsDeleteItem/my_deployment_package.zip") # Tracks code changes

  handler       = "lambda_function.lambda_handler" # Entry point in the code
  runtime       = "python3.12"                     # Runtime environment for the Lambda function
  memory_size   = 2048                             # Memory allocated to the function
  architectures = var.lambda_architecture          # CPU architecture (must be same as that of build machine)

  environment {
    variables = {
      "JWT_SECRET_KEY" = random_password.jwt_secret_key.result # JWT secret key for authentication
    }
  }
}
