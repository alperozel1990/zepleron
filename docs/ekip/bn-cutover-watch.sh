#!/data/data/com.termux/files/usr/bin/bash
# Publishes the Burn Notice cutover build (origin/bn-cutover-ready = main + 4075f4c) the moment bn.zepleron.com
# starts accepting the NEW per-game client key. Until then the live build (old key) keeps working, so nothing is pushed.
set -u
W=~/projects/zepleron-website-sef; LOG=~/projects/zepleron/docs/bn-cutover.log; IP=158.180.58.125
cd "$W" || exit 2
git fetch -q origin
key(){ git show "$1:site/burnnotice/play/game.js" | grep -oE 'function [A-Za-z]+\(\)\{return"[A-Za-z0-9]{32}"' | grep -oE '"[A-Za-z0-9]{32}"' | tr -d '"' | head -1; }
OLD=$(key origin/main); NEW=$(key origin/bn-cutover-ready)
probe(){ curl -s --resolve "bn.zepleron.com:443:$IP" --max-time 12 -o /dev/null -w "%{http_code}" -u "$1:" -H 'Content-Type: application/json' -d '{"id":"masa-sefi-probe-0000000000000000"}' "https://bn.zepleron.com/v2/account/authenticate/device?create=false"; }
say(){ echo "$(date '+%d.%m %H:%M:%S') $*" | tee -a "$LOG"; }
[ ${#OLD} = 32 ] && [ ${#NEW} = 32 ] && [ "$OLD" != "$NEW" ] || { say "ABORT: keys not extracted"; exit 2; }
say "watch start: main=$(git rev-parse --short origin/main) ready=$(git rev-parse --short origin/bn-cutover-ready)"
ok=0; i=0
while [ $i -lt 1080 ]; do                      # 1080 x 5 s = 90 min
  n=$(probe "$NEW")
  if [ "$n" = "404" ] || [ "$n" = "200" ]; then ok=$((ok+1)); else ok=0; fi
  [ $ok -ge 2 ] && break
  i=$((i+1)); sleep 5
done
if [ $ok -lt 2 ]; then say "TIMEOUT 90 min: bn.zepleron.com still NEW=$(probe "$NEW") OLD=$(probe "$OLD"); nothing published"; kokpit notify "BN cutover: 90 dk içinde bn.zepleron.com yeni anahtara geçmedi, site yayınlanmadı" >/dev/null 2>&1; exit 1; fi
say "switch detected: NEW=$n OLD=$(probe "$OLD")"
git fetch -q origin
if ! git merge-base --is-ancestor origin/main origin/bn-cutover-ready; then say "ABORT: main moved, ready branch is not a fast-forward"; kokpit notify "BN cutover: main ilerlemiş, otomatik yayın durdu" >/dev/null 2>&1; exit 3; fi
git push -q origin origin/bn-cutover-ready:refs/heads/main && say "pushed main=$(git rev-parse --short origin/bn-cutover-ready)" || { say "ABORT: push failed"; exit 4; }
ssh -o BatchMode=yes -o ConnectTimeout=15 web /usr/local/bin/zepleron-autopull.sh >/dev/null 2>&1 && say "droplet pulled now" || say "forced pull failed; cron pulls within 2 min"
want=$(git show origin/bn-cutover-ready:site/burnnotice/play/game.js | sha256sum | cut -c1-64); j=0
until [ "$(curl -s --max-time 20 https://zepleron.com/burnnotice/play/game.js | sha256sum | cut -c1-64)" = "$want" ] || [ $j -ge 30 ]; do j=$((j+1)); sleep 6; done
live=$(curl -s --max-time 20 https://zepleron.com/burnnotice/play/game.js | sha256sum | cut -c1-64)
if [ "$live" = "$want" ]; then say "LIVE OK: game.js sha256 ${live:0:16} = commit; NEW key @bn.zepleron.com=$(probe "$NEW")"; kokpit notify "BN cutover web yayında: zepleron.com/burnnotice/play/ yeni anahtarla" >/dev/null 2>&1; exit 0
else say "LIVE MISMATCH: live ${live:0:16} want ${want:0:16}"; kokpit notify "BN cutover: push edildi ama canlı game.js eşleşmedi, bak" >/dev/null 2>&1; exit 5; fi
