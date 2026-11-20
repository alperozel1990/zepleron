GÖREV — GA4 analitik izin penceresi + Consent Mode v2 (AYRI DALDA; YAYIN YOK)

Sonuç beklentisi: zepleron-website'te `ga4-izin` dalı (origin/main 08207a1 üstüne), kendi worktree'nde. `main`'e DOKUNMA,
`main`'e push ETME (push = canlı). Yalnız `git push origin ga4-izin`. Yayın ayrı onayla, hukuki adım (K13) bitince.

Kaynak (önce OKU, 9 kalemlik tablo §4): ~/projects/studio-ops/docs/platform/t69/01-ga4-uyum.md
O belgedeki bir cümle eski: "AdSense yalnız kişiselleştirilmemiş reklam" — geçersiz; reklam tarafına HİÇ dokunma
(AdSense etiketi, Funding Choices akışı, ads.json, reklam kutuları aynen kalır).

YAPILACAKLAR (tablodaki #1–#6; #7 için elinden gelen yerel test; #8–#9 sahibin işi, yapma)
1. Yapılandırma: portal/games.json üst düzeye `"analytics": {"ga4_id": "G-XXXXXXXXXX"}` (yer tutucu; gerçek kimlik sonra
   gelecek). build.py bunu <html data-ga4="..."> gibi bir özniteliğe yazar. `ga4_id` boşsa/yoksa özelliğin TAMAMI yok:
   pencere yok, altbilgi düğmesi yok, hiçbir gtag kodu çalışmaz.
2. Kendi "Analitik" izin penceresi (TR/EN, metinler belgede §1 — aynen kullan): varsayılan KAPALI; `Kabul et` / `Reddet`
   eşit boyut ve stil, `Ayrıntılar` çerez sayfasına bağlantı; Esc/kapat = red; önceden işaretli kutu yok. Seçim
   localStorage `zp_consent_analytics` = {v:"granted"|"denied", t:<tarih>}; 6 ay geçmeden yeniden sorma (red için de).
   Altbilgide her zaman görünen `Analitik tercihleri` / `Analytics preferences` düğmesi (`#cmp-settings` yanında) pencereyi
   yeniden açar. Funding Choices mesajı açıkken analitik penceresi BEKLER (mevcut cmpOpen()/is-cmp mantığına bak:
   portal.js ~241-260, ~642-655); oyun açıkken (body.is-full) pencere çıkmaz; alt şeritle (dock) çakışmaz.
   Erişilebilirlik: role=dialog + aria-labelledby, odak pencereye girer ve kapanınca geri döner, dokunma hedefi ≥48 px,
   kontrast ≥4.5:1, CLS 0 (pencere akışı itmez; fixed/overlay). Pencere sayfa kullanımını engellemez (erişim koşulu değil).
3. Consent Mode v2, BASIC kip: izin yokken gtag.js HİÇ yüklenmez ve Google'a tek istek gitmez. CSP `script-src 'self'`
   olduğu için satır içi <script> YASAK: dataLayer/gtag tanımı ve `gtag('consent','default',{analytics_storage:'denied',
   ad_storage:'denied',ad_user_data:'denied',ad_personalization:'denied',wait_for_update:500})` portal.js içinde (ya da
   ayrı /assets/portal/ dosyasında) çalışır. Kabulde: `consent update {analytics_storage:'granted'}` (diğer üçü denied
   KALIR) → `https://www.googletagmanager.com/gtag/js?id=<kimlik>` dinamik eklenir → `gtag('js',new Date())`,
   `gtag('config',<kimlik>,{allow_google_signals:false,allow_ad_personalization_signals:false,send_page_view:false,
   cookie_expires:33696000})` → elle `page_view`.
4. Kişisel veri temizliği: `page_location` = origin + pathname + yalnız `utm_*` ve `gclid` parametreleri (başka her
   parametre ve hash atılır); `page_referrer` yalnız origin+pathname; `user_id` / Nakama kimliği / takma ad / arama metni
   GÖNDERİLMEZ. Yalnız `page_view` olayı (başka olay ekleme).
5. Geri çekme (Reddet ya da tercih değişimi): `consent update denied`, `window['ga-disable-<kimlik>']=true`, `_ga` ve
   `_ga_*` çerezlerini sil (alan adı varyantları: zepleron.com ve .zepleron.com, path=/).
6. CSP — YALNIZ site/deploy/nginx/portal-page.conf: script-src'ye `https://www.googletagmanager.com`; connect-src'ye
   `https://*.google-analytics.com https://*.analytics.google.com https://*.googletagmanager.com`; img-src'ye
   `https://*.google-analytics.com https://*.googletagmanager.com`. Google'ın CSP rehberini (developers.google.com/
   tag-platform/security/guides/csp) aç ve GA4 için listeyi doğrula; farklıysa rehberdekini uygula ve raporda yaz.
   Oyun iframe CSP'leri (zepleron.conf içindeki /<oyun>/play/ blokları) DEĞİŞMEZ; oyun sayfalarının içine GA yok.
