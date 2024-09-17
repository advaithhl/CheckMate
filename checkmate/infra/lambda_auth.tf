resource "aws_lambda_function" "auth_register" {
  function_name = "authRegister"
  role          = aws_iam_role.auth_register_role.arn
  timeout       = 30

  filename         = "../backend/authRegister/my_deployment_package.zip"
  source_code_hash = filebase64sha256("../backend/authRegister/my_deployment_package.zip")

  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["arm64"] # TODO: Determine this dynamically.
}

resource "aws_lambda_function" "auth_login" {
  function_name = "authLogin"
  role          = aws_iam_role.auth_login_role.arn
  timeout       = 30

  filename         = "../backend/authLogin/my_deployment_package.zip"
  source_code_hash = filebase64sha256("../backend/authLogin/my_deployment_package.zip")

  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["arm64"] # TODO: Determine this dynamically.
}
