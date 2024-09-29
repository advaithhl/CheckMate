# Random Password: JWT Secret Key
# This block generates a random password which is used as the secret key for JWT generation.
# The secret key is 32 characters long and will be stored in the environment variables
# of the Lambda functions that require JWT token generation or validation.
resource "random_password" "jwt_secret_key" {
  length = 32 # Length of the generated secret key
}
