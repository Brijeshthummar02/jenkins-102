# Jenkins BlueOcean Setup with Docker

This guide provides steps to set up Jenkins BlueOcean using Docker, with minimal and straightforward instructions.

---

## Prerequisites

- Docker installed on your system.
- Basic understanding of Docker commands.

---

## Steps

### 1. Build or Pull the Jenkins BlueOcean Docker Image

**Option A: Build the image locally**

```bash
docker build -t myjenkins-blueocean:2.414.2 .
```

**Option B: Pull a pre-built image**

```bash
docker pull devopsjourney1/jenkins-blueocean:2.332.3-1
docker tag devopsjourney1/jenkins-blueocean:2.332.3-1 myjenkins-blueocean:2.332.3-1
```

---

### 2. Create a Docker Network for Jenkins

```bash
docker network create jenkins
```

---

### 3. Run the Jenkins Container

#### For MacOS/Linux

```bash
docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.414.2
```

#### For Windows

```powershell
docker run --name jenkins-blueocean --restart=on-failure --detach `
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 `
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 `
  --publish 8080:8080 --publish 50000:50000 `
  --volume jenkins-data:/var/jenkins_home `
  --volume jenkins-docker-certs:/certs/client:ro `
  myjenkins-blueocean:2.414.2
```

---

### 4. Retrieve the Initial Admin Password

```bash
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```

---

### 5. Access Jenkins

Open your browser and navigate to: `http://localhost:8080`  
Use the retrieved admin password to unlock Jenkins.

---

### 6. Optional: Forward Traffic from Jenkins to Docker Desktop

Run an Alpine/socat container to forward traffic to Docker Desktop:

```bash
docker run -d --restart=always -p 127.0.0.1:2376:2375 --network jenkins \
  -v /var/run/docker.sock:/var/run/docker.sock alpine/socat \
  tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
```

Verify the container IP:

```bash
docker inspect <container_id> | grep IPAddress
```

---

### 7. Use Pre-Built Python Agent

Pull and use the pre-built Python agent for Jenkins:

```bash
docker pull devopsjourney1/myjenkinsagents:python
```

---

## References

- [Jenkins Official Documentation](https://www.jenkins.io/doc/book/installing/docker/)
- [StackOverflow Discussion on Docker Host URI](https://stackoverflow.com/questions/47709208/how-to-find-docker-host-uri-to-be-used-in-jenkins-docker-plugin)
