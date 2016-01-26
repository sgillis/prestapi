#! /bin/bash
docker run \
    -it --rm \
    -v $(pwd)/src:/src \
    -v $(pwd)/masterfile.csv:/masterfile.csv \
    -e PGHOST=192.168.99.100 \
    -e PGUSER=postgres \
    -e PGPASS= \
    -p 3000:3000 \
    sgillis/prestapi \
    /bin/bash
