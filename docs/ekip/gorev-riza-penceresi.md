GÖREV (Koordinasyon T89 EK / Gelir T97 + Uyum D19) — Kendi rıza penceremiz + "rıza yoksa reklam yok", dal adsense-hazirlik (yeni commit), YAYIN YOK

OKU: ~/projects/studio-ops/docs/gelir/adsense-yerlesim-kurallari.md kural 12 (5e90935), docs/gelir/t94/riza-yapisi.md (özellikle §7), docs/gelir/zepleron-uygulama-listesi.md madde 2 kabul ölçütleri. T69 kodu: zepleron-ads.js `ZepleronConsent`, portal.js push yolu, check_ads.py. Sitede zaten alt şerit/dock, `.dock.is-cmp` ve gizlilik ayarlarında bir rıza düğmesi var: önce onları oku, sıfırdan kurma.

KURAL (son karar):
- AEA/BK/İsviçre: Google CMP (TCF) aynen; mevcut TCF yolu kalır.
- ABD: kendi pencere YOK; requestNonPersonalizedAds=0; opt-out'u AdSense eyalet mesajı yönetir.
- Türkiye ve diğer HER yer: kendi rıza penceremiz. "Kabul" = kişiselleştirilmiş (npa=0) ve görünür kutular push edilir. "Reddet" ya da SEÇİM YOK = `adsbygoogle.pauseAdRequests = 1`: reklam isteği 0, push yok, kutuda house promo, CLS 0. Rıza sonradan verilirse bekleyen kutular push edilir (tek push/birim korunur); sonradan geri alınırsa (#cmp-settings → Reddet) yeni istek yok.
- Rızasız NPA dalı KALDIRILSIN (T69'daki "AB dışı = NPA=1" yolu). 
- Bölge belirsizse pencere gösterilir (tutucu taraf). Bölge tespiti: önce sunucuda hazır geoip/başlık var mı bak (nginx geoip, Cloudflare vb.); yoksa istemci buluşsal (zaman dilimi + dil) ile "ABD kesin" tespit et, geri kalan her şey pencere. Hangi yöntemi seçtiğini ve yanılma riskini rapora yaz (ABD'li yanlışlıkla pencere görürse zararsız; TR'li yanlışlıkla ABD sayılırsa KVKK ihlali → ABD tespiti yalnız yüksek güvenle).
- Pencere (KVKK): ÖNCEDEN İŞARETLİ KUTU YOK; "Reddet" ile "Kabul" eşit görünürlük ve boyut (≥48 px, aynı stil ağırlığı); kaydırma/gezinme rıza sayılmaz; `#cmp-settings` bağlantısıyla geri alma/değiştirme; Esc/kapatma = seçim yok (reklam yok). Pencere oyun akışını ve dock'u bozmasın (ui-standard: 48 dp hedefler, kontrast ≥4.5:1, odak tuzağı/klavye, Android Back, TR+EN).
- Durum ZepleronConsent'e 3. kaynak: zp_consent.ads (localStorage/çerezsiz, sürüm + zaman damgası + dil). 
- Gizlilik ve çerez metni TR/EN: değişiklik gerekiyor. Bu metinler Uyum masasının alanı: metin taslağını yaz ama commit'ten ÖNCE 'Uyum ve Gizlilik Uzmanı'na kokpit ask ile onaylat (kısa, tek mesaj); onay gelmeden o dosyalara commit atma, kalan kodu commit'le. Rapora onay durumunu yaz.
- check_ads.py: yeni kuralı kontrol etsin (rızasız NPA dalı yok, pauseAdRequests yolu var, pencere öğeleri var; negatif test).

KABUL/ÖLÇÜM (headless; IP taklidi mümkün değilse bölge tespit girdisini taklit et ve bunu UNKNOWN değil "taklitle ölçüldü" diye yaz; gerçek IP/gerçek CMP UNKNOWN):
(a) TR + seçim yok: ads? isteği 0, kutular house promo, CLS 0. (b) Kabul → istekte npa yok (ya da 0); sonradan Kabul: bekleyen kutular push, eskiler yeniden push yok. (c) Reddet → istek 0. (d) ABD girdisi → pencere yok, npa yok. (e) Belirsiz bölge → pencere var. (f) AB (TCF taklidi) → T69 yolu bozulmadı. (g) LCP ≤1,5–2 sn, CLS 0, tek push/birim. (h) ui-standard: `uiq lint` + pencere hedef boyutları/kontrast ölçümü + telefonda (412×915) ve masaüstü ekran görüntüsü; ölçemediğini UNKNOWN yaz.
ÇIKTI: push'lu commit(ler), rapor ~/projects/reports/zepleron-adsense-hazirlik-20261121/rapor-riza-penceresi.md (5 satır özet + kanıt). Son satır DURUM: BİTTİ/DEVAM/ONAY GEREK/ENGEL.
