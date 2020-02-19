#!/usr/bin/env bash

cd "$(dirname "$0")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Getting the sources."

if [ ! -d src ]; then
  git clone https://github.com/lukbek/supla-core.git -q --single-branch --branch supla-pushover src >/dev/null || exit 1
fi

(cd src && git pull >/dev/null && cd ..) || exit 1

echo "Building. Be patient."

(cd src/supla-console-client/Release && make all >/dev/null 2>&1 && cd ../../..) || exit 1

if [ ! -f supla-pushover ]; then
  ln -s src/supla-console-client/Release/supla-pushover supla-pushover
fi

echo -e "${GREEN}OK!${NC}"
./supla-pushover -v

if [ ! -f supla-pushover-config.yaml ]; then
  cp supla-pushover-config.yaml.sample supla-pushover-config.yaml
  echo -e "${YELLOW}Sample configuration has been created for you (${NC}supla-pushover-config.yaml${YELLOW})${NC}"
  echo -e "${YELLOW}Adjust it to your needs before launching.${NC}"
fi
