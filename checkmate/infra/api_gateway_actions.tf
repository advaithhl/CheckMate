resource "aws_apigatewayv2_route" "actions_add_item_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "POST /actions/addItem"
  target    = "integrations/${aws_apigatewayv2_integration.actions_add_item_integration.id}"
}

resource "aws_apigatewayv2_route" "actions_get_items_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "GET /actions/getItems"
  target    = "integrations/${aws_apigatewayv2_integration.actions_get_items_integration.id}"
}

resource "aws_apigatewayv2_route" "actions_delete_item_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id
  route_key = "DELETE /actions/deleteItem/{itemId}"
  target    = "integrations/${aws_apigatewayv2_integration.actions_delete_items_integration.id}"
}

resource "aws_apigatewayv2_integration" "actions_add_item_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.actions_add_item.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "actions_get_items_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.actions_get_items.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "actions_delete_items_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.actions_delete_item.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}
