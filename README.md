# ZEPPELIN: A DIAGNOSTIC INSTRUMENT FOR Continuous Software Engineering

Zeppelin is a web platform designed to help organizations identify their degree of adoption of Continuous Software Engineering (CSE) practices. Using the Stairway to Heaven (StH) model and the Eye of CSE as frameworks, the tool provides a panoramic view of an organization's evolutionary path.

This repository contains the complete web application, transitioning the diagnostic tool from its original spreadsheet/form formats into a robust, multi-tenant platform where users can manage their organizations, answer the assessment, and visualize their maturity through interactive charts and tailored recommendations.

---

## Tech Stack

- **Backend:** Django, Django Rest Framework (DRF)
- **Database:** PostgreSQL
- **Asynchronous Tasks:** Celery + Redis
- **Frontend:** React, Vite
- **Infrastructure:** Docker & Docker Compose

---

## References

1. Monalessa Perini Barcellos. 2020. Towards a Framework for Continuous Software Engineering. In Proceedings of the 34th Brazilian Symposium on Software Engineering.
2. Brian Fitzgerald and Klaas-Jan Stol. 2017. Continuous software engineering: A roadmap and agenda.
3. Helena Holmström Olsson, Hiva Alahyari, and Jan Bosch. 2012. Climbing the "Stairway to Heaven".
4. Jan Ole Johanssen, Anja Kleebaum, Barbara Paech, and Bernd Bruegge. 2019. Continuous software engineering and its support by usage and decision knowledge: An interview study with practitioners.

---

## Development Environment Setup

### Prerequisites
- Python 3.11+
- Node.js 18+
- Docker and Docker Compose

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd zeppelin-backend

# Create the virtual environment
python3.11 -m venv .venv
source .venv/bin/activate

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
   *(Update the variables inside `.env` according to your environment).*

2. **Start the environment with Docker**
   ```bash
   make up
   ```
   *This will pull/build images and start the PostgreSQL, Redis, Django Backend, and React Frontend containers.*

3. **Create a Django superuser**
   ```bash
   make superuser
   ```

4. **Access Zeppelin**
   * **Web Interface (React):** [http://localhost:5173](http://localhost:5173)
   * **API / Backend Admin:** [http://localhost:8000/admin](http://localhost:8000/admin)

5. **Stop the environment**
   ```bash
   make down
   ```

---

## Makefile Commands

| Command          | Description                                                                 |
| ---------------- | --------------------------------------------------------------------------- |
| `make up`        | Starts the containers defined in `docker-compose.yml`.                      |
| `make build`     | Rebuilds images and starts containers. Use after adding new dependencies.   |
| `make down`      | Stops and removes containers, preserving volumes.                           |
| `make destroy`   | Stops and removes containers **and** volumes (erases persisted data).       |
| `make superuser` | Runs the `create_superuser.sh` script to create a Django admin.             |
