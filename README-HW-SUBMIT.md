# Project Setup Guide

## Running the Project with Docker

### 1. Clone the Repository from provided bundle

### 2. Start the Application with Docker
Make sure you have [Docker](https://www.docker.com/) installed. Then, run:

```bash
make up
```

This will:
- Start a **PostgreSQL** database container.
- Start a **Nominatim** geolocation service.
- Build and start the **Rails web application**.

### 3. Verify the Containers Are Running
Check that all required services are up and running:
```bash
docker ps
```

The expected services:
- `db` (PostgreSQL running on port `7006`)
- `web` (Rails app running on port `3300`)
- `nominatim` (Geolocation service running on port `8080`)

### 4. Set Up the Database
Run the following commands inside the `web` container:
```bash
make connect  # Opens a shell in the web container
rails db:create db:migrate db:seed
```

This will:
- Create the database.
- Run migrations.
- Seed the database with initial data.

### 5. Access the Application
After starting the containers, the application should be accessible at:
```
http://localhost:3300
```

The **Nominatim geolocation API** is available at:
```
http://localhost:8080
```

---

## Running Background Jobs

The project includes a scheduled job (`WarmupHotelsJob`) that preloads hotel data for better performance. It runs daily via cron but can also be triggered manually:
```bash
make connect  # Open a shell inside the web container
rails runner "WarmupHotelsJob.perform_now"
```

To configure automatic execution via cron, ensure that the job is scheduled in the `config/schedule.rb` and update the cron table:
```bash
whenever --update-crontab
```

---

## Managing Docker Containers

Command | Description
--- | ---
`make up` | Start all services in the background.
`make down` | Stop all running containers.
`make restart` | Restart the web service.
`make connect` | Open a shell inside the web container.
`make cop` | Run **Rubocop** for code linting.
`make irb` | Open a Rails console inside the container.

---

This setup ensures you can quickly get started with the project using Docker. Let me know if any adjustments are needed!

