# Полное решение лабораторной работы 1

DevOps Fundamentals: Linux, Git, Docker and Jenkins.
Eldar Sarsembayev, IT2-2301, Student ID 37006.

## Что уже подготовлено и что нужно выполнить

Готовы персональное приложение, конфигурация, Bash-скрипты, Dockerfile,
docker-compose.yml, Jenkinsfile, тесты и локальная история Git.
Приложение и 11 тестов проверены на Windows. Для окончания лабораторной нужны
реальный запуск на твоей Linux-системе, собственный GitHub-репозиторий, успешная
сборка Jenkins и непрерывное видео с твоим голосом. Успех внешних запусков нельзя
подменять подготовленным кодом или примером вывода.

## Подготовка Linux

Перенеси ZIP на Linux и распакуй в домашний каталог `devops`. Внутри архива
корневая папка называется `sarsembayev_eldar`, включая скрытую папку `.git`.
Если архив находится в Downloads, используй его фактическое имя:

```bash
mkdir -p ~/devops
unzip ~/Downloads/Sarsembayev_Eldar_DevOps_Package.zip -d ~/devops
cd ~/devops/sarsembayev_eldar
bash scripts/setup_linux.sh
```

Скрипт создаёт `logs/`, `backup/`, `reports/evidence/`, пример журнала из 10 строк,
локальный `.env`, выставляет права и проверяет инструменты. Если `unzip` отсутствует,
можно распаковать архив графически. Повторный запуск не перезаписывает `.env`
и существующий журнал. Нужны Git, Python 3.10+, Docker и Compose.

## Задание 1. Каталоги и файлы

```bash
cd ~/devops/sarsembayev_eldar
pwd
ls -la
cd app
pwd
cd ..
mkdir -p backup/demo
touch backup/demo/empty.txt
cp Sarsembayev_Eldar_info.txt backup/demo/info-copy.txt
mv backup/demo/info-copy.txt backup/demo/info-renamed.txt
cat Sarsembayev_Eldar_info.txt
head -n 5 logs/application.log
tail -n 5 logs/application.log
rm backup/demo/empty.txt
```

`pwd` показывает текущий каталог; `ls` перечисляет содержимое; `cd` меняет каталог;
`mkdir` создаёт каталоги; `touch` создаёт пустой файл или обновляет его время;
`cp` копирует; `mv` переносит или переименовывает; `rm` удаляет указанный файл;
`cat` выводит содержимое; `head` показывает начало; `tail` показывает конец.
Удаляется только специально созданный демонстрационный файл.

Обязательные папки: `app`, `scripts`, `config`, `logs`, `backup`.
Файл `Sarsembayev_Eldar_info.txt` содержит Name: Eldar, Surname: Sarsembayev,
Group: IT2-2301, Student ID: 37006, Course: DevOps.

## Задание 2. Поиск и журнал

```bash
find . -type f -name 'application.log'
grep 'ERROR' logs/application.log
grep 'WARNING' logs/application.log
grep -c 'ERROR' logs/application.log
tail -n 5 logs/application.log
```

`find` ищет файл по имени и типу; `grep` отбирает строки с заданным текстом;
`grep -c` считает подходящие строки. В подготовленном учебном журнале 10 строк,
2 строки ERROR и 2 строки WARNING. Последние пять строк:

```text
INFO Application restarted
WARNING Memory usage is high
INFO Request received
ERROR Request failed
INFO Application stopped
```

Если журнал изменён, счётчик отражает его фактическое содержимое.

## Задание 3. Права доступа

```bash
chmod 600 private.txt
chmod 644 public.txt
ls -l private.txt public.txt
chmod 755 scripts/Sarsembayev_Eldar_system.sh
```

`600` означает `rw-------`: владелец читает и записывает, группа и остальные
не имеют прав. `644` означает `rw-r--r--`: владелец читает и записывает,
группа и остальные читают. `755` означает `rwxr-xr-x`: владелец имеет все права,
группа и остальные читают и выполняют. В числовой записи r=4, w=2, x=1.
Три цифры относятся к owner, group и others. Для обычного файла x позволяет
выполнение; для каталога x позволяет проход и доступ к его содержимому.
Различие файлов демонстрирует ограничение личных данных и общий доступ к
информации для чтения. В private.txt нет настоящих секретов.

## Задание 4. Bash-скрипт

```bash
chmod +x scripts/Sarsembayev_Eldar_system.sh
./scripts/Sarsembayev_Eldar_system.sh
```

Скрипт выводит сведения студента, `whoami`, `hostname`, дату, `uname -a`,
`/etc/os-release`, `df -h` и `free -h`. Проверяет персональный файл относительно
расположения скрипта, поэтому не зависит от текущего каталога.
Выводит точно `Student information file exists.` или
`Student information file does not exist.`. Настоящие имя машины, дата и объёмы
памяти определяются при запуске, они не записаны заранее.

