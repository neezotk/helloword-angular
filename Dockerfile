FROM node:latest AS build

# Repertoire de travail 
WORKDIR /app

# Ajout code source de l'APP
COPY ./ /app/

# Installtion dependences 
RUN npm ci  

# Build de notre APP
RUN npm run build

# hebergement APP sur NGINX
FROM nginx:latest

# On copie le build de l'app sur le serveur NGINX
COPY --from=build /app/dist/helloworld-angular /usr/share/nginx/html

# On expose le port 80
EXPOSE 80