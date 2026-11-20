#!/data/data/com.termux/files/usr/bin/bash
# "web geri al": put the pre-cutover Burn Notice game.js (main 7623a7a) back on main and deploy it at once.
set -u
W=~/projects/zepleron-website-sef; PREV=7623a7a; F=site/burnnotice/play/game.js
for p in $(pgrep -f '[b]n-cutover-watch.sh'); do kill -9 "$p" 2>/dev/null; done
cd "$W" && git fetch -q origin && git checkout -q main && git merge -q --ff-only origin/main || exit 2
if [ "$(git rev-parse HEAD:$F)" = "$(git rev-parse $PREV:$F)" ]; then echo "already the pre-cutover game.js on main ($(git rev-parse --short HEAD)); nothing to revert"; exit 0; fi
git checkout -q "$PREV" -- "$F" && git -c user.name="Masa şefi (zepleron)" -c user.email="alperozel1990@gmail.com" commit -q -m "burnnotice play: back to the pre-cutover game.js ($PREV; cutover rolled back by Platform)" && git push -q origin main || exit 3
ssh -o BatchMode=yes -o ConnectTimeout=15 web /usr/local/bin/zepleron-autopull.sh >/dev/null 2>&1
want=$(git show HEAD:$F | sha256sum | cut -c1-64); j=0
until [ "$(curl -s --max-time 20 https://zepleron.com/burnnotice/play/game.js | sha256sum | cut -c1-64)" = "$want" ] || [ $j -ge 30 ]; do j=$((j+1)); sleep 6; done
echo "main=$(git rev-parse --short HEAD) live_matches=$([ "$(curl -s --max-time 20 https://zepleron.com/burnnotice/play/game.js | sha256sum | cut -c1-64)" = "$want" ] && echo yes || echo NO)"
