variable "lambda_architecture" {
  type        = list(string)
  default     = ["arm64"]
  description = "The architecture of the Lambda function to be launched."
}
