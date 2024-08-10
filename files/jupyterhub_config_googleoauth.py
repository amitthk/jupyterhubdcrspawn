import os

c.JupyterHub.hub_ip = os.getenv('HUB_IP')
c.JupyterHub.hub_connect_ip = os.getenv('HUB_CONNECT_IP')
c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'

# Use Google OAuth2 for authentication
c.JupyterHub.authenticator_class = 'oauthenticator.GoogleOAuthenticator'
c.GoogleOAuthenticator.client_id = os.getenv('GOOGLE_CLIENT_ID')
c.GoogleOAuthenticator.client_secret = os.getenv('GOOGLE_CLIENT_SECRET')
c.GoogleOAuthenticator.oauth_callback_url = os.getenv('GOOGLE_CALLBACK_URL')

c.Authenticator.delete_invalid_users = True
c.Authenticator.admin_users = {'professor'}
