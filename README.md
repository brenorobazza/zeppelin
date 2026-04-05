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

1. Araujo, Alline Dias de; França, Breno Bernard Nicolau de, 2025, "Replication Data for: Diagnosis and recommendations for CI/CD practices based on the zeppelin instrument", https://doi.org/10.25824/redu/GVNP7C, Repositório de Dados de Pesquisa da Unicamp, V1.
2. Monalessa Perini Barcellos. 2020. Towards a Framework for Continuous Software Engineering. In Proceedings of the 34th Brazilian Symposium on Software Engineering.
3. Brian Fitzgerald and Klaas-Jan Stol. 2017. Continuous software engineering: A roadmap and agenda.
4. Helena Holmström Olsson, Hiva Alahyari, and Jan Bosch. 2012. Climbing the "Stairway to Heaven".
5. Jan Ole Johanssen, Anja Kleebaum, Barbara Paech, and Bernd Bruegge. 2019. Continuous software engineering and its support by usage and decision knowledge: An interview study with practitioners.
6. Santos Jr, G. D.; França, B. B. N. 2022. "Flying over Brazilian Organizations with Zeppelin".

---

## Development Environment Setup

### Prerequisites
- Python 3.12+
- Node.js 20+
- Docker and Docker Compose

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

### Pre-commit
The project uses [pre-commit](https://pre-commit.com/) to ensure code quality. After running `setup-dev.sh`, the hook is automatically installed and will run **Black** and **Flake8** on every `git commit`.

```bash
# To run manually across all files:
pre-commit run --all-files
```

---

## Quick Start (Docker)

Follow these steps to get the entire Zeppelin stack (Backend + Frontend) running in under 5 minutes:

1. **Copy the `.env` file and configure your settings**
   ```bash
   cp .env.example .env
   ```
   *(Update the variables inside `.env`. For local development via proxy, keep `VITE_API_BASE_URL` empty).*

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
   *This will load the 71 official questions and required adoption levels into the database.*

5. **(Optional) Load demo data**
   ```bash
   make seed-demo
   ```
   *This will populate a sample organization with answers to test the analytics dashboard.*

6. **Access Zeppelin**
   * **Web Interface (React):** [http://localhost:5173](http://localhost:5173)
   * **API / Backend Admin:** [http://localhost:8000/admin](http://localhost:8000/admin)

7. **Stop the environment**
   ```bash
   make down
   ```

---

## ⚙️ Makefile Commands

| Command          | Description                                                                 |
| ---------------- | --------------------------------------------------------------------------- |
| `make up`        | Starts the containers defined in `docker-compose.yml`.                      |
| `make build`     | Rebuilds images and starts containers. Use after adding new dependencies.   |
| `make seed-db`   | Populates the database with the 71 official questions and base structures.  |
| `make seed-demo` | Populates the database with demo answers for testing analytics.             |
| `make down`      | Stops and removes containers, preserving volumes.                           |
| `make destroy`   | Stops and removes containers **and** volumes (erases persisted data).       |
| `make superuser` | Runs the `create_superuser.sh` script to create a Django admin.             |