## Задание 5. Процессы

```bash
ps
ps aux
ps -p $$ -o pid,user,pcpu,pmem,comm
top
```

В `top` нажми q для выхода. Процесс - запущенная программа с собственным
состоянием и ресурсами; PID - его числовой идентификатор. USER - владелец;
%CPU - использование процессора; %MEM - доля физической памяти. `ps` показывает
снимок процессов, `top` регулярно обновляет данные. `$$` - PID текущего Bash.
Для конкретного PID можно использовать `ps -p PID -o pid,user,pcpu,pmem,comm`.

Все команды заданий 1-5 также демонстрирует `bash scripts/linux_demo.sh`;
реальный протокол записывается в `logs/linux-demo.log`.

## Задание 6. Git и идентификация

Репозиторий в архиве уже инициализирован, его `.git` нужно сохранить.
Повторный `git init -b main` не создаёт заново существующую историю.

```bash
git init -b main
git config --global --get user.name || true
git config --global --get user.email || true
git config --local user.name 'Eldar Sarsembayev'
git config --local --get user.email
git status
```

Глобальные настройки только проверяются, не заменяются. В подготовленной
офлайн-истории указан локальный учебный адрес `37006@devops.local`; это не
GitHub-аккаунт и не настоящий почтовый ящик. После регистрации GitHub укажи
для новых коммитов свою подтверждённую почту либо настоящий noreply-адрес
из GitHub Settings → Emails. Git identity - автор коммита, она сама по себе
не предоставляет доступ к GitHub.

```bash
read -r -p 'Git author email from your GitHub settings: ' git_email
git config --local user.email "$git_email"
git config --local --list
```

## Задание 7. Содержательные коммиты

Подготовленная история разделяет реальные изменения: структура и ignore,
сведения студента, Linux-скрипты, приложение с тестами, Docker, Jenkins,
инструкции и документация API в development. Пустые коммиты не используются.

```bash
git log
git log --oneline
git rev-list --count HEAD
git show --stat HEAD
```

Для самостоятельной правки обычная последовательность: изменить конкретный
файл, проверить `git diff`, добавить его через `git add`, выполнить
`git commit -m 'Describe the actual change'`. Не пересоздавай историю пятью
пустыми коммитами и не загружай файлы по одному через интерфейс GitHub.

## Задание 8. gitignore

```bash
cat .gitignore
git check-ignore -v logs/application.log backup/demo/info-renamed.txt .env
git status --short --ignored
git ls-files '*.log' .env 'backup/*'
```

Обязательные правила `*.log`, `backup/`, `.env` включены. `git check-ignore`
показывает правило, которое исключает каждый файл. Последняя команда не должна
вывести отслеживаемые журналы, .env или backup. Ignore предотвращает попадание
временных файлов и локальной конфигурации в репозиторий. Он не удаляет файл,
который уже был отслеживаемым, и не заменяет управление секретами.

## Задание 9. Ветка и merge

В проекте уже есть ветка development с содержательной документацией API и
merge-коммит в main. Покажи фактическую историю:

```bash
git branch
git log --oneline --graph --all
git show development:docs/API.md
```

Если нужно заново продемонстрировать действия преподавателю, создай новую
содержательную правку в существующей development:

```bash
git switch development
printf '\nVideo verified by Eldar Sarsembayev, IT2-2301.\n' >> docs/API.md
git add docs/API.md
git commit -m 'Document personal video verification'
git switch main
git merge --no-ff development -m 'Merge personal verification note'
git log --oneline --graph --all
```

Эту запись добавляй только после своей проверки. Для создания новой ветки
команды `git branch feature-demo` и `git switch feature-demo`, либо
`git switch -c feature-demo`. Ветки отделяют изменения, merge объединяет
истории. `--no-ff` сохраняет видимый отдельный merge-коммит.

## Задание 10. Собственный GitHub

Зарегистрируй личный аккаунт на GitHub и подтверди почту. Создай пустой
репозиторий `sarsembayev-eldar-devops`, без автоматически созданных README,
.gitignore и лицензии. Выбери доступ преподавателю: public или private с
приглашением преподавателя. Student ID находится в исходных файлах.

```bash
bash scripts/publish_github.sh
git remote -v
git branch -vv
```

Скрипт запросит настоящий логин, добавит origin и выполнит
`git push -u origin main`, затем push ветки development. Он не создаёт аккаунт
или репозиторий. HTTPS-аутентификация использует credential manager,
GitHub CLI/browser login или токен с нужным доступом; обычный пароль аккаунта
для git push не подходит. Никогда не помещай токен в URL или репозиторий.
Для private-репозитория Jenkins нужны отдельные настроенные credentials.
На странице GitHub проверь все файлы и историю коммитов.

