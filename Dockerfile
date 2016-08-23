FROM centos:centos7

MAINTAINER Edward J Kim <edward.junhyung.kim@gmail.com>

ENV HTTPD_PREFIX /etc/httpd
ENV PATH $HTTPD_PREFIX/bin:$PATH
WORKDIR $HTTPD_PREFIX

ENV HTTPD_VERSION 2.4.20
ENV HTTPD_BZ2_URL http://shinyfeather.com//httpd/httpd-$HTTPD_VERSION.tar.bz2

ENV APR_VERSION 1.5.2
ENV APR_BZ2_URL http://mirror.cogentco.com/pub/apache//apr/apr-$APR_VERSION.tar.bz2

RUN yum -y install epel-release && \
    yum -y update && \
    yum -y install \
        vim \
        wget \
        bzip2 \
        rpm-build \
        make \
        autoconf \
        zlib-devel \
        libselinux-devel \
        libuuid-devel \
        pcre-devel \
        openldap-devel \
        lua-devel \
        libxml2-devel \
        openssl \
        openssl-devel \
        autoconf \
        libtool \
        doxygen \
        mailcap && \
    yum clean all && \
    set - x && \
    wget "$HTTPD_BZ2_URL" && \
    wget "$APR_BZ2_URL" && \
    rpmbuild -tb --clean "apr-$APR_VERSION.tar.bz2" && \
    rpm -ivh /root/rpmbuild/RPMS/x86_64/apr-*.rpm && \
    rm "apr-$APR_VERSION.tar.bz2" && \
    \
    wget ftp://ftp.at.netbsd.org/opsys/linux/fedora/linux/releases/17/Everything/source/SRPMS/d/distcache-1.4.5-23.src.rpm && \
    rpmbuild --rebuild --clean distcache-1.4.5-23.src.rpm && \
    rpm -ivh ~/rpmbuild/RPMS/x86_64/distcache-*.rpm && \
    rm distcache-1.4.5-23.src.rpm && \
    \
    yum -y install apr-util-ldap apr-util-devel && \
    rpmbuild -tb --clean "httpd-$HTTPD_VERSION.tar.bz2" && \
    rpm -ivh /root/rpmbuild/RPMS/x86_64/httpd-*.rpm && \
    rpm -ivh /root/rpmbuild/RPMS/x86_64/mod_*.rpm && \
    rm "httpd-$HTTPD_VERSION.tar.bz2"
  
COPY httpd-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/httpd-foreground

EXPOSE 80 443

CMD ["/usr/local/bin/httpd-foreground"]
