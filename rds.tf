resource "aws_db_parameter_group" "csye6225-postgresql_parameter_group" {
  name        = "csye6225-postgresql-parameter-group"
  family      = "postgres16"
  description = "Custom parameter group for PostgreSQL 16"

  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_statement"
    value        = "all"
    apply_method = "immediate"
  }
}


resource "aws_db_instance" "csye6225-postgresql" {
  identifier             = "csye6225"
  instance_class         = var.database_instance_class
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "16.4"
  username               = "csye6225"
  password               = var.database_password
  db_subnet_group_name   = aws_db_subnet_group.csye6225-db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.csye6225-database-security-group.id]
  parameter_group_name   = aws_db_parameter_group.csye6225-postgresql_parameter_group.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_name                = "csye6225"


  tags = {
    Name = "csye6225-postgresql"
  }
}
