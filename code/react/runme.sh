#!/bin/bash
echo "put stuff in src, builds in build, run http-server"
echo "tsc build/*.ts --outDir final -w"
env jsx -x ts --harmony -w "src/" "build/"
