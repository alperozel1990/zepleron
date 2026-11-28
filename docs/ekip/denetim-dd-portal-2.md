DENETİM İSTEĞİ — Dice & Decks portal build'i (yayın öncesi kapı)

Depo: ~/projects/zepleron-website (kendi ayrı worktree'nde çalış; paylaşılan klonu değiştirme).
Aralık: origin/main (929306a) .. origin/dd-portal-ready-2 (db9c746) — iki commit:
  8be4aa8 = dd3a93e'nin cherry-pick'i (daha önce incelediğin T59-B2 build'i + /dicedecks/play/ CSP bloğu). Çakışma yalnız
            site/deploy/nginx/zepleron.conf'ta çıktı (main'e bu arada quiver + buynumbers blokları girmişti); ikisini de
            koruyup dicedecks bloğunu buynumbers'tan sonra, "# Deploy directory never served" öncesine koydum.
  db9c746 = 2f5bfc0'ın cherry-pick'i: yalnız site/dicedecks/play/game.js (10 satır; Poki dönemi ses ayarı
            poki_ignore:dd:muted yeni anahtara taşınıyor, eski kayıtlar korunuyor).
Değişen dosyalar: site/dicedecks/play/{game.js,index.html}, site/deploy/nginx/{zepleron.conf,portal-page.conf(yorum satırı)}.
Benim doğruladıklarım: game.js ve index.html origin/dd-portal ile bayt bayt aynı (sha256 70ea2e19…, 2d1abe32…);
python3 portal/build.py çıktı değiştirmiyor.

Bakmanı istediklerim:
1. nginx: zepleron.conf sözdizimi/blok düzeni (çakışma çözümü doğru mu, quiver/buynumbers blokları main ile aynı mı),
   dicedecks CSP'si oyunun gerçekten yaptığı isteklere yetiyor mu (index.html'de satır içi <script> var mı — script-src 'self';
   game.js'in bağlandığı hostlar connect-src'de mi; WebSocket kullanıyorsa wss eksik mi).
2. game.js (8be4aa8..db9c746 farkı + genel): Poki SDK çağrısı / dış alan adı / reklam kodu kalmış mı; portal SDK
   (Zepleron.init/load/save) doğru yoldan mı yükleniyor; kayıt anahtarı taşıması eski localStorage kaydını silmeden mi yapıyor;
   sır/anahtar gömülü mü (sunucu anahtarı varsa hangisi, herkese açık istemci anahtarı mı).
3. /oyun/dicedecks/ ve /en/game/dicedecks/ portal sayfaları bu build'i iframe/yönlendirme ile açarken kırılan bir şey var mı
   (frame-ancestors 'self', "Telefona indir" düğmesi, tam ekran).
4. Yerelde statik sunucuyla açıp (WebGL2 gerekir) en az: açılış, bir el oynama, kayıt→yeniden açma. Yapamadığını UNKNOWN yaz.
Dokunulmaz yollar değişmemiş olmalı: */privacy.html, */support.html, ads.txt, app-ads.txt, robots.txt.

Kısa rapor: bulgular (dosya:satır), yayın engeli olan/olmayan ayrımı. Son satır: VERDICT: PASS ya da VERDICT: FAIL
