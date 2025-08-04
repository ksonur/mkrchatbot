# AI Chatbot with Azure AD Authentication

A React-based chatbot application that integrates with Azure Active Directory for authentication and OpenAI's fine-tuned GPT model for intelligent responses.

## Features

- **Azure AD Authentication**: Secure enterprise login using Microsoft Authentication Library (MSAL)
- **Fine-tuned GPT Integration**: Powered by OpenAI's fine-tuned GPT-3.5-turbo model
- **Modern UI**: Beautiful, responsive interface built with React and Tailwind CSS
- **Real-time Chat**: Interactive chat interface with typing indicators
- **Secure**: Enterprise-grade security with Azure AD integration
- **Docker Ready**: Containerized for easy deployment

## Prerequisites

- Node.js (version 14 or higher) OR Docker
- npm or yarn
- Azure AD application registration
- OpenAI API key with access to fine-tuned model

## Quick Start with Docker 🐳

### Option 1: Using Docker Script (Recommended)

```bash
# Clone the repository
git clone https://github.com/ksonur/mkrchatbot.git
cd mkrchatbot

# Start development environment
./docker-start.sh dev

# Or start production environment
./docker-start.sh prod
```

### Option 2: Using Docker Compose Directly

```bash
# Development mode with hot reload
docker-compose --profile dev up --build

# Production mode
docker-compose up mikrogrup-itbot --build -d

# Custom port (e.g., port 8080)
PORT=8080 docker-compose up mikrogrup-itbot --build
```

### Option 3: Using Docker Commands

```bash
# Build production image
docker build -t mikrogrup-itbot .

# Run production container
docker run -p 3000:80 --env-file .env.local mikrogrup-itbot

# Run development container
docker build -f Dockerfile.dev -t mikrogrup-itbot:dev .
docker run -p 5173:5173 -v $(pwd):/app mikrogrup-itbot:dev
```

## Local Development Setup

### 1. Clone and Install Dependencies

```bash
git clone https://github.com/ksonur/mkrchatbot.git
cd mkrchatbot
npm install
```

### 2. Azure AD Configuration

1. Go to the [Azure Portal](https://portal.azure.com/)
2. Navigate to **Azure Active Directory** > **App registrations**
3. Create a new registration or use existing one
4. Note down:
   - **Application (client) ID**
   - **Directory (tenant) ID**
5. Under **Authentication**, add redirect URIs:
   - `http://localhost:5173` (development)
   - `http://localhost:3000` (production)

### 3. Environment Configuration

Create `.env.local` file:

```bash
# Copy template
cp .env.docker .env.local

# Edit with your actual values
VITE_OPENAI_API_KEY=your-openai-api-key
VITE_OPENAI_MODEL=your-fine-tuned-model-id
VITE_AZURE_CLIENT_ID=your-azure-client-id
VITE_AZURE_TENANT_ID=your-azure-tenant-id
VITE_AZURE_REDIRECT_URI=http://localhost:5173
```

### 4. Run the Application

```bash
npm run dev
```

The application will start on `http://localhost:5173`

## Docker Management Commands

The `docker-start.sh` script provides easy management:

```bash
./docker-start.sh dev      # Development with hot reload
./docker-start.sh prod     # Production deployment
./docker-start.sh build    # Build production image
./docker-start.sh stop     # Stop all containers
./docker-start.sh clean    # Remove containers and images
./docker-start.sh logs     # View container logs
./docker-start.sh shell    # Access container shell
```

## Deployment Options

### Development Deployment

- **URL**: `http://localhost:5173`
- **Features**: Hot reload, source maps, dev tools
- **Use**: Local development

### Production Deployment

- **URL**: `http://localhost:3000` (or custom PORT)
- **Features**: Optimized build, nginx serving, compression
- **Use**: Production environments

### Cloud Deployment

The Docker container can be deployed to:

- **AWS ECS/Fargate**
- **Google Cloud Run**
- **Azure Container Instances**
- **DigitalOcean App Platform**
- **Heroku Container Registry**

Example for cloud deployment:

```bash
# Build and tag for registry
docker build -t your-registry/mikrogrup-itbot:latest .

# Push to registry
docker push your-registry/mikrogrup-itbot:latest

# Deploy with environment variables
docker run -p 80:80 \
  -e VITE_OPENAI_API_KEY=your-key \
  -e VITE_AZURE_CLIENT_ID=your-client-id \
  your-registry/mikrogrup-itbot:latest
```

## Usage

1. **Login**: Click "Sign in with Azure AD" and authenticate with your Azure AD credentials
2. **Chat**: Once authenticated, you can start chatting with the AI assistant
3. **Logout**: Use the logout button in the top-right corner to sign out

## Project Structure

```
src/
├── components/
│   ├── AzureLogin.tsx     # Azure AD login component
│   └── ChatBot.tsx        # Main chat interface
├── config/
│   ├── env.ts            # Environment configuration
│   └── authConfig.ts     # MSAL authentication config
├── services/
│   └── openaiService.ts  # OpenAI API integration
├── assets/
│   └── mikrogrup-logo.png # Company logo
├── App.tsx               # Main application component
└── main.tsx             # Application entry point
```

## Docker Files

- `Dockerfile` - Multi-stage production build with nginx
- `Dockerfile.dev` - Development container with hot reload
- `docker-compose.yml` - Orchestration for dev/prod environments
- `.dockerignore` - Excludes unnecessary files from build context
- `nginx.conf` - Production web server configuration

## Security Notes

- **API Key Security**: API keys are managed through environment variables
- **CORS**: Properly configured for production deployment
- **Security Headers**: Nginx includes security headers
- **Container Security**: Uses Alpine Linux for smaller attack surface

## Troubleshooting

### Common Issues

1. **Authentication Popup Blocked**: Ensure popup blockers are disabled
2. **CORS Errors**: Check environment configuration and redirect URIs
3. **Docker Permission Issues**: Ensure Docker daemon is running
4. **Port Conflicts**: Use different ports or stop conflicting services

### Docker Debugging

```bash
# Check container status
docker-compose ps

# View logs
./docker-start.sh logs

# Access container
./docker-start.sh shell

# Rebuild without cache
docker-compose build --no-cache
```

## Development

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint

### Technologies Used

- React 18
- TypeScript
- Tailwind CSS
- Azure MSAL
- OpenAI API
- Vite
- Docker & nginx

## License

This project is private and confidential. 