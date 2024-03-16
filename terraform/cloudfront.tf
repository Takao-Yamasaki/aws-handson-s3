# CloudFrontの作成
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
# https://dev.classmethod.jp/articles/static-web-with-cf-s3-tf/
resource "aws_cloudfront_distribution" "aws_handson_s3" {
  # 配信元のオリジンサーバーを設定
  origin {
    domain_name = aws_s3_bucket.aws_handson_s3.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.aws_handson_s3.id
    origin_id = aws_s3_bucket.aws_handson_s3.id
  }
  enabled = true

  default_root_object = "index.html"

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
    viewer_protocol_policy = "allow-all"
  }

  # 配信地域を設定
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = [ "JP" ]
    }
  }
  # 証明書を管理
  # CloudFrontのドメインを使用するので設定
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # 料金クラスの設定
  # 北米、欧州、アジア、中東、アフリカを使用
  price_class = "PriceClass_200"
}

# オリジンアクセスの設定
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control
resource "aws_cloudfront_origin_access_control" "aws_handson_s3" {
  name                              = "aws_handson_s3"
  description                       = "for aws_handson_s3"
  # オリジンタイプ
  origin_access_control_origin_type = "s3"
  # 常にリクエストに署名する
  signing_behavior                  = "always"
  # 署名プロトコルの設定
  signing_protocol                  = "sigv4"
}
