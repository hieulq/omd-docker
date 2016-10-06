# omd for centos
FROM centos:latest
MAINTAINER Hieu LE <hieulq19@gmail.com>
EXPOSE 443 80 22 5666 6556 5000
RUN echo 'root:docker' | chpasswd
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
RUN rpm -ivh https://labs.consol.de/repo/stable/rhel7/x86_64/labs-consol-stable.rhel7.noarch.rpm
RUN yum makecache
RUN yum install -y which telnet net-tools check-mk-agent
RUN yum install -y omd-labs-edition
RUN sed -i 's|echo "on"$|echo "off"|' /opt/omd/versions/default/lib/omd/hooks/TMPFS
RUN omd create demo || true
RUN omd config demo set APACHE_MODE own
RUN omd config demo set APACHE_TCP_ADDR 0.0.0.0
RUN omd config demo set TMPFS off
RUN omd start

# Add watchdog script
ADD watchdog.sh /opt/omd/watchdog.sh
RUN chmod +x /opt/omd/watchdog.sh

ENTRYPOINT ["/opt/omd/watchdog.sh"]
