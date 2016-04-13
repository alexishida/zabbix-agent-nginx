#!/bin/bash

##########################################################
#                                                        #
#   Author: Alex Ishida                                  #
#   E-mail: alexishida@gmail.com                         #
#   Date: 12/04/2016                                     #
#                                                        #
#  Original-file: http://pr0fikoss.weebly.com/blog/1     #
#                                                        #
##########################################################

# Example use  /usr/local/etc/zabbix_agentd.conf.d/userparameter_custom.conf
#
# NginX Keys
#UserParameter=nginx.active[*],/usr/local/etc/scripts/nginx_status.sh http://localhost/nginx_zabbix_stats active
#UserParameter=nginx.reading[*],/usr/local/etc/scripts/nginx_status.sh http://localhost/nginx_zabbix_stats reading
#UserParameter=nginx.writing[*],/usr/local/etc/scripts/nginx_status.sh http://localhost/nginx_zabbix_stats writing
#UserParameter=nginx.waiting[*],/usr/local/etc/scripts/nginx_status.sh http://1localhost/nginx_zabbix_stats waiting
#UserParameter=nginx.accepted[*],/usr/local/etc/scripts/nginx_status.sh http://localhost/nginx_zabbix_stats accepted
#UserParameter=nginx.handled[*],/usr/local/etc/scripts/nginx_status.sh http://localhost/nginx_zabbix_stats handled
#UserParameter=nginx.requests[*],/usr/local/etc/scripts/nginx_status.sh http://localhost/nginx_zabbix_stats requests


##### OPTIONS VERIFICATION #####
if [[ -z "$1" || -z "$2" ]]; then
  exit 1
fi

##### PARAMETERS #####
STATSURL="$1"
METRIC="$2"
CURL="/usr/bin/curl"


###### CURL EXEC COMMAND #####
CACHE_FILE=`${CURL} --insecure -s "${STATSURL}"`


######## GET METRICS  #########
if [ "${METRIC}" = "active" ]; then
 echo "${CACHE_FILE}" | grep "Active connections" | cut -d':' -f2 | awk '{gsub(/^ +| +$/,"")} {print $0 }'
fi
if [ "${METRIC}" = "accepted" ]; then
  echo "${CACHE_FILE}" | sed -n '3p' | cut -d" " -f2 | awk '{gsub(/^ +| +$/,"")} {print $0 }'
fi
if [ "${METRIC}" = "handled" ]; then
  echo "${CACHE_FILE}" | sed -n '3p' | cut -d" " -f3 | awk '{gsub(/^ +| +$/,"")} {print $0 }'
fi
if [ "${METRIC}" = "requests" ]; then
  echo "${CACHE_FILE}" | sed -n '3p' | cut -d" " -f4 | awk '{gsub(/^ +| +$/,"")} {print $0 }'
fi
if [ "${METRIC}" = "reading" ]; then
  echo "${CACHE_FILE}" | grep "Reading" | cut -d':' -f2 | cut -d' ' -f2 | awk '{gsub(/^ +| +$/,"")} {print $0 }'
fi
if [ "${METRIC}" = "writing" ]; then
  echo "${CACHE_FILE}" | grep "Writing" | cut -d':' -f3 | cut -d' ' -f2 | awk '{gsub(/^ +| +$/,"")} {print $0 }'
fi
if [ "${METRIC}" = "waiting" ]; then
  echo "${CACHE_FILE}" | grep "Waiting" | cut -d':' -f4 | cut -d' ' -f2 | awk '{gsub(/^ +| +$/,"")} {print $0 }'
fi

exit 0
