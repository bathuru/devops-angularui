# base image
FROM node:latest as build-stage 

# set working directory
WORKDIR /app

# install and cache app dependencies
COPY package.json /app/package.json
RUN npm install

# add app
COPY . /app

# generate build
RUN npm run build --prod

# base image
FROM nginx:alpine

# copy artifact build from the 'build environment'
COPY --from=build-stage /app/dist/EmployeeAngular /usr/share/nginx/html

# expose port 80
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]