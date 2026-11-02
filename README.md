# toss

Push a file to another machine over SSH with one short command.

```zsh
toss              # send the newest file in ~/Downloads
toss report.pdf   # send specific file(s)
```

For the moment you just downloaded a file and want it on your other
machine, without typing a full `scp` command with host, user, and a
filename full of spaces.

## Setup

Prerequisites: zsh, rsync, and an SSH alias for the target machine in
`~/.ssh/config` with key authentication working (`ssh myserver` connects
without a password prompt).

```zsh
# in ~/.zshrc
source /path/to/toss/toss.zsh
export TOSS_TO=myserver       # target SSH alias
export TOSS_SRC=~/Downloads   # optional: where bare `toss` looks
export TOSS_DEST=Downloads/   # optional: destination dir on the target
```

Open a new terminal and try it:

```zsh
toss photo.jpg
```

## Why SSH and rsync

- Traffic stays encrypted inside your SSH connection. There is no
  third-party relay and no upload to someone else's cloud.
- Authentication uses your SSH key, so no passwords end up in shell
  history.
- Sending an identical file again transfers almost nothing (rsync quick
  check), and interrupted transfers resume thanks to `-P`.

Works well over Tailscale: point `TOSS_TO` at a machine in your tailnet
and the file stays on your private network the whole way.

## License

MIT
