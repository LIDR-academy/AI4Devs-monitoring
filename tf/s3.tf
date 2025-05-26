resource "aws_s3_bucket" "code_bucket" {
  bucket = "ai4devs-code-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "code_bucket_public_access_block" {
  bucket = aws_s3_bucket.code_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
  key    = "backend.zip"
  source = "${path.module}/../backend.zip"
}

resource "aws_s3_object" "frontend_zip" {
  bucket = aws_s3_bucket.code_bucket.id
  key    = "frontend.zip"
  source = "${path.module}/../frontend.zip"
}