7. Metinler (belge §3, TR/EN aynen): portal/legal/cookies.{tr,en}.html — "Analitik (isteğe bağlı)" bölümü, eski "analiz
   çerezimiz yoktur" cümlesinin yenisi, zorunlu yerel kayıt listesine `zp_consent_analytics`; portal/legal/
   privacy.{tr,en}.html — dayanak, amaç/saklama, geri çekme satırları. Yurt dışı aktarım cümlesine DOKUNMA (K13 bekliyor);
   sayfa tarihlerini güncelle. `ga4_id` boşken bu metinlerin nasıl görüneceğini düşünme: dal yalnız kimlikle yayınlanacak.
8. python3 portal/build.py çalıştır, çıktıyı commit'le (site/ elle düzenlenmez).

TEST (çıktıları rapora koy; kanıt klasörü ~/projects/reports/zepleron-ga4-20261120/)
Headless Chromium + CDP ile (örnek araçlar: ~/projects/zepleron/docs/ekip/oyun-duman.mjs, ~/projects/reports/
zepleron-hiz-20261119/olc.mjs — Network.requestWillBeSent ile istek say). Yerelde statik sunucu; CSP'yi gerçekten sınamak
için portal-page.conf'taki Content-Security-Policy başlığını ekleyen küçük bir Python sunucusu yaz (http.server düz hali
CSP göndermez). Sunucuyu başlattığın komut satırında pkill/pgrep ile öldürme (kabuk ölür); ayrı komutta `pgrep -f "[h]ttp..."`.
 a) Seçim yok (ilk ziyaret) ve Reddet sonrası: ana sayfa + bir oyun sayfası + çerez sayfası, 10 sn bekle →
    host'u google-analytics.com / analytics.google.com / googletagmanager.com olan istek sayısı = 0; `_ga*` çerezi yok.
 b) Kabul sonrası: gtag.js isteği var; `/g/collect` isteği var ve sorgusunda `gcs`/`gcd` izin alanları analytics=granted,
    reklam alanları denied gösteriyor (gcs=G101 beklenir; gördüğünü yaz); `dl` parametresinde utm dışı sorgu yok
    (ör. sayfayı `?utm_source=x&code=GIZLI&q=arama#h` ile aç → `dl` içinde code/q/hash YOK); `uid` yok.
 c) Kabul → sonra Reddet: `_ga*` çerezleri silindi, yeni collect isteği yok.
 d) CSP başlıklı sunucuda (b) tekrar: konsolda CSP ihlali yok.
 e) Düzen: 390x844 ve 1366x768'de pencere açıkken ve kapalıyken ekran görüntüsü (ana sayfa TR + EN, oyun sayfası);
    GERÇEKTEN bak: taşma yok, düğmeler ≥48 px (getBoundingClientRect ile ölç), alt şeritle çakışma yok.
 f) Reklam tarafı değişmedi: AdSense geç yükleme yolu ve `#cmp-settings` davranışı aynı (kod farkına bak + bir duman testi).
Ölçemediğini UNKNOWN yaz (ör. AB'de Funding Choices ile sıra — yerelde FC mesajı çıkmaz).

KURALLAR: standart çalışma kuralların geçerli (kendi worktree, açık `git add <yol>`, dokunulmaz yollar, satır içi script
yok). Hesap/konsol işlemi yok (GA4 mülkü, Tag Assistant girişi vb. AÇMA). Aynı anda tek Chromium.

RAPOR: dal adı + commit, `git diff --stat origin/main..ga4-izin` özeti (değişen dosyalar), a–f test çıktıları,
UNKNOWN'lar, açık sorular. Son satır DURUM: BİTTİ / ENGEL / ONAY GEREK.
