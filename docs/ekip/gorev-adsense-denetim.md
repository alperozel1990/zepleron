DENETİM (salt okur) — adsense-hazirlik dalı (Koordinasyon T89), 2 iş:

A) origin/adsense-hazirlik (8c6e06a) vs origin/main (fc4b67f). Uygulayıcı raporu: ~/projects/reports/zepleron-adsense-hazirlik-20261121/rapor.md (ölçüm JSON'ları yanında).
 1. Dokunulmaz yollar (play dizinleri, privacy/support/press, app-ads.txt, ads.txt, robots, google doğrulama) diff boş mu; gizlilik/çerez metinleri değişmemiş mi.
 2. Gerçek slot kimliği ya da test bayrağı (data-adbreak-test|zp_adtest|google_adtest) yok; slotlar yalnız <slot:zp-…> yer tutucu; `python3 portal/check_ads.py` ve build temiz; --release yer tutucuda FAIL veriyor mu.
 3. Kod incelemesi: portal.js (NPA tek anahtar, her ins için tek push, zp-ins yeniden adlandırma, .is-wait mantığı, noads yolu), zepleron-ads.js, portal.css. Yarış durumu / boş kutu / CLS riski var mı.
 4. En az iki ölçümü bağımsız tekrarla (örn. 412×915 ana sayfa + 1280×800 oyun sayfası): ilk ekranda birim 0, oyun kontrollerine ≥150 px, reklam kaynaklı layout-shift 0. Ölçülemeyeni UNKNOWN.
 5. Reklamsız sayfalar (quiver/buynumbers/rideordie, yasal, 404, hesap-sil, studio): adsbygoogle/.ad 0.
 6. Diğer oyun sayfalarında (özellikle D&D alt çubuğu) görsel regresyon var mı.
B) rod-portal denetim raporunda (~/projects/reports/zepleron-rod-denetim-20261121/rapor.md) son VERDICT satırı eksik. Raporun sonuna VERDICT: PASS/FAIL ekle (bulgu: privacy.html "SDK yok" metni ↔ zepleron-sdk.js çelişkisi düzeltilmeden yayına PASS verme; dal PASS-şartlı ise nedenini yaz).

Çıktı: ~/projects/reports/zepleron-adsense-denetim-20261121/rapor.md, son satır VERDICT: PASS veya VERDICT: FAIL.
