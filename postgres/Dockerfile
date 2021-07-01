FROM postgres:13.2

ENV PGROONGA_VERSION=2.2.7-1
ENV POSTGISV 3
ENV TDS_FDW_VERSION 2.0.2
ENV TZ Asia/Tehran

# install requirements
RUN apt-get update && \
    apt-get -y install gcc mono-mcs libsybdb5 freetds-dev freetds-common libpq-dev git make curl ca-certificates gnupg htop

# add pg_hashids
RUN mkdir -p /opt/apps
COPY ./pg_hashids /opt/apps/pg_hashids

# install postgis
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  postgresql-$PG_MAJOR-postgis-$POSTGISV \
  postgresql-$PG_MAJOR-postgis-$POSTGISV-scripts \
  postgresql-$PG_MAJOR-pgrouting \
  postgresql-$PG_MAJOR-pgrouting-scripts \
  postgresql-server-dev-$PG_MAJOR \
  unzip \
  make \
  && cd /opt/apps \
  && cd pg_hashids \
  && make install \
  && apt-get purge -y  unzip


#install pgroonga
RUN \
  apt update && \
  apt install -y wget && \
  wget https://packages.groonga.org/debian/groonga-archive-keyring-latest-buster.deb && \
  apt install -y -V ./groonga-archive-keyring-latest-buster.deb && \
  apt update && \
  apt install -y \
    postgresql-$PG_MAJOR-pgdg-pgroonga=${PGROONGA_VERSION} \
    groonga-normalizer-mysql \
    groonga-tokenizer-mecab && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

#install tds_fd
RUN wget https://github.com/tds-fdw/tds_fdw/archive/v${TDS_FDW_VERSION}.tar.gz -O /opt/apps/v${TDS_FDW_VERSION}.tar.gz && \
  cd /opt/apps && \
  tar -xvzf v${TDS_FDW_VERSION}.tar.gz && \
  cd tds_fdw-${TDS_FDW_VERSION}/ && \
  make USE_PGXS=1 && \
  make USE_PGXS=1 install

# set time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# add backup job
RUN mkdir -p /opt/backups
COPY ./scripts/pgbackup.sh /opt/pgbackup.sh
RUN chmod +x /opt/pgbackup.sh

# add init script
RUN mkdir -p /docker-entrypoint-initdb.d

#create log path
RUN mkdir /var/log/postgresql -p
RUN chmod 0700 /var/log/postgresql
RUN chown postgres:postgres /var/log/postgresql


# create volume for backups
VOLUME ["/opt/backups","/var/log/postgresql"]

#uninstall extra dependencies
RUN apt-get -y remove git make curl gcc
