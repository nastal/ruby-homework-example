up:
	docker-compose up -d

down:
	docker-compose down

connect:
	docker-compose exec web bash

restart:
	docker-compose restart web

cop:
	docker-compose exec web bundle exec rubocop -A

irb:
	docker-compose exec web rails console