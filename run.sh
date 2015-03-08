#! /bin/bash
docker run \
    -it --rm \
    -v $(pwd)/src:/src \
    -e PGHOST=172.17.42.1 \
    -e PGUSER=postgres \
    -e PGPASS= \
    -p 3000:3000 \
    prestapi_prestapi \
    /bin/bash
