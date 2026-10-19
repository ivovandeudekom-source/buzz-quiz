#!/usr/bin/env bash
# Bouwt index.html uit src/index.template.html + tools/questions_block.js
cd "$(dirname "$0")/.." && python3 - <<'PY'
html=open('src/index.template.html').read(); qs=open('tools/questions_block.js').read()
assert '/*__QUESTIONS__*/' in html; open('index.html','w').write(html.replace('/*__QUESTIONS__*/',qs)); print('index.html gebouwd')
PY
