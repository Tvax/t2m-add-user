#!/bin/bash

t2m_path="/home/tvax/t2m"
masto_account="@Tvax_x@mstdn.io"

if [ $# -eq 0 ]; then
  echo "No arguments supplied" >&2
  exit 1;
fi

function add_user {
  #remove last spaces at the end and beginning of string
  user="$(echo -e "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

  if [[ $user != @?* ]]; then
    echo "Not a Birdsite user"
    return 2
  fi

  db_user="\"$user\""

  if grep -q $db_user db.json; then
    echo "${user} is already in the database check if you're not adding it to the same Mastodon account"
    return 3
  fi

  echo "Adding '${user}' to $masto_account"
  python t2m one $user -m $masto_account -r -o
  return 0
}

function add_user_with_loop {
  while true; do
    read -p "Birdsite user to add : " user
    add_user $user
  done
}

cd $t2m_path
source ve/bin/activate

#if option loop
if [[ $1 == "-l" ]]; then
  add_user_with_loop
fi

add_user $1
