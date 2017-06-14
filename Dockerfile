FROM ubuntu:latest

MAINTAINER Xavier Garnier "xavier.garnier@irisa.fr"

# Set Virtuoso commit SHA to Virtuoso 7.2.4 release (25/04/2016)
ENV VIRTUOSO_COMMIT 96055f6a70a92c3098a7e786592f4d8ba8aae214

# Prerequisites
RUN apt-get update && apt-get install -y \
  #virtuoso
  build-essential \
  debhelper \
  autotools-dev \
  autoconf \
  automake \
  unzip \
  wget \
  net-tools \
  git \
  libtool \
  flex \
  bison \
  gperf \
  gawk \
  m4 \
  libssl-dev \
  libreadline-dev \
  libreadline-dev \
  openssl \
  python-pip \
  #AskOmics
  build-essential \
  python3 \
  python3-pip \
  python3-venv \
  vim \
  ruby \
  npm \
  nodejs-legacy


## VIRTUOSO ###################################################################

# Get Virtuoso source code from GitHub and checkout specific commit
# Make and install Virtuoso (by default in /usr/local/virtuoso-opensource)
RUN git clone https://github.com/openlink/virtuoso-opensource.git \
        && cd virtuoso-opensource \
        && git checkout ${VIRTUOSO_COMMIT} \
        && ./autogen.sh \
        && CFLAGS="-O2 -m64" && export CFLAGS && ./configure --disable-bpel-vad --enable-conductor-vad --enable-fct-vad --disable-dbpedia-vad --disable-demo-vad --disable-isparql-vad --disable-ods-vad --disable-sparqldemo-vad --disable-syncml-vad --disable-tutorial-vad --with-readline --program-transform-name="s/isql/isql-v/" \
        && make && make install \
        && ln -s /usr/local/virtuoso-opensource/var/lib/virtuoso/ /var/lib/virtuoso \
        && ln -s /var/lib/virtuoso/db /data \
        && cd .. \
        && rm -r /virtuoso-opensource

# Add Virtuoso bin to the PATH
ENV PATH /usr/local/virtuoso-opensource/bin/:$PATH

# Add Virtuoso config
ADD virtuoso/virtuoso.ini /virtuoso.ini

# Add dump_nquads_procedure
ADD virtuoso/dump_nquads_procedure.sql /dump_nquads_procedure.sql

# Add Virtuoso log cleaning script
ADD virtuoso/clean-logs.sh /clean-logs.sh

# Add startup script
ADD virtuoso/virtuoso.sh /virtuoso.sh

# Add dum template
ADD virtuoso/dump.template.nq /dump.template.nq

ENV SPARQL_UPDATE true

## ASKOMICS ###################################################################

# AskOmics github repo
ENV ASKOMICS_URL https://github.com/xgaia/askomics.git
# AskOmics commit
ENV ASKOMICS_COMMIT bb4952f82d3f9d59f4f35046d24e2f5f226bfdb4

RUN git config --global http.sslVerify false
RUN git clone ${ASKOMICS_URL} /usr/local/askomics/

WORKDIR /usr/local/askomics/

RUN git checkout ${ASKOMICS_COMMIT}

RUN npm install gulp -g
RUN npm install
RUN chmod +x startAskomics.sh

# Delete the local venv if exist and build the new one
RUN rm -rf /usr/local/askomics/venv && \
    ./startAskomics.sh -b

ADD monitor_traffic.sh /
ADD start.sh ./
RUN chmod +x start.sh /virtuoso.sh /monitor_traffic.sh

EXPOSE 6543
CMD ["./start.sh"]
