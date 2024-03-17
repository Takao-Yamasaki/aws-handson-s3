provider "aws" {
  region = "ap-northeast-1"
}

# for ACM
# https://zenn.dev/not75743/articles/9621e088b757b3
provider "aws" {
  # マルチリージョン対応のため、エイリアス設定
  alias = "virginia"
  # バージニア北部のリージョンを指定
  region = "us-east-1"
}
