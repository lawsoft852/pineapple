#!/bin/bash
set -e

echo "🚀 Setting up LawSoft LPMS Development Environment..."
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please wait for the devcontainer to fully initialize."
    exit 1
fi

# Start PostgreSQL database
echo "📦 Starting PostgreSQL database..."
docker run --name lawsoft-postgres -d \
  -e POSTGRES_DB=lawsoft \
  -e POSTGRES_USER=lawsoft_user \
  -e POSTGRES_PASSWORD=lawsoft123 \
  -p 5432:5432 \
  postgres:17 || echo "Database already running"

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Create project structure
echo "📁 Creating project structure..."
mkdir -p backend/src
mkdir -p frontend/src
mkdir -p shared/types
mkdir -p docs

# Create package.json files
echo "📦 Creating package.json files..."

# Backend package.json
cat > backend/package.json << 'EOF'
{
  "name": "lawsoft-backend",
  "version": "1.0.0",
  "description": "LawSoft LPMS Backend API",
  "main": "dist/main.js",
  "scripts": {
    "dev": "ts-node-dev --respawn --transpile-only --ignore-watch node_modules src/main.ts",
    "build": "tsc",
    "start": "node dist/main.js",
    "test": "jest",
    "lint": "eslint src/**/*.ts",
    "format": "prettier --write src/**/*.ts"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "pg": "^8.11.3",
    "knex": "^3.0.1",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "helmet": "^7.1.0",
    "express-rate-limit": "^7.1.5",
    "express-validator": "^7.0.1",
    "winston": "^3.11.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/cors": "^2.8.17",
    "@types/pg": "^8.10.9",
    "@types/bcryptjs": "^2.4.6",
    "@types/jsonwebtoken": "^9.0.5",
    "@types/node": "^20.10.5",
    "typescript": "^5.3.3",
    "ts-node-dev": "^2.0.0",
    "eslint": "^8.56.0",
    "@typescript-eslint/eslint-plugin": "^6.15.0",
    "@typescript-eslint/parser": "^6.15.0",
    "prettier": "^3.1.1",
    "jest": "^29.7.0",
    "@types/jest": "^29.5.11"
  }
}
EOF

# Frontend package.json
cat > frontend/package.json << 'EOF'
{
  "name": "lawsoft-frontend",
  "version": "1.0.0",
  "description": "LawSoft LPMS Frontend",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.1",
    "axios": "^1.6.2",
    "@mui/material": "^5.15.1",
    "@mui/icons-material": "^5.15.1",
    "@emotion/react": "^11.11.1",
    "@emotion/styled": "^11.11.0",
    "react-hook-form": "^7.48.2",
    "react-query": "^3.39.3",
    "@types/react": "^18.2.45",
    "@types/react-dom": "^18.2.18",
    "typescript": "^5.3.3"
  },
  "scripts": {
    "start": "react-scripts start",
    "dev": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "devDependencies": {
    "react-scripts": "5.0.1"
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOF

# Install backend dependencies
echo "⚙️ Installing backend dependencies..."
cd backend && npm install && cd ..

# Install frontend dependencies
echo "🎨 Installing frontend dependencies..."
cd frontend && npm install && cd ..

echo ""
echo "✅ Setup complete!"
echo ""
echo "🚀 Next steps:"
echo "1. Run: cd backend && npm run dev"
echo "2. Open new terminal and run: cd frontend && npm run dev"
echo ""
echo "🌐 Your app will be available at:"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:3001"
echo ""
echo "🔑 Database connection:"
echo "   Host: localhost"
echo "   Port: 5432"
echo "   Database: lawsoft"
echo "   User: lawsoft_user"
echo "   Password: lawsoft123"
