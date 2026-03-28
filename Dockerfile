FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .


FROM alpine:3.19

RUN apk add --no-cache nodejs

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app . .

ENV NODE_ENV=production

EXPOSE 3000

CMD ["node", "index.js"]
