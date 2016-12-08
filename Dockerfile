FROM quay.io/alaska/xfce:latest

ENV IDEA_URL https://download-cf.jetbrains.com/idea/ideaIU-2016.3.tar.gz
ENV IDEA_SH /usr/lib/idea-IU-163.7743.44/bin/idea.sh 
ENV IDEA_TGZ /tmp/idea.tgz

RUN apk update && apk add wget git python htop tmux openssh-client
RUN wget -O "$IDEA_TGZ" "$IDEA_URL" \
    && tar xvfz "$IDEA_TGZ" -C /usr/lib \
    && ln -s "$IDEA_SH" /usr/bin/idea \
    && sed -i "s/\ -e\ / /g" "$IDEA_SH" \
    && rm -rf "$IDEA_TGZ" \
    && echo "sh -c \"sleep 5 && $IDEA_SH \"" >> /etc/xdg/xfce4/xinitrc

CMD startxfce4
