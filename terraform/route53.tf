# ホストゾーンのデータソース定義
data "aws_route53_zone" "aws_handson_s3" {
  name = "zackzack.link" 
}

# DNSレコードの定義
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "aws_handson_s3" {
  zone_id = data.aws_route53_zone.aws_handson_s3.zone_id
  name = data.aws_route53_zone.aws_handson_s3.name
  type = "A"

  # S3バケットのエイリアスを指定
  alias {
    # S3バケットののDNSドメイン名
    name = aws_s3_bucket.aws_handson_s3.website_domain
    # S3バケットのホストゾーンID
    zone_id = aws_s3_bucket.aws_handson_s3.hosted_zone_id
    # ターゲットのヘルスチェック
    evaluate_target_health = false
  }
}
