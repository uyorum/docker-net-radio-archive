# docker-net-radio-archive
Run net-radio-archive in Docker container

## これは何？
@yayuguさんの[ねとらじあーかいぶ](https://github.com/yayugu/net-radio-archive)の環境をさくっと構築するためのもろもろ

以下のものが含まれています

* ねとらじあーかいぶを動かすDockerコンテナのDockerfileと必要なファイル
* MySQL，ねとらじあーかいぶを起動させるdocker-compose.yml

## ねとらじあーかいぶ
ソフトウェアの詳細は[本家リポジトリ](https://github.com/yayugu/net-radio-archive)を参照してください．今のところニコ生には非対応です．  
設定は以下の環境変数で調整してください．

|環境変数|デフォルト|設定例|説明|
|:-----|:------|:----|:--|
|NRA_WORKING_FILES_RETENTION_PERIOD_DAYS|30|7|settings.ymlの`working_files_retention_period_days`|
|NRA_RADIKO_CHANNELS|(空)|QRR,LFT|settings.ymlの`radiko_channels`|
|NRA_RADIRU_CHANNELS|(空)|r1,r2,fm|settings.ymlの`radiru_channels`|
|NRA_FORCE_MP4|false|true|settings.ymlの`force_mp4`|
|NRA_AGON_MAIL|(空)|foo@example.com|settings.ymlの`agon.mail`|
|NRA_AGON_PASSWORD|(空)|XXXXXX|settings.ymlの`agon.password`|
|NRA_DB_HOST|net-radio.db||database.ymlの`host`|
|NRA_DB_USER|root||database.ymlの`username`|
|NRA_DB_PASSWORD|password||database.ymlの`password`|
|NRA_DB_NAME|net-radio||database.ymlの`database`|
|NRA_ARCHIVE_FILES_RETENTION_PERIOD_DAYS|0|60|指定日数より古いファイルを自動で削除する(0=自動削除しない)|

```bash
$ git clone https://github.com/uyorum/docker-net-radio-archive
$ cd docker-net-radio-archive/net-radio-archive
$ docker build -t net-radio-archive .
$ docker run -d \
    --name net-radio-db \
    --env MYSQL_ROOT_PASSWORD=password \
    --env MYSQL_DATABASE=net-radio \
    mysql:5
$ docker run -d \
    --name net-radio-archive \
    --link net-radio-db:net-radio.db \
    -v /net-radio:/net-radio \
    net-radio-archive
```

## docker-compose
MySQL，ねとらじあーかいぶを一括起動します．  
Dockerホストの`/net-radio`ディレクトリにダウンロードしたコンテンツが貯まっていくのでサイズの大きなディスクをマウントしておくなどした方がいいです．

```bash
$ docker-compose up -d
```

必要に応じてねとらじあーかいぶの設定(環境変数)を追加・変更して使用してください．  
なおいくつかの値をデフォルトから変更しています．詳細はdocker-dompose.ymlを見てください．
