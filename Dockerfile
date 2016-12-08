FROM quay.io/alaska/xfce:latest

ENV IDEA_URL https://download-cf.jetbrains.com/idea/ideaIU-2016.3.tar.gz
ENV IDEA_SH /usr/lib/idea-IU-163.7743.44/bin/idea.sh 
ENV IDEA_TGZ /tmp/idea.tgz
ENV ALPINE_GLIBC_BASE_URL "https://github.com/sgerrand/alpine-pkg-glibc/releases/download" 
ENV ALPINE_GLIBC_PACKAGE_VERSION "2.23-r3" 
ENV ALPINE_GLIBC_BASE_PACKAGE_FILENAME "glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" 
ENV ALPINE_GLIBC_BIN_PACKAGE_FILENAME "glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" 
ENV ALPINE_GLIBC_I18N_PACKAGE_FILENAME "glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" 
ENV LANG=C.UTF-8

RUN apk update && apk add wget git python htop tmux openssh-client  && \
    \
    tar xvfz "$IDEA_TGZ" -C /usr/lib && \
    ln -s "$IDEA_SH" /usr/bin/idea && \
    rm -rf "$IDEA_TGZ" && \
    echo "sh -c \"sleep 5 && $IDEA_SH \"" >> /etc/xdg/xfce4/xinitrc

RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
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
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
"$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"
CMD startxfce4

#    && sed -i "s/\ -e\ / /g" "$IDEA_SH" \
#     apk del .build-dependencies && \
