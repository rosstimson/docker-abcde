FROM fedora:22
MAINTAINER Ross Timson <ross@rosstimson.com>

# Install build requirements.
RUN dnf install -y AtomicParsley \
                   ImageMagick \
                   autoconf \
                   automake \
                   cd-discid \
                   cdparanoia \
                   cmake \
                   curl \
                   flac \
                   gcc \
                   gcc-c++ \
                   git \
                   glib2-devel \
                   libcurl-devel \
                   libdiscid-devel \
                   libtool \
                   libxml2-devel \
                   make \
                   mercurial \
                   nasm \
                   opus-tools \
                   perl-App-cpanminus \
                   pkgconfig \
                   python \
                   python-eyed3 \
                   sqlite-devel \
                   vorbis-tools \
                   wget \
                   which \
                   zlib-devel

# Yasm
RUN cd /usr/local/src \
    && git clone --depth 1 git://github.com/yasm/yasm.git \
    && cd yasm \
    && autoreconf -fiv \
    && ./configure --prefix="/usr/local" \
    && make \
    && make install

# libx264
RUN cd /usr/local/src \
    && git clone --depth 1 git://git.videolan.org/x264 \
    && cd x264 \
    && ./configure --prefix="/usr/local" --enable-static \
    && make \
    && make install

# libx265
RUN cd /usr/local/src \
    && hg clone https://bitbucket.org/multicoreware/x265 \
    && cd /usr/local/src/x265/build/linux \
    && cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/usr/local" -DENABLE_SHARED:bool=off ../../source \
    && make \
    && make install

# libfdk_aac
RUN cd /usr/local/src \
    && git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac \
    && cd fdk-aac \
    && autoreconf -fiv \
    && ./configure --prefix="/usr/local" --disable-shared \
    && make \
    && make install

# libmp3lame
RUN cd /usr/local/src \
    && curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz \
    && tar xzvf lame-3.99.5.tar.gz \
    && cd lame-3.99.5 \
    && ./configure --prefix="/usr/local" --disable-shared --enable-nasm \
    && make \
    && make install

# libopus
RUN cd /usr/local/src \
    && git clone https://git.xiph.org/opus.git \
    && cd opus \
    && autoreconf -fiv \
    && ./configure --prefix="/usr/local" --disable-shared \
    && make \
    && make install

# libogg
RUN cd /usr/local/src \
    && curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz \
    && tar xzvf libogg-1.3.2.tar.gz \
    && cd libogg-1.3.2 \
    && ./configure --prefix="/usr/local" --disable-shared \
    && make \
    && make install

# libvorbis
RUN cd /usr/local/src \
    && curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz \
    && tar xzvf libvorbis-1.3.5.tar.gz \
    && cd libvorbis-1.3.5 \
    && ./configure --prefix="/usr/local" --disable-shared \
    && make \
    && make install

# libvpx
RUN cd /usr/local/src \
    && git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git \
    && cd libvpx \
    && ./configure --prefix="/usr/local" --as=yasm --disable-examples \
    && make \
    && make install

# ffmpeg
RUN cd /usr/local/src \
    && git clone --depth 1 git://source.ffmpeg.org/ffmpeg \
    && cd ffmpeg \
    && PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" ./configure --prefix="/usr/local" --extra-cflags="-I/usr/local/include" --extra-ldflags="-L/usr/local/lib" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 \
    && make \
    && make install

# glyr
RUN cd /usr/local/src \
    && git clone https://github.com/sahib/glyr.git \
    && cd glyr \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr/local . \
    && make \
    && make install
ENV LD_LIBRARY_PATH /usr/local/lib

# abcde
RUN cd /usr/local/src \
    && git clone http://git.einval.com/git/abcde.git \
    && cd abcde \
    && make install

# MusicBrainz perl libs
RUN cpanm --notest WebService::MusicBrainz \
    && cpanm --notest MusicBrainz::DiscID

# Cleanup.
RUN rm -rf /usr/local/src/* \
    && dnf clean all

# Define entrypoint so we can use container as if it's a standalone app.
ENTRYPOINT ["abcde"]
