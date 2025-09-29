resource "aws_s3_bucket" "code_bucket" {
  bucket = "ai4devs-project-code-bucket-adriansendin-20250928"
  acl    = "private"
}

resource "null_resource" "generate_zip" {
  provisioner "local-exec" {
    command     = "powershell -ExecutionPolicy Bypass -File ../generar-zip.ps1"
    working_dir = path.module
  }
  triggers = { always_run = timestamp() }
}

resource "aws_s3_object" "backend_zip" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key    = "backend.zip"
  source = "${path.module}/../backend.zip"
}

resource "aws_s3_object" "frontend_zip" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key    = "frontend.zip"
  source = "${path.module}/../frontend.zip"
}

