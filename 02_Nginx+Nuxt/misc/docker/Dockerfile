FROM node:16-slim AS deps
WORKDIR /app
COPY client/package*.json ./
RUN yarn install --frozen-lockfile --production

FROM node:16-slim as builder
WORKDIR /app
COPY client/package*.json ./
RUN yarn install --frozen-lockfile
COPY client/ .
RUN yarn build

FROM node:16-slim

# insall nginx
RUN apt-get update && apt-get install -y nginx && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/cache/nginx/cgicache
RUN mkdir -p /var/www/client
RUN adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx
RUN chmod 770 -R /var/cache/nginx && chown -R nginx /var/cache/nginx
COPY misc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY misc/nginx/local/client.conf /etc/nginx/conf.d/client.conf

WORKDIR /app
ENV NODE_ENV production
COPY --from=builder /app/.nuxt ./.nuxt
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
EXPOSE 80

WORKDIR /
COPY misc/docker/entry.sh .
CMD ["bash","entry.sh"]
