#!/bin/sh
# Сквозные тесты авторизации: поднимает бэкенд из ../megaladon_back в Docker
# (docker-compose.e2e.yml, MySQL в tmpfs, порт 18080), гоняет test_e2e и
# убирает стенд. Рабочий стек megaladon не трогает.
set -e
cd "$(dirname "$0")/.."
BACK=../megaladon_back
COMPOSE="docker compose -p megaladon_e2e -f $BACK/docker-compose.e2e.yml"
trap '$COMPOSE down -v >/dev/null 2>&1' EXIT
$COMPOSE up -d --build --wait
flutter test test_e2e "$@"
