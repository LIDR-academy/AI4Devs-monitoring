resource "aws_s3_bucket" "code_bucket" {
  bucket = "ai4devsjga"
}

resource "aws_s3_bucket_acl" "code_bucket_acl" {
  bucket = aws_s3_bucket.code_bucket.id
  acl    = "private"
}

resource "null_resource" "generate_zip" {
  provisioner "local-exec" {
    command = "cd .. && sh ./generar-zip.sh"
    working_dir = "${path.module}"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "aws_s3_object" "backend_zip" {
  bucket = aws_s3_bucket.code_bucket.id
  source = "../backend.zip"  # Asegúrate de que esta ruta es correcta
  key    = "backend/backend.zip"
}

resource "aws_s3_object" "frontend_zip" {
  bucket = aws_s3_bucket.code_bucket.id
  source = "../frontend.zip"  # Asegúrate de que esta ruta es correcta
  key    = "frontend/frontend.zip"
}
