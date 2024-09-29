# Permission to allow API Gateway to invoke the `authRegister` Lambda function
resource "aws_lambda_permission" "auth_register_permission" {
  statement_id  = "AllowApiGatewayInvoke"                                   # Unique statement ID
  action        = "lambda:InvokeFunction"                                   # Action to allow: invoking the Lambda function
  function_name = aws_lambda_function.auth_register.function_name           # Reference to the `authRegister` Lambda function
  principal     = "apigateway.amazonaws.com"                                # Principal: API Gateway service
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*" # ARN of the API Gateway stage to allow
}

# Permission to allow API Gateway to invoke the `authLogin` Lambda function
resource "aws_lambda_permission" "auth_login_permission" {
  statement_id  = "AllowApiGatewayInvoke"                                   # Unique statement ID
  action        = "lambda:InvokeFunction"                                   # Action to allow: invoking the Lambda function
  function_name = aws_lambda_function.auth_login.function_name              # Reference to the `authLogin` Lambda function
  principal     = "apigateway.amazonaws.com"                                # Principal: API Gateway service
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*" # ARN of the API Gateway stage to allow
}

# Permission to allow API Gateway to invoke the `actionsAddItem` Lambda function
resource "aws_lambda_permission" "actions_add_item_permission" {
  statement_id  = "AllowApiGatewayInvoke"                                   # Unique statement ID
  action        = "lambda:InvokeFunction"                                   # Action to allow: invoking the Lambda function
  function_name = aws_lambda_function.actions_add_item.function_name        # Reference to the `actionsAddItem` Lambda function
  principal     = "apigateway.amazonaws.com"                                # Principal: API Gateway service
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*" # ARN of the API Gateway stage to allow
}

# Permission to allow API Gateway to invoke the `actionsGetItems` Lambda function
resource "aws_lambda_permission" "actions_get_items_permission" {
  statement_id  = "AllowApiGatewayInvoke"                                   # Unique statement ID
  action        = "lambda:InvokeFunction"                                   # Action to allow: invoking the Lambda function
  function_name = aws_lambda_function.actions_get_items.function_name       # Reference to the `actionsGetItems` Lambda function
  principal     = "apigateway.amazonaws.com"                                # Principal: API Gateway service
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*" # ARN of the API Gateway stage to allow
}

# Permission to allow API Gateway to invoke the `actionsDeleteItem` Lambda function
resource "aws_lambda_permission" "actions_delete_item_permission" {
  statement_id  = "AllowApiGatewayInvoke"                                   # Unique statement ID
  action        = "lambda:InvokeFunction"                                   # Action to allow: invoking the Lambda function
  function_name = aws_lambda_function.actions_delete_item.function_name     # Reference to the `actionsDeleteItem` Lambda function
  principal     = "apigateway.amazonaws.com"                                # Principal: API Gateway service
  source_arn    = "${aws_apigatewayv2_api.checkmate_api.execution_arn}/*/*" # ARN of the API Gateway stage to allow
}
