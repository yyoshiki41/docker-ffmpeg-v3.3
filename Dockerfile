FROM ubuntu:16.04

LABEL maintainer="yyoshiki41@gmail.com"

RUN apt update
RUN apt install -y wget gcc make pkg-config

# Where the files will be built and libraries installed.
ARG PREFIX=/opt/ffmpeg
ARG PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"

WORKDIR "${PREFIX}"

# Install lame for libmp3lame option
RUN wget https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz
RUN tar -xzf ./lame-3.100.tar.gz
RUN cd lame-3.100 \
    && PATH="${PREFIX}/bin":$PATH \
    && ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --disable-shared \
    && make \
    && make install

# Install ffmpeg from sourcecode
RUN wget http://www.ffmpeg.org/releases/ffmpeg-3.3.6.tar.gz
RUN tar -xzf ./ffmpeg-3.3.6.tar.gz
RUN cd ffmpeg-3.3.6 \
    && PATH="${PREFIX}/bin":$PATH \
    && ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" \
       --extra-cflags="-I${PREFIX}/include" --extra-ldflags="-L${PREFIX}/lib" \
       --enable-libmp3lame --disable-yasm \
    && make \
    && make install

RUN cp "${PREFIX}"/bin/* /usr/local/bin/ \
    && cp -r "${PREFIX}"/share/ffmpeg /usr/local/share/

CMD ["/bin/bash"]
