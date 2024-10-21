#!/bin/bash

set -eo pipefail

CUSTOM_DIR="$(cd $(dirname $0) && pwd)"

APP_PATH="/Applications/WorkFlowy.app"
RESOURCES_PATH="${APP_PATH}/Contents/Resources"
ASAR_PATH="${RESOURCES_PATH}/app.asar"
BACKUP_ASAR_PATH="${ASAR_PATH}.bak"
EXTRACTED_ASAR_PATH="${RESOURCES_PATH}/app"

INDEX_HTML_PATH="${EXTRACTED_ASAR_PATH}/index.html"
INDEX_HTML_BACKUP_PATH="${EXTRACTED_ASAR_PATH}/index.html.bak"
CUSTOM_JS_TAG="<script src='/custom.js'></script>"
CUSTOM_CSS_TAG="<link href='/custom.css' type='text/css' rel='stylesheet' />"

if [[ ! -e "${APP_PATH}" ]]; then
  echo "Workflowy.app is not installed"
  exit
fi

if ! command -v npx >/dev/null; then
  echo "npx command not found"
  exit 1
fi

if [[ ! -e "${EXTRACTED_ASAR_PATH}" ]]; then
  echo "Extracting asar..."
  npx asar extract "${ASAR_PATH}" "${EXTRACTED_ASAR_PATH}"
  mv "${ASAR_PATH}" "${BACKUP_ASAR_PATH}"
fi

echo "Linking custom files..."
ln -sf "${CUSTOM_DIR}"/custom.{css,js} "${EXTRACTED_ASAR_PATH}"

if [[ -e "${INDEX_HTML_BACKUP_PATH}" ]]; then
  mv "${INDEX_HTML_BACKUP_PATH}" "${INDEX_HTML_PATH}"
fi

echo "Injecting into index...."
sed -i .bak "s|</body>|\n  ${CUSTOM_JS_TAG}\n  ${CUSTOM_CSS_TAG}\n&|" "${INDEX_HTML_PATH}"

if grep -q '[W]orkFlowy.app' < <(ps -e); then
  echo "Restarting app..."
  osascript -e 'quit app "WorkFlowy"'
  sleep 3
  open -a /Applications/WorkFlowy.app
fi
