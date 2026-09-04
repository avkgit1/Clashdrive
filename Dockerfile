# Stage 1: Install dependencies and build static assets
FROM oven/bun:1 AS builder
WORKDIR /app

COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile || bun install

COPY . .
RUN bun run build

# Stage 2: Serve static files with Cloudflare Tunnel host permitted
FROM oven/bun:1-slim
WORKDIR /app

COPY --from=builder /app/dist ./dist

EXPOSE 5173

# Allow the specific tunnel domain or set to all
CMD ["bun", "x", "vite", "preview", "--host", "0.0.0.0", "--port", "5173", "--allowed-hosts", "clashdrive-avk.renegade44apps.site"]
