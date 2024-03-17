# aws-handson-s3
S3に静的ウェブサイトホスティングを行うサンプル

## 起動方法
```
terraform apply
```
## HTMLファイルのアップロード
- S3バケットにindex.htmlをアップロードすること

## Cloud9上での作業
- ディレクトリを作成
```
mkdir my-webpage
```
- HTMLファイルに変更を加える
- AWS CLIを使って、変更したHTMLをS3バケットにアップロード
```
aws s3 cp index.html s3://zackzack.link
```
- AWS CLIを使って、カレントディレクトリ配下を全てS3バケットにアップロード
```
pwd /home/ec2-user/environment/my-webpage
aws s3 cp . s3://zackzack.link --recursive
```
- スーパーリロードしてキャッシュを削除すると、ファビコンが表示されるようになる
## CloudFront
- CDNサービス
- キャッシュの有効期間であるTTLを設定することができるので、長期間キャッシュすべきコンテンツかどうか検討して、設定することが可能
- WAFやACMとの連携も可能
- コンテンツキャッシュを行うので、以下２つのメリットがある
- レスポンス速度の向上
- オリジンサーバーの負荷軽減
## Route53
今回は、以下の2つの機能を使用する
- ドメインを登録するレジストラの機能
- ドメイン名とIPアドレスに名前解決するネームサーバーの機能
## ACM
- SSL/TLSサーバー証明書のプロビジョニング管理・展開・更新をおこなう
- プライベート証明書の発行が可能
- 証明書のデプロイや更新が自動化されることがメリット
- 配置対象は、ELBやCloudFront、APIGatewayなどでここに配置する場合は無料で使用可能

## アクセスを確認
### CloudFront
- https://xxxxxxxxx.cloudfront.net/
- 開発者ツールの[Network]からスーパーリロードを行い、画像がCloudFrontにキャッシュされていることを確認
```
# CloudFrontにキャッシュ
X-Cache: Hit from cloudfront
# ブラウザにキャッシュ
X-Cache: Miss from cloudfront
```
### S3
- http://xxxxxx.xxx.s3-website-ap-northeast-1.amazonaws.com/
-  開発者ツールの[Network]から、レスポンスにX-Cacheの記載がないことを確認

### ACMを使って、Route53-CloudFront-S3でHTTPアクセス
- (注意)SSL証明書は、バージニア北部で作成すること
- https://zackzack.link/
```
# CloudFrontにキャッシュ
X-Cache: Hit from cloudfront
```
## CloudFrontからのみのアクセスに限定する
- S3バケットポリシーに制限を入れる

## 削除方法
- (注意)S3バケット内を空にした上で実施すること
```
terraform destroy
```

## 参考
- CloudFrontのデフォルトルートオブジェクトとS3の静的ウェブサイトホスティングのインデックスドキュメントの動作の違い
https://dev.classmethod.jp/articles/cloudfront_s3_difference/
