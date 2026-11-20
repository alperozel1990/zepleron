# Zepleron oyun portalı: altyapı değerlendirmesi ve yol haritası (2026-11-15)

Masa: "Zepleron'u web oyun sitesine dönüştürüyoruz". Kaynaklar: repo okuması (zepleron-website, studio-ops registry,
multiplayer STANDARD) + 7 uzman görüşü (D1: portal, güvenlik, responsive, layout, Poki, multiplayer/ağ, Dice&Decks).

## 1. Mevcut durum

| Katman | Ne var | Ne eksik / risk |
|---|---|---|
| Site | `zepleron-website` repo, DigitalOcean droplet (~6 $/ay), nginx statik, push → 2 dk'da canlı | Test kapısı yok (push = canlı). `error_page 404 /index.html` soft-404 (SEO). Görseller `?v` damgasız 30 gün immutable |
| Portal | İskelet hazır: TR/EN ana sayfa (kutular, arama, kategori, son oynananlar), 6 oyun sayfası, `/studio/`, sitemap (`portal/build.py` + `games.json`) | **Yalnız yerel `portal` dalında, main'e push edilmedi.** Hiç ölçülmedi (uiq, LCP/CLS, gerçek cihaz). BTN + Pati Büyüsü kapak yok |
| Oyunlar webde | Burn Notice `/burnnotice/play/` canlı; Dice & Decks `/dicedecks/play/` Poki incelemesinde | Diğer 4 oyunun web build'i yok. BN web ölçümünde 15/15 ekranda sorun (yatayda düğmeler dışarıda, 8–10 px yazı) |
| Arka uç | games-1 (Oracle Always Free A1, 1 OCPU): Nakama 3.30 + Postgres + Caddy, gece yedek, 30 dk uptime | Tek makine, tek çekirdek; A1 kotası dolu (dikey büyüme yok). Adres `sslip.io` (CORS/marka). `modules.sh deploy` tüm oyunların kodunu birlikte taşıyor. Nakama güvenlik denetimi yapılmadı |
| Güvenlik | Bugün: SSH yalnız anahtar, 6/6 güvenlik başlığı (80037c0) | autopull `.git`'i www-data'ya veriyor, git root çalışıyor; fail2ban yok; 11 güncelleme bekliyor |
| Hesap | BN/DD zaten Nakama cihaz (anonim) hesabı kullanıyor | Oyunlar arası ortak kimlik, favori, portal profili yok |

## 2. Karar: altyapı yeterli mi?

**Evet, yeni teknoloji/veritabanı GEREKMEZ.** 7 uzmanın 7'si aynı görüşte:
- Ön yüz statik kalır (build.py ile üretilmiş HTML). SPA/framework yok; Poki'den hızlı olmanın en ucuz yolu bu.
- Hesap, skor, favori, bulut kaydı → mevcut Nakama (device auth + Google/Apple link, storage, leaderboard). Postgres zaten var.
- Analitik → çerezsiz, kendi sunucumuzda (GoatCounter/Umami/Plausible ya da nginx log + GoAccess). Çerez bandı gerekmez; Poki derlemelerine girmez.
- Eklenecek tek yeni parça: **Cloudflare Free** (CDN + DDoS + origin gizleme). DNS GoDaddy'den Cloudflare'e taşınır (sahip onayı).

## 3. Ölçekleme: ilk kırılacak yer ve ucuz çözüm

1. **Droplet bant genişliği** (oyun paketleri 10–50 MB; günde 10k oynanış ≈ 6 TB/ay ≈ 40 $ aşım) → Cloudflare Free + hash'li dosyalara 1 yıl immutable, HTML'e kısa cache. Maliyet 0.
2. **games-1 CPU** (Nakama + Postgres aynı çekirdek; `dd_submit` skoru yeniden oynatarak doğruluyor) → hız sınırı, sıralama okumalarını önbelleğe alma; gerekince Oracle PAYG ile A1'i 2–4 OCPU (0–30 $) ya da Hetzner ARM (~7 €) ikinci Nakama.
3. **Tek nokta arızası** → yedek makine dışında (var: games-backups), geri yükleme denemesi, servis düşünce otomatik restart.

