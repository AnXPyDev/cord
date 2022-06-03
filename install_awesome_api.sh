#!/bin/sh

mkdir __tmp; cd __tmp
git clone https://github.com/awesomewm/awesome --depth 1

lua_version=$1
[ -z "$lua_version" ] && lua_version=$(lua -v | awk '{split($0, a, " "); split(a[2], b, "."); print b[1]"."b[2]}')


sudo cp awesome/lib/* /usr/lib/lua/$lua_version/ -rf

cd -
rm __tmp -rf
