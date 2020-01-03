#!/bin/sh

lua_version=$(lua -v | awk '{split($0, a, " "); split(a[2], b, "."); print b[1]"."b[2]}')

sudo cp ./cord /usr/lib/lua/$lua_version/ -rf
echo Installed cord into /usr/lib/lua/$lua_version/
