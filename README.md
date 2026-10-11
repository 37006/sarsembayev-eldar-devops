# Eldar Sarsembayev - DevOps laboratory work 1

**Name:** Eldar | **Surname:** Sarsembayev | **Group:** IT2-2301 | **Student ID:** 37006

Personal teaching project: Linux → Git → GitHub → Jenkins → Docker.
The application uses Python's standard library and needs no pip dependencies.

## Names required by the assignment

| Item | Name |
| --- | --- |
| Linux working directory | `~/devops/sarsembayev_eldar/` |
| Student file | `Sarsembayev_Eldar_info.txt` |
| Bash script | `scripts/Sarsembayev_Eldar_system.sh` |
| GitHub repository | `sarsembayev-eldar-devops` |
| Docker image | `sarsembayev-eldar-devops` |
| Main container | `sarsembayev-eldar-container` |
| Compose demonstration container | `sarsembayev-eldar-compose` |
| Jenkins job | `Sarsembayev_Eldar_DevOps` |

## Windows 11 and Linux setup

The Windows WSL 3.0.1 component is installed. Virtual Machine Platform has been
enabled and Windows requires a restart before Linux can be started.
Ubuntu, Docker and Jenkins have not been installed or run yet.
After restarting Windows, continue the setup with Codex. The official Ubuntu
24.04 installer for Docker, Compose, Java and Jenkins is prepared in
`scripts/install_ubuntu_tools.sh`; it requires Linux with systemd.

## Start in Linux

Extract the ZIP so the project is in `~/devops/sarsembayev_eldar/`.
The ZIP includes `.git`, so the existing meaningful commit history is preserved.
The project folder in Windows is named like the GitHub repository; the Linux folder
inside the ZIP uses the assignment's underscore naming convention.

```bash
cd ~/devops/sarsembayev_eldar
bash scripts/setup_linux.sh
python3 -m unittest discover -s tests -v
bash scripts/linux_demo.sh
bash scripts/docker_demo.sh
```

Required tools: Bash, GNU/Linux utilities, Git, Python 3.10 or newer, Docker Engine,
and the Docker Compose plugin. Jenkins's agent also needs Git, Python 3 and access
to the Docker daemon. The app runs inside the official Python 3.12 image.

## Local application

```bash
python3 -m app.main
```

Open `http://127.0.0.1:8080/`. Stop with Ctrl+C.
The direct Docker and Compose demos use `http://127.0.0.1:8081/`.
Jenkins deploys on `http://127.0.0.1:8082/` to avoid its usual port 8080.
These addresses refer to the machine running the application or Docker daemon.
For a remote Linux host, use an SSH tunnel rather than changing the public binding.

## Tests

```bash
python3 -m compileall -q app tests
python3 -m unittest discover -s tests -v
```

11 tests cover default student data, complete and partial environment overrides,
missing configuration, HTML escaping, the required success message, homepage,
health, JSON data, HTTP environment overrides and 404 responses.

## GitHub and Jenkins

The GitHub account `37006` is connected and its private repository has been created:
https://github.com/37006/sarsembayev-eldar-devops
The complete project and its original Git history have been pushed to both `main`
and `development`. Instructor access must be configured before submission.
The setup status in `docs/WINDOWS_SETUP_RU.md` distinguishes preparation from
operations that have actually completed.

```bash
bash scripts/publish_github.sh
```

Create a **Pipeline** job `Sarsembayev_Eldar_DevOps`. Choose **Pipeline script from SCM**,
SCM **Git**, your real repository URL, branch `*/main`, Script Path `Jenkinsfile`.
For a private repository configure appropriate GitHub credentials in Jenkins.
Build Now must actually finish with `Finished: SUCCESS` before the lab is complete.

The pipeline stages are Checkout, Build, Test, Docker Build, Docker Run.
It prints student details and the exact Git commit, runs the 11 tests, builds a
versioned image and verifies the running container's health and student data.
It uses Docker CLI commands, so the Docker Pipeline plugin is not required.
Use a Linux Jenkins agent; `agent any` assumes the configured agents satisfy
these prerequisites. On a mixed agent installation restrict it to your Linux
agent's actual label before running.

## Complete instructions

- `docs/LAB_GUIDE_RU.md`: all 21 tasks, commands, explanations and troubleshooting.
- `docs/VIDEO_SCRIPT_RU.md`: continuous demonstration with your own voice.
- `docs/EVIDENCE_CHECKLIST.md`: real screenshots and submission checklist.
- `docs/API.md`: HTTP endpoints and environment variables.
- `verification/LOCAL_VERIFICATION.txt`: checks actually performed on Windows.

The prepared files do not themselves prove a Linux, Docker or Jenkins run.
Capture actual outputs on your Linux system. The sample `logs/application.log`
is intentionally generated for Task 2; it is not a historical execution log.

## Safe scope and privacy

Scripts only replace the specifically named container if its `lab.owner` label
belongs to this project. They do not prune unrelated images or containers.
`.env`, logs, backup, caches and evidence reports are ignored by Git.
The student ID is required by the assignment and appears in tracked files.
Review repository visibility before publishing.

The application is a local laboratory demonstration. Python's `http.server` is
not a production server. No secret or token should be committed or placed in the
Docker build context. Use a credential manager for GitHub authentication.

## Official references

- [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [Docker run](https://docs.docker.com/reference/cli/docker/container/run/)
- [Compose services](https://docs.docker.com/reference/compose-file/services/)
- [Jenkins Pipeline syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Git merge](https://git-scm.com/docs/git-merge)
- [Python HTTP server](https://docs.python.org/3.12/library/http.server.html)
- [Create a GitHub account](https://docs.github.com/en/account-and-profile/how-tos/account-management/creating-an-account-on-github)
