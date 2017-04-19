#!/bin/bash
set -euo pipefail
set -x

pip3 install homebrew-pypi-poet
python3 .travis/autobrew.py
cat ocrmypdf.rb
brew audit ocrmypdf.rb

# Extract deploy key for jbarlow83/homebrew-ocrmypdf
# Disable debug to avoid outputting key
echo "Decrypting .travis/homebrew-ocrmypdf.enc"
set +x
openssl aes-256-cbc -K $encrypted_e35043491734_key -iv $encrypted_e35043491734_iv \
    -in .travis/homebrew-ocrmypdf.enc -out homebrew-ocrmypdf_key -d
set -x

chmod 400 homebrew-ocrmypdf_key
ssh-add -K homebrew-ocrmypdf_key
export GIT_SSH_COMMAND="ssh -i homebrew-ocrmypdf_key -F /dev/null"

chmod a+rx .travis/ssh-askpass
export SSH_ASKPASS="$(pwd)/.travis/ssh-askpass"

git clone git@github.com:jbarlow83/homebrew-ocrmypdf.git homebrew

cd homebrew
cp ../ocrmypdf.rb Formula/ocrmypdf.rb
git add Formula/ocrmypdf.rb
git commit -m "homebrew-ocrmypdf: automatic release $TRAVIS_BUILD_NUMBER $TRAVIS_TAG"
git push -v origin master