__ansi_color() {
  local code

  local light

  local attr=""
  local color="$1"

  while [[ "${#color}" -gt 1 ]]; do

    code=

    case "${color:0:1}" in
      B) code="1" ;; # Bright / Bold
      D) code="2" ;; # Dimmed
      U) code="4" ;; # Underlined
      I) code="7" ;; # Inverted
      L) light=1  ;; # Light
      "[")           # Background
        code=$(__color_code "${color:1:1}")
        if [[ "$code" -eq 0 ]]; then
          code="49"
        else
          code=$(( "$code" + 10 ))
        fi
        color="${color:2}"
        ;;
    esac

    if [[ -n "$code" ]]; then
      attr="${attr}${code};"
    fi

    color="${color:1}"

  done

  if [[ "$color" = "_" ]]; then
    code=""
    attr="${attr%%;}"

  else
    code=$(__color_code "$color")

    if [[ "$light" -eq 1 && "$code" -ne 0 ]]; then
      code=$(( code + 60 ))
    fi
  fi

  # shellcheck disable=2028
  echo "\e[${attr}${code}m"
}

__color_code() {
  local code

  case "$1" in
    K) code="30" ;; # Black
    R) code="31" ;; # Red
    G) code="32" ;; # Green
    Y) code="33" ;; # Yellow
    B) code="34" ;; # Blue
    M) code="35" ;; # Magenta
    C) code="36" ;; # Cyan
    W) code="37" ;; # White (Light gray)
    X) code="0"  ;; # Reset
  esac

  echo "$code"
}

__colorize() {
  echo -ne "$(__ansi_color "$1")"

  if [[ $# -gt 1 ]]; then
    echo -n "$2"
    echo -ne "$(__ansi_color "[X]X")"
  fi
}

__colorize_ps1() {
  echo -n "\[$(__ansi_color "$1")\]$2\[$(__ansi_color "[X]X")\]"
}
