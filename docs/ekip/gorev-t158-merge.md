T158 (Koordinasyon) — adsense-hazirlik'i origin/main d2b4e45 üstüne BİRLEŞTİR (merge, rebase değil). YAYINA ALMA, push yalnız adsense-hazirlik dalına.
Klasör: ~/projects/zepleron-website-adsense (dal adsense-hazirlik, ucu 78eef3e). git fetch; git merge origin/main.
Kurallar:
- site/** üretilmiş HTML'i ELLE birleştirme: kaynakları (portal/build.py, portal/legal/*, portal/*.js/css) birleştir, çakışan üretilmiş dosyalarda main'inkini al, sonra python3 portal/build.py ile yeniden üret; git status temiz olmalı.
- build.py çakışmasında: main'in ld_json listesi + dalın head(..., ads=has_ads) birlikte kalır (T138 çözümü).
- Yasal sayfalarda (TR+EN, cerez/privacy) dört madde KORUNUR: 'Anonim oynanma sayımı', 'Oyun puanları ve canlı sayaç', zp.canli.off, zp.pwa.kapat. Hiçbiri silinmez; tarih çakışırsa yenisi. Dalın T82/T84 metni (EEA/UK/CH + ABD dışında pencere yok, 'meşru menfaat' yazılmaz) korunur.
- Doğrula: python3 portal/check_ads.py PASS (--release FAIL beklenen); çakışma işareti yok.
- Rapor: dal ucu hash, çakışan dosyalar ve çözüm, check_ads sonucu; Koordinasyon'a değil bana kokpit send ile 4 satır.
