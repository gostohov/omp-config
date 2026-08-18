# OMP config

Версионируемая часть конфигурации oh-my-pi 17.3.4 для Qwen3.6:27b через
OpenAI-compatible AIS endpoint.

В репозитории намеренно нет `.env`, ключей, SQLite-баз, сессий, кэша и runtime-
дампов. `models.yml` содержит только имя переменной `AIS_API_KEY`.

## Установка

```bash
mkdir -p ~/.omp/agent
cp config.yml ~/.omp/agent/config.yml
cp models.yml ~/.omp/agent/models.yml
```

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
`Thinking Level: off`.
