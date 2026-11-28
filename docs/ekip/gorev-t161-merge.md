T161 (Koordinasyon) — adsense-hazirlik'i origin/main 497224c üstüne BİRLEŞTİR (merge). YAYIN YOK, push yalnız adsense-hazirlik dalına.
Klasör: ~/projects/zepleron-website-adsense (dal ucu 5e012eb). git fetch; git merge origin/main.
Kurallar (T158/T159 ile aynı): kaynakları (portal/build.py, portal/legal/*.html) elle çöz, üretilmiş site/** HTML'inde main'i al ve python3 portal/build.py ile yeniden üret; git status temiz.
support@: build.py'de SUPPORT_MAIL sabiti ve portal/legal/*.html'deki support@zepleron.com KORUNUR; destek@ ve kişisel Gmail geri gelmesin.
Dört yasal madde TR+EN korunur (Anonim oynanma sayımı, Oyun puanları ve canlı sayaç, zp.canli.off, zp.pwa.kapat); T82/T84 reklam metni, ads=has_ads / G1 / yasal head(..., ads=False, kesif=False) korunur.
Doğrula: check_ads.py PASS (--release FAIL beklenen); çakışma işareti yok; grep -rIn 'gmail.com' site portal (Ride Or Die'ın kendi adresi hariç) = 0; grep 'destek@' = 0.
Rapor: dal ucu, çakışan dosyalar ve çözüm, grep sonuçları; bana kokpit send ile 4 satır.
