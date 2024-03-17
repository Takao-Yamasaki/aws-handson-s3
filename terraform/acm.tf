# ACMでSSL証明書の作成
resource "aws_acm_certificate" "aws_handson_s3_cfront" {
  # バージニア北部で作成
  provider = aws.virginia
  domain_name = data.aws_route53_zone.aws_handson_s3.name
  # ドメイン名の追加
  subject_alternative_names = [  ]
  # 自動更新したいので、DNS検証
  validation_method = "DNS"
  # 新しい証明書を作ってから、古い証明書を差し替える
  lifecycle {
    create_before_destroy = true
  }
}

# SSL証明書の検証完了まで待機
# NOTE: 実際にリソースを作成するわけではない
resource "aws_acm_certificate_validation" "aws_handson_s3_cfront" {
  # バージニア北部を指定
  provider = aws.virginia
  certificate_arn = aws_acm_certificate.aws_handson_s3_cfront.arn
  validation_record_fqdns =  [for record in aws_route53_record.aws_handson_s3_cfront : record.fqdn]
}