## Задание 11. Dockerfile

Готовый Dockerfile находится в корне проекта. `FROM` выбирает образ Python;
`WORKDIR /app` устанавливает рабочий каталог; `COPY` переносит приложение
и конфигурацию; `RUN` проверяет компиляцию и создаёт непривилегированного
пользователя; `EXPOSE 8080` описывает порт приложения; `CMD` запускает HTTP-сервер.
`EXPOSE` сам по себе не публикует порт на хосте - это делает `-p`.
Дополнительно указаны ENV, USER, LABEL и HEALTHCHECK.

Приложение показывает Eldar, Sarsembayev, IT2-2301, 37006 и точную фразу
`Application is running successfully!`. Значения окружения имеют приоритет
над `config/app.conf`. В `/api/student` доступны те же данные в JSON;
`/health` возвращает `{"status": "ok"}`.

## Задания 12 и 13. Сборка, запуск и окружение

```bash
docker build -t sarsembayev-eldar-devops:latest .
docker images sarsembayev-eldar-devops
docker run -d \
  --name sarsembayev-eldar-container \
  --label lab.owner=sarsembayev-eldar-devops \
  -p 127.0.0.1:8081:8080 \
  -e STUDENT_NAME=Eldar \
  -e STUDENT_SURNAME=Sarsembayev \
  -e STUDENT_GROUP=IT2-2301 \
  -e STUDENT_ID=37006 \
  sarsembayev-eldar-devops:latest
docker ps
docker ps -a
bash scripts/verify_container.sh
```

Эта команда предназначена для отсутствующего контейнера с указанным именем.
Для повторного запуска используй `bash scripts/run_container.sh`: он заменяет
только контейнер с этим именем и меткой данного проекта. Переменная окружения -
пара имя/значение, доступная процессу. Она позволяет менять конфигурацию при
запуске без пересборки образа. Секрет в Dockerfile или COPY останется в образе
или слоях; env удобен для лабораторных данных, но настоящие секреты лучше
передавать средствами secrets/credentials.

Открой `http://127.0.0.1:8081/` на машине Docker. Порт 8080 внутри контейнера
сопоставлен порту 8081 хоста; Jenkins использует 8082.

## Задание 14. Управление контейнером

```bash
docker logs sarsembayev-eldar-container
docker exec sarsembayev-eldar-container id
docker exec sarsembayev-eldar-container \
  printenv STUDENT_NAME STUDENT_SURNAME STUDENT_GROUP STUDENT_ID
docker stop sarsembayev-eldar-container
docker ps -a
docker start sarsembayev-eldar-container
bash scripts/verify_container.sh
docker stop sarsembayev-eldar-container
docker rm sarsembayev-eldar-container
```

Image - шаблон файловой системы и настроек запуска; container - созданный
из image экземпляр со своим состоянием и процессами. Контейнер может быть
остановлен. `logs` читает stdout/stderr; `exec` запускает команду в работающем
контейнере; `stop` останавливает; `start` запускает существующий; `rm` удаляет
контейнер, но не образ. Данные в writable layer сохраняются после stop и
теряются после удаления контейнера; для независимого хранения нужны volumes.

## Задание 15. Docker Compose

Сначала останови/удали обычный контейнер, использующий 8081, как в задании 14.

```bash
docker compose config
docker compose up -d --build
docker compose ps
bash scripts/verify_container.sh sarsembayev-eldar-compose
docker compose logs --no-color
docker compose down
bash scripts/run_container.sh
```

Compose хранит описание сервиса, сборки, портов и окружения в YAML. Это делает
запуск воспроизводимым и позволяет управлять несколькими сервисами одной
командой. Здесь один обязательный сервис app; искусственная база данных не
добавлена. `up` создаёт/запускает, `down` останавливает и удаляет контейнеры
и сеть Compose. По умолчанию `down` не удаляет именованные volumes.
Полную последовательность заданий 11-15 выполняет `bash scripts/docker_demo.sh`.

## Задание 16. Jenkins job

Открой свою действующую Jenkins-систему. Создай New Item → имя
`Sarsembayev_Eldar_DevOps` → тип Pipeline. Убедись, что доступны плагины Pipeline
и Git. Docker Pipeline не обязателен: в этом проекте используется Docker CLI.
Нужен Linux-агент с Bash, Git, Python 3 и Docker CLI с доступом к daemon.
Если есть разные агенты, замени `agent any` на label настоящего Linux-агента.

Если Jenkins установлен службой на Linux, проверь от его пользователя:

```bash
sudo -u jenkins python3 --version
sudo -u jenkins git --version
sudo -u jenkins docker info
```

