# Lambda: authRegister
# This block defines an IAM role for the "authRegister" Lambda function.
resource "aws_iam_role" "auth_register_role" {
  name = "authRegisterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# This policy grants the `authRegisterRole` role permission to perform PutItem 
# (to add a new user) and GetItem (to check if a user exists) actions on the DynamoDB users table.
resource "aws_iam_role_policy" "auth_register_policy" {
  name = "authRegisterPolicy"
  role = aws_iam_role.auth_register_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ],
        Resource = "${aws_dynamodb_table.users.arn}"
      }
    ]
  })
}

# This policy attachment ensures the `authRegisterRole` has basic Lambda execution role permissions, 
# including CloudWatch Logs for logging.
resource "aws_iam_role_policy_attachment" "auth_register_basic_execution" {
  role       = aws_iam_role.auth_register_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda: authLogin
# This block defines an IAM role for the "authLogin" Lambda function.
resource "aws_iam_role" "auth_login_role" {
  name = "authLoginRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# This policy grants the `authLoginRole` role permission to retrieve user information 
# from the DynamoDB users table.
resource "aws_iam_role_policy" "auth_login_policy" {
  name = "authLoginPolicy"
  role = aws_iam_role.auth_login_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "dynamodb:GetItem",
        Resource = "${aws_dynamodb_table.users.arn}"
      }
    ]
  })
}

# This policy attachment ensures the `authLoginRole` has basic Lambda execution role permissions, 
# including CloudWatch Logs for logging.
resource "aws_iam_role_policy_attachment" "auth_login_basic_execution" {
  role       = aws_iam_role.auth_login_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda: actionsAddItem
# This block defines an IAM role for the "actionsAddItem" Lambda function.
resource "aws_iam_role" "actions_add_item_role" {
  name = "actionsAddItemRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# This policy grants the `actionsAddItemRole` role permission to add (PutItem) tasks into the user_tasks table.
resource "aws_iam_role_policy" "actions_add_item_policy" {
  name = "actionsAddItemPolicy"
  role = aws_iam_role.actions_add_item_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "dynamodb:PutItem",
        Resource = "${aws_dynamodb_table.user_tasks.arn}"
      }
    ]
  })
}

# This policy attachment ensures the `actionsAddItemRole` has basic Lambda execution role permissions, 
# including CloudWatch Logs for logging.
resource "aws_iam_role_policy_attachment" "actions_add_item_basic_execution" {
  role       = aws_iam_role.actions_add_item_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda: actionsGetItems
# This block defines an IAM role for the "actionsGetItems" Lambda function.
resource "aws_iam_role" "actions_get_items_role" {
  name = "actionsGetItemsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# This policy grants the `actionsGetItemsRole` role permission to query tasks (Query action) 
# from the user_tasks table, including any indexes.
resource "aws_iam_role_policy" "actions_get_items_policy" {
  name = "actionsGetItemsPolicy"
  role = aws_iam_role.actions_get_items_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "dynamodb:Query",
        Resource = [
          "${aws_dynamodb_table.user_tasks.arn}",
          "${aws_dynamodb_table.user_tasks.arn}/index/*"
        ]
      }
    ]
  })
}

# This policy attachment ensures the `actionsGetItemsRole` has basic Lambda execution role permissions, 
# including CloudWatch Logs for logging.
resource "aws_iam_role_policy_attachment" "actions_get_items_basic_execution" {
  role       = aws_iam_role.actions_get_items_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda: actionsDeleteItem
# This block defines an IAM role for the "actionsDeleteItem" Lambda function.
resource "aws_iam_role" "actions_delete_item_role" {
  name = "actionsDeleteItemRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# The policy grants the `actionsDeleteItemRole` role permission to delete (DeleteItem) tasks from the user_tasks table.
resource "aws_iam_role_policy" "actions_delete_item_policy" {
  name = "actionsDeleteItemPolicy"
  role = aws_iam_role.actions_delete_item_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "dynamodb:DeleteItem",
        Resource = "${aws_dynamodb_table.user_tasks.arn}"
      }
    ]
  })
}

# This policy attachment ensures the `actionsDeleteItemRole` has basic Lambda execution role permissions, 
# including CloudWatch Logs for logging.
resource "aws_iam_role_policy_attachment" "actions_delete_item_basic_execution" {
  role       = aws_iam_role.actions_delete_item_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
