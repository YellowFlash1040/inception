# Inception

*This project has been created as part of the 42 curriculum by **akovtune**.*

## Description

Inception is a **system administration** and **containerization** project that focuses on building a complete web infrastructure using **Docker**. It demonstrates how to design and orchestrate multiple interconnected services with **Docker Compose**. All services present are open-source projects.

The infrastructure consists of three core services:
- **NGINX**: A reverse proxy and web server configured with TLS encryption (TLSv1.2/TLSv1.3)
- **WordPress + PHP-FPM**: A content management system running on PHP FastCGI Process Manager
- **MariaDB**: A relational database server providing persistent storage for WordPress

Each service is built from a custom **Dockerfile** based on **Alpine Linux**. The infrastructure is designed to be self-contained and easily reproducible.

The project emphasizes containerization best practices, including:
- Secure credential management through environment variables
- Proper service isolation and network segmentation
- Data persistence using **Docker volumes**
- Automatic container restart

## Instructions

### Prerequisites

- A virtual machine or a PC running a Linux distribution (tested on Debian/Ubuntu)
- Docker Engine
- Make utility

Links to install:
- Virtual Machine: https://www.virtualbox.org/
- Debian: https://www.debian.org/
- Docker Engine: https://docs.docker.com/engine/install
- Make utility: `sudo apt update && sudo apt install make`

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/YellowFlash1040/inception
   cd inception
   ```

2. **Configure environment variables**
   
   Create a `.env` file in the `srcs/` directory based on the provided `.env.example`:
   ```bash
   cp srcs/.env.example srcs/.env
   ```
   
   Edit the `.env` file and fill in all required values:
   ```bash
   # Example configuration
    DOMAIN_NAME=akovtune.42.fr
    
    # MariaDB Configuration
    MARIADB_FOLDER=/var/lib/mysql
    MARIADB_SOCKET_FOLDER=/run/mysqld
    MARIADB_LINUX_USER=mysql
    MARIADB_ROOT_USER_PASSWORD=
    
    # WordPress Files
    WP_FOLDER=/var/www/html/wordpress
    WP_LINUX_USER=wordpress
    
    # WordPress Database Configuration
    WP_DB_HOST=mariadb:3306
    WP_DB_NAME=
    WP_DB_USER=
    WP_DB_USER_PASSWORD=
    
    # WordPress Site Configuration
    WP_URL=https://localhost:443
    WP_TITLE=
    
    # WordPress Admin Account
    WP_ADMIN_USER=
    WP_ADMIN_EMAIL=
    WP_ADMIN_PASSWORD=
    
    # Additional WordPress User Account (Role: author)
    SECOND_WP_USER=
    SECOND_WP_USER_EMAIL=
    SECOND_WP_USER_PASSWORD=
   ```

3. **Update the Makefile**
   
   Modify the volume paths in the Makefile to match desired locations:
   ```bash
   WP_DATA_FOLDER		:= /home/akovtune/data/wordpress
   MARIADB_DATA_FOLDER	:= /home/akovtune/data/mariadb
   ```
   
   Also update the volume paths in `srcs/docker-compose.yml`:
   ```yaml
   volumes:
     mariadb_volume:
       driver_opts:
         device: /home/akovtune/data/mariadb
     wordpress_volume:
       driver_opts:
         device: /home/akovtune/data/wordpress
   ```

4. **Configure local domain resolution**
   
   Add the domain to your `/etc/hosts` file:
   ```bash
   sudo echo "127.0.0.1 akovtune.42.fr" >> /etc/hosts
   ```

### Building and Running

**Build and start all services:**
```bash
make
```

This command will:
- Create the necessary data directories
- Build all Docker images from the Dockerfiles
- Start all containers in detached mode

**Other useful commands:**

- **Stop all services:**
  ```bash
  make down
  ```

- **Stop and remove all containers:**
  ```bash
  make clean
  ```

- **Complete cleanup** (removes containers, images, volumes, and data):
  ```bash
  make fclean
  ```

- **Rebuild everything from scratch:**
  ```bash
  make re
  ```

### Accessing the Services

Once the containers are running:

1. **Access the WordPress website**:
   - Open your browser and navigate to `https://akovtune.42.fr`
   - You may need to accept the self-signed SSL certificate warning  

