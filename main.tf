provider "aws"{
    region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-public-bucket"
  acl    = "public-read"

  versioning {
    enabled = true
  }


  lifecycle_rule {
    id      = "archive"
    enabled = false
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

   logging {
    target_bucket = "my-unique-log-bucket" # Change to your unique log bucket name
    target_prefix = "log/"
  }

}

resource "aws_s3_bucket" "my_log_bucket" {
  bucket = "my-unique-log-bucket" # Change to your unique log bucket name
  acl    = "private"
}


# resource "aws_s3_bucket_policy" "example_policy" {
#   bucket = aws_s3_bucket.example.arn

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Id = "testBucketPolicy"
#     Statement = [
#       {
#         Sid         = "statement1",
#         Effect    = "Deny",
#         Principal = {
#           AWS = "*"
#         }
#         Action    = "s3:*",
#         Resource = [
#           "${aws_s3_bucket.example.arn}",
#           "${aws_s3_bucket.example.arn}/*"
#         ],
#         Condition = {
#           Bool = {
#             "aws:SecureTransport" = "false"
#           }
#         }
#       }
#     ]
#   })
#   depends_on = [aws_s3_bucket.example]
# }