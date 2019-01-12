.PHONY: default build run stop run_client stop_client clean

IMAGE_NAME = hub-infra-ldap
CONTAINER_NAME = ldap
LDAP_DATA_VOLUME = ldap-data
LDAP_SLAPD_VOLUME = ldap-slapd

default: build

build:
	docker volume create $(LDAP_DATA_VOLUME)
	docker volume create $(LDAP_SLAPD_VOLUME)
	docker build -t $(IMAGE_NAME) .

run: build
	docker run --name $(CONTAINER_NAME) \
		--env LDAP_ORGANISATION="Kraken Labs" \
		--env LDAP_DOMAIN="kraken.local" \
		-v $(LDAP_DATA_VOLUME):/var/lib/ldap \
		-v $(LDAP_SLAPD_VOLUME):/etc/ldap/slapd.d \
		-p 389:389 \
		-p 689:689 \
		--detach osixia/openldap:1.2.2

run_client:

	docker run --detach --rm \
		--name phpldapadmin-service \
		--hostname phpldapadmin.kraken.local \
		--link ldap:ldap-host \
		--env PHPLDAPADMIN_LDAP_HOSTS=ldap-host \
		osixia/phpldapadmin:0.7.2

stop_client:

	docker stop phpldapadmin-service

get_client:
	
	echo Go to: https://$$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin-service)

stop:
	docker stop $(CONTAINER_NAME) || /bin/true

clean: stop
	docker rm $(CONTAINER_NAME) || /bin/true
	docker volume rm $(LDAP_DATA_VOLUME) || /bin/true
	docker volume rm $(LDAP_SLAPD_VOLUME) || /bin/true
