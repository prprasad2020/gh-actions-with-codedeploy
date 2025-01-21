FROM node:20.6.1

WORKDIR /nodejs

COPY ./src .

COPY package.json package-lock.json ./

RUN npm ci

EXPOSE 3000

CMD [ "node", "index.js" ]
