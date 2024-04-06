#  docker-resonite-headless-dotnet8
[Resonite](https://resonite.com/)のHeadless鯖を.NET 8で動くよう[パッチ](https://github.com/BlueCyro/Cumulo)し、Dockerで動かすやつ

## 前提条件
- Docker, Docker Composeのインストール
- Steamガードを無効化したSteamアカウント
- ResoniteのHeadless用コード
## 推奨
- Docker Buildxのインストール

## インストール手順
1. このリポジトリをクローンする
2. `cp build-resonite-headless-image.sh.sample build-resonite-headless-image.sh && cp docker-compose.yml.sample docker-compose.yml` を実行する
3. build-resonite-headless-image.sh に、Steamアカウントのid パスワード, Headless用のクローズドベータコードを書き込む
4. `./build-resonite-headless-image.sh`　実行してDockerイメージをビルドする（※Resonite含むためイメージを公開しないこと！）

## 起動
`docker compose up -d` で起動！

## Headlessコマンドの入力方法
`docker compose attach resonite-headless`を実行すると、headless実行中のコンテナにattachされ、headlessコマンドを入力できる状態になります。抜けるときは`Ctrl + p`, `Ctrl + q`の順にキーを同時押ししてください。（※`Ctrl + C`を押すとheadlessが落ちます）

## 停止
`docker compose down`もしくは、attach中に`shutdown`コマンド実行

## 更新
`./build-resonite-headless-image.sh`　実行してDockerイメージをビルドすると、Resonite等が更新されます。（※Resonite含むためイメージを公開しないこと！）
