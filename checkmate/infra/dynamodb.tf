# DynamoDB Table: users
resource "aws_dynamodb_table" "users" {
  name           = "users"    # Table name: 'users'
  read_capacity  = 1          # Initial read capacity
  write_capacity = 1          # Initial write capacity
  hash_key       = "username" # Primary key: 'username'

  # Attribute definitions
  attribute {
    name = "username" # Attribute name: 'username'
    type = "S"        # Attribute type: String (S)
  }
}

# Autoscaling target for read capacity of 'users' table
resource "aws_appautoscaling_target" "dynamodb_table_users_read_target" {
  max_capacity       = 10                                       # Maximum read capacity units
  min_capacity       = 1                                        # Minimum read capacity units
  resource_id        = "table/${aws_dynamodb_table.users.name}" # Reference to the 'users' table
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"       # Dimension to scale: Read capacity
  service_namespace  = "dynamodb"                               # AWS service: DynamoDB
}

# Autoscaling policy for read capacity of 'users' table
resource "aws_appautoscaling_policy" "dynamodb_table_users_read_policy" {
  name               = "DynamoDBReadCapacityPolicy"                                                  # Policy name
  resource_id        = aws_appautoscaling_target.dynamodb_table_users_read_target.resource_id        # Target resource
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_users_read_target.scalable_dimension # Dimension to scale
  service_namespace  = aws_appautoscaling_target.dynamodb_table_users_read_target.service_namespace  # AWS service
  policy_type        = "TargetTrackingScaling"                                                       # Type: Target tracking scaling

  target_tracking_scaling_policy_configuration {
    target_value = 70 # Scale when utilization is at 70%
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization" # Metric: DynamoDB read utilization
    }

    scale_in_cooldown  = 60 # Cooldown period for scaling in
    scale_out_cooldown = 60 # Cooldown period for scaling out
  }
}

# Autoscaling target for write capacity of 'users' table
resource "aws_appautoscaling_target" "dynamodb_table_users_write_target" {
  max_capacity       = 10                                       # Maximum write capacity units
  min_capacity       = 1                                        # Minimum write capacity units
  resource_id        = "table/${aws_dynamodb_table.users.name}" # Reference to the 'users' table
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"      # Dimension to scale: Write capacity
  service_namespace  = "dynamodb"                               # AWS service: DynamoDB
}

# Autoscaling policy for write capacity of 'users' table
resource "aws_appautoscaling_policy" "dynamodb_table_users_write_policy" {
  name               = "DynamoDBWriteCapacityPolicy"                                                  # Policy name
  resource_id        = aws_appautoscaling_target.dynamodb_table_users_write_target.resource_id        # Target resource
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_users_write_target.scalable_dimension # Dimension to scale
  service_namespace  = aws_appautoscaling_target.dynamodb_table_users_write_target.service_namespace  # AWS service
  policy_type        = "TargetTrackingScaling"                                                        # Type: Target tracking scaling

  target_tracking_scaling_policy_configuration {
    target_value = 70 # Scale when utilization is at 70%
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization" # Metric: DynamoDB write utilization
    }

    scale_in_cooldown  = 60 # Cooldown period for scaling in
    scale_out_cooldown = 60 # Cooldown period for scaling out
  }
}

# Define the DynamoDB table for tasks added by users
resource "aws_dynamodb_table" "user_tasks" {
  name           = "user_tasks" # Table name: 'user_tasks'
  read_capacity  = 1            # Initial read capacity
  write_capacity = 1            # Initial write capacity
  hash_key       = "username"   # Primary key: 'username'
  range_key      = "id"         # Sort key: 'id' (to identify specific tasks)

  # Attribute definitions
  attribute {
    name = "username" # Attribute name: 'username'
    type = "S"        # Attribute type: String (S)
  }

  attribute {
    name = "id" # Attribute name: 'id' (task identifier)
    type = "S"  # Attribute type: String (S)
  }
}

# Autoscaling target for read capacity of 'user_tasks' table
resource "aws_appautoscaling_target" "dynamodb_table_user_tasks_read_target" {
  max_capacity       = 20                                            # Maximum read capacity units
  min_capacity       = 1                                             # Minimum read capacity units
  resource_id        = "table/${aws_dynamodb_table.user_tasks.name}" # Reference to the 'user_tasks' table
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"            # Dimension to scale: Read capacity
  service_namespace  = "dynamodb"                                    # AWS service: DynamoDB
}

# Autoscaling policy for read capacity of 'user_tasks' table
resource "aws_appautoscaling_policy" "dynamodb_table_user_tasks_read_policy" {
  name               = "DynamoDBReadCapacityPolicy"                                                       # Policy name
  resource_id        = aws_appautoscaling_target.dynamodb_table_user_tasks_read_target.resource_id        # Target resource
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_user_tasks_read_target.scalable_dimension # Dimension to scale
  service_namespace  = aws_appautoscaling_target.dynamodb_table_user_tasks_read_target.service_namespace  # AWS service
  policy_type        = "TargetTrackingScaling"                                                            # Type: Target tracking scaling

  target_tracking_scaling_policy_configuration {
    target_value = 60 # Scale when utilization is at 60% (a bit more critical than `users` table)
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization" # Metric: DynamoDB read utilization
    }

    scale_in_cooldown  = 60 # Cooldown period for scaling in
    scale_out_cooldown = 60 # Cooldown period for scaling out
  }
}

# Autoscaling target for write capacity of 'user_tasks' table
resource "aws_appautoscaling_target" "dynamodb_table_user_tasks_write_target" {
  max_capacity       = 20                                            # Maximum write capacity units
  min_capacity       = 1                                             # Minimum write capacity units
  resource_id        = "table/${aws_dynamodb_table.user_tasks.name}" # Reference to the 'user_tasks' table
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"           # Dimension to scale: Write capacity
  service_namespace  = "dynamodb"                                    # AWS service: DynamoDB
}

# Autoscaling policy for write capacity of 'user_tasks' table
resource "aws_appautoscaling_policy" "dynamodb_table_user_tasks_write_policy" {
  name               = "DynamoDBWriteCapacityPolicy"                                                       # Policy name
  resource_id        = aws_appautoscaling_target.dynamodb_table_user_tasks_write_target.resource_id        # Target resource
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_user_tasks_write_target.scalable_dimension # Dimension to scale
  service_namespace  = aws_appautoscaling_target.dynamodb_table_user_tasks_write_target.service_namespace  # AWS service
  policy_type        = "TargetTrackingScaling"                                                             # Type: Target tracking scaling

  target_tracking_scaling_policy_configuration {
    target_value = 60 # Scale when utilization is at 60% (a bit more critical than `users` table)
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization" # Metric: DynamoDB write utilization
    }

    scale_in_cooldown  = 60 # Cooldown period for scaling in
    scale_out_cooldown = 60 # Cooldown period for scaling out
  }
}
