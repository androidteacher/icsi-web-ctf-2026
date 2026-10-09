# iCSI-Web-CTF

This repository contains a single `docker-compose.yml` that stands up the entire
**iCSI-Web-CTF** environment: the CTFd scoring platform (with all challenges,
flags, theme, pages, and the admin account already baked into the images) plus
every individual web-challenge container.

> ⚠️ **Heads up:** this compose file starts **about 50 containers**. Plan your
> host accordingly.

## Requirements

- A **Kali Linux** machine (the challenges and hosts-file instructions assume Kali).
- At least **8 GB of RAM**.
- Internet access on first run (all images are pulled from Docker Hub).

## 1. Install Docker

```bash
sudo apt update
sudo apt install docker.io docker-compose
```

## 2. Start the environment

Once the `docker-compose.yml` file has been downloaded, from the folder that
contains it, run:

```bash
docker-compose up -d
```

The first launch will take a few minutes while ~50 images are pulled and the
CTFd database initializes. You can watch progress with `docker-compose ps`.

## 3. Access the CTF

The CTF platform will start on:

```
http://IP_OF_KALI:8000
```

(replace `IP_OF_KALI` with the IP address of the machine running Docker).

The admin credentials for the web interface are:

- **username:** `admin`
- **password:** `admin`

## Stopping

```bash
docker-compose down
```

---

### Notes

- Participants map the server in their `/etc/hosts` file so that the CTF IP
  address points to `sem2ctf.icsi.cyber` — the front page of CTFd explains this
  with examples.
- The CTFd front page includes an **instructor-only link to answer keys and
  walkthroughs**. It is visible to everyone who can load the page. If you do
  **not** want participants to see walkthroughs, remove that note from the front
  page (Admin → Pages → index) before the event.
