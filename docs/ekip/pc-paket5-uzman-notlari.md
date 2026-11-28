Masa şefi → PC orkestratörü: Paket 5 (G10 telefon ana sayfası + G11 alt şerit) için layout, responsive ve AdSense uzmanlarının birleşik notları. Tasarım ONAY; aşağıdakiler düzeltme/koşul.

KARO IZGARASI
- 360 px'te 3 sütun, karo ~104 px (16 px kenar, 8 px aralık). 340 px altında 2 sütuna düş ya da karo ≥96 px kalsın. Karo tamamen tıklanabilir; ad yazmadığı için alt + aria-label ŞART. Rozet ≥11–12 px, kontrast 4.5:1.
- Üst bar ikonları ≥48×48 px + aria-label; "Ara" büyüteç. Popüler/Yeni ikonları yeterli oyun olana kadar yok.

ÖNE ÇIKAN KART + VİDEO
- LCP = videonun poster görseli: fetchpriority=high, width/height, webp/avif ≤60 KB. Video preload=none, muted, playsinline; ilk boyamadan sonra bağlan.
- Hover değil görünürlük: IntersectionObserver, kart ≥50–60 % görünürken oynat; görünmeyince ve visibilitychange'de durdur; aynı anda tek video; Save-Data, prefers-reduced-motion, 2g/3g'de video hiç bağlanmasın.
- Kartın tamamı ve ortadaki ▶ aynı hedefe (oyun sayfası/oynat); ▶ ≥56–64 px.

ALT ŞERİT (son oynanan)
- position:fixed + transform ile gir/çık (CLS yok); gövdeye baştan şerit yüksekliği + env(safe-area-inset-bottom) kadar padding-bottom (altbilgi linkleri şeridin altında kalmasın). Göster/gizle eşiğine 8–16 px tolerans (titreme yok). reduced-motion'da animasyonsuz.
- Yükseklik 56–64 px, mobil ekranın ≤%15'i. Son oynanan oyun yoksa gösterme. ▶ ≥48 px ve oyunu başlatır; geri kalanı oyun sayfasına gider; ikisi arasında ≥8 px.
- Klavye: metin alanı odaktayken ya da visualViewport yüksekliği %75'in altına / 150 px'ten fazla düşünce gizle.
- CMP: rıza seçimi yapılana ve mesaj açıkken şerit HİÇ görünmesin; z-index CMP'nin altında. Test: ?fc=alwaysshow&fctype=gdpr.
- Telefon yatay (yükseklik <500 px): şerit 48 px ya da gizli. Oyun sayfasında oyun tam ekran/oynarken asla görünmesin; yalnız oyun kutusu ekrandan çıkınca.
- Tarayıcı geçmişine kayıt eklemesin.

ANDROID BACK
- Arama/kategori/hesap katmanları history.pushState ile açılsın; Back önce katmanı kapatsın. Tam ekran oyunda Back → oyun sayfası. Ana sayfada Back engellenmesin. bfcache açık kalsın (unload dinleyicisi yok).

ADSENSE (uyumluluk uzmanı: engel yok, koşullu)
- Şerit reklama benzemesin ("Sponsorlu/Reklam" etiketi, reklam çerçevesi yok). İleride reklam birimi eklenirse şeride bitişik olmasın (≥150 px kural: support.google.com/adsense/answer/1346295, /2768340).
- Anchor (yapışkan) reklam AÇILMASIN; açılırsa yalnız üstte. Auto ads şu an kapalı, sorun yok.
- Şerit CMP düğmelerini örtmesin (yukarıdaki CMP maddesi).

KANIT (kabul için)
- uiq lint + uiq probe; 360 ve 412 px dikey/yatay + klavye açıkken ekran görüntüleri; Lighthouse LCP <2.5 s, CLS <0.1. PC PASS sonrası gerçek telefonda son kontrolü ben yapacağım (yerel sunum).
