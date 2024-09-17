resource "aws_lambda_function" "actions_add_item" {
  function_name = "actionsAddItem"
  role          = aws_iam_role.actions_add_item_role.arn
  timeout       = 30

  filename         = "../backend/actionsAddItem/my_deployment_package.zip"
  source_code_hash = filebase64sha256("../backend/actionsAddItem/my_deployment_package.zip")

  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["arm64"] # TODO: Determine this dynamically.
}

resource "aws_lambda_function" "actions_get_items" {
  function_name = "actionsGetItems"
  role          = aws_iam_role.actions_get_items_role.arn
  timeout       = 30

  filename         = "../backend/actionsGetItems/my_deployment_package.zip"
  source_code_hash = filebase64sha256("../backend/actionsGetItems/my_deployment_package.zip")

  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["arm64"] # TODO: Determine this dynamically.
}

resource "aws_lambda_function" "actions_delete_item" {
  function_name = "actionsDeleteItem"
  role          = aws_iam_role.actions_delete_item_role.arn
  timeout       = 30

  filename         = "../backend/actionsDeleteItem/my_deployment_package.zip"
  source_code_hash = filebase64sha256("../backend/actionsDeleteItem/my_deployment_package.zip")

  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["arm64"] # TODO: Determine this dynamically.
}
