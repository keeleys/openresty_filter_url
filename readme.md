## read
nginx filter url

## require
redis-server
redis-cli
openresty/1.15.8.1

## start

nginx
```
nginx -c ~/work/conf/nginx.conf
```

redis
```redis
sadd black_list /tian /
smembers black_list
```