# Cloud9の作成
resource "aws_cloud9_environment_ec2" "aws_handson_s3" {
  instance_type = "t2.micro"
  name = "aws_handson_s3"
  image_id = "amazonlinux-2023-x86_64"
  automatic_stop_time_minutes = 30
}
