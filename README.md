# handle_server
Docker implementation of a handle.net server.

## Setup
### first run
The handle server needs to generate some configuration files the first time it's run. We can do so but running the `hdl-setup-server` using an interactive (`-i`) container.

The software will prompt for some parameters before outputting all required files to `/hs` - it is very important to map this directory to a persistent named volume.
```
docker run -i -v handle_server_config:/hs  openbookpublishers/handle_server ./bin/hdl-setup-server /hs
```

After the config files have been generated we can run the actual server:

### Starting the server
For simplicity we will use docker-compose:

```
version: "3.5"

services:
  handle_server:
    image: openbookpublishers/handle_server
    container_name: "handle_server"
    restart: always
    volumes:
      - config:/hs
      - /etc/localtime:/etc/localtime:ro
    ports:
      - 2461:2461

  handle_db:
    image: openbookpublishers/handle_db
    container_name: "handle_db"
    restart: always
    volumes:
      - db:/var/lib/postgresql/data
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - ./config/db.env

volumes:
  config:
  db:
```

The use of a database is optional. If you do use the provided postgres database, you must also configure the credentials in `config.dct` - refer to [openbookpublishers/handle_db][1] or [the technical manual][2].

[1]: https://github.com/OpenBookPublishers/handle_db  "Handle db repo"
[2]: http://www.handle.net/tech_manual/HN_Tech_Manual_9.pdf "Handle technical manual"
