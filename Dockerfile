# --- Stage 1 : Build de l'app NestJS ---
FROM node:22-alpine AS build

WORKDIR /app

# Copie des fichiers de dépendances
COPY package*.json ./

# Installation des dépendances
RUN npm ci

# Copie du code source
COPY . .

# Compilation TypeScript NestJS (génère le dossier /app/dist)
RUN npm run build


# --- Stage 2 : Image de production finale ---
FROM node:22-alpine AS production

WORKDIR /app

# Copie des package.json
COPY package*.json ./

# Installation des dépendances de production uniquement
RUN npm ci --only=production

# Copie du dossier dist compilé depuis le stage build
COPY --from=build /app/dist ./dist

# Exposition du port interne de l'application NestJS
EXPOSE 3000

# Commande de démarrage
CMD ["node", "dist/main.js"]
