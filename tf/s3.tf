resource "aws_s3_bucket" "code_bucket" {
  # Globally unique name using AWS account ID
  bucket = "ai4devs-project-code-bucket-${data.aws_caller_identity.current.account_id}"
}

# Note: S3 buckets are private by default since April 2023
# ACL configuration not needed unless specific permissions required

resource "null_resource" "generate_zip" {
  provisioner "local-exec" {
    command = "cd .. && sh ./generar-zip.sh"
    working_dir = "${path.module}"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Modern approach: aws_s3_object instead of aws_s3_bucket_object
resource "aws_s3_object" "backend_zip" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key    = "backend.zip"
  source = "${path.module}/../backend.zip"
  depends_on = [null_resource.generate_zip]
}

resource "aws_s3_object" "frontend_zip" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key    = "frontend.zip"
  source = "${path.module}/../frontend.zip"
  depends_on = [null_resource.generate_zip]
}
