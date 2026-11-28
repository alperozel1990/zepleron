GÖREV (Koordinasyon T89 / Gelir T87) — AdSense yerleşimine HAZIRLIK, AYRI DALDA, YAYIN YOK

Dal: `adsense-hazirlik`, origin/main (fc4b67f ya da güncel) üstüne, kendi worktree'nde (~/projects/zepleron-website-adsense).
`main`'e DOKUNMA / push ETME (push = canlı). Yalnız `git push origin adsense-hazirlik`. rod-portal ve ga4-izin dallarına dokunma (rod-portal portal.css'te alt çubuk düzeltmesi içerir; çakışma çıkarsa rapora yaz).

OKU (yalnız bunlar): ~/projects/studio-ops/docs/gelir/zepleron-uygulama-listesi.md (14 madde + kabul ölçütleri) ve
~/projects/studio-ops/docs/gelir/adsense-yerlesim-kurallari.md. Reklam altyapısı zaten var: portal/build.py `ad_unit()`/SLOTS,
site/assets/portal/portal.js (~20–40, ~674–702), portal.css (~704–732), portal/sdk/zepleron-ads.js, site/assets/portal/ads.json.

YAPILACAK (yalnız KİMLİK GEREKTİRMEYENLER; slot kimlikleri yer tutucu kalır: <slot:zp-home-h1> vb., madde 1'i "ads.json slots" olarak yer tutucuyla bağla ama gerçek kimlik YAZMA):
- Madde 2: NPA — ilk push öncesi `requestNonPersonalizedAds = 1`, koşulsuz; zepleron-ads.js'te de koru. Gizlilik/çerez metinlerine DOKUNMA.
  (Not: sahip kararı "kişiselleştirilmiş AdSense, AB'de CMP" idi; bu iş Koordinasyon/Gelir emri gereği NPA'yı HAZIRLAR, yayın öncesi Gelir şefi son kararı verir — rapora bu çelişkiyi tek satırla yaz, kodda bayrağı tek yerde ve kolay kapatılır tut.)
- Madde 3-5: yerleşim sırası, ilk ekranda birim 0, her .ad ile oyun kontrolleri (.stage/.stage__play/hero Oyna/.dock__play/[data-play]) arası ≥150 px, karolara ≥24 px, G2 yalnız ≥1000 px ve .stage'den ≥150 px aşağıdaysa (aksi halde display:none).
- Madde 6+9: CLS 0 için sabit min-height yer ayırma; boş kutu görünmesin: yer tutucu/dolmayan/hata durumu = HOUSE PROMO (kendi oyunlarımızın tanıtımı, .ad.is-house), kutu boyutu değişmez.
- Madde 7: geç yükleme (T63: ilk etkileşim ya da 3 sn + idle) KORUNUR; her ins için IntersectionObserver ile tek push. Gerilemesin.
- Madde 10-12: noads (html.zp-noads), dock/CMP çakışması, reklamsız sayfa taraması (quiver/buynumbers/rideordie, yasal, 404, hesap-sil, studio).
- Madde 13: CI kapısı betiği (test bayrağı grep 0, requestNonPersonalizedAds varlığı, 150 px ölçüm özeti; ihlalde kırmızı).
- Madde 14 (yayın) ve madde 8'in "gerçek slotlu" kısmı YAPILMAZ (kimlik yok). Madde 8'i slotsuz/yer tutucu ile önce/sonra LCP olarak ölç.

ÖLÇ (telefonda + PC görünümünde): CLS (PerformanceObserver, reklam kaynaklı layout-shift 0), LCP ≤2 sn (T63 değerleri aşılmasın), 6 genişlik (360×800, 412×915, 768×1024, 1280×800, 1440×900, 1920×1080), TR ve EN, 150 px tablosu birim×genişlik. Telefonda en az bir gerçek Opera/Chrome görüntüsü. Ölçülemeyeni UNKNOWN yaz, PASS deme. Boş kutu hiçbir durumda görünmemeli (reklamsız/adblock dahil).
Maliyet: büyük dosyaları baştan okuma, yalnız ilgili satırlar; ölçüm betiğini tek dosyada topla.

ÇIKTI: push'lu dal + rapor ~/projects/reports/zepleron-adsense-hazirlik-20261121/rapor.md (ölçüm JSON'ları yanında) + 5 satır özet.
Bitince denetçiye ben vereceğim. Son satır: "DURUM: BİTTİ" / "DURUM: DEVAM (ne kaldı)" / "DURUM: ONAY GEREK: …" / "DURUM: ENGEL: …".
