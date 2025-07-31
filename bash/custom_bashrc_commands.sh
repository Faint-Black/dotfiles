# ---------------------------------------- #
# append this to your .bashrc config file. #
# ---------------------------------------- #

# Custom terminal commands
# ----------------------------------------
cdfzf() {
  local selected_dir
  selected_dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && \
  cd "$selected_dir"
}

useful-commands() {
  local bold=$(tput bold)
  local reset=$(tput sgr0)
  echo "${bold}full recursive page style wget scrape${reset}:"
  echo " wget -m -p -E -k -K -np https://foo.bar/"
  echo "${bold}symbolic link creation syntax${reset}:"
  echo " ln -s path/to/binary ./linkname"
  echo "${bold}quick local HTTP server${reset}:"
  echo " python3 -m http.server 8080 -d ./server/files/"
  echo "${bold}tar flags${reset}:"
  echo " -${bold}t${reset} list contents"
  echo " -${bold}x${reset} extract mode"
  echo " -${bold}c${reset} compress mode"
  echo " -${bold}z${reset} gzip compression"
  echo " -${bold}J${reset} xz compression"
  echo " -${bold}v${reset} verbose"
  echo " -${bold}f${reset} archive filename"
}

# Custom PATH bindings
# ----------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# Custom commands to execute after terminal boots up
# ----------------------------------------
cat ~/terminal_welcome_message.txt
