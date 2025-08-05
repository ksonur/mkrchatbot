# 🔐 Azure AD Integration Test Guide

## ✅ **What We've Implemented:**

### **1. Enhanced Authentication Scopes**
```typescript
scopes: [
  "User.Read",     // Basic user profile
  "profile",       // Full profile information  
  "email",         // Email address
  "openid"         // OpenID Connect
]
```

### **2. Microsoft Graph API Integration**
- **Direct API calls** to `https://graph.microsoft.com/v1.0/me`
- **Fetches real user data** from Azure AD
- **Fallback mechanism** if Graph API fails

### **3. User Information Retrieved**
```json
{
  "displayName": "John Doe",
  "mail": "john.doe@company.com", 
  "userPrincipalName": "john.doe@company.onmicrosoft.com",
  "givenName": "John",
  "surname": "Doe",
  "jobTitle": "Software Developer",
  "department": "IT"
}
```

## 🧪 **Testing Steps:**

### **1. Local Testing**
```bash
# Your dev server is running on:
http://localhost:5176/

# 1. Click "Azure AD ile Giriş Yap"
# 2. Sign in with your Microsoft account
# 3. Check browser console for:
#    - "User info from Graph: {...}"
#    - User name and email in top right corner
```

### **2. Production Testing**
```bash
# Deploy to your Linux server
./build-local.sh

# Access via:
http://your-server-ip:8080
```

### **3. Troubleshooting**

**If login fails:**
- Check Azure Portal → App Registrations → Authentication
- Verify redirect URIs include your domain
- Check browser console for errors

**If Graph API fails:**
- Check Azure Portal → API permissions
- Ensure "User.Read" is granted
- App will fallback to basic MSAL account info

## 🔧 **Azure Portal Configuration Required:**

### **Redirect URIs to Add:**
```
http://localhost:5173
http://localhost:5176  
http://your-server-ip:8080
https://your-domain.com
```

### **API Permissions:**
- ✅ Microsoft Graph → User.Read (Application)
- ✅ Microsoft Graph → profile (Delegated)
- ✅ Microsoft Graph → email (Delegated)
- ✅ Microsoft Graph → openid (Delegated)

## 🎯 **Expected Result:**

**Top right corner should show:**
- ✅ **Real name** from Azure AD (displayName)
- ✅ **Real email** from Azure AD (mail or userPrincipalName)
- ✅ **Beautiful styling** with background and border
- ✅ **Working logout** that clears session

## 📋 **Environment Setup:**

**Create `.env.local` file:**
```env
VITE_AZURE_CLIENT_ID=645a4b0e-9042-474e-beea-f7840c1a8c83
VITE_AZURE_TENANT_ID=bb364f09-07cf-4eca-9b92-1f26a92d5f3f
VITE_AZURE_REDIRECT_URI=http://localhost:5176
VITE_OPENAI_API_KEY=your_openai_api_key_here
VITE_OPENAI_MODEL=ft:gpt-3.5-turbo-0125:mikrogrup::Bz01EUG1
```

**Your Azure AD integration is now complete and ready for testing! 🚀** 