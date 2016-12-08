FROM quay.io/alaska/xfce:latest
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

ENV LANG=C.UTF-8

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.23-r3" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    IDEA_URL=https://download-cf.jetbrains.com/idea/ideaIU-2016.3.tar.gz && \
    IDEA_SH=/usr/lib/idea-IU-163.7743.44/bin/idea.sh  && \
    IDEA_TGZ=/tmp/idea.tgz && \
    apk add --update --no-cache ca-certificates wget git python htop tmux openssh-client musl && \
    wget -O $IDEA_TGZ $IDEA_URL && \
    tar xvfz "$IDEA_TGZ" -C /usr/lib && \
    ln -s "$IDEA_SH" /usr/bin/idea && \
    sed -i "s/\ -e\ / /g" "$IDEA_SH" && \
    echo "sh -c \"sleep 5 && $IDEA_SH \"" >> /etc/xdg/xfce4/xinitrc && \
    wget \
        "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm \
        "/root/.wget-hsts" \ 
        "/etc/apk/keys/sgerrand.rsa.pub" \
        "$IDEA_TGZ" \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

CMD startxfce4

