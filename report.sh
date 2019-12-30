#!/bin/bash

httpuser=
httppass=''
forumuser=
forumpass=''

my_name=''
my_report_file=''

cookie=cookie
base_url=''

my_tl=7

#Log to the forum with the http auth.

function call {
  curl -sL -u "${httpuser}:${httppass}" -c cookie -b cookie "${base_url}$@"
}

#Now to log into the forum with the user login details:

function log_in {
      call "ucp.php?mode=login" -d "username=${forumuser}" -d "password=${forumpass}" -d "login=Login"        
}

#Get forum forum link (tl link) & forum title (tl name)

function list_tl {
 log_in | grep forumtitle| awk -F'[<>="]' '{print $5,$10}'
}

#Opens the page to post the forum topic, takes the info in order to post:

function get_form_report {
  post="$(call "posting.php"  -d "mode=post"  -d "f=${my_tl}" )"
  postid=$(echo "${post}" | awk -F\" '/topic_cur_post_id/{print $6}')
  lastclick=$(echo "${post}" | awk -F\" '/lastclick/{print $12}')
  creationtime=$(echo "${post}" | awk -F\" '/creation_time/{print $6}')
  formtoken=$(echo "${post}" | awk -F\" '/form_token/{print $6}')
}

#Posting a topic to the forum

function post_report {
  get_form_report
  local report_by="Report - ${my_name} - $(date +%d/%m/%Y)"
  call "posting.php" -X POST \
  --data-urlencode "message@$1" \
       -d "topic_cur_post_id=${postid}" \
       -d "mode=post" \
       -d "subject=${report_by}" \
       -d "lastclick=${lastclick}" \
       -d "creation_time=${creationtime}" \
       -d "form_token=${formtoken}" \
       -d "f=${my_tl}" \
       -d "post=Submit"

  if call "viewforum.php?f=${my_tl}" | grep -q "${report_by}"; then
    echo "GG WP";
  else
    echo "Huston we have a problem!";
  fi
  if [[ -f "${cookie}" ]]; then
    rm "${cookie}"
  fi
}

if [[ $1 == "--help" || $1 == '-h' ]]; then
  cat <<EOF
  PHPBB forum posting script.

  Usage: $0 [options]

  Open the script with a text editor and set your user and pass for both login section http and forum,
    set your name in 'my_name' and the base URL of the forum in 'base_url'. Set the path to the file(file_path) of which content you will post.

  Once configured with login details, file location and TL only run $0

 --list-tl
        List forum threads(TLs) to post to. The first number in the list is the number needed for variable "my_tl"
                                                                                                     Example: my_tl=7 .

 The script automatically sets the name and the current date in d/m/y format as a subject.
EOF
exit 1
fi

if [[ $1 == "--list-tl" ]]; then
  list_tl
  exit 1
fi

log_in
post_report $(echo ${my_report_file})
