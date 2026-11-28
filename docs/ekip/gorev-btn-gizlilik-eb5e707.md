DENETİM (salt okur, YAYINDAN ÖNCE PASS) — BTN gizlilik, T117+T119: origin/btn-admob-sdk @ eb5e707 vs origin/main (4f3a2cc)
(Önceki PASS 1e98024 içindi; dal güncellendi, ESKİ PASS GEÇERSİZ. Lütfen eb5e707'yi denetle: `git fetch origin; git log -1 origin/btn-admob-sdk`.)
1. Fark YALNIZ site/buynumbers/privacy.html, 6 satır (13, 17, 18, 36, 40, 41); başka dosya/karakter yok; HTML dengeli; #silme/#delete duruyor.
2. Beklenen 4 düzeltme (TR+EN):
 a) AdMob SDK cümlesi (13 TR, 36 EN paragraf sonunda): "Google AdMob SDK'sı reklam göstermek ve dolandırıcılığı önlemek için cihaz/uygulama bilgisi ile çökme ve performans verisini Google'a gönderebilir." / "The Google AdMob SDK may send device/app information and crash and performance data to Google to serve ads and prevent fraud." (BN canlı sayfayla aynı).
 b) F1 (18 TR, 41 EN): "kimliğinizle eşleştirilmez" → "rastgele oyuncu kimliğinize bağlı tutulur, üçüncü taraflarla paylaşılmaz" / "They are tied to your random player ID, are not shared with third parties" (sunucu studio_event/studio_crash'e user_id yazar: studio-platform/server/studio/main.js).
 c) F2 (17/18, 40/41): 'Tanılama'/'Diagnostics' → 'Hata/kullanım verisi gönder' / 'Send error/usage data' (başlık 'Hata/kullanım verisi (isteğe bağlı)' / 'Error/usage data (optional)'); sayfada Tanılama|Diagnostics = 0; etiket buynumbers ts/src/ui/i18n.ts ile aynı.
 d) F4 (13, 36): UMP 'açılışta/at launch' → 'ilk oyun oturumundan sonra, bir maçın bitişinde' / 'after your first play session, at the end of a match' (BN canlı ifadeyle aynı).
3. Uyum raporu ~/projects/studio-ops/docs/platform/beyan/buynumbers-denetim.md F1/F2/F4 giderildi mi.
Çıktı: ~/projects/reports/zepleron-btn-privacy-20261122/denetim.md'ye "## T117+T119 eb5e707" bölümü; son satır VERDICT PASS/FAIL; bana kokpit send ile 2 satır.
