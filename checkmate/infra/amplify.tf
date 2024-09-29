# This resource configures the AWS Amplify app for the CheckMate frontend
resource "aws_amplify_app" "checkmate_frontend" {
  name = "checkmate-frontend-prod" # Name of the Amplify app for the production environment

  # This section defines a custom rewrite rule for client-side routing
  # It rewrites all requests to the main index.html, similar to nginx try_files, 
  # which is useful for client-side routing
  custom_rule {
    source = "/<*>"        # Matches all incoming routes
    target = "/index.html" # Redirects all unmatched routes to index.html
    status = "404-200"     # Returns a 200 OK status, even for paths not found
  }
}

# This resource defines the branch for the production environment of the frontend
resource "aws_amplify_branch" "checkmate_frontend_production_branch" {
  app_id      = aws_amplify_app.checkmate_frontend.id # Links to the Amplify app created above
  branch_name = "prod"                                # Name of the branch to be used for production
  stage       = "PRODUCTION"                          # Specifies that this is the production stage
  description = "CheckMate frontend production"       # A description for the branch, identifying its purpose
}
