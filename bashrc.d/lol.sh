alias starwars="curl https://asciitv.fr"

alias busy="cat /dev/urandom | hexdump -C | grep --color 'ca fe'"

matrix() {
  local i r v
  echo -e "\e[32m"

  while :; do
    # shellcheck disable=2034
    for i in {1..16}; do
      r="$((RANDOM % 2))"
      if [[ $((RANDOM % 2)) == 1 ]]; then
        if [[ $((RANDOM % 4)) == 1 ]]; then
          v+="\e[1m $r   "
        else
          v+="\e[2m $r   "
        fi
      else
        v+="     "
      fi
    done

    echo -e "$v"
    v=""

    sleep 0.001
  done
}

sing() {
  if ! command -v sox >/dev/null; then
    brew install sox
  fi

  hexdump -v -e '/1 "%u\n"' < /dev/urandom | awk '{ split("0,2,4,5,7,9,11,12",a,","); for (i = 0; i < 1; i+= 0.0001) printf("%08X\n", 100*sin(1382*exp((a[$1 % 8]/12)*log(2))*i)) }' | xxd -r -p | sox -v 0.05 -traw -r44100 -b16 -e unsigned-integer - -tcoreaudio
}
