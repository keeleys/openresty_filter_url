-- package.path = '/usr/local/openresty/nginx/lua/?.lua;/usr/local/openresty/nginx/lua/lib/?.lua;'
-- package.cpath = '/usr/local/openresty/nginx/lua/?.so;/usr/local//openresty/nginx/lua/lib/?.so;'

-- 连接redis
local redis = require 'resty.redis'
local cjson = require 'cjson'
local cache = redis.new()
local ok ,err = cache.connect(cache,'127.0.0.1','6379')
cache:set_timeout(60000)
-- 如果连接失败，跳转到label处
if not ok then
  goto label 
end

-- 白名单
is_white ,err = cache:sismember('white_list', ngx.var.uri)
if is_white == 1 then
  goto label
end

-- 黑名单
is_black ,err = cache:sismember('black_list', ngx.var.uri)
if is_black == 1 then
  ngx.status = 401
  ngx.header.content_type = "application/json; charset=utf-8" 
  ngx.say(cjson.encode({ code=90000, msg='访问失败'}))  
  ngx.exit(401)
  goto label
end
::label::
local ok , err = cache:close()
