#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "first parameter \`version\` is required!"
  echo "look at https://releases.hashicorp.com/terraform to find the version you want."
  echo "exiting script..."
  exit 1
fi

VERSION=$1

mkdir -p ~/.local/bin/tf-update

wget -O ~/.local/bin/tf-update/tf_$VERSION.zip "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_darwin_arm64.zip" 

cd ~/.local/bin/tf-update
unzip tf_$VERSION.zip 

OLDVERSION=$(terraform -v | awk '{ print $2 }' | head -1)

cd ~/.local/bin
mv terraform terraform_${OLDVERSION:1}
mv tf-update/terraform .

echo "updated $(pwd)/terraform to version $VERSION"
