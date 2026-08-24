# OMP config

Версионируемая часть конфигурации oh-my-pi 18.0.4 для Qwen3.6:27b через AIS.
Provider использует Anthropic Messages.

В репозитории намеренно нет `.env`, ключей, SQLite-баз, сессий, кэша и runtime-
дампов. `models.yml` содержит только имя переменной `AIS_API_KEY`.

## Установка конфигурации

Из корня репозитория:

```bash
mkdir -p ~/.omp/agent ~/.local/bin
install -m 600 config.yml ~/.omp/agent/config.yml
install -m 600 models.yml ~/.omp/agent/models.yml
install -m 755 bin/playwright-cli ~/.local/bin/playwright-cli
```

Команды устанавливают конфигурацию OMP и WSL-wrapper для глобального Windows
`@playwright/cli`. Существующий `~/.omp/agent/.env` они не изменяют. Перед
заменой уже настроенных `config.yml` и `models.yml` при необходимости сделайте
их резервную копию.

Ключ задаётся только локально:

```bash
printf 'AIS_API_KEY=<key>\n' >> ~/.omp/agent/.env
chmod 600 ~/.omp/agent/.env
```

Локальные модели, используемые конфигурацией:

```bash
omp tiny-models download lfm2-350m
omp tiny-models download lfm2-1.2b
```

После обновления файлов нужно полностью перезапустить OMP и начать свежую
сессию. Для проверки non-thinking режима в новом request dump ожидается
`Thinking Level: off`, а provider должен быть `ais/qwen3.6:27b`.

## Multi-agent workflow

Основной агент может запускать до пяти фоновых sub-агентов. Дочерние агенты не
могут создавать следующий уровень, а общий лимит AIS составляет шесть
одновременных запросов с учётом родительского агента. Batch-схема пока выключена,
чтобы первый этап сохранил проверенный плоский формат `task` tool call.

После обновления проверьте версию и запустите отдельную свежую сессию:

```bash
omp --version
```

Ожидаемая версия для этого снимка конфигурации — `18.0.4`. Режим
`features.unexpectedStopDetection: smart` сохраняет классификацию текстовых
остановок через `lfm2-1.2b`, а `tui.resizeScrollback: preserve` предотвращает
очистку terminal scrollback при изменении размера окна.

## Установка Playwright CLI skill

Официальный generic skill устанавливается самим Playwright CLI. Поскольку
upstream помещает его в `.claude/skills`, сначала установите skill во временный
каталог, затем скопируйте его в нативный user-level каталог OMP:

```bash
skill_stage="$(mktemp -d)"
(
  cd "$skill_stage"
  playwright-cli install --skills
)
mkdir -p ~/.omp/agent/skills
cp -R "$skill_stage/.claude/skills/playwright-cli" ~/.omp/agent/skills/
rm -rf "$skill_stage"
```

Для обновления skill повторите команды, предварительно удалив или переименовав
существующий `~/.omp/agent/skills/playwright-cli`. После установки или
обновления полностью перезапустите OMP.

## Проверка Playwright CLI

На Windows должны быть установлены глобальный пакет `@playwright/cli` и
Playwright Extension. Chrome пользователь открывает вручную; OMP подключается к
нему только по необходимости.

Smoke test из WSL:

```bash
command -v playwright-cli
playwright-cli --version
playwright-cli -s=windows-chrome attach --extension=chrome
playwright-cli -s=windows-chrome snapshot
playwright-cli -s=windows-chrome detach
```

После smoke test перезапустите OMP и попросите его прочитать открытую
авторизованную страницу. В корректном прогоне OMP загружает skill, выполняет
реальные Bash-вызовы `playwright-cli`, проверяет результат snapshot и затем
отсоединяется, не закрывая Chrome.
