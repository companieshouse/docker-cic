
domain_name  = os.environ.get("DOMAIN_NAME", "wldomain")
domain_path  = '/apps/oracle/%s' % domain_name
db_user  = os.environ.get("DB_USER", 'db_user_missing')
db_password  = os.environ.get("DB_PASSWORD", 'db_password_missing')
db_url  = os.environ.get("DB_URL", 'db_url_missing')

print('domain_name : [%s]' % domain_name);
print('domain_path : [%s]' % domain_path);
print('db_url : [%s]' % db_url);

# Open the domain
# ======================
readDomain(domain_path)

cd('/JDBCSystemResource/CIC/JdbcResource/CIC/JDBCDriverParams/NO_NAME_0')
set('PasswordEncrypted', db_password)
cmo.setUrl(db_url)

cd('/JDBCSystemResource/CIC/JdbcResource/CIC/JDBCDriverParams/NO_NAME_0/Properties/NO_NAME_0/Property/user')
cmo.setValue(db_user)

# Write Domain
# ============
updateDomain()
closeDomain()

# Exit WLST
# =========
exit()
