import React, { useState, useEffect } from 'react';
// import { useIsAuthenticated, useMsal } from '@azure/msal-react';
import AzureLogin from './components/AzureLogin';
import ChatBot from './components/ChatBot';

interface User {
  name: string;
  email: string;
  avatar?: string;
}

function App() {
  // Bypass Azure AD for now - comment out these lines when ready to use Azure AD
  // const isAuthenticated = useIsAuthenticated();
  // const { accounts } = useMsal();
  
  const [user, setUser] = useState<User | null>({
    name: 'Test User',
    email: 'test@company.com'
  });

  // Comment out this useEffect when bypassing Azure AD
  // useEffect(() => {
  //   if (isAuthenticated && accounts.length > 0) {
  //     const account = accounts[0];
  //     setUser({
  //       name: account.name || 'Unknown User',
  //       email: account.username
  //     });
  //   } else {
  //     setUser(null);
  //   }
  // }, [isAuthenticated, accounts]);

  const handleLogin = (userData: User) => {
    setUser(userData);
  };

  const handleLogout = () => {
    setUser(null);
  };

  return (
    <div className="App">
      {/* Bypass Azure AD authentication - always show ChatBot for now */}
      {user ? (
        <ChatBot user={user} onLogout={handleLogout} />
      ) : (
        <AzureLogin onLogin={handleLogin} />
      )}
    </div>
  );
}

export default App;