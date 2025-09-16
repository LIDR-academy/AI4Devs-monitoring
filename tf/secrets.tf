resource "aws_secretsmanager_secret" "db_secret" {
  name        = var.db_secret_name
  description = "Credenciales de la base de datos para AI4Devs-monitoring"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    DB_USER     = "LTIdbUser"
    DB_PASSWORD = "D1ymf8wyQEGthFR1E9xhCq"
    DB_NAME     = "LTIdb"
    DB_PORT     = "5432"
    DATABASE_URL = "postgresql://LTIdbUser:D1ymf8wyQEGthFR1E9xhCq@localhost:5432/LTIdb"
  })
}