# This resource configures the API Gateway for the CheckMate application, using HTTP protocol
resource "aws_apigatewayv2_api" "checkmate_api" {
  name          = "checkmate-api-tf" # API name for identification
  protocol_type = "HTTP"             # Specifies the HTTP protocol for the API

  # Configuring CORS to allow cross-origin requests from the frontend
  cors_configuration {
    allow_credentials = false                                                                 # Specifies that credentials are not allowed in requests
    allow_headers     = ["Authorization", "Content-Type"]                                     # Allowed headers in requests
    allow_methods     = ["GET", "POST", "DELETE"]                                             # Allowed HTTP methods
    allow_origins     = ["https://prod.${aws_amplify_app.checkmate_frontend.default_domain}"] # Allowed origin (the frontend URL)
    expose_headers    = ["*"]                                                                 # Headers that can be exposed to the frontend
  }
}

# Defines the default stage for the API Gateway, enabling automatic deployments
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.checkmate_api.id # Links to the API Gateway defined above
  name        = "$default"                            # The default stage of the API
  auto_deploy = true                                  # Automatic deployment enabled when changes are made
}

# Route configuration for the /register endpoint for user registration
resource "aws_apigatewayv2_route" "auth_register_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id                                       # Links to the API
  route_key = "POST /register"                                                            # POST request to `/register`
  target    = "integrations/${aws_apigatewayv2_integration.auth_register_integration.id}" # Links to the corresponding Lambda function integration
}

# Integration for the user registration Lambda function
resource "aws_apigatewayv2_integration" "auth_register_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id        # Links to the API
  integration_type       = "AWS_PROXY"                                  # Lambda proxy integration
  integration_uri        = aws_lambda_function.auth_register.invoke_arn # ARN of the corresponding Lambda function
  integration_method     = "POST"                                       # HTTP method used in this integration
  payload_format_version = "2.0"                                        # Specifies the version of the payload format
}

# Route configuration for the /login endpoint for user login
resource "aws_apigatewayv2_route" "auth_login_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id                                    # Links to the API
  route_key = "POST /login"                                                            # POST request to `/login`
  target    = "integrations/${aws_apigatewayv2_integration.auth_login_integration.id}" # Links to the corresponding Lambda function integration
}

# Integration for the user login Lambda function
resource "aws_apigatewayv2_integration" "auth_login_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id     # Links to the API
  integration_type       = "AWS_PROXY"                               # Lambda proxy integration
  integration_uri        = aws_lambda_function.auth_login.invoke_arn # ARN of the corresponding Lambda function
  integration_method     = "POST"                                    # HTTP method used in this integration
  payload_format_version = "2.0"                                     # Specifies the version of the payload format
}

# Route for adding a new item
resource "aws_apigatewayv2_route" "actions_add_item_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id                                          # Links to the API
  route_key = "POST /actions/addItem"                                                        # POST request to `/actions/addItem`
  target    = "integrations/${aws_apigatewayv2_integration.actions_add_item_integration.id}" # Links to the corresponding Lambda function integration
}

# Integration for the add item Lambda function
resource "aws_apigatewayv2_integration" "actions_add_item_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id           # Links to the API
  integration_type       = "AWS_PROXY"                                     # Lambda proxy integration
  integration_uri        = aws_lambda_function.actions_add_item.invoke_arn # ARN of the corresponding Lambda function
  integration_method     = "POST"                                          # HTTP method used in this integration
  payload_format_version = "2.0"                                           # Specifies the version of the payload format
}

# Route for retrieving all items
resource "aws_apigatewayv2_route" "actions_get_items_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id                                           # Links to the API
  route_key = "GET /actions/getItems"                                                         # GET request to `/actions/getItems`
  target    = "integrations/${aws_apigatewayv2_integration.actions_get_items_integration.id}" # Links to the corresponding Lambda function integration
}

# Integration for the get all items Lambda function
resource "aws_apigatewayv2_integration" "actions_get_items_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id            # Links to the API
  integration_type       = "AWS_PROXY"                                      # Lambda proxy integration
  integration_uri        = aws_lambda_function.actions_get_items.invoke_arn # ARN of the corresponding Lambda function
  integration_method     = "POST"                                           # HTTP method used in this integration
  payload_format_version = "2.0"                                            # Specifies the version of the payload format
}

# Route for deleting an item based on its ID
resource "aws_apigatewayv2_route" "actions_delete_item_route" {
  api_id    = aws_apigatewayv2_api.checkmate_api.id                                              # Links to the API
  route_key = "DELETE /actions/deleteItem/{itemId}"                                              # DELETE request to `/actions/deleteItem/{itemId}`
  target    = "integrations/${aws_apigatewayv2_integration.actions_delete_items_integration.id}" # Links to the corresponding Lambda function integration
}

# Integration for the delete item Lambda function
resource "aws_apigatewayv2_integration" "actions_delete_items_integration" {
  api_id                 = aws_apigatewayv2_api.checkmate_api.id              # Links to the API
  integration_type       = "AWS_PROXY"                                        # Lambda proxy integration
  integration_uri        = aws_lambda_function.actions_delete_item.invoke_arn # ARN of the corresponding Lambda function
  integration_method     = "POST"                                             # HTTP method used in this integration
  payload_format_version = "2.0"                                              # Specifies the version of the payload format
}
