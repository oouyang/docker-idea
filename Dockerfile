FROM quay.io/alaska/xfce-ubuntu:latest
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

RUN wget -P /tmp https://download-cf.jetbrains.com/idea/ideaIC-2017.1-no-jdk.tar.gz \
    && tar xvfz /tmp/ideaIC-2017.1-no-jdk.tar.gz -C /opt \
    && ln -s /opt/idea-IC-171.3780.107/bin/idea.sh /usr/bin/idea \
    && rm -rf /var/lib/apt/lists/* /tmp/*z

ADD .config /root/.config

CMD startxfce4

