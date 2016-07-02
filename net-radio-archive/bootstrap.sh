#!/bin/bash

mkdir -p /net-radio/archive
mkdir -p /net-radio/working

set | grep ^NRA_ | grep -v =$ > /var/spool/cron/crontabs/root
echo "00 00 * * * rm -f /var/spool/mail/mail" >> /var/spool/cron/crontabs/root
if [ "$NRA_ARCHIVE_FILES_RETENTION_PERIOD_DAYS" -gt 0 ]; then
  echo "00 00 * * * find /net-radio/archive -type f -mtime +$NRA_ARCHIVE_FILES_RETENTION_PERIOD_DAYS -delete; find /net-radio/archive -type d -empty -delete" >> /var/spool/cron/crontabs/root
fi

cd /net-radio-archive

export RAILS_ENV=production
export LANG=en_US.UTF-8

sleep 5

bundle exec rake db:migrate
bundle exec whenever --update-crontab
bundle exec rake main:ag_scrape &
bundle exec rake main:onsen_scrape &
bundle exec rake main:hibiki_scrape &
bundle exec rake main:radiko_scrape &
bundle exec rake main:radiru_scrape &
bundle exec rake main:anitama_scrape &
bundle exec rake main:agon_scrape &
bundle exec rake main:wikipedia_scrape &
bundle exec rake main:niconama_scrape &

/usr/sbin/cron -f
