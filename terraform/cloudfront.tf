# CloudFrontの作成
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
# https://dev.classmethod.jp/articles/static-web-with-cf-s3-tf/
# https://zenn.dev/not75743/articles/9621e088b757b3
resource "aws_cloudfront_distribution" "aws_handson_s3" {
  # 配信元のオリジンサーバーを設定
  origin {
    domain_name = aws_s3_bucket.aws_handson_s3.bucket_regional_domain_name
    origin_id = aws_s3_bucket.aws_handson_s3.id
    
    # CloudFrontからのアクセスのみに制限
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.aws_handson_s3.cloudfront_access_identity_path
    }
  }
  enabled = true

  default_root_object = "index.html"

  # 代替ドメインをCloudFrontに追加
  aliases = [ data.aws_route53_zone.aws_handson_s3.name ]

  # キャッシュの設定
  default_cache_behavior {
    # 許可するHTTPメソッドを設定
    allowed_methods = [ "GET", "HEAD" ]
    # キャッシュするHTTPメソッドを設定
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = aws_s3_bucket.aws_handson_s3.id
    # クッキー・ヘッダー・クエリパラメータの転送を設定
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # TTLでキャッシュの有効期限を設定
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
    # ユーザーが使用できるプロトコルを指定
    viewer_protocol_policy = "redirect-to-https"
  }

  # 配信地域を設定
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = [ "JP" ]
    }
  }
  # 証明書を設定
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.aws_handson_s3_cfront.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # 料金クラスの設定
  # 北米、欧州、アジア、中東、アフリカを使用
  price_class = "PriceClass_200"
}

# Amazon CloudFrontオリジンのアクセスIDを作成
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity
resource "aws_cloudfront_origin_access_identity" "aws_handson_s3" {}
