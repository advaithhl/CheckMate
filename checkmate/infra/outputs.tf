output "checkmate_url" {
  value       = "https://prod.${aws_amplify_app.checkmate_frontend.default_domain}"
  description = "The application URL to be used by end-users."
}
