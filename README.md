# dockerengine-on-vagrant

Vagrant (VirtualBox, Ubuntu 20.04) 上で動かすDocker Engine


# requirements

* VirtualBox
* Docker CLI
* Vagrant

ぜんぶbrewとかでOK.


# usage

つかいかた


## VM作成とプロビジョニング

Vagrantfile ファイルがあるディレクトリでこれを実行.

```sh
vagrant up
```

仮想マシンが作られ, プロビジョニングされる.

途中で使うネットワークアダプタの選択を求められる.

```
==> default: Available bridged network interfaces:
1) en0: Wi-Fi (AirPort)
2) en1: Thunderbolt 1
3) en2: Thunderbolt 2
4) bridge0
5) p2p0
6) awdl0
7) llw0
==> default: When choosing an interface, it is usually the one that is
==> default: being used to connect to the internet.
==> default:
    default: Which interface should the network bridge to? 1
```

ブリッジ接続になるので, これがいやなら `public_network` を `private_network` に変更する.

```diff
- config.vm.network "public_network"
+ config.vm.network "private_network"
```

## VMのIPを確認する

VMのIPを確認する. `vagrant ssh` でVMにログイン.

このとき表示されるグリーティングメッセージでIPがわかる.

```
$ vagrant ssh
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-105-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Apr 13 03:32:04 UTC 2022

  System load:              0.13
  Usage of /:               5.1% of 38.71GB
  Memory usage:             26%
  Swap usage:               0%
  Processes:                123
  Users logged in:          0
  IPv4 address for docker0: 172.17.0.1
  IPv4 address for enp0s3:  10.0.2.15
  IPv4 address for enp0s8:  192.168.10.123
  IPv6 address for enp0s8:  2404:7a83:8000:2d00:a00:27ff:febc:7a65


29 updates can be applied immediately.
22 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable
```

この出力の場合は「192.168.10.123」


## 環境変数とSSH秘密鍵を登録する

環境変数 `DOCKER_HOST` を設定. SSH経由でdockerコマンドを使う.

```
$ set -x DOCKER_HOST "ssh://vagrant@192.168.10.123:22"
```

`DOCKER_HOST` 環境変数のSSH URLスキームに秘密鍵を乗せられず, `$HOME/.ssh/config` も使えないため,
`ssh-add` コマンドで秘密鍵を登録.

```
$ ssh-add .vagrant/machines/default/virtualbox/private_key
Identity added: .vagrant/machines/default/virtualbox/private_key (.vagrant/machines/default/virtualbox/private_key)
```

DOCKER_HOSTに指定したSSHホストにsshコマンドで接続できることを確認する.

```
$ ssh -lvagrant 192.168.10.123
```


## dockerコマンドが使えることをチェック

```
docker run hello-world
```


## 補足 1 運用

Vagrantfileがあるディレクトリ以下を仮想マシンに共有するようにしている.
このへんで調整可能. SRC/DESTは同じパスにしておいたほうが使いやすいです.

```
config.vm.synced_folder Dir.pwd, Dir.pwd
```

環境変数 `DOCKER_HOST` とssh-addコマンドによる秘密鍵の登録は,
使うたびに必要になりそうなので適宜運用を考えて.


## 補足 2 Vagrant

仮想マシンの終了.

```
vagrant halt
```

仮想マシンの起動.

```
vagrant up
```

仮想マシンの削除.

```
vagrant destroy
```
