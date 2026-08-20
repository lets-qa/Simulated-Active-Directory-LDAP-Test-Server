FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y samba-ad-dc krb5-user bind9-dnsutils ldap-utils acl attr && \
    rm -f /etc/samba/smb.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 389 636

CMD ["/entrypoint.sh"]
