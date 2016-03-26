FROM debian:8

RUN sed -i 's/http:\/\/.*\/debian/http:\/\/ftp\.jp\.debian\.org\/debian/g' /etc/apt/sources.list && \
      apt-get update && \
      apt-get install -y rtmpdump swftools ruby cron git wget xz-utils ruby-dev make gcc g++ libmysqlclient-dev && \
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
      bundle install --without development test agon && \
      mkdir -p /net-radio/archive && \
      mkdir -p /net-radio/working && \
      cd / && \
      rm -rf /tmp/gem
ENV NRA_WorkingFilesRetentionPeriodDays=30 \
      NRA_RadikoChannels="" \
      NRA_RadiruChannels="" \
      NRA_ForceMp4=false \
      NRA_DBHost=net-radio.db \
      NRA_DBUser=root \
      NRA_DBPassword=password \
      NRA_DBName=net-radio \
      NRA_ArchiveFilesRetentionPeriodDays=0
COPY dummyfile /tmp/
RUN cd / && \
      git clone https://github.com/yayugu/net-radio-archive && \
      cd /net-radio-archive && \
      git submodule update --init --recursive && \
      echo "gem 'therubyracer'" >> Gemfile && \
      bundle install --without development test agon
COPY config /net-radio-archive/config
COPY bootstrap.sh /

CMD ["/bootstrap.sh"]
