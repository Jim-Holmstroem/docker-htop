FROM debian:8.1

RUN apt-get update
RUN apt-get install --assume-yes \
    python \
    build-essential \
    libncurses5-dev \
    libncursesw5-dev

ADD http://hisham.hm/htop/releases/1.0.2/htop-1.0.2.tar.gz htop.tar.gz
# ln -s /proc /host_proc is a hack since somewhere in the installation/configuration it will peek /host_proc
RUN tar -xvf htop.tar.gz && cd htop-1.0.2 && \
    find . -type f -print0 | xargs -0 sed -i 's@/proc@/host_proc@g' && \
    ln -s /proc /host_proc && \
    ./configure && \
    make && \
    rm /host_proc

RUN useradd --create-home --home-dir /opt/htop --shell /bin/bash htop
ENV HOME /opt/htop
ENV USER htop
USER htop

ENTRYPOINT ["/htop-1.0.2/htop"]
