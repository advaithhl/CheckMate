resource "aws_apigatewayv2_api" "checkmate_api" {
  name          = "checkmate-api-tf"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.checkmate_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_route" "auth_register_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "POST /register"
  target    = "integrations/${aws_apigatewayv2_integration.auth_register_integration.id}"
}

resource "aws_apigatewayv2_integration" "auth_register_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.auth_register.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "auth_login_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "POST /login"
  target    = "integrations/${aws_apigatewayv2_integration.auth_login_integration.id}"
}

resource "aws_apigatewayv2_integration" "auth_login_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.auth_login.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "actions_add_item_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "POST /actions/addItem"
  target    = "integrations/${aws_apigatewayv2_integration.actions_add_item_integration.id}"
}

resource "aws_apigatewayv2_integration" "actions_add_item_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.actions_add_item.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "actions_get_items_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "GET /actions/getItems"
  target    = "integrations/${aws_apigatewayv2_integration.actions_get_items_integration.id}"
}

resource "aws_apigatewayv2_integration" "actions_get_items_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.actions_get_items.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "actions_delete_item_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "DELETE /actions/deleteItem/{itemId}"
  target    = "integrations/${aws_apigatewayv2_integration.actions_delete_items_integration.id}"
}

resource "aws_apigatewayv2_integration" "actions_delete_items_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.actions_delete_item.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}
