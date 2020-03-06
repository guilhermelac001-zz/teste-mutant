FROM node:10
WORKDIR /app
COPY /app/package.json /app
COPY /app/index.js /app
RUN npm install
COPY . /app
CMD [ "node", "index.js" ]
EXPOSE 80