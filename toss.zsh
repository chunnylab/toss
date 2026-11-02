# toss: push files to another machine over SSH with one short command.
#
# Requires: zsh, rsync, and an SSH alias for the target host
# (recommended, in ~/.ssh/config) with key authentication.
#
# Configuration (in your ~/.zshrc):
#   export TOSS_TO=myserver       # target SSH alias (required); list several,
#                                 # e.g. "mac windows-desktop", to pick per send
#   export TOSS_SCP=windows-desktop  # targets without rsync (Windows): use scp
#   export TOSS_SRC=~/Downloads   # where bare `toss` grabs the newest file
#   export TOSS_DEST=Downloads/   # destination dir on the target host
#
# Usage:
#   toss report.pdf        send specific file(s)
#   toss                   send the newest file in $TOSS_SRC
toss() {
  if [[ -z ${TOSS_TO:-} ]]; then
    echo "toss: set TOSS_TO first, e.g. export TOSS_TO=myserver (an SSH alias)" >&2
    return 1
  fi
  local src=${TOSS_SRC:-$HOME/Downloads}
  local -a files
  if (( $# == 0 )); then
    local newest=$(print -r -- $src/*(.om[1]))
    [[ -n $newest ]] || { echo "toss: no file found in $src" >&2; return 1 }
    files=($newest)
    echo "toss: $newest"
  else
    files=("$@")
  fi
  local -a targets=(${=TOSS_TO})
  local to
  if (( $#targets > 1 )); then
    local PROMPT3="toss to? "
    select to in $targets; do [[ -n $to ]] && break; done
    [[ -n $to ]] || return 1
  else
    to=$targets[1]
  fi
  local dest="${to}:${TOSS_DEST:-Downloads/}"
  # Windows OpenSSH ships no rsync; scp still lands in ~\Downloads.
  if (( ${${=TOSS_SCP:-}[(Ie)$to]} )); then
    scp -- "${files[@]}" "$dest"
  else
    rsync -avP -- "${files[@]}" "$dest"
  fi
}