**Aylık maliyet:** bugün ~6 $. Portal + Cloudflare: ~6 $. Ciddi büyümede ~15–45 $.

## 4. Register / giriş kararı

- "Oyna" asla kayıt istemez: Nakama cihaz/anonim hesabı, takma ad. İlk ekranda form yok.
- İsteğe bağlı bağlama ilk anlamlı anda (skor/favori): önce **Google** (Google Identity Services, ücretsiz), sonra **Apple** (Apple geliştirici hesabı durumuna bağlı; App Store'da Google varsa Apple zorunlu). E-posta/şifre YOK (parola sızıntısı, SMTP, sıfırlama yükü).
- Token'lar kısa ömürlü (STANDARD §1: 2 sa + 30 gün refresh).
- KVKK/GDPR: aydınlatma metni, tek tık hesap silme (mevcut `#silme` kalıbı), veri minimizasyonu, AB'de reklam/analitik rızası.
- Çocuk: Poki kitlesi çocuk ağırlıklı. 13 altı hesap bağlama yok, sohbet yok, kişiselleştirilmiş reklam yok. Dice & Decks kumar temalı: portalda yaş etiketi, çocuk kategorisine girmez.

## 5. Dokunulmaz linkler (tüm süreçte kural)

Taşınmaz, yeniden adlandırılmaz, içeriği değişmez; taşıma zorunluysa 301, asla 404:
- `/dicedecks/play/` (Poki incelemesi), `/burnnotice/play/`, bunların CSP/nginx blokları
- `/<oyun>/privacy.html` (+ `#silme` / `#delete`), `/<oyun>/support.html`, `/rideordie/privacy/`, `/burnnotice/press/`, `/dicedecks/press/`
- `/app-ads.txt` (kök, text/plain, içerik aynı), `google131d968357e28c17.html`, `robots.txt`
- `https://zepleron.com/burnnotice/privacy.html` Poki paketine gömülü.
- Portal CSS/JS oyun sayfalarına sarılmaz; Poki derlemelerine analitik/giriş/indir linki girmez.
- Her push öncesi korunan URL listesi curl ile 200 + içerik hash kontrolü (duman testi kapısı).
- Oyun slug'ları bir kez sabitlenir (`aspava` ↔ `sehirbankacisi` tutarsızlığı yayından önce karar).

## 6. Sahip kararı gereken noktalar

1. **Dice & Decks Poki anlaşma türü:** exclusive ise zepleron.com'da oynanabilir kopya çatışır → portalda yalnız mağaza/Poki linki gösterilir. Non-exclusive ise `/dicedecks/play/` portaldan da açılır. (BN non-exclusive, karar var.)
2. **Cloudflare'e DNS taşıma** (GoDaddy → Cloudflare nameserver). Geri dönülebilir ama ~1 saat yayılma.
3. **Slug:** `aspava` mı `sehirbankacisi` mi?
4. **Apple ile giriş:** Apple geliştirici hesabı durumu netleşene kadar yalnız Google.

## 7. Yol haritası (fazlar; uzmanlar sırayla çalışır)

### Faz 0 — Güvenli zemin (1 gün)
- F0.1 Link duman testi betiği (korunan URL'ler 200 + hash) ve push öncesi kapı. *(güvenlik / multiplayer, 0,5 g)*
- F0.2 Droplet: autopull sahiplik düzeltmesi, fail2ban, güncellemeler. *(güvenlik, 1 sa)*
- F0.3 games-1/Nakama güvenlik denetimi (console kapalı mı, key'ler, rate limit, Caddy başlıkları). *(güvenlik, 2 sa)*

### Faz 1 — Portalı yayınla (1–2 gün)
- F1.1 Sahip kararları (§6) → `games.json` güncelle (DD durumu, slug).
- F1.2 `portal` dalını ölç: `uiq lint`, 360/768/1024/1440 + yatay, LCP < 2,5 sn, CLS < 0,1. Hataları düzelt. *(responsive + layout, 1 g)*
- F1.3 Gerçek 404 sayfası, görsel sürümleme (`?v` ya da hash), `/en/` 301'leri, sitemap. *(portal, 0,5 g)*
- F1.4 Push → main, canlıda duman testi. *(portal, onayla)*

### Faz 2 — Ölçek ve ucuzluk (1 gün)
- F2.1 Cloudflare Free: DNS taşı, cache kuralları, origin'i yalnız CF IP'lerine aç. *(güvenlik + multiplayer, 2 sa, sahip onayı)*
- F2.2 `api.zepleron.com` → games-1 Caddy; CORS yalnız zepleron.com. *(Dice&Decks / multiplayer, 0,5 g)*
- F2.3 `modules.sh deploy --only <oyun>`. *(Dice&Decks, 0,5 g)*
- F2.4 Çerezsiz analitik + "oynandı" sayacı. *(portal, 1 g)*

### Faz 3 — Tek dokunuş oyna + isteğe bağlı hesap (4–5 gün)
- F3.1 Ortak "zepleron" kimliği: anonim cihaz hesabı, Google bağlama, hesap silme sayfası, tehdit modeli + CSP. *(multiplayer + güvenlik, 3 g)*
- F3.2 Arayüz: alttan açılan "ilerlemeni kaydet" paneli, favori/son oynanan (localStorage → Nakama eşitleme). *(responsive + layout, 1–2 g)*
- F3.3 Oyunlar arası sıralama + favori (Nakama storage/leaderboard). *(multiplayer, 2 g)*

### Faz 4 — Daha çok oyun webde (sürekli)
- F4.1 Ortak oynatma kabuğu: `100dvh`, güvenli alan, tam ekran yedeği, Back/Esc, yükleme göstergesi. *(responsive, 1–2 g)*
- F4.2 Burn Notice yatay masa düzeni + metin alt sınırı. *(responsive, 2–3 g)*
- F4.3 Sıradaki web build: Snowy Slide (çevrimdışı, sunucusuz, en kolay), sonra Quiver/BTN. *(ilgili oyun uzmanı, 1–2 g/oyun)*
- F4.4 Poki: site derlemesi ≠ Poki derlemesi otomatik tarama; BN P1'leri. *(Poki uzmanı, 2 g)*

### Faz 5 — Dayanıklılık (2 gün)
- F5.1 Bot istemcilerle Nakama yük testi; PAYG büyütme ya da Postgres ayırma kararı. *(multiplayer, 2 g)*
- F5.2 Yedekten geri yükleme denemesi, servis düşünce restart, sertifika/uptime izleme. *(güvenlik, 1 g)*

Toplam: ~12–15 uzman-günü; faz 0–2 sonunda portal canlı, ölçeklenebilir ve ucuz (ayda ~6 $).

---

## 8. Ek (D2): 3D hızlı tempolu multiplayer, 100+ oyun, ilerleme kaydı

Sahip hedefi genişletti. Danışılan: multiplayer/ağ, Ride or Die native, ROD Fizik, Snowy Slide. Dördü de aynı görüşte.

### 8.1 Oyunların gerçek durumu
- **Ride or Die:** Unity değil, saf Rust (rod-sim Rapier 60 Hz deterministik, rod-net kendi şifreli UDP, rod-server yetkili sunucu, rod-lobby). Çizim glow/GLES3, menüler Java. Bugün `MAX_CARS = 8`; 20 araç henüz yok.
- **Snowy Slide:** three.js + TS, tamamen çevrimdışı, ağ katmanı yok; `ts/www` (~3–5 MB) olduğu gibi portala konabilir. Multiplayer sıfırdan (en ucuzu hayalet/zaman yarışı).

### 8.2 Ride or Die webe nasıl çıkar
- **Unity WebGL değil** (15–40 MB, iOS Safari bellek çökmesi, telefonda Unity derleme yok). **three.js yeniden yazım değil** (sim'i JS'de baştan yazmak = aylar, sunucuyla aynı sim kalmaz).
- **Rust → wasm:** sim, botlar, ağ çekirdeği aynen derlenir; glow WebGL2 ve Rapier wasm destekliyor. Yeniden yazılacak: platform katmanı (JNI yerine web), ses (WebAudio, Opus akışı), dokunmatik arayüz (Java menüler → HTML/Canvas). Paket: wasm 3–6 MB + varlıklar, ilk açılış hedefi ≤10–15 MB (araçlar tembel yüklenir).
- Tahmini iş: **3–4 hafta** (platform katmanı, web taşıyıcı, web arayüzü). Risk: iOS Safari WebGL2 bellek/performans → düşük kalite modu şart.

### 8.3 Sunucu mimarisi (kesin karar)
- **Nakama goja JS match handler yetmez** (JIT'siz tek iş parçacığı, fizik yok). Nakama kalır: kimlik, eşleştirme, sıralama, ilerleme; maç bulununca `host:port + token` verir.
- **Oyun sunucusu = mevcut rod-server** (Rust, yetkili, istemci tahmini, delta snapshot), ayrı makinede.
- Tarayıcı UDP açamaz → web taşıyıcı: **WebTransport datagram** (asıl yol, Rust wtransport/quinn) ya da WebRTC DataChannel; **WebSocket** ilk sürüm/yedek (paket kaybında takılma yapar).
- Kapasite (telefon çekirdeğinde ölçülen C5e/C15: 20 oda/120 oyuncu tick p99 6,6 ms; 8 araçlık maç ~0,5 ms/kare): vCPU başına 8 kişilik ~15–30 maç; 20 kişilik ~6–12 maç.
- Bölge **Frankfurt/Falkenstein** (Türkiye'den ~41 ms). Maliyet: Hetzner CAX11/CX22 **~€4–9/ay** → 300–600 eşzamanlı oyuncu. Lobi Oracle ücretsiz mikro makinede. games-1 **üretim trafiğini taşımaz** (paylaşımlı OCPU tick p99'u bozar); 5–10 çevrimiçi oyunda games-1 de 2 OCPU'ya büyütülür.

### 8.4 100+ oyun / 2 ay: ortak SDK + yayın hattı (zorunlu)
- **`zepleron-sdk.js`** (~5 KB, tek dosya): `init(gameId)` anonim Nakama kimliği (sonradan Google bağlama) · `save/load` ilerleme (local-first + Nakama storage `game:<id>`) · `submitScore/top` (sunucuda doğrulanır) · `track(event)` (mevcut `studio_*` RPC'ler; `studio-platform/client/ts/studio.ts` çekirdeği var, web sarmalayıcısı eksik) · `matchmake()` (yalnız çok oyunculu) · reklam/Poki adaptörü (Poki'de Poki SDK, sitemizde bizimki).
- **Yayın hattı:** her oyun reposu `build:web` → `dist/` + `manifest.json` (id, başlık, kapak, boyut, sürüm) → GitHub Actions ücretsiz Linux: `gametest` headless Chromium duman testi + boyut kontrolü + `uiq` → geçerse hash'li dosyalar `/g/<id>/<sürüm>/` (Cloudflare R2 ya da site reposu) → `portal/build.py` kataloğu yeniler. Mevcut `play/` linkleri sabit.
- Sunuculu oyunlar ayrıca Docker imajı üretir; Hetzner'de işleyici ayağa kaldırır.
- **Kalite kapısı şart**, yoksa portal bozuk oyunla dolar.
- Gerçekçilik: 2 ayda 100 oyun ancak küçük 2D/HTML5 oyunlarla; 3D multiplayer en fazla 2–3 tane, her biri ayrı sunucu bütçesi.

### 8.5 İlerleme kaydı
Mevcut Nakama yeter: anonim cihaz hesabı + storage, oyun başına kayıt, local-first. Tarayıcı verisi silinince anonim hesap kaybolur → ilk skordan sonra "Google ile bağla" teklifi.

### 8.6 Güncellenmiş maliyet
Portal + Cloudflare ~6 $ · gerçek zamanlı sunucu €4–9 · games-1 büyütme 0–30 $ → **başlangıçta ~10–15 $/ay, büyümede 25–50 $/ay**.

### 8.7 Yol haritasına eklenenler
- Faz 2: **R2 / hash'li `/g/<id>/<sürüm>/`** oyun paketi deposu.
- Faz 3: **`zepleron-sdk.js` + manifest + CI yayın hattı** (SDK 2 g, hat 2 g). Snowy Slide ilk hat testi (zaten web, sunucusuz).
- **Faz 3b — gerçek zamanlı sunucu katmanı (Ride or Die ekibi, 3–4 hafta):** rod-server'a WebSocket taşıyıcı → WebTransport; Hetzner Frankfurt VM; Nakama'dan oda bileti; Rust→wasm istemci; web arayüzü. Bu iş Ride or Die masasında yürür, portal masası yalnız SDK `matchmake()` sözleşmesini verir.

---

## 9. Güncelleme 2026-11-17: Poki'den vazgeçildi (sahip kararı, Koordinasyon T25)

Dice & Decks Poki'ye konmayacak; web sürümü zepleron.com'da kalır. CrazyGames / GameDistribution yalnız zepleron.com'la çakışmazsa eklenir (şartları Poki D&D masası inceliyor). Bu belgedeki Poki varsayımları şöyle değişir:

| Yer | Eski varsayım | Yeni durum |
|---|---|---|
| §1, §5 `/dicedecks/play/` | "Poki incelemesinde, içeriği ve CSP'si dondurulmuş" | URL yine korunur (canlı oyun, kırılmaz), ama dondurma gerekçesi kalktı. D&D web derlemesi artık diğer oyunlar gibi güncellenebilir; değişiklik Dice decks masasından gelir, aynı denetim kapısından geçer. |
| §6 madde 1 | "D&D Poki anlaşması exclusive mi?" sahip kararı bekliyor | KAPANDI. Exclusive riski yok; D&D portalda oynanabilir kalır. |
| §5 "Poki paketine gömülü `/burnnotice/privacy.html`" | Poki paketi için URL sabit | URL yine sabit kalır (Play Data safety ve uygulama içi link kullanıyor); Poki gerekçesi düştü. |
| §7 F4.4 | Poki uzmanı: site ≠ Poki derlemesi taraması, BN Poki P1'leri | İPTAL. Yerine, karar çıkarsa: CrazyGames/GameDistribution derlemesi için aynı ayrım (dağıtım SDK'sı yalnız o derlemede, portal SDK'sı/reklam/satın alma yalnız zepleron.com derlemesinde). |
| §8.4 SDK "reklam/Poki adaptörü" | Poki'de Poki SDK, sitemizde bizimki | Adaptör katmanı kalır ("dağıtım kanalı adaptörü"); Poki hedefi yok. |
| "Poki kitlesi çocuk ağırlıklı" | Çocuk/13+ kuralları | DEĞİŞMEZ: site 13+ genel kitle, kişiselleştirilmemiş reklam, sohbet yok. Gerekçe artık "web oyun portalı kitlesi". |

**Açılan fırsatlar (yeni iş DEĞİL, sıraya alınacak öneri; Dice decks masasıyla):**
1. D&D web derlemesi hâlâ Poki derlemesi: içinde `PokiSDK` sarmalayıcısı var (SDK yüklü değilken etkisiz) ve portal SDK'sı bağlı değil. Yeniden derlenirse ilerleme kaydı, sıralama, "Reklamsız" hakkı ve ileride H5 reklamı D&D'de de çalışır.
2. `/dicedecks/play/index.html` `noindex, nofollow` taşıyor (Poki incelemesi için konmuştu). Oyun sayfası `/oyun/dicedecks/` zaten dizinde; çıplak oynatma sayfasının dizin dışı kalması zararsız, yeniden derlemede diğer oyunlarla aynı yapılır.
3. nginx: `/dicedecks/play/` varsayılan CSP ile sunuluyor; portal API'si (`api.zepleron.com`) için kendi `location ^~` bloğu yeniden derlemeyle birlikte eklenir.
4. "Poki tarzı / Poki-like" ifadeleri (build.py yorumları, bulgu belgeleri) yalnız tasarım referansıdır; değişmez.
