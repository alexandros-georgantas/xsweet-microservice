FROM node:20.0.0-alpine3.16

RUN apk update && apk add --no-cache unzip bash openjdk11-jre-headless git coreutils

WORKDIR /home/node/xsweet
# Download XSweet
RUN wget https://gitlab.coko.foundation/XSweet/XSweet/-/archive/wax2/XSweet-wax2.zip -O xsweet.zip; unzip xsweet.zip; rm xsweet.zip
RUN wget https://gitlab.coko.foundation/XSweet/editoria_typescript/-/archive/wax2/editoria_typescript-wax2.zip -O typescript.zip; unzip typescript.zip; rm typescript.zip
RUN wget https://gitlab.coko.foundation/XSweet/HTMLevator/-/archive/wax2/HTMLevator-wax2.zip -O htmlevator.zip; unzip htmlevator.zip; rm htmlevator.zip

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
