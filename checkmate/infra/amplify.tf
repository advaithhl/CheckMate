resource "aws_amplify_app" "checkmate_frontend" {
  name = "checkmate-frontend-prod"

  # Rewrite rules similar to nginx try_files to support
  # client-side routing
  custom_rule {
    source = "/<*>"
    target = "/index.html"
    status = "404-200"
  }
}

resource "aws_amplify_branch" "checkmate_frontend_production_branch" {
  app_id      = aws_amplify_app.checkmate_frontend.id
  branch_name = "prod"
  stage       = "PRODUCTION"
  description = "CheckMate frontend production"
}
