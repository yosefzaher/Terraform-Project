resource "aws_s3_bucket" "s3-state-bucket" {
    bucket = "s3-state-bucket-terraform-backend"
}

resource "aws_s3_bucket_versioning" "versioning_enable" {
    bucket = aws_s3_bucket.s3-state-bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_dynamodb_table" "dynamodb-lock-table" {
    name = "dynamodb-lock-table"
    hash_key       = "LockID"
    billing_mode     = "PAY_PER_REQUEST"
    
    attribute {
        name = "LockID"
        type = "S"
    }
}

