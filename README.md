# Hub - Infrastructure - LDAP




    cn=admin,dc=kraken,dc=local

    docker run --name phpldapadmin-service --hostname kraken.local --link ldap:ldap-host --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host --detach osixia/phpldapadmin:0.7.2
    PHPLDAP_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin-service)

## References

* [osixia/docker-openldap documentation](https://github.com/osixia/docker-openldap)
* [osixia/docker-phpLDAPadmin documentation](https://github.com/osixia/docker-phpLDAPadmin)
