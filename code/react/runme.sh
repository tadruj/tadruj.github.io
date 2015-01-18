#!/bin/bash
echo "put stuff in src, builds in build, run http-server"
env jsx -w src/ build/
