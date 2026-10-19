#!/usr/bin/env bash
# Genereert ontbrekende karakters (nano_banana_2_1, 1,5 credit/stuk) met tools/charsrc/kees.png als stijlreferentie.
set -u
cd "$(dirname "$0")/.."
STYLE="3D cartoon game show contestant in exactly the same rendering style as the reference image, bold shapes, big expressive eyes, full body standing and facing the camera, confident happy pose, bright studio lighting, plain solid bright green background (#00ff00), no text, no logos, centered, feet visible"
gen_one(){
  id="$1"; out="tools/charsrc/$id.png"; [ -s "$out" ] && exit 0
  desc=$(python3 -c "import json,sys;print([c['desc'] for c in json.load(open('tools/chars.json')) if c['id']==sys.argv[1]][0])" "$id")
  for attempt in 1 2; do
    url=$(higgsfield generate create nano_banana_2_1 --aspect-ratio 2:3 --resolution 1k --image-references tools/charsrc/kees.png --prompt "$STYLE. Character: $desc" --wait --wait-timeout 6m --json 2>"tools/log/char_$id.err" | python3 -c "import json,sys;d=json.load(sys.stdin);d=d[0] if isinstance(d,list) else d;print(d.get('result_url') or '')" 2>/dev/null)
    if [ -n "$url" ] && curl -sS -f -o "$out.part" "$url" && [ -s "$out.part" ]; then mv "$out.part" "$out"; echo "OK $id"; exit 0; fi
    sleep 8
  done; echo "FAIL $id"; exit 1
}
export -f gen_one; export STYLE
python3 -c "import json;print('\n'.join(c['id'] for c in json.load(open('tools/chars.json'))))" | xargs -P 4 -I{} bash -c 'gen_one "$@"' _ {}
