FROM jhedev/yesod-docker

RUN apt-get update && apt-get install -y libpq-dev
ADD src /src
WORKDIR /src
RUN cabal update
RUN cabal install -j --dependencies-only
RUN cabal configure
RUN cabal build

ADD masterfile.csv /masterfile.csv

EXPOSE 3000

CMD /src/dist/build/prestapi/prestapi production --port 3000
