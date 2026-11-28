KISA DENETİM — Buy the Numbers web kural düzeltmesi (yayın öncesi kapı, acil)

Depo: ~/projects/zepleron-website (kendi ayrı worktree'nde). Aralık: origin/main (08207a1) .. origin/btn-kural (fc4b67f), tek commit.
İçerik: yalnız site/buynumbers/play/game.js; origin/btn-web 37b306c'deki dosyanın aynısı (o dal eski main tabanlı olduğu
için birleştirilmedi, yalnız dosya alındı). Sürüm etiketi 1ca0923-20261119 → f30e6c2-20261120; kural: desteden kendi
tekelindeki kartı çeken oyuncunun kartı eline gelir; protokol PV 2 (sunucu PV 2'de, canlı web PV 1 = çevrimiçi uyumsuz).
Kontrol et (kısa tut):
1. Fark gerçekten yalnız o dosya mı; sha256 btn-web 37b306c'deki ile aynı mı (44224175f6963fb7…).
2. python3 portal/build.py → git status boş mu.
3. game.js: yeni dış host / eval / gömülü sır / reklam ya da izleme kodu eklenmiş mi (eski dosyayla karşılaştır);
   /buynumbers/play/ CSP'sine (site/deploy/nginx/zepleron.conf) sığıyor mu; index.html ve boot.js ile uyumlu mu
   (beklediği global/DOM değişmiş mi).
4. Yapabiliyorsan headless açılış (konsol hatası var mı); yapamadığını UNKNOWN yaz.
Son satır: VERDICT: PASS ya da VERDICT: FAIL
