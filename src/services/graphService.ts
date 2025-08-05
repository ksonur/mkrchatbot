// User interface for Graph API response
export interface GraphUser {
  displayName?: string;
  mail?: string;
  userPrincipalName?: string;
  givenName?: string;
  surname?: string;
  jobTitle?: string;
  department?: string;
}

// Get user information from Microsoft Graph using direct API call
export const getUserFromGraph = async (accessToken: string): Promise<GraphUser> => {
  try {
    const response = await fetch('https://graph.microsoft.com/v1.0/me', {
      headers: {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json'
      }
    });

    if (!response.ok) {
      throw new Error(`Graph API error: ${response.status} ${response.statusText}`);
    }

    const user = await response.json();
    console.log('Raw Graph API response:', user);
    
    return user as GraphUser;
  } catch (error) {
    console.error('Error fetching user from Graph:', error);
    throw new Error('Failed to fetch user information from Microsoft Graph');
  }
};

// Format user information for our app
export const formatUserInfo = (graphUser: GraphUser) => {
  // Prioritize mail over userPrincipalName for cleaner email display
  const email = graphUser.mail || graphUser.userPrincipalName || 'No email available';
  
  // Use displayName first, then construct from first/last name, or fallback
  const name = graphUser.displayName || 
               (graphUser.givenName && graphUser.surname ? 
                `${graphUser.givenName} ${graphUser.surname}` : 
                graphUser.givenName || 'Unknown User');

  return {
    name: name,
    email: email,
    fullName: graphUser.displayName,
    firstName: graphUser.givenName,
    lastName: graphUser.surname,
    jobTitle: graphUser.jobTitle,
    department: graphUser.department
  };
}; 