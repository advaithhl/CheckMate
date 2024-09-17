resource "aws_apigatewayv2_api" "checkmate_api" {
  name          = "checkmate-api-tf"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "auth_register_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "POST /register"
  target    = "integrations/${aws_apigatewayv2_integration.auth_register_integration.id}"
}

resource "aws_apigatewayv2_route" "auth_login_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "POST /login"
  target    = "integrations/${aws_apigatewayv2_integration.auth_login_integration.id}"
}

resource "aws_apigatewayv2_integration" "auth_register_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.auth_register.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "auth_login_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.auth_login.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.checkmate_api.id
  name        = "$default"
  auto_deploy = true
}
