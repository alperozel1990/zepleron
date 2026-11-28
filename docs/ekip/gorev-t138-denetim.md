KISA DENETİM (salt okur, YAYINDAN ÖNCE PASS; yayın sahip kararı + AdSense birimleri bekliyor) — Koordinasyon T138
origin/adsense-hazirlik @ 78eef3e = origin/main (499aaf7: SEO + Faz A + sayaç) birleştirilmiş (rebase yerine tek merge commit: 17 commit'lik dalda tek çakışma çözümü).
Kaynak çakışma yalnız portal/build.py (~satır 888): main'in ld_json listesi + dalın head(..., ads=has_ads) argümanı birlikte tutuldu. site/** üretilmiş HTML çakışmaları ELLE birleştirilmedi; python3 portal/build.py ile yeniden üretildi.
Doğrula:
1. `git merge-base origin/main origin/adsense-hazirlik` = 499aaf7; `git diff origin/main origin/adsense-hazirlik --stat` yalnız reklam/rıza işi + yasal sayfa metinleri (T82) + üretilmiş çıktı; main'in SEO/SSS/FAQPage/foot_stores/sayaç içeriği KORUNMUŞ (oyun sayfalarında FAQPage ld+json; yasal sayfada 'Anonim oynanma sayımı').
2. `python3 portal/build.py` sonrası git status temiz; `python3 portal/check_ads.py` PASS (1 uyarı yer tutucu); `--release` FAIL (beklenen).
3. Kendi pencere / zp_consent / pauseAdRequests YOK (T82 hâli bozulmamış); reklam birimleri, ilk ekran, 150 px kuralı kodu bozulmamış; portal.js'te sayaç kodu duruyor, çakışma işareti hiçbir kaynakta yok.
4. İki oyun sayfasında (D&D + Aspava) 412×915 hızlı ölçüm: ilk ekranda birim 0, CLS 0.
Çıktı: ~/projects/reports/zepleron-adsense-denetim-20261121/rapor.md'ye '## T138 merge (78eef3e)' bölümü, son satır VERDICT PASS/FAIL; bana kokpit send ile 3 satır.
