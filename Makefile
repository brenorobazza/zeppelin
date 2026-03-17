up:
	docker-compose up
stop:
	docker-compose stop
build:
	docker-compose up --build
down:
	docker-compose down
destroy:
	docker-compose down -v
superuser:
	sh ./create_superuser.sh

seed-db:
	docker-compose exec app python manage.py load_initial_questionnaire_data

seed-demo:
	docker-compose exec app python manage.py load_demo_questionnaire_data

frontend-install:
	cd frontend && npm install
frontend-dev:
	cd frontend && npm run dev
frontend-build:
	cd frontend && npm run build
frontend-test:
	cd frontend && npm test -- --watchAll=false
