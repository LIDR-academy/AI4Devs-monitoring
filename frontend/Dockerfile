# ============================================
# Stage 1: Build
# ============================================
FROM node:18-alpine AS builder

WORKDIR /app

# Copy dependency files first for better layer caching
COPY package*.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Build the React application
RUN npm run build

# ============================================
# Stage 2: Production
# ============================================
FROM node:18-alpine AS production

WORKDIR /app

# Install serve to serve the static files and curl for healthcheck
RUN npm install -g serve && \
    apk add --no-cache curl

# Copy built assets from builder
COPY --from=builder /app/build ./build

# Create a non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

USER appuser

# Expose port 3000
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

# Serve the static files
CMD ["serve", "-s", "build", "-l", "3000"]
