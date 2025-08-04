import React, { useState } from 'react';
import { MessageCircle, Shield, Users, Zap } from 'lucide-react';
import mikrogruplogoLogo from '../assets/mikrogrup-logo.png';
// import { useMsal } from '@azure/msal-react';
// import { loginRequest } from '../config/authConfig';

interface AzureLoginProps {
  onLogin: (user: { name: string; email: string }) => void;
}

const AzureLogin: React.FC<AzureLoginProps> = ({ onLogin }) => {
  // const { instance } = useMsal();
  const [isLogging, setIsLogging] = useState(false);

  const handleAzureLogin = async () => {
    setIsLogging(true);
    try {
      // Simulate login for bypass mode
      setTimeout(() => {
        const user = {
          name: 'Test User',
          email: 'test@company.com'
        };
        onLogin(user);
        setIsLogging(false);
      }, 1000);

      // Uncomment for real Azure AD login
      // const loginResponse = await instance.loginPopup(loginRequest);
      // if (loginResponse.account) {
      //   const user = {
      //     name: loginResponse.account.name || 'Unknown User',
      //     email: loginResponse.account.username
      //   };
      //   onLogin(user);
      // }
    } catch (error) {
      console.error('Login failed:', error);
      alert('Login failed. Please try again.');
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