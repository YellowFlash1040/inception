    # Inception - User Documentation

### Services Provided

The Inception stack includes the following services:

1. **NGINX** - Web server and reverse proxy
   - Handles HTTPS connections on port 443
   - Serves WordPress files
   - Implements TLS 1.2/1.3 encryption
   - Acts as the entry point for all web traffic

2. **WordPress** - Content Management System
   - Full WordPress installation with PHP-FPM
   - Accessible via web browser
   - Includes admin dashboard for site management
   - Pre-configured with admin and author user accounts

3. **MariaDB** - Database server
   - Stores all WordPress data (posts, pages, users, settings)
   - Isolated backend service (not directly accessible from outside)
   - Persistent data storage in Docker volumes

## Initial Setup

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
127.0.0.1    akovtune.42.fr
```

(Replace `akovtune.42.fr` with your actual domain name if different)

## Starting the Project

### Quick Start

To start all services:

```bash
make
```

This command will:

1. Create necessary data directories
2. Build Docker images
3. Start all containers in detached mode

## Stopping the Project

### Graceful Shutdown

To stop all services while preserving data:

```bash
make down
```

This stops all containers.

### Complete Cleanup

To remove everything including data:

```bash
make fclean
```

**Warning:** This will delete:

- All containers
- All images
- All volumes
- All data in `/home/user/data/`

Only use this when you want to completely reset the project.

## Accessing the Services

### WordPress Website

Once the services are running, access the website at:

```
https://akovtune.42.fr
```

**Note:** Your browser will show a security warning because the SSL certificate is self-signed. This is normal for development. Click "Advanced" and proceed to the site.

### WordPress Administration Panel

Access the admin dashboard at:

```
https://akovtune.42.fr/wp-admin/
```

**Login Credentials:**

- Username: Value of `WP_ADMIN_USER` from your `.env` file
- Password: Value of `WP_ADMIN_PASSWORD` from your `.env` file

### Additional User Account

A second user account (author role) is automatically created:

- Username: Value of `SECOND_WP_USER` from your `.env` file
- Password: Value of `SECOND_WP_USER_PASSWORD` from your `.env` file

This additional account can only create, edit and publish his own posts.

## Managing Credentials

### Location of Credentials

All credentials are stored in the `.env` file located at:

```
srcs/.env
```

### Credential Types

1. **MariaDB Root Password** (`MARIADB_ROOT_USER_PASSWORD`)
   - Full database administrator access
   - Used for database maintenance
   - Not needed for normal WordPress operation

2. **WordPress Database Password** (`WP_DB_USER_PASSWORD`)
   - Used by WordPress to connect to MariaDB
   - Managed automatically by the containers
   - Changing this requires rebuilding containers

3. **WordPress Admin Password** (`WP_ADMIN_PASSWORD`)
   - Full WordPress administrator access
   - Can be changed from wp-admin dashboard after login
   - Can also be reset using WP-CLI in the container

4. **WordPress Author Password** (`SECOND_WP_USER_PASSWORD`)
   - Limited WordPress user access
   - Can be changed from wp-admin dashboard

### Changing Credentials

To change credentials after initial setup:

1. **WordPress User Passwords** (Recommended method):
   - Log in to wp-admin
   - Go to Users → Select user → Edit
   - Scroll to "Account Management" → "New Password"
   - Generate or enter new password → Update User

2. **Environment Variables** (Requires rebuild):

   ```bash
   # Edit .env file
   nano srcs/.env

   # Rebuild and restart
   make re
   ```

### Credential Security Best Practices

- Use passwords with at least 12 characters
- Include uppercase, lowercase, numbers, and symbols
- Never share credentials in plain text
- Use different passwords for each service
- Consider using a password manager
- Regularly rotate passwords (every 90 days recommended)

## Verifying Services

### Check Container Status

To verify all services are running:

```
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

or just

```bash
docker ps
```

You should see three containers:

- `nginx` - Status: Up
- `wordpress` - Status: Up
- `mariadb` - Status: Up

### Check Container Logs

To view logs for troubleshooting:

```bash
# All services
docker compose -f srcs/docker-compose.yml logs

# Specific service
docker logs nginx
docker logs wordpress
docker logs mariadb

# Adding -f flags allows to follow logs in real-time
docker compose -f srcs/docker-compose.yml logs -f
docker logs service_name -f
```

### Check Network Connectivity

Verify the services can communicate:

```bash
# Check if NGINX can reach WordPress
docker exec nginx nc -z wordpress:9000 && echo "connection works" || echo "no connection"

# Check if WordPress can reach MariaDB
docker exec wordpress ping -c 3 mariadb
```

### Check NGINX Configuration

```bash
# Test NGINX configuration syntax
docker exec nginx nginx -t
```

Should return: `syntax is ok` and `test is successful`
