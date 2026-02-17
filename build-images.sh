#!/bin/bash
set -e

# =============================================================================
# Docker Image Build & Version Script for LTI Recruiter
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
REGISTRY="${DOCKER_REGISTRY:-}"
VERSION_FILE="VERSION"
FRONTEND_IMAGE="lti-frontend"
BACKEND_IMAGE="lti-backend"

# Read current version from VERSION file
get_current_version() {
  if [ -f "$VERSION_FILE" ]; then
    cat "$VERSION_FILE" | tr -d '[:space:]'
  else
    echo "0.0.1"
  fi
}

# Display usage
usage() {
  echo -e "${BLUE}============================================${NC}"
  echo -e "${BLUE}  LTI Recruiter - Docker Image Manager${NC}"
  echo -e "${BLUE}============================================${NC}"
  echo ""
  echo "Usage: $0 [OPTION]"
  echo ""
  echo "Options:"
  echo "  --version, -v VERSION    Set version for images (e.g., 1.0.0)"
  echo "  --build-frontend, -bf    Build frontend Docker image"
  echo "  --build-backend, -bb     Build backend Docker image"
  echo "  --build-all, -ba         Build both frontend and backend images"
  echo "  --push-frontend, -pf     Push frontend image to registry"
  echo "  --push-backend, -pb      Push backend image to registry"
  echo "  --push-all, -pa          Push both images to registry"
  echo "  --registry, -r REGISTRY  Set container registry (e.g., 123456789.dkr.ecr.us-east-1.amazonaws.com)"
  echo "  --list, -l               List current images"
  echo "  --help, -h               Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0 --version 1.2.0 --build-all"
  echo "  $0 -v 2.0.0 -ba -r my-registry.com"
  echo "  $0 --build-frontend --version 1.0.0"
  echo ""
}

# Set version
set_version() {
  local new_version="$1"
  if [[ ! "$new_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version format. Use semantic versioning (e.g., 1.0.0)${NC}"
    exit 1
  fi
  echo "$new_version" > "$VERSION_FILE"
  echo -e "${GREEN}Version set to: ${new_version}${NC}"
}

# Build frontend image
build_frontend() {
  local version="$1"
  local full_tag="${FRONTEND_IMAGE}:${version}"
  local latest_tag="${FRONTEND_IMAGE}:latest"

  if [ -n "$REGISTRY" ]; then
    full_tag="${REGISTRY}/${full_tag}"
    latest_tag="${REGISTRY}/${latest_tag}"
  fi

  echo -e "${YELLOW}Building frontend image: ${full_tag}${NC}"
  docker build \
    -t "$full_tag" \
    -t "$latest_tag" \
    -f frontend/Dockerfile \
    frontend/

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Frontend image built successfully: ${full_tag}${NC}"
  else
    echo -e "${RED}✗ Frontend image build failed${NC}"
    exit 1
  fi
}

# Build backend image
build_backend() {
  local version="$1"
  local full_tag="${BACKEND_IMAGE}:${version}"
  local latest_tag="${BACKEND_IMAGE}:latest"

  if [ -n "$REGISTRY" ]; then
    full_tag="${REGISTRY}/${full_tag}"
    latest_tag="${REGISTRY}/${latest_tag}"
  fi

  echo -e "${YELLOW}Building backend image: ${full_tag}${NC}"
  docker build \
    -t "$full_tag" \
    -t "$latest_tag" \
    -f backend/Dockerfile \
    backend/

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend image built successfully: ${full_tag}${NC}"
  else
    echo -e "${RED}✗ Backend image build failed${NC}"
    exit 1
  fi
}

# Push image to registry
push_image() {
  local image_name="$1"
  local version="$2"

  if [ -z "$REGISTRY" ]; then
    echo -e "${RED}Error: No registry specified. Use --registry or set DOCKER_REGISTRY env var.${NC}"
    exit 1
  fi

  local full_tag="${REGISTRY}/${image_name}:${version}"
  local latest_tag="${REGISTRY}/${image_name}:latest"

  echo -e "${YELLOW}Pushing ${full_tag}...${NC}"
  docker push "$full_tag"
  docker push "$latest_tag"

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Pushed: ${full_tag}${NC}"
  else
    echo -e "${RED}✗ Push failed for: ${full_tag}${NC}"
    exit 1
  fi
}

# List images
list_images() {
  echo -e "${BLUE}Current Docker images:${NC}"
  docker images | grep -E "(lti-frontend|lti-backend|REPOSITORY)" || echo "No images found"
}

# Interactive menu
interactive_menu() {
  local version
  version=$(get_current_version)

  echo -e "${BLUE}============================================${NC}"
  echo -e "${BLUE}  LTI Recruiter - Docker Image Manager${NC}"
  echo -e "${BLUE}============================================${NC}"
  echo -e "  Current version: ${GREEN}${version}${NC}"
  echo ""
  echo "  1) Set version number"
  echo "  2) Build frontend image"
  echo "  3) Build backend image"
  echo "  4) Build both images"
  echo "  5) Push frontend image to registry"
  echo "  6) Push backend image to registry"
  echo "  7) Push both images to registry"
  echo "  8) List current images"
  echo "  9) Exit"
  echo ""
  read -p "Select an option [1-9]: " choice

  case $choice in
    1)
      read -p "Enter new version (current: ${version}): " new_version
      set_version "$new_version"
      version="$new_version"
      interactive_menu
      ;;
    2)
      build_frontend "$version"
      ;;
    3)
      build_backend "$version"
      ;;
    4)
      build_frontend "$version"
      build_backend "$version"
      ;;
    5)
      read -p "Enter registry URL (or set DOCKER_REGISTRY env var): " reg
      REGISTRY="${reg:-$REGISTRY}"
      push_image "$FRONTEND_IMAGE" "$version"
      ;;
    6)
      read -p "Enter registry URL (or set DOCKER_REGISTRY env var): " reg
      REGISTRY="${reg:-$REGISTRY}"
      push_image "$BACKEND_IMAGE" "$version"
      ;;
    7)
      read -p "Enter registry URL (or set DOCKER_REGISTRY env var): " reg
      REGISTRY="${reg:-$REGISTRY}"
      push_image "$FRONTEND_IMAGE" "$version"
      push_image "$BACKEND_IMAGE" "$version"
      ;;
    8)
      list_images
      ;;
    9)
      echo -e "${GREEN}Goodbye!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option${NC}"
      interactive_menu
      ;;
  esac
}

