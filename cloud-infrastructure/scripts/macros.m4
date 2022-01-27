esyscmd(`env | sed -ne "s/^\([A-Z_]*\)=\(.*\)/define(__\1__, \`\2')/p" | tr -d "\n"')
