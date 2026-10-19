#!/usr/bin/env bash
# Presentator-loops: image-to-video vanaf tools/hostsrc/base.png (groen scherm), 5 s, 7,5 credits per clip.
cd "$(dirname "$0")/.."
BASE="The same cartoon TV host from the start image, full body, standing on a plain solid bright green screen background that stays perfectly flat and uniform, static camera, no camera movement, no zoom, no text, character stays fully in frame with feet visible."
gen(){ id="$1"; p="$2"; out="tools/hostvid/$id.mp4"; [ -s "$out" ] && return
  url=$(higgsfield generate create kling3_0_turbo --aspect-ratio 9:16 --resolution 720p --duration 5 --start-image tools/hostsrc/base.png --prompt "$BASE $p" --wait --wait-timeout 15m --wait-interval 10s --json 2>"tools/log/hostvid_$id.err" | python3 -c "import json,sys;d=json.load(sys.stdin);d=d[0] if isinstance(d,list) else d;print(d.get('result_url') or '')")
  [ -n "$url" ] && curl -sS -f -o "$out" "$url" && echo "OK $id" || echo "FAIL $id"; }
export -f gen; export BASE
printf '%s\n' "idle|He stands relaxed, breathing calmly, slight weight shift from one foot to the other, small natural head movements, friendly smile, holding the microphone loosely. Seamless idle loop." "talk|He talks animatedly into the microphone, mouth moving continuously, expressive eyebrows, gesturing with his free hand, energetic game show host energy." "laugh|He bursts out laughing, throws his head back, slaps his knee, then recovers with a big grin." "shock|He reacts with exaggerated shock: eyes wide, mouth open, hand to the forehead, stumbles half a step back, then shakes his head in disbelief." | xargs -P 4 -I{} bash -c 'IFS="|" read -r id p <<< "{}"; gen "$id" "$p"'
