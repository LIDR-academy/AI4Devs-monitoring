# ============================================
# Stage 1: Build
# ============================================
FROM node:18-alpine AS builder

WORKDIR /app

# Install OpenSSL and dependencies needed for Prisma
RUN apk add --no-cache openssl openssl-dev libc6-compat

# Copy dependency files first for better layer caching
COPY package*.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci

# Copy prisma schema and generate client
COPY prisma ./prisma/
RUN npx prisma generate

# Copy the rest of the source code
COPY . .

# Build TypeScript
RUN npm run build

# ============================================
# Stage 2: Production
# ============================================
FROM node:18-alpine AS production

WORKDIR /app

# Install OpenSSL and dependencies needed for Prisma at runtime
RUN apk add --no-cache openssl openssl-dev libc6-compat curl

# Copy dependency files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production

# Copy prisma schema and generated client from builder
COPY --from=builder /app/prisma ./prisma/
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma

# Copy built application from builder
COPY --from=builder /app/dist ./dist

# Create a non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup && \
    chown -R appuser:appgroup /app

USER appuser

# Expose port 8080
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Run migrations and start the application
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/index.js"]
