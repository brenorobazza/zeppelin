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

frontend-install:
	cd frontend && npm install
frontend-dev:
	cd frontend && npm run dev
frontend-build:
	cd frontend && npm run build
frontend-test:
	cd frontend && npm test -- --watchAll=false