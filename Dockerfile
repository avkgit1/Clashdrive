# Stage 1: Build static assets
FROM oven/bun:1 AS builder
WORKDIR /app

COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile || bun install

COPY . .
RUN bun run build

# Stage 2: Serve using static file server
FROM oven/bun:1-slim
WORKDIR /app

RUN bun install -g serve

COPY --from=builder /app/dist ./dist

EXPOSE 5173

# -s enables single-page application routing mode
CMD ["serve", "-s", "dist", "-l", "5173"]
