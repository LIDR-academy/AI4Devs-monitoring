resource "aws_s3_bucket" "code_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "${var.project_name}-code-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "code_bucket_acl" {
  bucket = aws_s3_bucket.code_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "code_bucket_versioning" {
  bucket = aws_s3_bucket.code_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "code_bucket_sse" {
  bucket = aws_s3_bucket.code_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "code_bucket_pab" {
  bucket = aws_s3_bucket.code_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "null_resource" "generate_zip" {
  provisioner "local-exec" {
    command     = "cd .. && sh ./generar-zip.sh"
    working_dir = path.module
  }

  triggers = {
    always_run = timestamp()
  }
}

resource "aws_s3_object" "backend_zip" {
  bucket     = aws_s3_bucket.code_bucket.bucket
  key        = "backend.zip"
  source     = "${path.module}/../backend.zip"
  depends_on = [null_resource.generate_zip]
}

resource "aws_s3_object" "frontend_zip" {
  bucket     = aws_s3_bucket.code_bucket.bucket
  key        = "frontend.zip"
  source     = "${path.module}/../frontend.zip"
  depends_on = [null_resource.generate_zip]
}
