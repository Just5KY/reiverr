FROM node:20-alpine as pre-production

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . .

#COPY package.json .
#COPY package-lock.json .

RUN npm i

RUN npm run build

FROM --platform=linux/amd64 node:20-alpine as production

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV NODE_ENV=production

COPY --from=pre-production /usr/src/app/build ./build

COPY package.json .
COPY package-lock.json .

RUN npm ci --omit dev

CMD [ "npm", "run", "deploy" ]

FROM node:20 as development

ENV NODE_ENV=development

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json .
COPY package-lock.json .

RUN npm i

CMD [ "npm", "run", "dev" ]