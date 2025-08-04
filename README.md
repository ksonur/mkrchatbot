# AI Chatbot with Azure AD Authentication

A React-based chatbot application that integrates with Azure Active Directory for authentication and OpenAI's fine-tuned GPT model for intelligent responses.

## Features

- **Azure AD Authentication**: Secure enterprise login using Microsoft Authentication Library (MSAL)
- **Fine-tuned GPT Integration**: Powered by OpenAI's fine-tuned GPT-3.5-turbo model
- **Modern UI**: Beautiful, responsive interface built with React and Tailwind CSS
- **Real-time Chat**: Interactive chat interface with typing indicators
- **Secure**: Enterprise-grade security with Azure AD integration

## Prerequisites

- Node.js (version 14 or higher)
- npm or yarn
- Azure AD application registration
- OpenAI API key with access to fine-tuned model

## Setup Instructions

### 1. Clone and Install Dependencies

```bash
git clone <your-repo-url>
cd mgchatbot
npm install
```

### 2. Azure AD Configuration

1. Go to the [Azure Portal](https://portal.azure.com/)
2. Navigate to **Azure Active Directory** > **App registrations**
3. Create a new registration or use existing one
4. Note down:
   - **Application (client) ID**
   - **Directory (tenant) ID**
5. Under **Authentication**, add `http://localhost:5173` as a redirect URI for Single Page Application

### 3. Environment Configuration

Update the values in `src/config/env.ts`:

```typescript
export const config = {
  openai: {
    apiKey: 'your-openai-api-key',
    model: 'your-fine-tuned-model-id'
  },
  azure: {
    clientId: 'your-azure-client-id',
    tenantId: 'your-azure-tenant-id',
    redirectUri: 'http://localhost:5173'
  }
};
```

Or set environment variables:

```bash
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
├── App.tsx               # Main application component
└── main.tsx             # Application entry point
```

## Security Notes

- **API Key Security**: In production, avoid exposing API keys in the frontend. Use a backend proxy for OpenAI API calls.
- **CORS**: Configure proper CORS settings for production deployment
- **Environment Variables**: Never commit sensitive keys to version control

## Troubleshooting

### Common Issues

1. **Authentication Popup Blocked**: Ensure popup blockers are disabled for the application
2. **CORS Errors**: The OpenAI API calls are configured with `dangerouslyAllowBrowser: true` for development. In production, use a backend service
3. **Azure AD Configuration**: Ensure redirect URI matches exactly with your Azure AD app registration

### Error Messages

- **"Login failed"**: Check Azure AD configuration and network connectivity
- **"Failed to get response from AI"**: Verify OpenAI API key and model ID are correct

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

## License

This project is private and confidential. 