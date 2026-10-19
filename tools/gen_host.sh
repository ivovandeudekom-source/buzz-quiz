#!/usr/bin/env bash
cd "$(dirname "$0")/.."
S="Same character as the reference image: 3D cartoon TV quiz host, shiny purple suit, magenta tie, silver-blond slicked hair, thin glasses, identical face and outfit, same rendering style, full body facing camera, plain solid bright green background (#00ff00), no text, centered, feet visible. Pose:"
gen(){ id="$1"; p="$2"; out="tools/hostsrc/$id.png"; [ -s "$out" ] && return
  url=$(higgsfield generate create nano_banana_2_1 --aspect-ratio 2:3 --resolution 1k --image-references tools/hostsrc/base.png --prompt "$S $p" --wait --wait-timeout 6m --json 2>"tools/log/host_$id.err" | python3 -c "import json,sys;d=json.load(sys.stdin);d=d[0] if isinstance(d,list) else d;print(d.get('result_url') or '')")
  [ -n "$url" ] && curl -sS -f -o "$out" "$url" && echo "OK $id" || echo "FAIL $id"; }
export -f gen; export S
printf '%s\n' "talk|speaking enthusiastically into the microphone, mouth wide open, one hand gesturing outward" "laugh|laughing out loud, head tilted back, eyes closed, hand on belly" "shock|shocked, eyes wide, mouth open in an O, hands up near the face" "point|pointing straight at the camera with a sly grin, other hand holding the microphone at the hip" | xargs -P 4 -I{} bash -c 'IFS="|" read -r id p <<< "{}"; gen "$id" "$p"'
