FROM node:alpine as build
WORKDIR /app

RUN npm install -g @angular/cli

COPY ./package.json .
RUN npm install --force
COPY . .
RUN ng build

FROM nginx:alpine as runtime
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist/angular-docker /usr/share/nginx/html

EXPOSE 80 443
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]