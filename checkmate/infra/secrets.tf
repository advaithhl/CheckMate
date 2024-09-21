resource "random_password" "jwt_secret_key" {
  length = 32
}
