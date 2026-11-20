Masa şefi → PC orkestratörü: Paket 5 GERÇEK TELEFON kontrolü (Samsung S24 FE 1080x2340, Opera, portal dalı d9da768 yerel sunum). Görüntüler telefonda ~/projects/reports/zepleron-bulgular-20261116/telefon-paket5/01..10 (scp phone:projects/reports/zepleron-bulgular-20261116/telefon-paket5/ .)

GEÇTİ
- Üst bar (logo, kategori, ara, EN, hesap) ve tek büyük kart + ortada ▶ + ad/geliştirici: görüntü 01. Kartta video yok (dosya yok), poster doğru.
- Oyun sayfası telefon düzeni: kapak + Oyna, alt bar (favori, bildir, ana sayfa), içerik: 04.
- Oyna → tam ekran kabuk gerçekten tam ekran (adres çubuğu yok), sol kenarda ev + kapat sekmesi: 06. Android Back → tam ekrandan çıkıp oyun sayfasına dönüyor, oyun kutuda kalıyor: 07. Ana sayfaya Back: 05.
- Arama: büyüteç → alan açılıyor, klavye geliyor, alan klavyenin üstünde: 09. Back önce klavyeyi kapatıyor (sistem), arama katmanı açık kalıyor (ikinci Back kapatmalı; kontrol etmedim): 10.
- Yakında rozetleri, Mobil beta rozeti okunaklı: 02, 08.

SORUN / SORU
1. ALT ŞERİT HİÇ GÖRÜNMEDİ (08): Burn Notice'i tam ekranda açıp çıktıktan sonra ana sayfaya dönüp kartın çok altına kaydırdım; şerit yok. Olası nedenler: (a) 'son oynanan' yalnız SDK/sunucu kaydıyla set ediliyor (yerel sunumda api CORS reddediyor) — localStorage'a da yazılmalı; (b) 'CMP seçimi yapılana kadar gösterme' kuralı CMP hiç yüklenmeyince (AB dışı, yerel) sonsuza kadar gizliyor — kural 'CMP açıkken gizle' olmalı, 'rıza yoksa gizle' değil; (c) eşik. Lütfen kök nedeni bulun; canlıda da aynı olur.
2. IZGARA 2 SÜTUN (02, 08): bu telefonda Opera varsayılan ayarlarla karolar 2 sütun, 6 karo 3 satır → (max-width:339px) kuralı tetikleniyor, yani Opera'nın bildirdiği CSS genişliği ≤339 px (zoom/yazı ölçeği). Gerçek cihazlarda bu sık olacak. Öneri: sabit 339 eşiği yerine karo genişliğini container query ile hesaplayın (3 sütun ancak karo ≥96 px olursa; 2 sütunda karo ≥140) — mevcut davranış bozuk değil ama sahibin 'Poki gibi 3 sütun' beklentisini karşılamayabilir; sahibe iki görünümün de hazır olduğunu söyleyin.
3. Oyun sayfasında ▶ ile gelince (#play) tam ekrana geçmemesi kabul (dokunuş gerekiyor); kapakta büyük 'Oyna' zaten belirgin.

KARAR: 1 çözülmeden main'e ALMIYORUM (şerit sahibin istediği özellik). Düzeltme commit'i gelince aynı sunumla yeniden bakarım (yerel sunucu açık: telefonda http://127.0.0.1:8765, dalı ben güncellerim). Denetim 14 (telefon denetçisi) ayrıca sürüyor.
