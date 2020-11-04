FROM node:12-alpine

RUN apk update && apk add --no-cache unzip openjdk11-jre-headless



WORKDIR /home/node/service-xsweet
# Download XSweet
RUN wget https://gitlab.coko.foundation/XSweet/XSweet/repository/archive.zip?ref=master -O xsweet.zip; unzip xsweet.zip; rm xsweet.zip
RUN wget https://gitlab.coko.foundation/XSweet/editoria_typescript/repository/archive.zip?ref=master -O typescript.zip; unzip typescript.zip; rm typescript.zip
RUN wget https://gitlab.coko.foundation/XSweet/HTMLevator/repository/archive.zip?ref=master -O htmlevator.zip; unzip htmlevator.zip; rm htmlevator.zip

# Download Saxon
RUN wget "https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.9/SaxonHE9-9-1-1J.zip" -O saxon.zip; unzip saxon.zip -d saxon; rm saxon.zip

RUN chown -R node:node /home/node/service-xsweet

COPY package.json ./package.json
COPY yarn.lock ./yarn.lock

RUN yarn

COPY . .

RUN chmod +x ./scripts/move_xslts.sh
RUN chmod +x ./scripts/wait-for-it.sh
RUN chmod +x ./scripts/execute_chain.sh
RUN ./scripts/move_xslts.sh

USER node

ENTRYPOINT . scripts/startServer.sh
