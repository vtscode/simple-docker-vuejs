# build stage
# node and yarn installed in here image
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY . .
RUN yarn && yarn run build
# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]