# ==========================================
# Main CLI argument parsing
# ==========================================
VERSION=$(get_current_version)
DO_BUILD_FRONTEND=false
DO_BUILD_BACKEND=false
DO_PUSH_FRONTEND=false
DO_PUSH_BACKEND=false
DO_LIST=false

# If no arguments, run interactive menu
if [ $# -eq 0 ]; then
  interactive_menu
  exit 0
fi

while [ $# -gt 0 ]; do
  case "$1" in
    --version|-v)
      set_version "$2"
      VERSION="$2"
      shift 2
      ;;
    --build-frontend|-bf)
      DO_BUILD_FRONTEND=true
      shift
      ;;
    --build-backend|-bb)
      DO_BUILD_BACKEND=true
      shift
      ;;
    --build-all|-ba)
      DO_BUILD_FRONTEND=true
      DO_BUILD_BACKEND=true
      shift
      ;;
    --push-frontend|-pf)
      DO_PUSH_FRONTEND=true
      shift
      ;;
    --push-backend|-pb)
      DO_PUSH_BACKEND=true
      shift
      ;;
    --push-all|-pa)
      DO_PUSH_FRONTEND=true
      DO_PUSH_BACKEND=true
      shift
      ;;
    --registry|-r)
      REGISTRY="$2"
      shift 2
      ;;
    --list|-l)
      DO_LIST=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      usage
      exit 1
      ;;
  esac
done

# Execute actions
if $DO_BUILD_FRONTEND; then build_frontend "$VERSION"; fi
if $DO_BUILD_BACKEND; then build_backend "$VERSION"; fi
if $DO_PUSH_FRONTEND; then push_image "$FRONTEND_IMAGE" "$VERSION"; fi
if $DO_PUSH_BACKEND; then push_image "$BACKEND_IMAGE" "$VERSION"; fi
if $DO_LIST; then list_images; fi

echo -e "${GREEN}Done!${NC}"
