# ZEPPELIN: A DIAGNOSTIC INSTRUMENT FOR Continuous Software Engineering

It helps identify the degree of adoption of Continuous Software Engineering (CSE) practices in each StH stage. This way, organizations can have a panoramic view of the CSE practices they perform, identify where they are in the CSE evolutionary path, and which areas should be improved. Thus, it is possible to develop a plan to improve and advance software development towards CSE. Zeppelin uses StH \[3] as a reference model and also considers Continuous\* activities proposed in \[2], CSE practices and aspects provided in the Eye of CSE \[4], and CSE processes constituting the CSE framework (hereafter, called FCSE) proposed in \[1].

> The name Zeppelin was chosen because the diagnostic tool allows viewing an organization in a panoramic way, as if we were in a zeppelin looking at a city. Moreover, the band Led Zeppelin created the song "Stairway to Heaven."

---

## References

1. Monalessa Perini Barcellos. 2020. Towards a Framework for Continuous Software Engineering. In Proceedings of the 34th Brazilian Symposium on Software Engineering (Natal, Brazil) (SBES ’20). ACM, 626–631.
2. Brian Fitzgerald and Klaas-Jan Stol. 2017. Continuous software engineering: A roadmap and agenda. Journal of Systems and Software 123 (2017), 176–189.
3. Helena Holmström Olsson, Hiva Alahyari, and Jan Bosch. 2012. Climbing the "Stairway to Heaven": A Multiple-Case Study Exploring Barriers in the Transition from Agile Development towards Continuous Deployment of Software. In 2012 38th Euromicro Conference on Software Engineering and Advanced Applications. 392–399.
4. Jan Ole Johanssen, Anja Kleebaum, Barbara Paech, and Bernd Bruegge. 2019. Continuous software engineering and its support by usage and decision knowledge: An interview study with practitioners. Journal of Software: Evolution and Process 31, 5 (2019), 21–69.

---

## ⚙️ Makefile Commands

The project includes a `Makefile` to facilitate running tasks in the Docker environment.

| Command          | Description                                                                 |
| ---------------- | --------------------------------------------------------------------------- |
| `make up`        | Starts the containers defined in `docker-compose.yml`.                      |
| `make build`     | Rebuilds images and starts containers. Use after changes in the Dockerfile. |
| `make down`      | Stops and removes containers, preserving volumes.                           |
| `make destroy`   | Stops and removes containers **and** volumes (erases persisted data).       |
| `make superuser` | Runs the `create_superuser.sh` script to create a Django superuser.         |

**Examples:**

```bash
# Start the environment
make up

# Rebuild and start containers
make build

# Stop containers
make down

# Remove everything (including volumes)
make destroy

# Create Django superuser
make superuser
```

---

## 📄 Environment Variables (`.env`)

The `.env` file contains all environment variables required for Zeppelin’s configuration and execution.

### 🔹 General Settings

| Variable                 | Description                                       | Example                   |
| ------------------------ | ------------------------------------------------- | ------------------------- |
| `ALLOWED_HOSTS`          | List of allowed hosts in Django (`*` allows all). | `*`                       |
| `DEBUG`                  | Debug mode (`True` or `False`).                   | `True`                    |
| `SECRET_KEY`             | Secret key used by Django (keep it private).      | `3izb^ryg...`             |
| `DJANGO_SETTINGS_MODULE` | Django settings module.                           | `zeppelin.settings.local` |

---

### 🔹 Database

| Variable            | Description                                             | Example                         |
| ------------------- | ------------------------------------------------------- | ------------------------------- |
| `USE_SQLITE`        | Whether to use SQLite (`True`) or PostgreSQL (`False`). | `False`                         |
| `DB_ENGINE_LOCAL`   | Database backend.                                       | `django.db.backends.postgresql` |
| `DB_HOST_LOCAL`     | Database host.                                          | `zeppelin-db`                   |
| `DB_NAME_LOCAL`     | Database name.                                          | `zeppelin`                      |
| `DB_USER_LOCAL`     | Database user.                                          | `zeppelin`                      |
| `DB_PASSWORD_LOCAL` | Database password.                                      | `zeppelin`                      |
| `DB_PORT_LOCAL`     | Database port.                                          | `5432`                          |

---

### 🔹 Email Configuration

| Variable              | Description               | Example                |
| --------------------- | ------------------------- | ---------------------- |
| `DEFAULT_FROM_EMAIL`  | Default sender email.     | `no-reply@example.com` |
| `EMAIL_HOST`          | SMTP server.              | `smtp.example.com`     |
| `EMAIL_HOST_USER`     | SMTP user.                | `no-reply@example.com` |
| `EMAIL_HOST_PASSWORD` | SMTP password.            | `mypassword`           |
| `EMAIL_PORT`          | SMTP port.                | `587`                  |
| `EMAIL_USE_TLS`       | Use TLS (`True`/`False`). | `True`                 |

---

### 🔹 Security and Hash

| Variable       | Description                      | Example        |
| -------------- | -------------------------------- | -------------- |
| `HASHIDS_SALT` | Salt for generating encoded IDs. | `hA8(scA@!...` |

---

### 🔹 URLs and Integrations

| Variable         | Description                    | Example                 |
| ---------------- | ------------------------------ | ----------------------- |
| `URL_VALIDATION` | URL for validation (optional). | *(empty)*               |
| `URL`            | Base system URL.               | `http://localhost:8000` |

---

### 🔹 PostgreSQL (Docker)

Used by the PostgreSQL container in `docker-compose.yml`:

| Variable            | Description        | Example    |
| ------------------- | ------------------ | ---------- |
| `POSTGRES_DB`       | Database name.     | `zeppelin` |
| `POSTGRES_USER`     | Database user.     | `zeppelin` |
| `POSTGRES_PASSWORD` | Database password. | `zeppelin` |

---

### 🔹 Django Superuser (Automatic Creation)

| Variable                    | Description     | Example           |
| --------------------------- | --------------- | ----------------- |
| `DJANGO_SUPERUSER_USERNAME` | Admin username. | `admin`           |
| `DJANGO_SUPERUSER_EMAIL`    | Admin email.    | `admin@admin.org` |
| `DJANGO_SUPERUSER_PASSWORD` | Admin password. | `xxxxxx!`         |

---

## 🛠️ Development Environment Setup

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

> ⚠️ If the lint check fails, the commit is blocked until the errors are fixed.

To run manually across all files:

```bash
pre-commit run --all-files
```

---

## 🚀 Quick Start

Follow these steps to get Zeppelin running in under 5 minutes:


1. **Copy the `.env` file and configure your settings**

   ```bash
   cp .env.example .env
   ```

   Update the variables inside `.env` according to your environment.

2. **Start the environment with Docker**

   ```bash
   make up
   ```

   This will pull/build images and start the containers.

3. **(Optional) Create a Django superuser**

   ```bash
   make superuser
   ```

4. **Access Zeppelin**

   * **Web Interface:** [http://localhost:8000](http://localhost:8000)
   * **Admin Panel:** [http://localhost:8000/admin](http://localhost:8000/admin)

6. **Stop the environment**

   ```bash
   make down
   ```
