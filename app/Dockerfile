# stage 1 - Build

FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json ./
RUN npm install --production


# stage 2 - Production

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .

EXPOSE 3000
ENV NODE_ENV=production

CMD ["node", "index.js"]