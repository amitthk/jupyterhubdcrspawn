import os
c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.hub_connect_ip = '192.168.1.122'
c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'
c.JupyterHub.authenticator_class = 'ldapauthenticator.LDAPAuthenticator'
c.LDAPAuthenticator.server_hosts = ['ldaps://192.168.1.112:9636']
c.LDAPAuthenticator.bind_user_dn = 'cn=Hubert J. Farnsworth,ou=people,dc=ldap,dc=amitthk,dc=com'
c.LDAPAuthenticator.bind_user_password = 'professor'
c.LDAPAuthenticator.user_search_base = 'ou=people,dc=ldap,dc=amitthk,dc=com'
c.LDAPAuthenticator.user_search_filter = '(&(objectClass=posixAccount)(uid={username}))'
c.LDAPAuthenticator.create_user_home_dir = True
c.LDAPAuthenticator.username_pattern = '[a-zA-Z0-9_.][a-zA-Z0-9_.-]{8,20}[a-zA-Z0-9_.$-]?'
c.Authenticator.delete_invalid_users = True
c.Authenticator.admin_users = {'professor'}

#c.DockerSpawner.image = 'amitthk/jupyterhub-singleuser:latest'
#c.LDAPAuthenticator.server_port = 389
#c.LDAPAuthenticator.server_use_ssl = True 
#c.LDAPAuthenticator.server_connect_timeout = 100
# c.LDAPAuthenticator.user_membership_attribute = 'memberOf'
# c.LDAPAuthenticator.group_search_base = 'cn=groups,cn=accounts,dc=example,dc=com'
# c.LDAPAuthenticator.group_search_filter = '(&(objectClass=group)(memberOf={group}))'
# c.LDAPAuthenticator.allow_nested_groups = True
