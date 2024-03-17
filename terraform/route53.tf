# ホストゾーンのデータソース定義
data "aws_route53_zone" "aws_handson_s3" {
  name = "zackzack.link" 
}

# Aレコードの定義
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "aws_handson_s3" {
  zone_id = data.aws_route53_zone.aws_handson_s3.zone_id
  name = data.aws_route53_zone.aws_handson_s3.name
  type = "A"

  # CloudFrontのエイリアスを指定を設定する場合
  alias {
    name = aws_cloudfront_distribution.aws_handson_s3.domain_name
    zone_id = aws_cloudfront_distribution.aws_handson_s3.hosted_zone_id
    evaluate_target_health = false
  }
  
  # S3バケットのエイリアスを指定を設定する場合
  # alias {
  #   # S3バケットののDNSドメイン名
  #   name = aws_s3_bucket_website_configuration.aws_handson_s3.website_domain
  #   # S3バケットのホストゾーンID
  #   zone_id = aws_s3_bucket.aws_handson_s3.hosted_zone_id
  #   # ターゲットのヘルスチェック
  #   evaluate_target_health = false
  # }

}

# CNAMEレコードの定義(DNS検証用)
# https://dev.classmethod.jp/articles/terraform-aws-certificate-validation/#toc-5
resource "aws_route53_record" "aws_handson_s3_cfront" {
  for_each = {
    for dvo in aws_acm_certificate.aws_handson_s3_cfront.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  name = each.value.name
  type = each.value.type
  records = [ each.value.record ]
  zone_id = data.aws_route53_zone.aws_handson_s3.id
  ttl = 60
}
