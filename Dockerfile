FROM armv7/armhf-ubuntu

RUN apt-get update && \
    apt-get -y install curl tar subversion && \
    apt-get -y install make automake gcc g++ ncurses-dev openssl libssl-dev && \
    apt-get -y install libxml2 libxml2-dev sqlite3 libsqlite3-dev pkg-config && \
    apt-get -y install libsrtp0 libsrtp0-dev && \
    apt-get -y install libjansson4 libjansson-dev && \
    apt-get -y install uuid uuid-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp/jansson
RUN curl -sf -L http://www.digip.org/jansson/releases/jansson-2.7.tar.gz | tar -C /tmp/jansson --strip-components=1 -zxf - && \
    ./configure && make && make install && ldconfig && \
    rm -fr /tmp/jansson

WORKDIR /tmp/pjproject
RUN curl -sf -L http://www.pjsip.org/release/2.4/pjproject-2.4.tar.bz2 | tar -C /tmp/pjproject --strip-components=1 -xjf - && \
    ./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr CFLAGS='-O2 -DNDEBUG' && \
    make dep && make && make install && ldconfig && \
    rm -fr /tmp/pjproject

WORKDIR /tmp/asterisk
RUN curl -sf -L http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz | tar -C /tmp/asterisk --strip-components=1 -zxf - &&\
    ./contrib/scripts/get_mp3_source.sh && \
    ./configure && \
    make menuselect.makeopts && menuselect/menuselect --enable CORE-SOUNDS-JA-WAV --enable CORE-SOUNDS-JA-ULAW --enable CORE-SOUNDS-JA-ALAW \
        --enable CORE-SOUNDS-JA-GSM --enable CORE-SOUNDS-JA-G729 --enable CORE-SOUNDS-JA-G722 --enable CORE-SOUNDS-JA-SLN16 \
        --enable CORE-SOUNDS-JA-SIREN7 --enable CORE-SOUNDS-JA-SIREN14 menuselect.makeopts && \
    make && make install && make samples && make config && ldconfig && \
    rm -fr /tmp/asterisk

ADD sip.conf /etc/asterisk/sip.conf
ADD extensions.conf /etc/asterisk/extensions.conf
ADD rtp.conf /etc/asterisk/rtp.conf

VOLUME ["/etc/asterisk"]

EXPOSE 5060/udp 10000/udp 10001/udp 10002/udp 10003/udp 10004/udp 10005/udp 10006/udp 10007/udp 10008/udp 10009/udp

