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
