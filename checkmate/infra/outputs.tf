# Output: CheckMate Frontend URL
# This output provides the URL where the CheckMate application is accessible for end users.
# The URL is built using the default domain provided by AWS Amplify for the frontend app.
output "checkmate_url" {
  value       = "https://prod.${aws_amplify_app.checkmate_frontend.default_domain}"
  description = "The application URL to be used by end-users."
}

# Output: CheckMate Backend API URL
# This output returns the API Gateway URL for the backend service.
# The URL is to be passed to the frontend during the build process to allow interaction with the backend.
output "checkmate_backend_url" {
  value       = aws_apigatewayv2_api.checkmate_api.api_endpoint
  description = "The API Gateway URL to be provided to frontend during build."
}

# Output: Amplify Application ID
# This output gives the Amplify App ID, which is needed when deploying or interacting with the frontend via the AWS Amplify service.
output "amplify_app_id" {
  value       = aws_amplify_app.checkmate_frontend.id
  description = "The Amplify app ID used for deploying frontend."
}
