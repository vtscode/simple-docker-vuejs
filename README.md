# docker-vuejs

## Project setup
Reference this project for docker setup vuejs
https://www.middlewareinventory.com/blog/docker-vuejs/

Other reference
https://docs.vuejs.id/v2/cookbook/dockerize-vuejs-app.html

## My Setup
Presequite: 
- nodejs version 14.x
- yarn
### Install Docker
https://computingforgeeks.com/install-docker-and-docker-compose-on-linux-mint-19/
```
sudo apt update
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common

sudo apt -y remove docker docker-engine docker.io containerd runc

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
newgrp docker
```
Check docker installed correctly or not
```
docker version
```
### Install Docker Compose
```
curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url  | grep docker-compose-linux-x86_64 | cut -d '"' -f 4 | wget -qi -
chmod +x docker-compose-linux-x86_64
sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
docker-compose version
sudo usermod -aG docker $USER
newgrp docker
```
```
sudo curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
source /etc/bash_completion.d/docker-compose
```

test docker compose with this code
```
nano docker-compose.yml
```
copy and paste this script below on terminal
```
version: '3'  
services:
  web:
    image: nginx:latest
    ports:
     - "8080:80"
    links:
     - php
  php:
    image: php:7-fpm
```
Start service container
```
docker-compose up -d
```

Show running Containers
```
docker-compose ps
```
Stop container and Destroy container
```
docker-compose stop
docker-compose rm -f
```

### Installing Vue Js CLI
npm or yarn global CLI
```
yarn global add @vue/cli
```
Atau
```
npm install -g @vue/cli
```
check version
```
vue --version
```
To upgrade the global Vue CLI package
```
yarn global upgrade --latest @vue/cli
```
Atau
```
npm update -g @vue/cli
```

### Create Simple Project Vuejs
```
vue create docker-vuejs-project
```
You will be prompted to pick a preset. You can either choose the default preset which comes with a basic Babel + ESLint setup, or select “Manually select features” to pick the features you need.

In this case i select default setup because it’s great for quickly prototyping a new project, while the manual setup provides more options that are likely needed for more production-oriented projects.

Test Run 
```
yarn serve
```
if Run success then you can stop run and move to <b>Directory for setup project</b>
make file name it "Dockerfile", there is no extention then copy paste script below to Dockerfile

place Dockerfile in your vuejs folder when you have been run before, in the root project that contain package.json src and others
```
# Choose the Image which has Node installed already
FROM node:lts-alpine

# install simple http server for serving static content
RUN npm install -g http-server

# make the 'app' folder the current working directory
WORKDIR /app

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# build app for production with minification
RUN npm run build

EXPOSE 8080
CMD [ "http-server", "dist" ]
```

### Build Docker Container
Using the Dockerfile we have created. Let us create an Image.

Note: Before Creating the Image, Please be aware, It is a good practice that you name your images with your docker username in a prefix,  It would enable you to share your work(images) with other people easily in future with the help of docker hub which we will see later in this article.
Having said that it is always recommended to name your images after your docker username. I am going to do the same and my docker username is riventus.
```
docker build -t riventus/docker-vuejs-project .
```
Here the PERIOD/DOT at the end is intentional and it represents the current directory.  With this command issued, Docker looks for a Dockerfile in the current directory and create the image out of it

To validate if your image has created and to know the list of images available in your system locally. use the following command.
```
docker images
```

### Run Docker Container
The Image we have created is ready to be started and it can now become a Fully Qualified and Operational Container.

The following Command would create and start the Container from the image we have created
```
docker run -it -p 8081:8080 -d --name docker-vuejs-project riventus/docker-vuejs-project
```
Explanation:

-it  –  This flag sets the container in Interactive mode and allocate a Dedicated TTY id for later SSHing.

-d –  This flag sets the container to run in the background.

-p 8081:8080 – Port Forwarding Between Host and the Container. Right to the colon is a container and Left to the colon is Host. 8081 is the Host and 8080 is the container Port.

–name – Once started docker daemon assigns a random string name to the container. But i recommend defining a name can be handy way to add meaning to a container.

docker-vuejs-project – Name of the container we are starting ( Replacement of Container ID).

riventus/docker-vuejs-project – The name of the image from which we are going to create a Container.

### Validate the Web Application running inside the Container
Having started the Container with Port Forwarding to the host machine on Port 8081. You should be able to access the website from the Host machine (mac/windows)  at http://localhost:8081

If everything is done correctly,  We should be able to see our desired website which we have tested locally.



## CASE PRODUCTION
Securing Vue JS Application using NGINX
Above created Docker Vue JS Web Application is powerful enough for production usage, but it’s simple and hackable enough to be used for testing, local development and learning.

For complex production use cases it may be wiser to use giants like NGINX or Apache. In our case we are using NGINX to serve our Vue JS Web Application because it is considered as one of the most performant and tested solutions.

Create .dockerignore for ignore file if you want it

Let’s refactor our Dockerfile to use NGINX or Delete the old Dockerfile and create a new one.
```
# build stage
# node and yarn installed in here image
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY . .
RUN yarn run build
# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Build a Docker Vue JS image using Dockerfile
```
docker build -t riventus/docker-vuejs-nginx .
```
Start the container from the image we have created
```
docker run -it -p 8080:80 -d --name docker-vuejs-nginx riventus/docker-vuejs-nginx
```

Validate the Vue JS Web Application running inside the container
You should be able to access the website from the Host machine (mac/windows)  at http://localhost:8080
Hope this helps.


### Stop docker Container that still running
check container ID by command docker ps 
```
sudo docker ps
sudo docker stop [CONTAINER ID]
```
to show all docker container 
```
sudo docker container ls -aq
```
stop all container
```
docker container stop $(docker container ls -aq)
```

### REMOVE DOCKER Container
```
sudo docker rm [CONTAINER ID]
```

to show all docker container 
```
sudo docker container ls -aq
```

Remove all Container
```
docker container rm $(docker container ls -aq)
```

