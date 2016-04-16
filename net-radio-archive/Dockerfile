FROM debian:8

RUN sed -i 's/http:\/\/.*\/debian/http:\/\/ftp\.jp\.debian\.org\/debian/g' /etc/apt/sources.list && \
      apt-get update && \
      apt-get install -y rtmpdump swftools ruby cron git wget xz-utils ruby-dev make gcc g++ libmysqlclient-dev xvfb iceweasel && \
      apt-get clean
RUN cd /tmp && \
      wget http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz && \
      mkdir ffmpeg && tar Jxvf ffmpeg-release-64bit-static.tar.xz -C ffmpeg --strip-components 1 && \
      cp -p ffmpeg/ffmpeg /usr/local/bin && \
      rm -rf ffmpeg*
COPY gem /tmp/gem
RUN cd /tmp/gem && \
      gem install bundler therubyracer --no-ri --no-rdoc  && \
      sed -i 's/^.*path:.*$//g' Gemfile && \
      bundle install --without development test && \
      mkdir -p /net-radio/archive && \
      mkdir -p /net-radio/working && \
      cd / && \
      rm -rf /tmp/gem
ENV NRA_WORKING_FILES_RETENTION_PERIOD_DAYS=30 \
      NRA_RADIKO_CHANNELS="" \
      NRA_RADIRU_CHANNELS="" \
      NRA_FORCE_MP4=false \
      NRA_AGON_MAIL="" \
      NRA_AGON_PASSWORD="" \
      NRA_DB_HOST=net-radio.db \
      NRA_DB_USER=root \
      NRA_DB_PASSWORD=password \
      NRA_DB_NAME=net-radio \
      NRA_ARCHIVE_FILES_RETENTION_PERIOD_DAYS=0
COPY dummyfile /tmp/
RUN cd / && \
      git clone https://github.com/yayugu/net-radio-archive && \
      cd /net-radio-archive && \
      git submodule update --init --recursive && \
      echo "gem 'therubyracer'" >> Gemfile && \
      bundle install --without development test
COPY config /net-radio-archive/config
COPY bootstrap.sh /

CMD ["/bootstrap.sh"]
