FROM node:20.6.1

WORKDIR /nodejs

COPY ./simple-node-app/src .

COPY ./simple-node-app/package.json ./simple-node-app/package-lock.json ./

RUN npm ci

EXPOSE 3000

CMD [ "node", "index.js" ]
