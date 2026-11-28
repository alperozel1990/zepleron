T159 (Koordinasyon) — adsense-hazirlik'i origin/main 72ccac4 üstüne BİRLEŞTİR (merge, rebase değil). YAYIN YOK, push yalnız adsense-hazirlik dalına.
Klasör: ~/projects/zepleron-website-adsense (dal ucu a6586f9). git fetch; git merge origin/main.
Beklenen çakışma: portal/build.py ve 404.html (kaynak/portal'daki karşılığı). build.py'yi ELLE çöz: main'in CLS/LCP düzeltmeleri + dalın ads=has_ads / G1 yerleşimi / yasal sayfa head(..., ads=False, kesif=False) birlikte kalır. Üretilmiş site/** HTML'i elle birleştirme: çakışanlarda main'i al, python3 portal/build.py ile yeniden üret; git status temiz.
Dört yasal madde TR+EN korunur: 'Anonim oynanma sayımı', 'Oyun puanları ve canlı sayaç', zp.canli.off, zp.pwa.kapat. T82/T84 reklam metni (pencere yok, 'meşru menfaat' yazılmaz) korunur. Tarih çakışırsa yenisi.
Doğrula: python3 portal/check_ads.py PASS (--release FAIL beklenen); çakışma işareti yok; main'in CLS/LCP düzeltmesi (oyun sayfası ilk ekran yerleşimi) reklam birimi eklenince bozulmuyor.
Rapor: dal ucu hash, çakışan dosyalar ve çözüm, check_ads; bana kokpit send ile 4 satır.
