# Lambda: authRegister
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

resource "aws_iam_role_policy_attachment" "auth_register_basic_execution" {
  role       = aws_iam_role.auth_register_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda: authLogin
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

resource "aws_iam_role_policy_attachment" "auth_login_basic_execution" {
  role       = aws_iam_role.auth_login_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda: actionsAddItem
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

resource "aws_iam_role_policy_attachment" "actions_add_item_basic_execution" {
  role       = aws_iam_role.actions_add_item_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda: actionsGetItems
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

resource "aws_iam_role_policy_attachment" "actions_get_items_basic_execution" {
  role       = aws_iam_role.actions_get_items_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda: actionsDeleteItem
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

resource "aws_iam_role_policy_attachment" "actions_delete_item_basic_execution" {
  role       = aws_iam_role.actions_delete_item_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
