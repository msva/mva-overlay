#!zsh

GREP=${GREP:-rg}
OK="${OK:-✅}"
NOK=${NOK:-❌}

action=${1}
not=${2}

filter() {
  local pat
  if [[ -z "${not}" ]]; then
    pat="${NOK}"
  else
    pat="${OK}"
  fi
  case "${action}" in
    ("count")
        ${(z)GREP} -c -v "${pat}"
      ;;
    ("ebuilds")
        # NOTE: actually awk or sed can do in one command, but are additional deps 🤷
        ${(z)GREP} -v "${pat}" | ${(z)GREP} -o "^[^:]+"
      ;;
    (*)
      echo "Choose action: 'count' or 'ebuilds' (1st param), and whether reverse matching (2nd param)"
      ;;
  esac
}

${(z)GREP} '^inherit ' *-* | while read line; do
  local ebuild=${line%%:*} inherit=${line##*:};
  echo -n "${ebuild}: ";
  local eclasses=(${(@s: :)${inherit##inherit }});
  for eclass in ${eclasses}; do
    echo -n "${eclass}:"
    ${(z)GREP} -q '@SUPPORTED_EAPIS.*9' \
      ../gentoo/eclass/${eclass}.eclass \
       eclass/${eclass}.eclass \
       2>/dev/null &&
       echo -n "${OK}" ||
       echo -n "${NOK}"
    echo -n ' '
  done;
  echo;
done | filter
