提供制作rpm、deb、pypi仓库的环境。

* 目录说明:

    ```
    /srv/类型/操作系统/软件名称/版本/ 
        类型:    source | mirrors
            source 存放源包
            mirrors 存放制作完成的仓库
        操作系统: centos | ubuntu | pypi | docker
            docker 目录直接存放镜像，没有子目录
        软件名称: ceph | zabbix | saltstack | ...
        版本:    10.2.10-2 | ....
    example:
    /srv/source/docker/
    /srv/source/centos/ceph/10.2.10-2/
    /srv/source/pypi/ceph/10.2.10-2/
    /srv/source/ubuntu/ceph/10.2.10-2/
    /srv/mirrors/centos/ceph/10.2.10-2/
    /srv/mirrors/pypi/ceph/10.2.10-2/
    /srv/mirrors/ubuntu/ceph/10.2.10-2/
    # 需严格按照目录结构存放软件包。
    ```

#### 制作镜像

```
$ docker build -t repository .
```

#### 一、pypi 

制作pypi仓库步骤：运行容器、准备源包、创建索引、拷贝仓库、提供example.conf文件。

* 运行容器:

    ```
    $ docker run -v /var/www/html/:/srv/ -it repository bash
    ```

* 准备源包:

    ```
    方式一:
        将提前下载完成的包拷贝到/srv/source/pypi/.../.../目录下
    方式二:
        $ pip2tgz /srv/source/pypi/.../.../ pip 
        $ pip2tgz /srv/source/pypi/.../.../ -r packages_list.txt
    ```
    
* 创建索引:

    ```
    $ dir2pi -S /srv/source/pypi/.../.../
    ```
    
* 拷贝仓库:

    ```
    $ mv /srv/source/pypi/.../.../simple/ /srv/mirrors/pypi/.../.../
    ```

* 提供example.conf文件:

    ```
    $ cat example.conf
    [global]
    index-url = http://127.0.0.1/mirrors/pypi/.../.../simple/
    timeout = 20
    [install]
    trusted-host =  127.0.0.1
    ```
#### 二、ubuntu

制作ubuntu仓库需提前准备好源包和配置文件(distributions options).

* 配置文件存放位置:

    ```
    $ ls /srv/source/ubuntu/ceph/10.2.10-2/
    ceph.deb conf/
    $ ls /srv/source/ubuntu/ceph/10.2.10-2/conf/
    distributions options
    ```

* 配置文件参考:

    ```
    $ cat distributions
    Origin:     ceph               # 你的名字
    Label:      ceph               # 库的名字
    Suite:      jewel              # 版本名称
    Codename:   jewel
    Version:   10.2.10-2          # 版本号
    Architectures:  amd64   i386         # 软件包所支持的架构， 比如 i386 或 amd64
    Components: main               # 包含的部件，比如 main restricted universe  multiverse
    Description:    private main deb repository
    SignWith:   default

    $ cat options
    verbose
    basedir  .
    ask-passphrase
    distdir  /srv/mirrors/ubuntu/ceph/10.2.10-2/dists
    outdir   /srv/mirrors/ubuntu/ceph/10.2.10-2         # 制作好的仓库存放目录
    ```

* 运行容器:

    ```
    $ docker run -v /var/www/html/:/srv/ -it repository bash
    ```

* 制作仓库:

    ```
    $ reprepro --ask-passphrase -Vb /srv/source/ubuntu/ceph/10.2.10-2/conf/ export
    $ reprepro -b /srv/source/ubuntu/ceph/10.2.10-2/conf/ -C main includedeb jewel /srv/source/ubuntu/ceph/10.2.10-2/*.deb
    $ cp /keys/public.key /srv/mirrors/ubuntu/ceph/10.2.10-2/public.key
    ```

* 提供example.list:

    ```
    $ cat /srv/mirrors/ubuntu/ceph/10.2.10-2/example.list
    deb http://127.0.0.1/mirrors/ubuntu/ceph/10.2.10-2/ jewel main
    ```

#### 三、centos


* 运行容器:

    ```
    $ docker run -v /var/www/html/:/srv/ -it repository bash
    ```

* 拷贝目录:

    ```
    $ cp -r /srv/source/centos/ceph/10.2.10-2/ /srv/mirrors/centos/ceph/10.2.10-2/
    ```

* 制作仓库:

    ```
    $ createrepo /srv/mirrors/centos/ceph/10.2.10-2/
    ```
    
* 提供example.repo

    ```
    $ cat /srv/mirrors/centos/ceph/10.2.10-2/example.repo
    [ceph-10.2.10-2]
    name=ceph-10.2.10-2
    baseurl=http://127.0.0.1/mirrors/centos/ceph/10.2.10-2/
    enabled=1
    gpgcheck=0
    ```
