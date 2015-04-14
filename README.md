# kureha
Dropbox で同期されてきて入ってきた画像を自動で Gyazo に上げてくれるやつ。

# 使い方
1. [config.rb.example](config.rb.example) の `ACCESS_TOKEN` を
[https://gyazo.com/api](https://gyazo.com/api) とかで登録したりして持ってくる。
2. [kureha.rb](kureha.rb) の `WATCHPATH = "images/"` を監視したいディレクトリにする
([images](images) のシンボリックリンク先を変更する
(こっちを想定して `kureha.rb` に書かれてある？
なんで `WATCHPATH` が `congif.rb` になっていないか、`images` がレポジトリに入っているのか今見たら謎))。

あとは `bundle install` したら動く。

# systemd で動かす
[kureha.service](kureha.service) を適当な場所(`~/.config/systemd/user/`) に設置してユーザ権限で動かすことを想定している。
`ExecStart` と `ExecReload` の編集が必要な可能性があるので、空気を読んで編集する。
