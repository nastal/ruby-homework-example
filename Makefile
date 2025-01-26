up:
	docker-compose up -d

down:
	docker-compose down

connect:
	docker-compose exec web bash

cop:
	docker-compose exec web bundle exec rubocop -A
