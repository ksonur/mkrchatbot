import React, { useState, useEffect } from 'react';
import { useIsAuthenticated, useMsal } from '@azure/msal-react';
import AzureLogin from './components/AzureLogin';
import ChatBot from './components/ChatBot';
import { getUserFromGraph, formatUserInfo } from './services/graphService';

interface User {
  name: string;
  email: string;
  avatar?: string;
}

function App() {
  // Azure AD authentication
  const isAuthenticated = useIsAuthenticated();
  const { accounts, instance } = useMsal();
  
  const [user, setUser] = useState<User | null>(null);
  const [isLoadingUser, setIsLoadingUser] = useState(false);

  // Set user data from Azure AD account
  useEffect(() => {
    const fetchUserInfo = async () => {
      if (isAuthenticated && accounts.length > 0 && !user) {
        setIsLoadingUser(true);
        try {
          const account = accounts[0];
          
          // Get access token for Microsoft Graph
          const tokenRequest = {
            scopes: ['User.Read'],
            account: account,
          };
          
          const tokenResponse = await instance.acquireTokenSilent(tokenRequest);
          
          // Fetch detailed user information from Microsoft Graph
          try {
            const graphUser = await getUserFromGraph(tokenResponse.accessToken);
            const userInfo = formatUserInfo(graphUser);
            
            console.log('User info loaded from Graph:', userInfo);
            
            setUser({
              name: userInfo.name,
              email: userInfo.email
            });
          } catch (graphError) {
            console.warn('Could not fetch from Graph, using basic account info:', graphError);
            // Fallback to basic account information
            setUser({
              name: account.name || 'Unknown User',
              email: account.username
            });
          }
        } catch (error) {
          console.error('Error fetching user info:', error);
          // Fallback to basic account information
          const account = accounts[0];
          setUser({
            name: account.name || 'Unknown User',
            email: account.username
          });
        } finally {
          setIsLoadingUser(false);
        }
      } else if (!isAuthenticated) {
        setUser(null);
      }
    };

    fetchUserInfo();
  }, [isAuthenticated, accounts, instance, user]);

  const handleLogin = (userData: User) => {
    setUser(userData);
  };

  const handleLogout = () => {
    setUser(null);
  };

  // Show loading state while fetching user info
  if (isAuthenticated && isLoadingUser) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-blue-100 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Kullanıcı bilgileri yükleniyor...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="App">
      {user ? (
        <ChatBot user={user} onLogout={handleLogout} />
      ) : (
        <AzureLogin onLogin={handleLogin} />
      )}
    </div>
  );
}

export default App;