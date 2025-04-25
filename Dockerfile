FROM node:latest AS build

# Repertoire de travail 
WORKDIR /app

# Ajout code source de l'APP
COPY ./ /app/

# Installtion dependences 
RUN npm ci  

# Build de notre APP
RUN npm run build -- --configuration=production

# hebergement APP sur NGINX
FROM nginx:latest

# Repertoire de travail du NGINX
WORKDIR /usr/share/nginx/html

#On supprime le contenue du repertoire
RUN rm -rf ./*

# On Copie notre fichier de conf NGINX
COPY nginx.conf /etc/nginx/conf.d/default.conf

# On copie le build de l'app sur le serveur NGINX
COPY --from=build /app/dist/helloworld-angular/browser .

# On expose le port 80
EXPOSE 80