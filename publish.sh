#!/bin/sh
# Публикация сайта в ../apmath-spbu.github.io зеркально текущей сборке:
# конспекты с publishDate в будущем не собираются и УДАЛЯЮТСЯ из выкладки,
# уже открытые — обновляются. Запускать в день занятия или позже.
# После скрипта: cd ../apmath-spbu.github.io && git pull && git add -A && git commit -m publish && git push
# ВНИМАНИЕ: с 10.10.2026 сайт публикуется сам (Actions в репо выкладки, 07:00 МСК),
# поэтому перед ручной публикацией делайте git pull — иначе разъедетесь с ботом.
set -e
cd "$(dirname "$0")"
DEST=../apmath-spbu.github.io
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
hugo -d "$TMP" --quiet
rsync -a --delete \
  --exclude='.git' --exclude='.github' --exclude='.gitignore' --exclude='.DS_Store' \
  "$TMP"/ "$DEST"/
echo "Готово: $DEST обновлён зеркально сборке."
