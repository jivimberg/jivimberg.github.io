#!/usr/bin/env bash

set -e

execute () {
  echo ""
  echo "########################################"
  echo "# $*"
  echo "########################################"
  "$@"
}
ssh_key=$1
git_user_email=$2
git_user_name=$3

execute bundle install
execute gem update rake
execute rake integrate

# Setup github pages
printf 'git@github.com:jivimberg/jivimberg.github.io.git' | rake setup_github_pages

execute rake generate --trace

execute mkdir -p ~/.ssh
execute chmod 700 ~/.ssh
echo "$ssh_key" > ~/.ssh/id_rsa
execute chmod 600 ~/.ssh/id_rsa
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
execute chmod 600 ~/.ssh/known_hosts

execute git config --global user.email "$git_user_email"
execute git config --global user.name "$git_user_name"

cd _deploy
git pull origin master --rebase

cd -

execute rake deploy
