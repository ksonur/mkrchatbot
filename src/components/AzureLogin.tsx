import React, { useState } from 'react';
import { MessageCircle, Shield, Users, Zap } from 'lucide-react';
import mikrogruplogoLogo from '../assets/mikrogrup-logo.png';
import { useMsal } from '@azure/msal-react';
import { loginRequest } from '../config/authConfig';
import { getUserFromGraph, formatUserInfo } from '../services/graphService';

interface AzureLoginProps {
  onLogin: (user: { name: string; email: string }) => void;
}

const AzureLogin: React.FC<AzureLoginProps> = ({ onLogin }) => {
  const { instance } = useMsal();
  const [isLogging, setIsLogging] = useState(false);

  const handleAzureLogin = async () => {
    setIsLogging(true);
    try {
      console.log('🔐 Starting Azure AD login...');
      console.log('📋 Login request config:', loginRequest);
      console.log('🏢 MSAL instance config:', {
        clientId: instance.getConfiguration().auth.clientId,
        authority: instance.getConfiguration().auth.authority,
        redirectUri: instance.getConfiguration().auth.redirectUri
      });
      
      // Step 1: Authenticate with Azure AD
      console.log('🔑 Attempting popup login...');
      const loginResponse = await instance.loginPopup(loginRequest);
      console.log('✅ Login response received:', loginResponse);
      
      if (loginResponse.account) {
        console.log('👤 Account found:', {
          username: loginResponse.account.username,
          name: loginResponse.account.name,
          tenantId: loginResponse.account.tenantId
        });
        
        // Step 2: Get access token for Microsoft Graph
        console.log('🎫 Requesting access token...');
        const tokenRequest = {
          scopes: ['User.Read'],
          account: loginResponse.account,
        };
        
        const tokenResponse = await instance.acquireTokenSilent(tokenRequest);
        console.log('✅ Token acquired successfully');
        
        // Step 3: Fetch detailed user information from Microsoft Graph
        try {
          console.log('📊 Fetching user info from Microsoft Graph...');
          const graphUser = await getUserFromGraph(tokenResponse.accessToken);
          const userInfo = formatUserInfo(graphUser);
          
          console.log('✅ User info from Graph:', userInfo);
          
          // Step 4: Pass formatted user info to parent component
          onLogin({
            name: userInfo.name,
            email: userInfo.email
          });
          
          setIsLogging(false);
        } catch (graphError) {
          console.warn('⚠️ Could not fetch from Graph, using basic account info:', graphError);
          // Fallback to basic account information
          const user = {
            name: loginResponse.account.name || 'Unknown User',
            email: loginResponse.account.username
          };
          console.log('🔄 Using fallback user info:', user);
          onLogin(user);
          setIsLogging(false);
        }
      } else {
        console.error('❌ No account found in login response');
        throw new Error('No account found in login response');
      }
    } catch (error) {
      console.error('❌ Login failed with error:', error);
      
      // More detailed error logging with proper typing
      const msalError = error as any; // MSAL errors have specific properties
      
      if (msalError?.errorCode) {
        console.error('📍 MSAL Error Code:', msalError.errorCode);
        console.error('📍 MSAL Error Message:', msalError.errorMessage);
        console.error('📍 MSAL Error Description:', msalError.errorDesc);
      }
      
      if (msalError?.name) {
        console.error('📍 Error Name:', msalError.name);
      }
      
      if (msalError?.message) {
        console.error('📍 Error Message:', msalError.message);
      }
      
      // Show user-friendly error based on error type
      let userMessage = 'Giriş başarısız oldu. Lütfen tekrar deneyin.';
      
      if (msalError?.errorCode === 'user_cancelled') {
        userMessage = 'Giriş işlemi iptal edildi.';
      } else if (msalError?.errorCode === 'consent_required') {
        userMessage = 'İzin gerekli. Lütfen yöneticinizle iletişime geçin.';
      } else if (msalError?.message && msalError.message.includes('popup')) {
        userMessage = 'Popup penceresi engellendi. Popup engelleyiciyi devre dışı bırakın.';
      } else if (msalError?.message && msalError.message.includes('redirect')) {
        userMessage = 'Yönlendirme hatası. Lütfen Azure yöneticinize başvurun.';
      }
      
      alert(userMessage);
      setIsLogging(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-blue-100 flex items-center justify-center p-4">
      <div className="max-w-md w-full">
        {/* Logo and Header */}
        <div className="text-center mb-8">
          <div className="w-24 h-24 bg-white rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg p-3">
            <img 
              src={mikrogruplogoLogo} 
              alt="Mikrogrup Logo" 
              className="w-full h-full object-contain"
            />
          </div>
          <h1 className="text-3xl font-bold text-gray-800">Mikrogrup ITBOT</h1>
          <p className="text-gray-600 mt-2">Güvenli kurumsal chatbot - TeamSystem destekli</p>
        </div>

        {/* Login Card */}
        <div className="bg-white/80 backdrop-blur-md rounded-2xl shadow-xl border border-blue-100 p-8">
          <div className="text-center mb-6">
            <h2 className="text-xl font-semibold text-gray-800 mb-2">Hoş Geldiniz</h2>
            <p className="text-gray-600">Azure Active Directory hesabınızla giriş yapın</p>
          </div>

          {/* Azure Login Button */}
          <button
            onClick={handleAzureLogin}
            disabled={isLogging}
            className="w-full bg-gradient-to-r from-blue-500 to-blue-600 text-white py-3 px-4 rounded-xl font-medium hover:from-blue-600 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all duration-200 flex items-center justify-center space-x-2 shadow-md hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Shield className="w-5 h-5" />
            <span>{isLogging ? 'Giriş yapılıyor...' : 'Azure AD ile Giriş Yap'}</span>
          </button>

          {/* Features */}
          <div className="mt-8 space-y-4">
            <div className="flex items-center space-x-3 text-sm text-gray-600">
              <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                <Shield className="w-4 h-4 text-blue-600" />
              </div>
              <span>Kurumsal düzeyde güvenlik</span>
            </div>
            <div className="flex items-center space-x-3 text-sm text-gray-600">
              <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                <Users className="w-4 h-4 text-blue-600" />
              </div>
              <span>Takım işbirliği özellikleri</span>
            </div>
            <div className="flex items-center space-x-3 text-sm text-gray-600">
              <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                <Zap className="w-4 h-4 text-blue-600" />
              </div>
              <span>Hızlı AI yanıtları</span>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center mt-6 text-sm text-gray-500">
          <p>Azure Active Directory ile korunmaktadır</p>
          <p className="mt-1 text-xs">Powered by TeamSystem & Mikrogrup</p>
        </div>
      </div>
    </div>
  );
};

export default AzureLogin;