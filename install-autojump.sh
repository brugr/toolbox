#!/usr/bin/env bash

git clone https://github.com/wting/autojump /tmp/autojump
mkdir -vp /usr/local/bin /usr/local/share/man/man1 /etc/profile.d /usr/local/share/autojump /usr/share/zsh/site-functions
cp -v /tmp/autojump/bin/{autojump,autojump_argparse.py,autojump_data.py,autojump_match.py,autojump_utils.py} /usr/local/bin
cp -v /tmp/autojump/bin/icon.png /usr/local/share/autojump
cp -v /tmp/autojump/docs/autojump.1 /usr/local/share/man/man1
cp -v /tmp/autojump/bin/autojump.sh /etc/profile.d
cp -v /tmp/autojump/bin/autojump.{bash,fish,zsh} /usr/local/share/autojump
cp -v /tmp/autojump/bin/_j /usr/share/zsh/site-functions
rm -vrf /tmp/autojump