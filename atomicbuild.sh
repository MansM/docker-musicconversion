#!/bin/bash

cd /tmp
unzip atomicparseley.zip
cd wez-atomic*/
./autogen.sh && ./configure && make && make install