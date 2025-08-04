import React from 'react'
import ReactDOM from 'react-dom/client'
// import { PublicClientApplication } from '@azure/msal-browser'
// import { MsalProvider } from '@azure/msal-react'
import App from './App.tsx'
import './index.css'
// import { config } from './config/env.ts'

// MSAL configuration - commented out when bypassing Azure AD
// const msalConfig = {
//   auth: {
//     clientId: config.azure.clientId,
//     authority: `https://login.microsoftonline.com/${config.azure.tenantId}`,
//     redirectUri: config.azure.redirectUri,
//   },
//   cache: {
//     cacheLocation: 'localStorage',
//     storeAuthStateInCookie: false,
//   }
// }

// const msalInstance = new PublicClientApplication(msalConfig)

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    {/* Bypass MSAL Provider for now */}
    <App />
    {/* Uncomment when ready to use Azure AD */}
    {/* <MsalProvider instance={msalInstance}>
      <App />
    </MsalProvider> */}
  </React.StrictMode>,
)
