#!/bin/sh
# Публикация сайта в ../apmath-spbu.github.io зеркально текущей сборке:
# конспекты с publishDate в будущем не собираются и УДАЛЯЮТСЯ из выкладки,
# уже открытые — обновляются. Запускать в день занятия или позже.
# После скрипта: cd ../apmath-spbu.github.io && git add -A && git commit -m publish && git push
set -e
cd "$(dirname "$0")"
DEST=../apmath-spbu.github.io
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
hugo -d "$TMP" --quiet
rsync -a --delete \
  --exclude='.git' --exclude='.gitignore' --exclude='.DS_Store' \
  "$TMP"/ "$DEST"/
echo "Готово: $DEST обновлён зеркально сборке."
