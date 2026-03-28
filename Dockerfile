# -------- Stage 1: build --------
FROM node:18-alpine AS builder

WORKDIR /app

# Copia apenas dependências primeiro (melhor cache)
COPY package*.json ./

# Instala tudo (incluindo dev deps para build)
RUN npm ci

# Copia código
COPY . .

# Se tiver build (TypeScript, etc)
RUN npm run build


# -------- Stage 2: produção --------
FROM alpine:3.19

# Instala apenas Node.js runtime
RUN apk add --no-cache nodejs

WORKDIR /app

# Copia apenas o necessário do build
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# Remove devDependencies (extra seguro)
RUN npm prune --omit=dev

ENV NODE_ENV=production

EXPOSE 3000

CMD ["node", "dist/index.js"]
