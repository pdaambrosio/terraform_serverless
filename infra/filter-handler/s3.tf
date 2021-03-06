resource "aws_s3_bucket" "bucket-filter-images" {
  bucket        = "${var.prefix}-images"
  acl           = "private"
  tags          = var.tags
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.bucket-filter-images.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
