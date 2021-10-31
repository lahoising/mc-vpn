#!/bin/bash

sudo hamachi login

pushd server
reserved_ram="$(cat ram)"
java -Xmx${reserved_ram} -Xms${reserved_ram} -jar minecraft_server.jar --nogui
popd
