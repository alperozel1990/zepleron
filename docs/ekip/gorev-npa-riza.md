GÖREV (Koordinasyon T95) — NPA'yı rıza sinyaline bağla, dal adsense-hazirlik (aynı dal, yeni commit), YAYIN YOK

Karar (Koordinasyon, sahibin 19.11 kararı geçerli): NPA KOŞULSUZ DEĞİL. Kural: rıza sinyali yoksa NPA (requestNonPersonalizedAds=1), rıza varsa kişiselleştirilmiş (=0). Varsayılan NPA. Rıza penceresini sitede Gelir masası ayarlayacak (T94); sen yalnız sinyali okuyan mantığı hazırla.
(1) T89 madde 2'deki "koşulsuz NPA" bu karara göre DEĞİŞİR. (2) İlk ekran kuralı yüzünden birim sayısının düşmesi KABUL; yeniden ayar yok.

Yap:
- portal.js'teki `const NPA` tek anahtarını, her push ÖNCESİ okunan bir fonksiyona çevir: rıza sinyali = IAB TCF `__tcfapi('addEventListener', 2, …)` (Google Funding Choices/CMP bunu sağlar) + varsa Google Consent Mode durumu (gtag consent ad_personalization/ad_storage). Rıza kriterini Google'ın dokümanından doğrula (TCF'de Google'ın kişiselleştirme için istediği amaçlar/satıcı) ve kodda tek yerde, açık yorumla yaz; emin olmadığın kriteri UNKNOWN diye rapora yaz, uydurma. Sinyal yoksa, API yoksa, hata/zaman aşımı varsa → NPA=1 (güvenli varsayılan).
- Rıza SONRADAN gelirse (kullanıcı kutuya basar): henüz push edilmemiş birimler =0 ile push edilir; zaten push edilmiş birim yeniden push EDİLMEZ (tek push kuralı korunur, CLS 0 korunur).
- Etiket (adsbygoogle.js) geç yükleme (T63) davranışı aynı kalır; rıza dinleyicisi etiketi erkene çekmesin, LCP'yi bozmasın.
- zepleron-ads.js (H5 kapalı) tutarlı: aynı rıza fonksiyonunu kullansın, H5 hâlâ canlıda kapalı.
- check_ads.py'deki "NPA koşulsuz var" kontrolünü yeni kurala uyarla: (a) varsayılan 1, (b) rıza yolu var, (c) data-tag-for-age-treatment yok, (d) test bayrağı yok. Negatif test: rıza mantığı silinirse FAIL.
- Ölç (headless, sahte __tcfapi taklidiyle; gerçek CMP yok → bunu UNKNOWN yaz): (i) API yok → tüm pagead/ads isteklerinde npa=1; (ii) rıza yok → npa=1; (iii) rıza var (ilk push öncesi) → npa yok/0; (iv) rıza push'lardan sonra gelir → eski birimler yeniden push edilmez, yeni birimler npa=0; (v) CLS/LCP regresyonu yok (kısa tekrar), tek push/birim.
- Gizlilik/çerez METNİNE dokunma (Gelir/Uyum masası). Rapora: bu yolun KVKK/TR'de rıza penceresi olmadan zaten NPA kalacağını yaz.
Çıktı: push'lu commit(ler), kısa rapor ~/projects/reports/zepleron-adsense-hazirlik-20261121/rapor-npa-riza.md (5 satır). Son satır DURUM: BİTTİ / …
