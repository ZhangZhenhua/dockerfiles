FROM centos/systemd
MAINTAINER "wangtao" 61550080@qq.com

RUN yum -y install wget
RUN wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
RUN yum -y install cobbler cobbler-web dnsmasq syslinux pykickstart httpd vim iproute initscripts livecd-tools

RUN systemctl enable httpd
RUN systemctl enable cobblerd

RUN rm -rf /etc/httpd/conf.d/ssl.conf
RUN sed -i 's#Listen 80#Listen 8011#' /etc/httpd/conf/httpd.conf

COPY conf/dnsmasq.template /etc/cobbler/dnsmasq.template
COPY conf/settings /etc/cobbler/settings
COPY conf/modules.conf /etc/cobbler/modules.conf
COPY conf/pxedefault.template /etc/cobbler/pxe/pxedefault.template

CMD ["/usr/sbin/init"]
