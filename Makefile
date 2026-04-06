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
	sh ./backend/create_superuser.sh

# Alimenta o banco com as 71 perguntas oficiais.
seed-db:
	docker-compose exec app python manage.py load_initial_questionnaire_data

# Alimenta o banco com dados de teste para ver graficos e dashboard.
seed-demo:
	docker-compose exec app python manage.py load_demo_questionnaire_data

# --- FRONTEND COMMANDS ---
frontend-install:
	cd frontend && npm install
frontend-dev:
	cd frontend && npm run dev
frontend-build:
	cd frontend && npm run build
frontend-test:
	cd frontend && npm test

# --- TESTING & QUALITY ---
# Roda os testes do backend (camada analitica).
test-backend:
	docker-compose exec -e SECRET_KEY=zeppelin-test -e DB_ENGINE_TEST=django.db.backends.sqlite3 app python manage.py test apps.questionnaire.test_analytics --settings=zeppelin.settings.test

# Roda os testes do frontend (Vitest).
test-frontend:
	cd frontend && npm test

# Roda a verificacao de estilo (Linting) do projeto.
lint:
	pre-commit run --all-files

# COMANDO PRINCIPAL: Roda todas as validacoes exigidas pelo GitHub Actions localmente.
verify: lint test-backend test-frontend
	@echo "All checks passed! Your branch is ready for push."
