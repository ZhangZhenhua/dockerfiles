提供制作私有仓库的环境

#### 一、build 镜像

```
$ docker build -t reprepro .
```

build环境中已包含制作仓库的keys.

#### 二、ubuntu 仓库

制作ubuntu私有仓库,需要考虑三种挂载点:
	
	* 配置文件: distributions options
	* deb包
	* 输出目录

提前准备目录和文件:

	/srv/
	├── conf
	│   ├── distributions
	│   └── options
	├── incoming					# deb存放目录
	└── output						# 制作完成的仓库将存放在这儿



配置文件参考:

```
$ cat distributions 
Origin:		ceph               # 你的名字
Label:		ceph               # 库的名字
Suite:		jewel              # 版本名称
Codename:	jewel
Version:   10.2.10-2          # 版本号
Architectures:	amd64   i386         # 软件包所支持的架构， 比如 i386 或 amd64
Components:	main               # 包含的部件，比如 main restricted universe multiverse
Description:	private main deb repository
SignWith:	default

$ cat options 
verbose
basedir  .
ask-passphrase
distdir  /srv/optput/ceph/10.2.10-2/dists
outdir   /srv/optput/ceph/10.2.10-2         # 制作好的仓库存放目录
```

运行容器:

```
$ docker run -it -v /srv/:/srv reprepro bash
```

制作仓库(容器中运行):

```
$ reprepro --ask-passphrase -Vb /srv/conf/ export
$ reprepro -b /srv/conf/ -C main includedeb jewel /srv/incoming/*.deb
$ cp /keys/public.key /srv/output/ceph/10.2.10-2/public.key
```

发布包要求:

	* 将仓库拷贝到 /var/www/html/mirrors/ubuntu/ceph/10.2.10-2/目录
	* 提供example.list文件
		deb http://127.0.0.1/mirrors/ubuntu/ceph/10.2.10-2/ jewel main
	* 将源包拷贝到 /var/www/html/mirrors/ubuntu/ceph/10.2.10-2/目录

编写source.list文件，如:

```
deb http://192.168.1.253/mirrors/ubuntu/ceph/10.2.10-2/ jewel main
deb http://192.168.1.253/mirrors/ubuntu/saltstack/20171103/ trusty main
deb http://192.168.1.253/mirrors/ubuntu/zabbix/3.2/ trusty main
```

#### 三、pypi

挂载点:

	* /srv/       输出simple目录

运行容器:

```
$ docker run -it -v /srv/:/srv reprepro bash
```

制作仓库(容器中运行):

```
# 下载软件包
$ pip2tgz /srv/ pip
$ pip2tgz /srv/ -r packages_list.txt
# 创建索引
$ dir2pi -S /srv/
```

发布包要求:

        * 将/srv/simple拷贝到 /var/www/html/mirrors/pypi/目录

编写pip.conf文件，如:

```
$ vim /root/.pip/pip.conf
[global]
index-url = http://127.0.0.1/simple/

[install]
trusted-host=127.0.0.1
```

