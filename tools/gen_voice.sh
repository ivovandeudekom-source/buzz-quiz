#!/usr/bin/env bash
# Genereert ontbrekende presentatorclips via de Higgsfield CLI (ElevenLabs-engine, stem Bram).
# Gebruik: tools/gen_voice.sh [parallel]   — alleen clips zonder media/voice/<key>.mp3 worden gemaakt.
set -u
cd "$(dirname "$0")/.."
VOICE_ID="549ff70a-3ee7-4f04-a4d9-89a24fab7709"   # Bram (preset)
PAR="${1:-4}"
mkdir -p media/voice tools/log
gen_one() {
  key="$1"
  out="media/voice/$key.mp3"
  [ -s "$out" ] && exit 0
  text=$(python3 -c "import json,sys;print(json.load(open('tools/lines.json'))[sys.argv[1]])" "$key")
  for attempt in 1 2 3; do
    url=$(higgsfield generate create text2speech_v2 --variant elevenlabs --voice-type preset --voice-id "$VOICE_ID" \
          --prompt "$text" --wait --wait-timeout 4m --json 2>"tools/log/$key.err" \
          | python3 -c "import json,sys;d=json.load(sys.stdin);d=d[0] if isinstance(d,list) else d;print(d.get('result_url') or '')" 2>/dev/null)
    if [ -n "$url" ] && curl -sS -f -o "$out.part" "$url" && [ -s "$out.part" ]; then mv "$out.part" "$out"; echo "OK  $key"; exit 0; fi
    sleep $((attempt*5))
  done
  echo "FAIL $key"; exit 1
}
export -f gen_one; export VOICE_ID
python3 -c "import json;print('\n'.join(json.load(open('tools/lines.json')).keys()))" | xargs -P "$PAR" -I{} bash -c 'gen_one "$@"' _ {}
echo "done: $(ls media/voice/*.mp3 2>/dev/null | wc -l) clips"
