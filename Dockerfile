FROM scratch
ADD root.tar.bz2 /
ENTRYPOINT ["/usr/azusa/docker-entrypoint.sh", "--"]
