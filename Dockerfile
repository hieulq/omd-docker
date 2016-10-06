# omd for ubuntu14.04
FROM ubuntu:trusty
MAINTAINER Hieu LE <hieulq19@gmail.com>

EXPOSE 443 80 22 5666 6556 5000

RUN echo 'root:docker' | chpasswd

RUN apt-get update
RUN apt-get -y install wget
RUN wget -q "https://labs.consol.de/repo/stable/RPM-GPG-KEY" -O - | sudo apt-key add -
RUN echo "deb http://labs.consol.de/repo/stable/ubuntu trusty main" > /etc/apt/sources.list.d/labs-consol-stable.l$

# Install OMD
RUN apt-get update
RUN apt-get -y install omd-1.30 check-mk-agent net-tools netcat xinetd openssh-server
RUN sed "s/disable        = yes/disable        = no/" -i /etc/xinetd.d/check_mk
RUN sudo service xinetd restart

RUN echo "APACHE_ULIMIT_MAX_FILES=true" >> /etc/apache2/envvars
RUN echo ServerName docker-omd > /etc/apache2/conf-available/docker-servername.conf
RUN a2enconf docker-servername

RUN sed -i 's|echo "on"$|echo "off"|' /opt/omd/versions/default/lib/omd/hooks/TMPFS
RUN omd create demo || true
RUN omd config demo set APACHE_MODE own
RUN omd config demo set APACHE_TCP_ADDR 0.0.0.0
RUN omd config demo set THRUK_COOKIE_AUTH off
RUN omd config demo set TMPFS off
RUN omd start

RUN mkdir -p /root/.ssh
ADD ssh/id_rsa /root/.ssh/id_rsa
ADD ssh/id_rsa.pub /root/.ssh/id_rsa.pub
ADD ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/id_rsa

# Add watchdog script
ADD watchdog.sh /opt/omd/watchdog.sh
RUN chmod +x /opt/omd/watchdog.sh

ENTRYPOINT ["/opt/omd/watchdog.sh"]
#CMD /bin/bash
