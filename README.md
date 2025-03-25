## Backend take-home task

### Task
Analyze and improve this application based on the requirements below.

### What the application does
- Fetches hotel data in cities using openstreetmap.org data
- Stores hotel data locally
- Allows to search through simple hotel data locally

### Requirements, improvements needed
- Improve search speed, warmup doesn't need to happen on every search (see failing test)
- New feature: Allow to search through hotels in a specific city (see failing test)
- New feature: Allow to add "Coat of arms"(Ģērbonis) image url to City and expose it in search results
- Please refactor code to your liking (e.g. too much logic in the controller)
- Think about the tests written, what You can improve there? Do all tests make sense?

### Submitting
- Please bundle your homework using `git bundle create lp-be-homework.bundle --all`
- Attach bundle file to email and send as a reply to initial homework email
- We will then extract it using `git clone lp-be-homework.bundle` on our side

### Hints from us
- Base code is not good, provided tests aren't good either
- We encourage to modify existing tests and write a new ones
- We really like when TDD approach is used during live coding [https://www.youtube.com/watch?v=K6RPMhcRICE]
- When planning improvements and work, try to come up with the action plan first, that way we will be able to prioritize and concentrate on important things first


### What's inside docker compose?

#### Openstreetmap/Nominatim service, that runs locally
To avoid unfair usage of public openstreetmap/nominatim API, local service is started on port 8080. 
It is an open source nominatim app that loads all data for Latvia, so the service can be called locally.


- Original project URL: https://nominatim.org/release-docs/latest/api/Overview/
- Example call for hotels on public API: https://nominatim.openstreetmap.org/ui/search.html?q=Hotels%20in%20sigulda

Booting up service for the first time may take up to 30 minutes, please be patient. You can watch the progress by looking
at the logs by running `docker compose logs -f nominatim` command

Please do a quick test after starting the services that local API is avlailable and returns results by calling
http://localhost:8080/search?q=Hotels%20in%20Sigulda

In case you are not getting any results, please run following command to enable searching by phrases, like in our case "Hotels in ..."
```bash
docker compose exec nominatim sudo -u nominatim nominatim special-phrases --import-from-wiki --project-dir /nominatim

```
After that try searchin again - You should be seeing the data returned.

#### App was created using
```bash
rails new . --api
```

#### To start rails server, on the host system run
```bash
./run.sh
```

#### To connect to running web container
```bash
./connect.sh
```

#### Inside the container - DB setup
```bash
bundle exec rake db:create
```

For development environment, run migrations
```bash
bundle exec rake db:migrate
```

#### Run tests
```bash
bundle exec rspec
```

#### Notes

* rails is set to port 3300 in development environment, so the api endpoint will be located at `http://localhost:3300/api/search`
* If you are familiar with docker compose, feel free to ignore helper commands

---
version: 2024-04-23


