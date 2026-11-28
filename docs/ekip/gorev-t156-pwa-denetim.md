KALICI NOT / SONRAKİ MERGE DENETİMİ — Koordinasyon T156 (yayın yok)
1) Yasal kaynaklar: PC masası dalga-c78 çerez sayfasının 'Zorunlu: yerel depolama' listesine 'zp.pwa.kapat' ekler (uygulama-ekle şeridini kapatma tercihi; kişisel veri yok). adsense-hazirlik'e origin/main merge edilirken KORUNACAK. Üç önceki madde de durur: sayım, puan/canlı sayaç, zp.canli.off. Hiçbiri silinmez; tarih çakışırsa yenisi.
2) PWA service worker origin/main'e girdiğinde (şu an 499aaf7..3af9e5d'de YOK; zepleron-website-adsense'ta sw/serviceWorker yok) denetçi kontrol eder:
   a. SW'nin fetch/precache/runtime-cache kurallarında pagead2.googlesyndication.com, googleads.g.doubleclick.net, googletagservices, adservice.google.*, fundingchoicesmessages.google.com, portal reklam/rıza betikleri (ads/consent js) ÖNBELLEĞE ALINMIYOR; cross-origin istekler ağdan geçiyor (respondWith yok ya da network-only).
   b. HTML'deki adsbygoogle.js ve rıza (CMP) betik etiketleri SW kapsamından etkilenmiyor; çevrimdışı iken reklam alanı boş kalıyor, sayfa kırılmıyor.
   c. SW önbellek sürümü: yeni deploy'da eski reklam/rıza içeriği takılı kalmıyor (skipWaiting/clients.claim ya da sürümlü cache adı).
   d. kanıt: grep sonucu + Chrome DevTools/Playwright ile Application>Cache Storage içeriği (reklam alan adı yok).
Rapor: ~/projects/reports/zepleron-adsense-denetim-20261121/rapor.md '## T156 PWA SW' bölümü; son satır VERDICT PASS/FAIL.
