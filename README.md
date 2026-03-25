# ZEPPELIN: A DIAGNOSTIC INSTRUMENT FOR Continuous Software Engineering

Zeppelin is a web platform designed to help organizations identify their degree of adoption of Continuous Software Engineering (CSE) practices. Using the Stairway to Heaven (StH) model and the Eye of CSE as frameworks, the tool provides a panoramic view of an organization's evolutionary path.

This repository contains the complete web application, transitioning the diagnostic tool from its original spreadsheet/form formats into a robust, multi-tenant platform where users can manage their organizations, answer the assessment, and visualize their maturity through interactive charts and tailored recommendations.

---

## Tech Stack

- **Backend:** Django 4.1+, Django Rest Framework (DRF)
- **Database:** PostgreSQL 15+
- **Asynchronous Tasks:** Celery + Redis
- **Frontend:** React 18, Vite 5 (with Radar Charts for analytics)
- **Infrastructure:** Docker & Docker Compose

---

## References

1. ARAUJO, Alline Dias de. "Diagnosis and Recommendations for CI/CD Practices based on the Zeppelin Instrument". 2025. Dissertation (Master in Computer Science) – University of Campinas (UNICAMP), Institute of Computing.
2. DOS SANTOS JÚNIOR, Paulo Sérgio; PERINI BARCELLOS, Monalessa; BORGES RUY, Fabiano. "Tell me: Am I going to Heaven? A Diagnosis Instrument of Continuous Software Engineering Practices Adoption". In: Proceedings of the 25th International Conference on Evaluation and Assessment in Software Engineering (EASE '21). 2021. DOI: https://doi.org/10.1145/3463274.3463324.
3. BARCELLOS, Monalessa Perini. "Towards a Framework for Continuous Software Engineering". In: Proceedings of the 34th Brazilian Symposium on Software Engineering. 2020.
4. FITZGERALD, Brian; STOL, Klaas-Jan. "Continuous software engineering: A roadmap and agenda". 2017.
5. OLSSON, Helena Holmström; ALAHYARI, Hiva; BOSCH, Jan. "Climbing the 'Stairway to Heaven'". 2012.
6. JOHANSSEN, Jan Ole et al. "Continuous software engineering and its support by usage and decision knowledge: An interview study with practitioners". 2019.

---

## Development Environment Setup

### Prerequisites
- Python 3.12+
- Node.js 22+
- Docker and Docker Compose
- Postgresql

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd zeppelin-backend

# Create the virtual environment
# On Unix:
python -m venv .venv
source .venv/bin/activate
# On Windows:
# python -m venv .venv
# .venv\Scripts\activate

# Install all dependencies (Python, pre-commit hooks and frontend)
./setup-dev.sh
```

### Quality Assurance
The project uses pre-commit hooks and a comprehensive testing suite to ensure code quality.

- **Frontend Testing:** Powered by Vitest and React Testing Library. Documentation available at `docs/frontend-testing.md`.
- **Backend Testing:** Django unit tests for analytics and core logic.
- **Unified Validation:** Use `make verify` to run all checks (linting, backend tests, and frontend tests) before pushing code.

---

## Quick Start (Docker)

Follow these steps to get the entire Zeppelin stack (Backend + Frontend) running:

1. **Copy the .env file and configure your settings**
   ```bash
   cp .env.example .env
   ```
   *(Update the variables inside .env. For local development via proxy, keep VITE_API_BASE_URL empty).*

2. **Start the environment with Docker**
   ```bash
   make up
   ```
   *This will pull/build images and start the PostgreSQL, Redis, Django Backend, and React Frontend containers.*

3. **Create a Django superuser**
   ```bash
   make superuser
   ```

4. **Populate the database with the official questionnaire data**
   ```bash
   make seed-db
   ```
   *This will load the 71 official questions, adoption levels, and OAuth2 setup into the database.*

5. Access Zeppelin
   * **Web Interface (React):** [http://localhost:5173](http://localhost:5173)
   * **API / Backend Admin:** [http://localhost:8000/admin](http://localhost:8000/admin)
   * **API Documentation (Swagger):** [http://localhost:8000/](http://localhost:8000/)

---

## API and Integration

The project uses OAuth2 for secure API communication. To test the API endpoints manually:

1. **Postman Collection:** An official collection is available at `docs/zeppelin-api-collection.json`.
2. **Authentication:** Use the `Login (Get Tokens)` request in Postman. The `access_token` is automatically managed if you use the provided environment.
3. **Automatic Setup:** The `make seed-db` command automatically creates the necessary OAuth2 Application (Zeppelin Web) required for the authentication flow to work.

---

## Makefile Commands

| Command          | Description                                                                 |
| ---------------- | --------------------------------------------------------------------------- |
| `make up`        | Starts the containers defined in docker-compose.yml.                      |
| `make build`     | Rebuilds images and starts containers. Use after adding new dependencies.   |
| `make verify`    | **Main QA Command:** Runs linting, backend tests, and frontend tests.       |
| `make test-backend` | Runs Django unit tests for analytics and business logic.                 |
| `make test-frontend`| Runs Vitest suite for React components and routing logic.                |
| `make lint`      | Runs pre-commit hooks (Black, Flake8) manually across all files.            |
| `make seed-db`   | Populates the database with the 71 official questions and base structures.  |
| `make seed-demo` | Populates the database with demo answers for testing analytics.             |
| `make down`      | Stops and removes containers, preserving volumes.                           |
| `make destroy`   | Stops and removes containers and volumes (erases persisted data).           |
| `make superuser` | Runs the create_superuser.sh script to create a Django admin.             |
