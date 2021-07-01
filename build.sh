docker build -t pgadmin_openresty ./openresty
docker build -t post_postgres ./postgres
docker build -t post_pgadmin ./pgadmin
mkdir /docker/data/postgres_cluster -p
mkdir /docker/data/postgres_cluster/postgres01/data /docker/data/postgres_cluster/postgres01/log /docker/data/postgres_cluster/ostgres01/backups -p
mkdir /docker/data/postgres_cluster/postgres02/data /docker/data/postgres_cluster/postgres02/log /docker/data/postgres_cluster/postgres02/backups -p
mkdir /docker/data/postgres_cluster/postgres03/data /docker/data/postgres_cluster/postgres03/log /docker/data/postgres_cluster/postgres03/backups -p

su $USER
chmod 777 /docker -R


