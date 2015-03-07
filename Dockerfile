FROM jhedev/yesod-docker

RUN apt-get update && apt-get install -y libpq-dev
ADD src /src
WORKDIR /src
RUN cabal install -j
RUN cabal configure && cabal build

EXPOSE 3000

CMD /src/dist/build/prestapi/prestapi production --port 3000
