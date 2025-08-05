# 🔧 Fix Azure AD App Registration Configuration

## ❌ **Current Problem:**
```
AADSTS9002326: Cross-origin token redemption is permitted only for the 'Single-Page Application' client-type
```

## ✅ **Solution Steps:**

### **1. Azure Portal Configuration**

1. **Open:** [Azure Portal](https://portal.azure.com)
2. **Navigate:** Azure Active Directory → App registrations
3. **Find app:** `645a4b0e-9042-474e-beea-f7840c1a8c83`
4. **Click:** Authentication (left sidebar)

### **2. Platform Configuration**

**Current Configuration (WRONG):**
```
Platform: Web
Type: Traditional web application
```

**Required Configuration (CORRECT):**
```
Platform: Single-page application
Type: SPA (React/Angular/Vue.js)
```

### **3. Step-by-Step Fix**

#### **Option A: If you see "Web" platform**
1. **Delete** the "Web" platform (click trash icon)
2. **Click** "Add a platform"
3. **Select** "Single-page application"
4. **Add Redirect URIs:**
   - `http://localhost:5173`
   - `http://localhost:5176`
   - `http://your-server-ip:8080` (for production)
5. **Click** "Configure"

#### **Option B: If no platforms exist**
1. **Click** "Add a platform"
2. **Select** "Single-page application"
3. **Add Redirect URIs:**
   - `http://localhost:5173`
   - `http://localhost:5176`
   - `http://your-server-ip:8080` (for production)
4. **Click** "Configure"

### **4. API Permissions (verify these exist)**
- ✅ Microsoft Graph → User.Read (Delegated)
- ✅ Microsoft Graph → profile (Delegated)
- ✅ Microsoft Graph → email (Delegated)
- ✅ Microsoft Graph → openid (Delegated)

### **5. Final Configuration Should Look Like:**

```
Authentication:
├── Platform configurations
│   └── Single-page application
│       ├── Redirect URIs:
│       │   ├── http://localhost:5173
│       │   ├── http://localhost:5176
│       │   └── http://your-server-ip:8080
│       └── Front-channel logout URL: (leave empty)
├── Advanced settings
│   ├── Allow public client flows: No
│   └── Live SDK support: No
└── Supported account types: 
    └── Accounts in this organizational directory only
```

### **6. After Making Changes:**
1. **Click** "Save" in Azure Portal
2. **Wait** 2-3 minutes for changes to propagate
3. **Clear browser cache** or use incognito mode
4. **Try login again**

## 🚀 **Expected Result:**
After these changes, your Azure AD login should work without the AADSTS9002326 error.

## 🔍 **If Still Not Working:**
- Clear browser cache completely
- Try incognito/private browsing mode
- Check browser console for new error messages
- Verify all redirect URIs are exactly correct (no trailing slashes) 