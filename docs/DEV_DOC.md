# Inception - Developer Documentation

## Architecture Overview

The Inception stack consists of three Docker containers:

- **NGINX** - Web server
- **WordPress** - PHP-FPM application server
- **MariaDB** - Database server

## Prerequisites

- A virtual machine or a PC running a Linux distribution (tested on Debian/Ubuntu)
- Docker Engine
- Make utility

Links to install:

- Virtual Machine: https://www.virtualbox.org/
- Debian: https://www.debian.org/
- Docker Engine: https://docs.docker.com/engine/install
- Make utility: `sudo apt update && sudo apt install make`

## Project initial Setup

### 1. Configure Environment Variables

Before running the project for the first time, you must create a `.env` file:

```bash
cd srcs
cp .env.example .env
```

and fill in all the values.

### 2. Configure Domain Name

Add your domain to your hosts file for local development:

```bash
sudo nano /etc/hosts
```

Add the following line:

```
127.0.0.1    wil.42.fr
```

(Replace `wil.42.fr` with your actual domain name if different)

## Services setup and configuration from scratch

### MariaDB

For MariaDB you can use next commands:

```bash
mariadb-install-db # MariaDB installer/initial setup
mariadb # MariaDB SQL client
mariadbd # MariaDB server
mariadb-admin # MariaDB server administration tool
```

### NGINX

NGINX is being configured using `nginx.conf` configuration file

### Wordpress + PHP-FPM

Wordpress is being installed and configured using WP-CLI and next commands:

```bash
wp core download # Download Wordpress
wp config create # Create WordPress application config file
wp core is-installed # Check if Wordpress is already installed
wp core install # Famous Wordpress 5-minute install
wp user get # Check if user exists
wp user create # Create new user
```

And PHP-FPM is being configured using a PHP-FPM configuration file `www.conf`

## Building and Launching

### Using Makefile

```bash
# Build and start all services
make

# This executes:
# 1. make prepare  - Creates data directories
# 2. make up       - Builds images and starts containers
```

### Individual Commands

```bash
# Create data directories only
make prepare

# Build and start services
make up

# Stop services (preserves data)
make down

# Remove containers (preserves volumes and images)
make clean

# Complete cleanup (removes everything including data)
make fclean

# Rebuild from scratch
make re
```

### Using Docker Compose Directly

```bash
# Build images
docker compose -f srcs/docker-compose.yml build

# Start services
docker compose -f srcs/docker-compose.yml up -d

# Build and start
docker compose -f srcs/docker-compose.yml up -d --build

# Stop services
docker compose -f srcs/docker-compose.yml down
```

## Managing Containers

### Viewing Status

```bash
# List running containers
docker ps

# Formatted view
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Using docker compose
docker compose -f srcs/docker-compose.yml ps
```

### Starting/Stopping

```bash
# Stop all services
docker compose -f srcs/docker-compose.yml stop

# Start all services
docker compose -f srcs/docker-compose.yml start

# Restart specific service
docker compose -f srcs/docker-compose.yml restart nginx
```

### Viewing Logs

```bash
# All services
docker compose -f srcs/docker-compose.yml logs

# Specific service
docker logs nginx
docker logs wordpress
docker logs mariadb

# Follow logs in real-time
docker compose -f srcs/docker-compose.yml logs -f
docker logs wordpress -f
```

### Executing Commands

```bash
# Access container shell
docker exec -it nginx sh
docker exec -it wordpress bash
docker exec -it mariadb bash

# Run single command
docker exec nginx nginx -t
docker exec wordpress wp --info --allow-root --path=/var/www/html/wordpress
```

## Managing Volumes

### Volume Locations

**Host filesystem:**

```
/home/user/data/
├── mariadb/           # Database files
└── wordpress/         # WordPress files
```

**Container paths:**

```
MariaDB:    /var/lib/mysql → /home/user/data/mariadb
WordPress:  /var/www/html/wordpress → /home/user/data/wordpress
NGINX:      /var/www/html/wordpress → /home/user/data/wordpress
```

### Viewing Volume Information

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect srcs_mariadb_volume
docker volume inspect srcs_wordpress_volume

# Check volume usage
du -sh /home/user/data/mariadb
du -sh /home/user/data/wordpress
```

### Backup Volumes

```bash
# Stop services first
make down

# Backup MariaDB
sudo tar -czf mariadb-backup-$(date +%Y%m%d).tar.gz \
  -C /home/user/data mariadb

# Backup WordPress
sudo tar -czf wordpress-backup-$(date +%Y%m%d).tar.gz \
  -C /home/user/data wordpress

# Restart services
make up
```

### Restore Volumes

```bash
# Stop services
make down

# Restore from backup
sudo tar -xzf mariadb-backup-20250206.tar.gz \
  -C /home/user/data
sudo tar -xzf wordpress-backup-20250206.tar.gz \
  -C /home/user/data

# Restart services
make up
```

## Data Persistence

### How Data Persists

The project uses Docker volumes defined in `docker-compose.yml`:

```yaml
volumes:
  mariadb_volume:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/user/data/mariadb
```

**Data survives:**

- Container stop/start
- Container removal
- Image rebuild
- System reboot

**Data is lost when:**

- Host directory is deleted
- `make fclean` is executed

### What Persists

**MariaDB** (`/home/user/data/mariadb/`):

- All databases and tables
- User accounts and permissions
- System databases (mysql, performance_schema)

**WordPress** (`/home/user/data/wordpress/`):

- WordPress core files
- Configuration (`wp-config.php`)
- Themes and plugins
- Uploaded media files (`wp-content/uploads/`)

### Verifying Data

```bash
# Check MariaDB data
docker exec mariadb ls -la /var/lib/mysql

# Check WordPress data
docker exec wordpress ls -la /var/www/html/wordpress

# Verify database contents
docker exec mariadb mysql -u root -p${MARIADB_ROOT_USER_PASSWORD} -e "SHOW DATABASES;"

# Check WordPress installation
docker exec wordpress wp core version --allow-root --path=/var/www/html/wordpress
```
