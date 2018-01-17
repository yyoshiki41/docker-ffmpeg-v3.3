FROM ubuntu:16.04

LABEL maintainer="yyoshiki41@gmail.com"

RUN apt update
RUN apt install -y wget gcc make pkg-config

WORKDIR /tmp
RUN wget http://www.ffmpeg.org/releases/ffmpeg-3.3.6.tar.gz
RUN tar -xzf ./ffmpeg-3.3.6.tar.gz

WORKDIR ffmpeg-3.3.6
RUN ./configure --disable-yasm && \
    make && \
    make install

CMD ["/bin/bash"]
