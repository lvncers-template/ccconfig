#!/usr/bin/env bash

input=$(cat)

afplay /System/Library/Sounds/Bottle.aiff 2> /dev/null || true
terminal-notifier -title 'Claude Code' -message 'Action required for your next command.' 2> /dev/null || true
exit 0
