## Setup

- set AWS credential

```shell
$ cp .envrc.example .envrc
$ direnv allow
direnv: loading /path/to/terraform-sandbox/.envrc
direnv: export +AWS_ACCESS_KEY_ID +AWS_DEFAULT_REGION +AWS_SECRET_ACCESS_KEY

$ aws sts get-caller-identity --query Account --output text
xxxxxxxxxxxx
```

## TL;DR

Route53 + CloudFront + S3 で静的サイトをホスティングするためのサンプルコード

- AWS マネジメントコンソールから Route53 でドメインを登録
- 自動作成されたホストゾーンを terraform にインポートする
  `terraform import aws_route53_zone.this ${zone_id}`
- cloudfront とそのオリジンとなる S3 の作成
- us-east-1（バージニア）に証明書をインポート
- Route53 レコードを追加
- cloudfront にドメインと証明書を設定
