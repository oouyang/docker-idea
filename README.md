# docker-idea

$ docker run -ti --rm --net=host -e DISPLAY=$DISPLAY \
             -v $HOME/.Xauthority:/root/.Xauthority \
             -v /tmp/.X11-unix:/tmp/.X11-unix \
             quay.io/alaska/idea
