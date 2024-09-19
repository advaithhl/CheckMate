resource "aws_lambda_permission" "auth_register_permission" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_register.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "auth_login_permission" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_login.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "actions_add_item_permission" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.actions_add_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "actions_get_items_permission" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.actions_get_items.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "actions_delete_item_permission" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.actions_delete_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*"
}
