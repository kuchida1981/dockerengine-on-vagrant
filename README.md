# vboxdocker

* Vagrant (VirtualBox, Debian/bullseye) 上で動かすDocker Engine
* Docker Machine (+boot2docker) の代わり

これを用意したモチベーションは docker engine / boot2docker
の開発とサポートが終了したことです.

Linuxデスクトップであれば, ネイティブにDockerを動かせますが,
普段使いのユーザー権限だけで動かせるようにしたかったため, Vagrant (VirtualBox)
を使っています.

現在は Docker Desktop for Linux という選択肢もある. Windows (WSL2), Mac で使う意味は薄いと思います.

Vagrant, VirtualBox, Docker, Systemd にそれなりに習熟した人向け.


## Requirements

* VirtualBox
* Docker CLI
* Vagrant


## Usage

リポジトリをチェックアウトする

```
git checkout https://github.com/kuchida1981/vboxdocker
```

インストールする.

```
make Install
```

Vagrantfile と設定ファイルを `$HOME/.local/share/vboxdocker` へ,
systemd のサービスユニットを `$HOME/.config/systemd/user` へインストールします.

```
$ make install
install -Dm644 Vagrantfile /home/kosuke/.local/share/vboxdocker/Vagrantfile
install -Dm644 default.conf /home/kosuke/.local/share/vboxdocker/default.conf
install -Dm644 service /home/kosuke/.config/systemd/user/vboxdocker@.service
```

`$HOME/.local/share/vboxdocker/default.conf` を見て,
内容を適宜設定してください. 詳しくは後述.

```
$ cat $HOME/.local/share/vboxdocker/default.conf
VBOXDCR_GUESTPORT=2376
VBOXDCR_HOSTPORT=12376
VBOXDCR_SHAREDDIR=/home/kosuke
VBOXDCR_NAME=vboxdocker-default
VBOXDCR_VM_DISKSIZE=20GB
VBOXDCR_VM_MEMORY=2048
VBOXDCR_VM_CPUS=6
VBOXDCR_NETWORK=vboxnet1
```


サービスを起動/有効化します.

```
systemctl --user enable --now vboxdocker@default.service
# または
systemctl --user start vboxdocker@default.service
```

環境変数 `DOCKER_HOST` 指定して, 起動した仮想マシンの Docker Engine を利用できます.

```
set -x DOCKER_HOST "tcp://127.0.0.1:12376"
```

動作確認.

```sh
docker run --rm hello-world
```

## Environment Variables

環境変数についての解説.

### `VBOXDCR_GUESTPORT`

仮想マシン内でのDocker Engine がサービスをListen するポート番号.
デフォルトで 2376. 公開しないので, 特に変更は不要.

### `VBOXDCR_HOSTPORT`

ホスト側に転送するDocker Engineのポート番号. デフォルトで12376.
複数の環境を用意するなら変更が必要なはずです.

### `VBOXDCR_SHAREDDIR`

仮想マシンに共有するディレクトリを指定します. 必ず変えてください.

### `VBOXDCR_NAME`

Vagrantにおけるマシンの名前です.

### `VBOXDCR_VM_DISKSIZE`

仮想マシンのディスクサイズを指定します.
デフォルトは 20GB

### `VBOXDCR_VM_MEMORY`

仮想マシンのメモリサイズを指定します.

デフォルトは 2048. 単位はMBです.

### `VBOXDCR_VM_CPUS`

仮想マシンのCPUコア数? を指定します.

デフォルトは6. 実行環境によってエラーを誘発するかも.

### `VBOXDCR_NETWORK`

仮想マシンのホストオンリーネットワークの名前を指定してください.

デフォルトは vboxnet1
