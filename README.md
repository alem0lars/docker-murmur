# docker-murmur

Docker image for murmur (mumble server)

## Version

1.0.1

## Initial setup

```
docker volume create murmur-data
```

## Create and start container

Execute:

```
docker run -d -p 64738:64738 -p 64738:64738/udp -v murmur-data:/home/murmur/data --name murmur alem0lars/murmur
```

## Notes

### Server password

If you want to set the server password, change the configuration file and then
run: `supervisorctl restart murmur`.
