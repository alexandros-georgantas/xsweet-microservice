FROM node:20.0.0-alpine3.16

RUN apk update && apk add --no-cache ranger vim bash coreutils unzip openjdk11-jre-headless git ruby gcompat 

# install mathtype – ruby and gcompat above were addded to make nokogiri work correctly.

RUN gem install mathtype

WORKDIR /home/node/xsweet
# Download XSweet
RUN wget https://gitlab.coko.foundation/XSweet/XSweet/-/archive/3.0/XSweet-3.0.zip -O xsweet.zip; unzip xsweet.zip; rm xsweet.zip
RUN wget https://gitlab.coko.foundation/XSweet/editoria_typescript/-/archive/3.0/editoria_typescript-3.0.zip -O typescript.zip; unzip typescript.zip; rm typescript.zip
RUN wget https://gitlab.coko.foundation/XSweet/HTMLevator/-/archive/3.0/HTMLevator-3.0.zip -O htmlevator.zip; unzip htmlevator.zip; rm htmlevator.zip

# Download Saxon
RUN wget "https://sourceforge.net/projects/saxon/files/Saxon-HE/10/Java/SaxonHE10-3J.zip/download" -O saxon.zip; unzip saxon.zip -d saxon; rm saxon.zip

RUN chown -R node:node /home/node/xsweet

USER node

COPY --chown=node:node package.json ./package.json
COPY --chown=node:node yarn.lock ./yarn.lock

RUN yarn

COPY --chown=node:node . .

RUN chmod +x ./scripts/move_xslts.sh
RUN chmod +x ./scripts/execute_chain.sh
RUN ./scripts/move_xslts.sh

ENTRYPOINT ["sh", "./scripts/setupProdServer.sh"]

CMD ["node", "./server/startServer.js"]
