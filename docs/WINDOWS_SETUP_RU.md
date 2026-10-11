# Фактическое состояние среды, 11 октября 2026 года

Студент: Eldar Sarsembayev, IT2-2301, Student ID 37006.

## Выполнено и проверено

- Windows 11 Pro, Microsoft WSL 3.0.1.0, Ubuntu 24.04.5 LTS с systemd.
- Linux-пользователь eldar и каталог ~/devops/sarsembayev_eldar.
- Все команды Linux, персональный Bash-скрипт, права 600/644/755 и процессы.
- Компиляция приложения и все 11 тестов в Ubuntu: PASS.
- GitHub: https://github.com/37006/sarsembayev-eldar-devops ; main и development,
  содержательные коммиты и merge, реальный push и проверка через clone.
- Docker Engine 29.9.0 и Compose v5.6.0. Образ собран, контейнер и его данные
  проверены, logs/exec/stop/start/rm и Compose up/down выполнены успешно.
- Java 21, Jenkins 2.580.1 и необходимые Pipeline/Git плагины.
- Job Sarsembayev_Eldar_DevOps использует свой GitHub-репозиторий через
  публичный HTTPS URL без GitHub credentials; проверка TLS-сертификатов включена.
- Первая настоящая сборка Jenkins завершила все пять стадий с Finished: SUCCESS.
  Проверен Git commit b5fa1e0e28ab5626c80e8c1a9bb22d2fe8407489.
- Приложение Jenkins доступно на http://127.0.0.1:8082/ и содержит личные данные.

## Повторный запуск

После перезагрузки Windows выполни ./scripts/Start-Lab.ps1 из Windows-папки проекта.
Jenkins открывается на http://127.0.0.1:8080/; логин существующего администратора admin.
Его исходный пароль остаётся в защищённом файле /var/lib/jenkins/secrets/initialAdminPassword.
Пароль не опубликован в проекте и не включён в отчёт. Вход в Linux:
wsl -d Ubuntu-24.04 -u eldar. Административная настройка уже выполнена.
Ни Jenkins, ни контейнеры не открыты на внешнем интерфейсе Windows.

## Личное участие студента

Нужно записать одно непрерывное видео экрана и собственного голоса на 10-20 минут.
Сценарий готов в VIDEO_SCRIPT_RU.md. Студент также должен уметь повторить команды.
Репозиторий стал public по явному разрешению студента и доступен преподавателю.
Сдача: GitHub URL, PDF с реальными доказательствами и собственное видео.
