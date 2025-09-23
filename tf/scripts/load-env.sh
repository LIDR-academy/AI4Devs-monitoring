#!/bin/bash

# Load environment variables from .env file
# Usage: source load-env.sh

if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    export $(cat .env | grep -v '^#' | xargs)
    echo "Environment variables loaded successfully!"
else
    echo "Warning: .env file not found. Please create it from .env.template"
    echo "Copy .env.template to .env and fill in your actual values"
fi
