DENETİM — rod-portal dalı (Ride or Die portala; YAYIN YOK, dosya değiştirme)

Depo: ~/projects/zepleron-website, `git fetch origin` sonra origin/rod-portal (7e2aa42) vs origin/main (fc4b67f).
Uygulayıcı raporu: ~/projects/reports/zepleron-rod-portal-20261120/rapor.md

Bak:
1. Dokunulmaz yollar: dicedecks/play, burnnotice/play, buynumbers/play, quiver play, app-ads.txt, robots.txt, diğer oyunların privacy/support/press değişmemiş mi.
   NOT: site/rideordie/privacy.html bu dalda YENİ eklenir (beklenen; eski kuralın istisnası). İçeriğini doğrula: TR+EN, gerçek veri toplamayla uyumlu mu (docs: ~/projects/ride-or-die/docs/rod_play_ready.md).
2. site/rideordie/play/ dosya sha256'ları VERSION.json ile eşleşiyor mu (12 dosya, .br ve nginx.conf.example YOK).
3. nginx: zepleron.conf'taki yeni /rideordie/play/ location'ı diğer oyun bloklarıyla aynı kalıpta mı (CSP, no-cache, wasm MIME, HSTS, nosniff); connect-src yalnız rod.zepleron.com + 164-90-213-64.sslip.io (wss) ve portal gerekenleri mi; gereksiz geniş izin var mı.
4. games.json rideordie girdisi (status web, play, shell top 28, stores aynen), build.py "Oyun gizliliği"/"Mobil uygulama gizliliği" ayrımı, portal.css alt çubuk düzeltmesi: diğer 6 oyun sayfasında regresyon yaratıyor mu (build çıktılarını main ile karşılaştır).
5. sitemap, hreflang/canonical, EN sayfası (/en/game/rideordie/).
6. Bilinen açıklar (not et, FAIL sayma): 360 px yükseklikte kabuk sekmeleri birkaç px biniyor; rod.zepleron.com DNS yok (sslip.io'ya düşüyor); açılış ~10 sn/2,9 MB.
Yayın engeli adaylarını (Harun lisansı, ElevenLabs FREE ses, dirty paket bea5a09, Play linki) ayrıca doğrula/listele.

Çıktı: kısa rapor ~/projects/reports/zepleron-rod-denetim-20261121/rapor.md, son satır VERDICT: PASS veya VERDICT: FAIL.
