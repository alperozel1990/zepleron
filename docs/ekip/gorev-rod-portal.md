GÖREV — Ride or Die'ı portala hazırla (AYRI DALDA; YAYIN YOK)

Sonuç: zepleron-website'te `rod-portal` dalı (origin/main fc4b67f üstüne), kendi worktree'nde. `main`'e DOKUNMA / push ETME
(push = canlı). Yalnız `git push origin rod-portal`. Yeni oyun: canlıya alma sahibin ayrı "yayınla" onayıyla.

KAYNAK (yalnız OKU; ride-or-die deposunda hiçbir şeyi değiştirme, paketi yeniden DERLEME — ağır iş):
- Paket: ~/projects/ride-or-die/dist/rideordie-play/ (VERSION.json: dosya başına sha256). Belge: ~/projects/ride-or-die/
  docs/rod_w5_paket.md. nginx örneği: paket içindeki nginx.conf.example.
- Gizlilik içeriği: ~/projects/ride-or-die/docs/rod_play_ready.md, "Gizlilik politikası + veri güvenliği formu" satırı.
- Portala oyun ekleme örneği: Quiver ve Buy the Numbers (git log --oneline -- portal/games.json; commit 929306a ve
  Quiver'ınki) — games.json alanları (status web, play, tile…), nginx bloğu, sayfa üretimi.

1. OYUN PAKETİ → site/rideordie/play/
   - Kopyala: index.html, main.js, pkg/, assets/, VERSION.json ve bunların `.gz` kopyaları. KOPYALAMA: `*.br` (sunucuda
     ngx_brotli YOK; `nginx -V` yalnız gzip_static gösteriyor) ve nginx.conf.example.
   - Kopyadan sonra her dosyanın sha256'sını VERSION.json ile karşılaştır; çıktıyı rapora koy. Paket dosyalarını DÜZENLEME
     (oyun masasının malı). İçinde düzeltilmesi gereken bir şey görürsen rapora "ROD masasına" diye yaz.
   - Not: VERSION.json "commit bea5a09, dirty:true" diyor; aynen aktar, rapora yaz.
2. PORTAL
   - portal/games.json rideordie: "status": "web", "play": "/rideordie/play/", gereken diğer alanlar Quiver örneğine göre.
     `stores` (Play TEST bağlantısı + TestFlight) AYNEN kalır — "Telefona indir" şimdilik mevcut test bağlantısı.
     Metin (tr/en) "mobil beta" diyorsa web'de oynanabilir olacak şekilde güncelle (kısa; uydurma özellik yazma).
   - Kabuk düğmeleri (Ana sayfa/Kapat): oyun yatay ve dokunmatik kontrolleri kenarlarda olabilir. Oyunun ana menü + maç
     HUD'ına bak, çakışmayan yeri `"shell"` ile seç (portal.css .stage__tabs açıklaması; side left|right, top %).
   - python3 portal/build.py; çıktıyı commit'le. site/ elle düzenlenmez. Oyun metni iki dilde, sitemap build'den.
3. NGINX — site/deploy/nginx/zepleron.conf: `location ^~ /rideordie/play/` (diğer play bloklarının yanına, "# Deploy
   directory never served" öncesi): `include .../security-headers.conf;` (diğer bloklardaki gibi), `gzip_static on;`,
   `types { application/wasm wasm; text/javascript js; text/html html; application/json json; application/octet-stream pack; }`,
   `Cache-Control "no-cache"`, CSP paket örneğindeki ile AYNI (script-src 'self' 'wasm-unsafe-eval'; connect-src 'self'
   wss://rod.zepleron.com wss://164-90-213-64.sslip.io https://api.zepleron.com https://zp.158-180-58-125.sslip.io),
   try_files. portal-page.conf'taki "play locations" yorum satırını güncelle. Mevcut `location = /rideordie/ { return 301
   /oyun/rideordie/; }` kalır. `types` bloğu ile security-headers include'unun birlikte geçerli nginx olduğundan emin ol
   (yerelde nginx varsa `nginx -t` benzeri; yoksa UNKNOWN yaz, ben sunucuda bakarım).
4. GİZLİLİK — YENİ dosya site/rideordie/privacy.html (TR + EN aynı sayfada ya da site/quiver/privacy.html hangi kalıptaysa
   o kalıp; stil oradan). İçerik YALNIZ kaynaktaki gerçekler: hesap ve veritabanı yok; kalıcı oyuncu anahtarı yok (oturum
   başına geçici anahtar); ilerleme, altın ve ad CİHAZDA; sunucuda yalnız geçici işletim günlükleri (oturum kimliği + IP,
   oda satırlarında oyuncu adı), 14 gün, paylaşılmaz/satılmaz; silinecek sunucu verisi yok; oyunda reklam, analitik, ödeme
   SDK'sı yok. Web sürümü zepleron.com portalında açıldığı için portalın kendi gizlilik/çerez sayfalarına (/gizlilik/,
   /cerez/, EN karşılıkları) bağlantı ver (portal reklam/hesap verisi orada anlatılıyor; burada tekrar etme, çelişme).
   Geliştirici "Zepleron Studios"; iletişim adresi diğer oyun gizlilik sayfalarındakiyle aynı. Kişi adı YOK.
   ESKİ sayfa site/rideordie/privacy/index.html (Play'deki Unity uygulamasının politikası, com.alphagames.RideOrDie) —
   DOKUNMA, URL'si bozulmasın. build.py:132 LEGAL ve :806 oyun sayfasından /rideordie/privacy/'ye bağlıyor: web sürümü için
   oyun sayfası yeni /rideordie/privacy.html'e bağlansın (mobil uygulama politikası bağlantısını silme; ikisi ayrı etiketle).
5. TEST (kanıt: ~/projects/reports/zepleron-rod-portal-20261120/; aynı anda tek Chromium)
   Yerel sunucu: nginx'i taklit eden küçük Python sunucusu — /rideordie/play/ için yukarıdaki CSP + MIME + no-cache,
   Accept-Encoding gzip ise `.gz` kopyayı Content-Encoding: gzip ile ver; portal sayfaları için portal-page.conf CSP'si.
   (Sunucuyu başlattığın komutta pkill/pgrep kullanma; ayrı komutta `pgrep -f "[p]ython3 ..."`.)
   Headless WebGL: düz swiftshader bu telefonda bağlamı kaybediyor; ROD ekibinin bayrakları çalışıyor —
   ~/projects/ride-or-die/tools/web/w5_proof.py:50-52 (--use-gl=angle --use-angle=vulkan + lavapipe ICD). Onları kullan.
   a) /oyun/rideordie/ ve /en/game/rideordie/ → Oyna → iframe'de ana menü (`body[data-screen=home]`); CSP ihlali 0, sayfa
      istisnası 0, 404 yok; wasm `application/wasm` ve gzip ile geldi.
   b) PC görünümü 1366x768: yalnız klavye ile menü → maç (yön tuşları + yetenek tuşları; fare gerekmemeli — sahip kuralı).
      Telefon görünümü 915x412 dokunmatik emülasyon: dokunarak menü → maç. Ekran görüntüleri; GERÇEKTEN bak.
   c) Hızlı maç canlı oyun sunucusuna (wss://164-90-213-64.sslip.io; rod.zepleron.com DNS kaydı yoksa geri düşmeli) —
      bağlanıyor mu, maç başlıyor mu. Sunucuya ulaşılamazsa nedenini yaz (UNKNOWN değil, gördüğün hata).
   d) Kabuk: Ana sayfa/Kapat düğmeleri menüde ve maçta hiçbir oyun düğmesiyle çakışmıyor (iki yön); Kapat çalışıyor;
      oyunun kendi "Google Play'den indir" bağlantısı portal düğmeleriyle çakışmıyor.
   e) Açılış süresi, Fast 4G (CDP ağ profili, ~/projects/reports/zepleron-hiz-20261119/olc.mjs'teki değerler; CPU 4x),
      soğuk önbellek, 3 koşu, medyan: Oyna'ya dokunuştan `data-screen=home`'a kadar süre + o ana dek aktarılan bayt;
      ayrıca rest.pack bitişi (maç düğmelerinin açıldığı an). Hedefle kıyas yorumu yazma, sayıları ver.
   f) Diğer sayfalar bozulmadı: ana sayfa (rideordie artık "oynanabilir" bölümünde), bir başka oyun sayfası, sitemap.
   Ölçemediğini UNKNOWN yaz.

KURALLAR: standart çalışma kuralların (kendi worktree, açık `git add <yol>`, satır içi script yok, dokunulmaz yollar —
bu görevde yalnız site/rideordie/play/ ve site/rideordie/privacy.html açıkça serbest). Hesap/konsol/DNS işlemi yok.

RAPOR: dal + commit'ler, `git diff --stat origin/main..rod-portal` özeti, sha256 karşılaştırması, a–f sonuçları ve sayılar,
sorunlar ("ROD masasına" / "site" ayrımıyla), UNKNOWN'lar. Son satır DURUM: BİTTİ / ENGEL / ONAY GEREK.
