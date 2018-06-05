make --print-data-base --question | awk '/^[^.%][-A-Za-z0-9_]*:/ { print substr($$1, 1, length($$1)-1)}' | sort | pr --omit-pagination --width=80 --columns=4