**Important notice**: if you are using a VM, make sure to configure port forwarding.

2. **Check service status:**
   ```bash
   docker ps
   ```

3. **View logs:**
   ```bash
   docker logs nginx
   docker logs wordpress
   docker logs mariadb
   ```

## Resources

### Docker and Containerization
- [Install Docker](https://docs.docker.com/engine/install/)
- [Docker Docs Homepage](https://docs.docker.com/)
- [Docker Reference](https://docs.docker.com/reference/)
- [Docker Best Practices](https://docs.docker.com/build/building/best-practices/)
- [Docker Best Practices YouTube version](https://www.youtube.com/watch?v=t779DVjCKCs)
- [Docker in 100 seconds](https://www.youtube.com/watch?v=Gjnup-PuquQ&pp=ygUVZG9ja2VyIGluIDEwMCBzZWNvbmRz)
- [Docker 101](https://www.youtube.com/watch?v=rIrNIzy6U_g&pp=ygUVZG9ja2VyIGluIDEwMCBzZWNvbmRz)
- [Learn Docker in 7 Easy Steps](https://www.youtube.com/watch?v=gAkwW2tuIqE)
- [VM vs Container](https://www.youtube.com/watch?v=eGz9DS-aIeY&list=PLIhvC56v63IJlnU4k60d0oFIrsbXEivQo&index=2)
- [Learn Docker in 2 hours](https://www.youtube.com/watch?v=fqMOX6JJhGo&pp=ygUZbGVhcm4gZG9ja2VyIGZyZWVjb2RlY2FtcA%3D%3D)
- [Docker Free Labs](https://kodekloud.com/free-labs/docker)
- [Custom Dockerfile](https://www.youtube.com/watch?v=SnSH8Ht3MIc)
- [Docker Compose Restart option](https://docs.docker.com/reference/compose-file/services/#restart)

### NGINX
- [What is a Webserver](https://developer.mozilla.org/en-US/docs/Learn_web_development/Howto/Web_mechanics/What_is_a_web_server)
- [What is NGINX?](https://nginx.org/)
- [NGINX Official Documentation](https://nginx.org/en/docs/)
- [NGINX configuration file structure](https://nginx.org/en/docs/beginners_guide.html#conf_structure)
- [Alphabetical index of directives](https://nginx.org/en/docs/dirindex.html)
- [NGINX SSL Configuration](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [How to Setup SSL with NGINX](https://www.youtube.com/watch?v=X3Pr5VATOyA&pp=ygUJbmdpbnggc3Ns)
- [Install NGINX](https://nginx.org/en/docs/install.html)
- [NGINX on Alpine Linux](https://nginx.org/en/linux_packages.html#Alpine)

### Self-signed certificate and encryption
- [What is a Self-signed certificate?](https://linuxize.com/post/creating-a-self-signed-ssl-certificate/)
- [OpenSSL Documentation](https://docs.openssl.org/1.0.2/man1/req/)
- [TLS explained](https://www.youtube.com/watch?v=o_g-M7UBqI8)
- [Asymmetric Encryption simply explained](https://www.youtube.com/watch?v=AQDCe585Lnc)
- [SSL, TLS, HTTPS](https://www.youtube.com/watch?v=j9QmMEWmcfo)
- [7 Cryptography Concepts EVERY Developer Should Know](https://www.youtube.com/watch?v=NuyzuNBFWxQ)
- [SSL/TLS in 7 minutes](https://www.youtube.com/watch?v=67Kfsmy_frM)
- [A better definition of Asymmetric Cryptography](https://www.youtube.com/watch?v=QToJvh7M62o)

### WordPress and PHP-FPM
- [WordPress Documentation](https://wordpress.org/documentation/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [WP-CLI Reference](https://developer.wordpress.org/cli/commands/)
- [Wordpress user roles](https://wordpress.org/documentation/article/roles-and-capabilities/)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.configuration.php)

### MariaDB
- [What is MariaDB?](https://www.youtube.com/watch?v=-b3trv4e5TE)
- [MariaDB Knowledge Base](https://mariadb.com/docs/)
- [MariaDB Server Documentation](https://mariadb.com/docs/server)

### Shell scripting
- [Bash in 100 seconds](https://www.youtube.com/watch?v=I4EWvMFj37g)
- [Learn Bash](https://www.youtube.com/watch?v=SPwyp2NG-bE&list=PLIhvC56v63IKioClkSNDjW7iz-6TFvLwS)

### Dot files
- [Dot files in 100 second](https://www.youtube.com/watch?v=r_MpUP6aKiQ)

## AI Usage in This Project

AI was used throughout the development of this project in the following ways:

**Learning and Understanding**  
AI helped me understand new concepts such as Docker, containerization, NGINX, PHP-FPM, and MariaDB, and how these technologies work together.

**Finding Resources**  
AI assisted in locating relevant documentation, tutorials, and best practices.

**Troubleshooting and Problem Solving**  
When errors occurred, AI helped analyze issues, explain their causes, and suggest possible solutions.

**Configuration and Code Support**  
AI explained configuration options in Dockerfiles, docker-compose.yml, NGINX configs, and shell scripts, and reviewed them for potential issues or improvements.

**Best Practices and Security**  
AI provided guidance on good practices such as running services as non-root users, handling secrets properly, and applying the principle of least privilege.

**Documentation**  
AI helped structure and write this README while keeping it clear and aligned with project requirements.

Overall, AI acted as a learning companion, helping me move from unfamiliar concepts to a working implementation that follows project guidelines and industry best practices.

## Project Architecture

**Key Design Decisions:**

1. **Base Image Selection**: Alpine Linux 3.22.2 was chosen as the base image for all containers due to its minimal footprint (approximately 5MB) and reduced attack surface. This choice prioritizes security and efficiency over convenience.

2. **Custom Dockerfiles**: Each service has its own Dockerfile built from scratch rather than using pre-built images from DockerHub. This approach provides:
   - Complete control over the container environment
   - Better understanding of dependencies and security
   - Optimization for specific use cases

3. **Multi-stage Builds**: The NGINX and Wordpress Dockerfiles use a multi-stage build, reducing the final image size and improving security by not including build tools in the runtime image.

4. **Service Isolation**: Each service runs in its own container with dedicated resources, following the single-responsibility principle. This ensures that failures in one service don't directly affect others. And it again improves security by reducing the potential data leakage surface.

### Virtual Machines vs Docker

| Aspect | Virtual Machines | Docker Containers |
|--------|------------------|-------------------|
| **Architecture** | Full OS with kernel for each VM | Shared host kernel, isolated user space |
| **Resource Usage** | Heavy (GB of RAM, significant CPU) | Lightweight (MB of RAM, minimal CPU overhead) |
| **Startup Time** | Minutes | Seconds |
| **Isolation** | Complete hardware-level isolation | Process-level isolation |
| **Use Case** | Complete OS simulation, strong isolation needs | Application deployment, microservices |

### Secrets vs Environment Variables

| Aspect | Docker Secrets | Environment Variables |
|--------|---------------------------|----------------------|
| **Security** | Stored as encrypted data | Stored in plain text |
| **Visibility** | Hidden from logs and inspect commands | Visible in `docker inspect` and logs |
| **Management** | Requires orchestration platform (Docker Swarm) | Built right into Docker Engine |
| **Best For** | Production sensitive data | Development, non-sensitive configuration |

### Docker Network vs Host Network

| Aspect | Docker Network (Bridge) | Host Network |
|--------|------------------------|--------------|
| **Isolation** | Services isolated in virtual network | Services share host network stack |
| **Port Mapping** | Explicit port mapping required | Direct access to host ports |
| **Security** | Better isolation, controlled exposure | Full exposure to host network |
| **Performance** | Minor overhead from NAT | Native network performance |
| **DNS** | Internal DNS for service discovery | Must use host DNS or IPs |
| **Use Case** | Multi-container applications | High-performance network I/O |

### Docker Volumes vs Bind Mounts

| Aspect | Docker Volumes | Bind Mounts |
|--------|----------------|-------------|
| **Management** | Managed by Docker | Managed by host filesystem |
| **Location** | Docker internal directory | Any host path |
| **Portability** | Portable across hosts | Path-dependent |
| **Performance** | Optimized by Docker | Direct filesystem access |
| **Backup** | Docker-aware backup tools | Standard filesystem backups |
| **Permissions** | Docker manages ownership | Host filesystem permissions |