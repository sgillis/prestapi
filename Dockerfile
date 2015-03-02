FROM jhedev/yesod-docker

RUN apt-get update && apt-get install -y libpq-dev
ADD src /src
WORKDIR /src
RUN cabal install -j
