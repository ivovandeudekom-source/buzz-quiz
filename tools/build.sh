#!/usr/bin/env bash
# Bouwt index.html uit src/index.template.html + tools/questions_block.js + tools/rank_block.js
cd "$(dirname "$0")/.." && python3 - <<'PY'
html=open('src/index.template.html').read()
for ph,f in (('/*__QUESTIONS__*/','tools/questions_block.js'),('/*__RANK__*/','tools/rank_block.js')):
    assert ph in html, ph; html=html.replace(ph,open(f).read())
open('index.html','w').write(html); print('index.html gebouwd', len(html))
PY
