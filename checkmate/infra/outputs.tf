output "checkmate_url" {
  value       = "https://prod.${aws_amplify_app.checkmate_frontend.default_domain}"
  description = "The application URL to be used by end-users."
}

output "checkmate_backend_url" {
  value       = aws_apigatewayv2_api.checkmate_api.api_endpoint
  description = "The API Gateway URL to be provided to frontend during build."
}

output "amplify_app_id" {
  value       = aws_amplify_app.checkmate_frontend.id
  description = "The Amplify app ID used for deploying frontend."
}
