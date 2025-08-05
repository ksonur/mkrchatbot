// MSAL authentication configuration
export const loginRequest = {
  scopes: [
    "User.Read",
    "profile",
    "email",
    "openid"
  ],
};

// Microsoft Graph API configuration
export const graphConfig = {
  graphMeEndpoint: "https://graph.microsoft.com/v1.0/me",
}; 