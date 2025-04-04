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

ffmpeg-compress-video() {
  if [ -z "$1" ]; then
    echo "You must provide an input parameter."
    return 1
  fi

  ffmpeg -i $1 -vf "scale='if(gt(iw,ih),720,-1)':'if(gt(ih,iw),720,-1)', pad='ceil(iw/2)*2:ceil(ih/2)*2:(ow-iw)/2:(oh-ih)/2'" -c:v libx264 -preset veryslow -r 24 -crf 27 -c:a aac -b:a 128k compressed.mp4

  local green=$(tput setaf 2)
  local bold=$(tput bold)
  local reset=$(tput sgr0)
  echo "${bold}${green}COMPRESSION COMPLETE.${reset}"
  echo " "
  echo "${bold}Video filesizes comparison${reset}:"
  echo "-input:"
  du -h $1
  echo "-output:"
  du -h compressed.mp4
  echo " "
  echo "${bold}Video resolutions comparison${reset}:"
  echo "-input:"
  ffprobe -v error -show_entries stream=width,height -of default=nw=1:nk=1 $1
  echo "-output:"
  ffprobe -v error -show_entries stream=width,height -of default=nw=1:nk=1 compressed.mp4
  echo " "
  echo "${bold}Video bitrates comparison${reset}:"
  echo "-input:"
  echo "$(ffprobe -v error -show_entries format=bit_rate -of default=nw=1:nk=1 $1 | numfmt --to=si)b/s"
  echo "-output:"
  echo "$(ffprobe -v error -show_entries format=bit_rate -of default=nw=1:nk=1 compressed.mp4 | numfmt --to=si)b/s"
  echo " "
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