Если Docker отвечает permission denied, администратор может добавить
пользователя службы Jenkins в docker group и перезапустить службу. Членство
в docker group даёт широкие права на хосте; это настройка доверенного учебного
агента. Не исправляй это через `chmod 777 /var/run/docker.sock`.
Для Jenkins в контейнере проверка и настройка выполняются внутри его агента:
наличие Docker на хосте само по себе не гарантирует CLI и доступ внутри Jenkins.

## Задания 17 и 18. Pipeline из GitHub

В настройках job: Pipeline → Definition = Pipeline script from SCM;
SCM = Git; Repository URL = настоящий URL созданного репозитория;
Credentials = твои credentials при private-доступе; Branch Specifier = `*/main`;
Script Path = `Jenkinsfile`. Сохрани именно настройки этого Jenkins job.

`checkout scm` получает код из настроенного GitHub-репозитория. Jenkinsfile
исполняет пять стадий: Checkout, Build, Test, Docker Build, Docker Run.
Build компилирует Python-модули и обнаруживает синтаксические ошибки; Test
выполняет 11 проверок; Docker Build строит image с тегами latest и build-N;
Docker Run запускает персональный контейнер и проверяет health и JSON.
Для Python-приложения не требуется фиктивный npm/Maven build.

## Задание 19. Jenkins environment

Jenkinsfile содержит STUDENT_NAME=Eldar, STUDENT_SURNAME=Sarsembayev,
STUDENT_GROUP=IT2-2301, STUDENT_ID=37006. Console Output показывает имя,
фамилию, группу и ID в Checkout. Docker получает те же значения через `-e`.
Они доступны всем стадиям благодаря environment верхнего уровня.
GitHub-токен не должен выводиться в консоль или храниться в этом блоке.

## Задание 20. Настоящий успешный запуск

Нажми Build Now в Jenkins и дождись завершения. Проверь каждую стадию,
Console Output, фактическое `Finished: SUCCESS`, Git SHA, image и container.
Строка успеха в инструкции не является доказательством выполненной сборки.
Открой `http://127.0.0.1:8082/` на Docker-хосте. Контейнер после успеха остаётся
работать для демонстрации. `disableConcurrentBuilds` предотвращает конфликт
запусков одного job; образ build-N связывает сборку с конкретным номером.

Если стадия падает, последующие обычные стадии пропускаются, а post failure
сообщает об ошибке и пытается показать логи. Исправь причину, закоммить и push,
затем повтори Build Now. Не переписывай неудачный вывод как SUCCESS.

## Задание 21. Полный DevOps workflow

Linux предоставляет окружение команд и процессов. Git фиксирует версии
проекта, а GitHub хранит удалённый репозиторий для доступа и совместной работы.
Jenkins получает конкретный commit из GitHub, выполняет Build и Test, затем
создаёт Docker image из того же кода. Docker запускает container из image,
а проверка health и данных подтверждает работоспособность. Только после
успешного завершения всех стадий сборка считается успешной.

Jenkins нужен GitHub как доступный источник версии проекта. Сам по себе
Jenkins может работать и с другими Git-серверами, но эта лабораторная требует
личный GitHub-репозиторий. Docker image делает окружение воспроизводимым;
container обеспечивает фактический запуск приложения. При старте Pipeline
выделяется агент, выполняется checkout выбранной ветки, затем стадии по порядку.

## Типовые проблемы

- Порт уже занят: проверь `docker ps` и настройки Jenkins. Для ручного запуска
  используй `HOST_PORT=8083 bash scripts/run_container.sh`; для Compose задавай
  HOST_PORT в `.env`; для Jenkins меняй HOST_PORT в Jenkinsfile и push.
- `python3: command not found`: Python должен быть установлен на Linux-агенте,
  а не только внутри создаваемого Docker image.
- `docker: permission denied`: проверь доступ пользователя агента к daemon.
- Checkout fails: проверь URL, ветку main и credentials private-репозитория.
- Compose port conflict: останови обычный контейнер, который использует 8081.
- `bad interpreter`: файлы .sh должны иметь LF; .gitattributes уже задаёт LF.
- `git push` rejected из-за созданного GitHub README: используй изначально пустой
  новый репозиторий. Не применяй force push без анализа существующей истории.

## Сбор доказательств и сдача

После реальных запусков выполни `bash scripts/collect_evidence.sh` и сохрани
скриншоты по `docs/EVIDENCE_CHECKLIST.md`. Запиши непрерывное видео 10-20 минут
по `docs/VIDEO_SCRIPT_RU.md`. Сдай настоящий URL GitHub, PDF со скриншотами
реальных запусков и своё видео. Подготовленный PDF описывает решение и текущую
проверку; финальные Linux/GitHub/Jenkins скриншоты нужно добавить после запуска.

