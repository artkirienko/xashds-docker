FROM debian:buster-slim

ARG hlds_build=8308
ARG steamcmd_url=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
ARG hlds_url="https://github.com/DevilBoy-eXe/hlds/releases/download/$hlds_build/hlds_build_$hlds_build.zip"
ENV XASH3D_BASEDIR=/opt/steam/xashds

# Fix warning:
# WARNING: setlocale('en_US.UTF-8') failed, using locale: 'C'.
# International characters may not work.
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales=2.28-10 \
 && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ENV LC_ALL en_US.UTF-8

# Fix error:
# Unable to determine CPU Frequency. Try defining CPU_MHZ.
# Exiting on SPEW_ABORT
ENV CPU_MHZ=2300

RUN groupadd -r steam && useradd -r -g steam -m -d /opt/steam steam
RUN usermod -a -G games steam

RUN dpkg --add-architecture i386
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    ca-certificates=20190110 \
    curl=7.64.0-4+deb10u1 \
    gnupg2=2.2.12-1+deb10u1 \
    lib32gcc1=1:8.3.0-6 \
    libstdc++6:i386=8.3.0-6 \
    unzip=6.0-23+deb10u1 \
    xz-utils=5.2.4-1 \
    zip=3.0-11+b1 \
 && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'deb http://download.opensuse.org/repositories/home:/a1batross/Debian_9.0/ /' > /etc/apt/sources.list.d/home:a1batross.list \
    && curl -sL https://download.opensuse.org/repositories/home:a1batross/Debian_9.0/Release.key | apt-key add - \
    && apt-get -y update && apt-get install -y --no-install-recommends xashds=1.0.19.3 \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

USER steam
WORKDIR /opt/steam
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
COPY ./lib/hlds.install /opt/steam

RUN curl -sL "$steamcmd_url" | tar xzvf - \
    && ./steamcmd.sh +runscript hlds.install

RUN curl -sLJO "$hlds_url" \
    && unzip "hlds_build_$hlds_build.zip" -d "/opt/steam/hlds_build_$hlds_build" \
    && cp -R "hlds_build_$hlds_build/hlds"/* xashds/ \
    && rm -rf "hlds_build_$hlds_build" "hlds_build_$hlds_build.zip"

# Fix error that steamclient.so is missing
RUN mkdir -p "$HOME/.steam" \
    && ln -s /opt/steam/linux32 "$HOME/.steam/sdk32"

# Fix warnings:
# couldn't exec listip.cfg
# couldn't exec banned.cfg
RUN touch /opt/steam/xashds/valve/listip.cfg
RUN touch /opt/steam/xashds/valve/banned.cfg

WORKDIR /opt/steam/xashds

RUN mv cstrike/liblist.gam cstrike/gameinfo.txt
RUN mv valve/liblist.gam valve/gameinfo.txt

# Copy default config
COPY valve valve

EXPOSE 27015
EXPOSE 27015/udp

# Start server
ENTRYPOINT ["xashds"]

# Default start parameters
CMD ["+ip 0.0.0.0", "-timeout 3", "-pingboost 1", "+rcon_password 12345678"]
