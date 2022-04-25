# dockerengine-on-vagrant

* Vagrant (VirtualBox, Debian/bullseye) 上で動かすDocker Engine
* Docker Machine (+boot2docker) の代わり


# requirements

* VirtualBox
* Docker CLI
* Vagrant


# usage

仮想マシンを立ち上げ.

```sh
vagrant up
```

環境変数 `DOCKER_HOST` 指定して, 仮想マシンで起動するDocker Engine を利用可能.

```sh
set -x DOCKER_HOST "tcp://127.0.0.1:12376"
```

動作確認.

```sh
docker run --rm hello-world
```

## environment variables

* `DOCKER_PORT`
  ホスト側に転送するDocker Engineのポート番号を指定. デフォルト 12376.

* `VAGRANT_DOCKER_DIR`
  仮想マシンに共有するディレクトリを指定. デフォルトは ホームディレクトリ


## systemd

systemdでサービス化する場合, ユニットファイルを作成.

```sh
systemctl --user edit --force --full docker-userlevel.service
```

`VAGRANT_CWD` は Vagrantfile があるディレクトリを指定.

```
[Unit]
Description = Docker Engine on user level

[Service]
Type=oneshot
Environment="VAGRANT_CWD=%h/Documents/Projects/dockerengine-on-vagrant"
Environment="DOCKER_PORT=12376"
Environment="VAGRANT_DOCKER_DIR=%h/Documents/Projects"
ExecStart=vagrant up
ExecStop=vagrant halt
RemainAfterExit=yes

[Install]
WantedBy=default.target
```

次のコマンドで, サービスを起動/有効化.

```sh
systemctl --user enable --now docker-userlevel.service
```
