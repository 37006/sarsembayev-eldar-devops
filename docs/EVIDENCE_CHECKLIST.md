# Настоящие доказательства и итоговая сдача

## Скриншоты для финального PDF

1. Linux: pwd, ls, пять папок и персональный файл.
2. Linux: find application.log, grep ERROR/WARNING, счётчик, последние пять строк.
3. Linux: chmod и ls -l с 600/644, Bash-скрипт с реальной системой.
4. Linux: ps aux или top с PID, USER, CPU и памятью.
5. Git: git log --graph --oneline --all, минимум пять осмысленных коммитов,
   development и merge. git check-ignore для журнала, backup и .env.
6. GitHub: настоящий URL, имя репозитория, файлы и история коммитов.
7. Docker: Dockerfile, docker images, docker ps, приложение с личными данными.
8. Docker: переменные окружения, docker logs, stop/start/rm, Compose ps.
9. Jenkins: Dashboard, точное имя job и настройки SCM с GitHub URL.
10. Jenkins: пять успешных стадий, Console Output с Student ID и Git SHA,
    настоящая строка Finished: SUCCESS; image/container после запуска.

Сохраняй скриншоты в reports/evidence/ с понятными именами. Эта папка не
публикуется в GitHub по умолчанию. Скриншот должен показывать реальное состояние,
а не нарисованный терминал или заранее написанный вывод.

## Контроль перед сдачей

- [x] Проект находится в ~/devops/sarsembayev_eldar.
- [x] Все команды Linux выполнены, права и процессы объяснены.
- [x] В Git есть реальные коммиты, development и merge.
- [ ] Собственный GitHub-репозиторий доступен преподавателю.
- [x] Docker image/container реально созданы, окружение и Compose проверены.
- [x] Jenkins использует GitHub и завершил все пять стадий успешно.
- [ ] PDF содержит титульный лист, данные, разделы и реальные скриншоты.
- [ ] Записано непрерывное видео экрана с собственным голосом.
- [ ] Сданы три элемента: GitHub URL, итоговый PDF и видео.

## Быстрые ответы на индивидуальные вопросы

1. Новая ветка: git switch -c feature-demo.
2. Поиск файла: find . -type f -name 'application.log'.
3. Ошибки: grep 'ERROR' logs/application.log.
4. chmod 755: owner rwx, group r-x, others r-x.
5. pull получает изменения из remote и интегрирует их; push отправляет свои
   локальные коммиты в remote. Для pull интеграция зависит от merge/rebase настроек.
6. Image - шаблон; container - экземпляр образа с состоянием и процессами.
7. Логи: docker logs sarsembayev-eldar-container.
8. WORKDIR задаёт рабочий каталог для последующих команд и запуска контейнера.
9. .gitignore исключает неотслеживаемые временные/локальные файлы из Git.
10. Test выполняет 11 тестов и останавливает pipeline при неуспехе.
11. Если Docker Build падает, Docker Run пропускается, сборка завершается FAILURE.
12. Изменение env без изменения образа:
    STUDENT_GROUP=DEMO HOST_PORT=8083 bash scripts/run_container.sh.
    Затем восстановление: bash scripts/run_container.sh.

