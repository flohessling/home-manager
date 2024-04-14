#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "first parameter \`version\` is required!"
  echo "look at https://github.com/gruntwork-io/terragrunt/releases to find the version you want."
  echo "exiting script..."
  exit 1
fi

VERSION=$1

mkdir -p ~/.local/bin/tg-update

wget -O ~/.local/bin/tg-update/tg_"$VERSION" "https://github.com/gruntwork-io/terragrunt/releases/download/${VERSION}/terragrunt_darwin_arm64"

cd ~/.local/bin/tg-update

OLDVERSION=$(terragrunt -v | awk '{ print $3 }')

cd ~/.local/bin
mv terragrunt terragrunt_"${OLDVERSION:1}"
mv tg-update/tg_"$VERSION" ~/.local/bin/terragrunt

chmod +x ~/.local/bin/terragrunt

echo "updated $(pwd)/terragrunt to version $VERSION"
