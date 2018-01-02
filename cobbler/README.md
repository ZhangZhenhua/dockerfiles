简化cobbler部署


#### 容器

1. build 容器

    ```
    $ docker build -t wt/cobbler .
    ```

2. 启动容器

    ```
    $ docker run --privileged --net host --name httpd -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d wt/cobbler
    ```

#### 添加bootstrap

    ```
    $ cobbler distro add --name=bootstrap --kernel=/root/vmlinuz --initrd=/root/bootstrap.img
    $ cobbler distro edit --name=bootstrap --kopts='root=live:http://192.168.82.1/bootstrap.iso rootfstype=iso9660 rootflags=loop !text !lang !ksdevice'
    $ cobbler profile add --name=bootstrap --distro=bootstrap
    $ cobbler system add --name default --profile=bootstrap
    ```


#### 配置记录


cobbler配置记录:

    ```
    /etc/cobbler/settings                           # 部署容器后需修改server 和 next_server地址
        server: 172.17.0.2
        next_server: 172.17.0.2
        http_port: 8011
        manage_dhcp: 1
        manage_dns: 1
        pxe_just_once: 1
        allow_dynamic_settings: 1

    /etc/cobbler/modules.conf
        [dns]
        module = manage_dnsmasq
        [dhcp]
        module = manage_dnsmasq

    /etc/cobbler/dnsmasq.template                   # 部署容器后，需要修改dhcp的ip范围.
        enable-tftp
        tftp-root=/var/lib/tftpboot
        log-queries
        log-facility=/var/log/dnsmasq.log
        log-async=100

    /etc/cobbler/pxe/pxedefault.template
        TIMEOUT 20
    ```
