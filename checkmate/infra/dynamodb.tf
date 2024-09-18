# Table: users
resource "aws_dynamodb_table" "users" {
  name           = "users"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "username"

  attribute {
    name = "username"
    type = "S"
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_users_read_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.users.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_users_read_policy" {
  name               = "DynamoDBReadCapacityPolicy"
  resource_id        = aws_appautoscaling_target.dynamodb_table_users_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_users_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_users_read_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 70 # Scale when utilization is at 70%
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_users_write_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.users.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_users_write_policy" {
  name               = "DynamoDBWriteCapacityPolicy"
  resource_id        = aws_appautoscaling_target.dynamodb_table_users_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_users_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_users_write_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 70 # Scale when utilization is at 70%
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

# Table: user_tasks
resource "aws_dynamodb_table" "user_tasks" {
  name           = "user_tasks"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "username"
  range_key      = "id"

  attribute {
    name = "username"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_user_tasks_read_target" {
  max_capacity       = 20
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.user_tasks.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_user_tasks_read_policy" {
  name               = "DynamoDBReadCapacityPolicy"
  resource_id        = aws_appautoscaling_target.dynamodb_table_user_tasks_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_user_tasks_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_user_tasks_read_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 60 # Scale when utilization is at 60% (a bit more critical than `users` table)
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_user_tasks_write_target" {
  max_capacity       = 20
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.user_tasks.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_user_tasks_write_policy" {
  name               = "DynamoDBWriteCapacityPolicy"
  resource_id        = aws_appautoscaling_target.dynamodb_table_user_tasks_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_user_tasks_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_user_tasks_write_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 60 # Scale when utilization is at 60% (a bit more critical than `users` table)
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
