// Environment configuration
export const config = {
  openai: {
    apiKey: import.meta.env.VITE_OPENAI_API_KEY || '',
    model: import.meta.env.VITE_OPENAI_MODEL || 'ft:gpt-3.5-turbo-0125:mikrogrup::Bz01EUG1'
  },
  azure: {
    clientId: import.meta.env.VITE_AZURE_CLIENT_ID || 'e2169084-d5d5-4518-8269-5441b145cb8f',
    tenantId: import.meta.env.VITE_AZURE_TENANT_ID || 'bb364f09-07cf-4eca-9b92-1f26a92d5f3f',
    redirectUri: import.meta.env.VITE_AZURE_REDIRECT_URI || window.location.origin
  }
}; 