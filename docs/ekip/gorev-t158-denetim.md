T158 denetim (salt okur; YAYIN YOK). origin/adsense-hazirlik a6586f9 = origin/main d2b4e45 + reklam/rıza işi merge'ü.
Doğrula:
1. git merge-base origin/main origin/adsense-hazirlik = d2b4e45; diff yalnız reklam/rıza işi + T82 yasal metinler + üretilmiş çıktı.
2. python3 portal/build.py sonrası git status temiz; check_ads.py PASS.
3. Yasal sayfalar TR+EN: 'Anonim oynanma sayımı', 'Oyun puanları ve canlı sayaç', zp.canli.off, zp.pwa.kapat dört madde de var; 'meşru menfaat' yok; kendi rıza penceresi/zp_consent/pauseAdRequests yok.
4. PWA: service worker YOK (yalnız site.webmanifest) → önbellek denetimi gerekmiyor; manifest ve manifest/PWA şeridi (zp.pwa.kapat) reklam/rıza akışını bozmuyor: adsbygoogle/CMP etiketleri yerinde, şerit reklam birimini örtmüyor, 412×915'te ilk ekranda birim 0, CLS 0.
5. Çakışma işareti yok; sayaç/puan kodu duruyor.
Çıktı: ~/projects/reports/zepleron-adsense-denetim-20261121/rapor.md '## T158 merge' bölümü, son satır VERDICT PASS/FAIL; bana kokpit send ile 3 satır.
