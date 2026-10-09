# iCSI-Web-CTF

This repository stands up the entire **iCSI-Web-CTF** environment: the CTFd
scoring platform (with all challenges, flags, theme, pages, and the admin
account already baked into the images) plus every individual web-challenge
container.

> ⚠️ **Heads up:** this environment runs **about 50 containers** in total.

The services are split across **three Compose files** that are started **in
order**. This keeps the number of images pulled in any single step well under
Docker Hub's **unauthenticated pull rate limit** (pulling all ~50 at once will
trip the limit).

## Requirements

- A **Kali Linux** machine (challenges and the hosts-file instructions assume Kali).
- At least **8 GB of RAM**.
- Internet access on first run (all images are pulled from Docker Hub).

## 1. Install Docker

```bash
sudo apt update
sudo apt install docker.io docker-compose
```

## 2. Start the environment

The easiest way is the included `start_env.sh` script, which starts all three
Compose files **in order**, waiting for each to finish (and for CTFd to come up)
before starting the next. From the folder that contains the files, run:

```bash
chmod 777 start_env.sh
```

```bash
./start_env.sh
```

- **Part 1** brings up the CTFd platform (database + web app) and the pivot
  challenge; **parts 2 and 3** bring up the remaining challenges.

### Manual alternative

If you prefer to run the parts yourself, start them **one at a time, in this
order**, letting each finish before the next:

```bash
docker-compose -p ctf1 -f docker-compose.part1.yml up -d
docker-compose -p ctf2 -f docker-compose.part2.yml up -d
docker-compose -p ctf3 -f docker-compose.part3.yml up -d
```

> **If you hit a pull rate-limit error** (`toomanyrequests` / "pull rate limit"),
> either wait a little while before running the next part, **or** run
> `docker login` with a free Docker Hub account (which raises the limit) and then
> continue with the next file.

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

Bring the parts down the same way they were started:

```bash
docker-compose -p ctf1 -f docker-compose.part1.yml down
docker-compose -p ctf2 -f docker-compose.part2.yml down
docker-compose -p ctf3 -f docker-compose.part3.yml down
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
