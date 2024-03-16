# S3バケットを作成
resource "aws_s3_bucket" "aws_handson_s3" {
  # 外部公開する場合、バケット名はドメイン名と一致させる必要がある
  bucket = "zackzack.link"
  tags = {
    Name = "zackzack.link"
  }
}

# ウェブサイトホスティングの設定
resource "aws_s3_bucket_website_configuration" "aws_handson_s3" {
  bucket = aws_s3_bucket.aws_handson_s3.id
  
  # インデックスドキュメントの設定
  index_document {
    suffix = "index.html"
  }
}

# S3バケットパブリックアクセスブロックを解除
resource "aws_s3_bucket_public_access_block" "aws_handson_s3" {
  bucket = aws_s3_bucket.aws_handson_s3.id
  block_public_acls =  false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

# バケットポリシーの作成
resource "aws_s3_bucket_policy" "aws_handson_s3" {
  bucket = aws_s3_bucket.aws_handson_s3.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicReadGetObject",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "s3:GetObject"
        ],
        "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.aws_handson_s3.bucket}/*"
        ]
      }
    ]
  }
  POLICY

  // NOTE: S3バケットパブリックアクセスブロックを解除した後に作成する
  depends_on = [
    aws_s3_bucket_public_access_block.aws_handson_s3,
  ]
}

// 静的ウェブサイトホスティングのURLを表示
output "aws_handson_s3_url" {
  value = aws_s3_bucket.aws_handson_s3.website_endpoint
}
