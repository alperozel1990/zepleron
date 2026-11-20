T-QUIVER-WEB (Masa şefi, Zepleron web sitesi; sahip kararı 19 Kas: reklam zepleron.com'a yapılacak, Quiver portala eklenecek. Koordinasyon T54)

HEDEF: Quiver'ın tarayıcı sürümü https://zepleron.com/quiver/play/ adresinde, telefonda (dikey + yatay) ve masaüstünde sorunsuz. Kaynak ~/projects/letgo (ts/src → ts/www). Çıktı: ~/projects/zepleron-website reposu, site/quiver/play/ (YALNIZ bu dizin). Telefonda ağır derleme yok (esbuild yeter).

ÇALIŞMA ŞEKLİ (ortak klonu bozma): cd ~/projects/zepleron-website && git fetch origin && git worktree add ~/projects/zepleron-website-quiver -b quiver-web origin/main ; orada çalış; 'git add site/quiver/play' (açık yol) → commit → git push origin quiver-web. main'e ve portal'a push ETME. İş bitince worktree'yi kaldır.

ŞARTLAR
1. Paket: index.html + game.js + art/ + fonts/ ; inline <script> YOK (site CSP script-src 'self'; Snowy Slide'daki boot.js kalıbı: site/snowyslide/play/), dış kaynak yok, .map / dev / test dosyası yok, __TEST__=false. Boyut hedefi ≤3 MB; raporla.
2. Ekran: viewport-fit=cover, height:100dvh, safe-area. Oyun yatay tasarlandı: telefonda DİKEY tutulunca da oynanabilir olmalı (tercih: dikey düzen; olmuyorsa Burn Notice'teki gibi net 'telefonu çevir' ekranı, ama o zaman bunu açıkça raporla). Masaüstünde kutu boyutları 890x501 ve 1356x763'te kesilme/kaydırma yok. Dokunma hedefleri ≥48 px (fareli ekranda ≥24 px), metin ≥12 px. ui-standard skill'ini oku; uiq lint.
3. Sunucu: web derlemesi host sırası 'q.zepleron.com' sonra '158-180-58-125.sslip.io' (reklam engelleyici DNS'ler sslip.io'yu engelliyor; q.zepleron.com Caddy'de hazır, DNS kaydı ayrıca açılacak; ad çözülmezse yedeğe düşmeli; Burn Notice web'deki kalıp: burnnotice2 Zn host listesi). Yalnız public istemci anahtarı; başka sır yok.
4. Portal SDK (aynı origin, /assets/portal/zepleron-sdk.js; belge ~/projects/zepleron-website/portal/sdk/README.md): index.html'de <script src="/assets/portal/zepleron-sdk.js"> ; açılışta Zepleron.init('quiver') (hata verirse oyun yine çalışır); maç başında Zepleron.track('play_start',{gameId:'quiver'}), maç sonunda 'play_end'. Oyuncu adı boşsa Zepleron.profile().name kullanılabilir.
5. Reklam molası (şimdilik etkisiz kanca): maç SONU ekranından yeni maça geçerken ve yalnız orada: `if (window.Zepleron && Zepleron.showInterstitial) await Zepleron.showInterstitial('next')` ; ödüllü token varsa `Zepleron.showRewarded` aynı kalıp. SDK'da bu fonksiyonlar henüz yok; çağrı özellik algılamalı olsun, reklam yokken oyun akışı değişmesin. Oyun sırasında (el ortasında) reklam çağrısı YOK. AdMob/Play Billing kodu web paketine girmez.
6. Botlar: stüdyo multiplayer standardı §5 botların etiketlenmesini ister ('Bot' rozeti); web sürümünde botlar gerçek oyuncu adıyla ETİKETSİZ görünüyorsa bunu raporunda AÇIKÇA yaz (değiştirme kararı sahipte; sen yalnız bildir).
7. Mağaza/iOS/Android derlemelerine ve Play Console'a DOKUNMA.

DOĞRULAMA (görüntülere gerçekten bak): headless Chromium (WebGL gerekmiyor) 390x844 dikey, 844x390 yatay, 890x501, 1356x763: ana menü → hızlı oyun → bir el oynanıyor → maç sonu; JS hatası 0, CSP ihlali 0 (test sayfasına katı CSP meta ekleyerek). gametest köprüsü varsa 20 seed duman. Görüntüler ~/projects/reports/quiver-web/.

RAPOR: commit hash, git show --stat, boyut, hangi hostlara bağlanıyor (nginx CSP connect-src için tam liste: https + wss), dikeyde ne yaptın, bot etiketi durumu, ölçülemeyenler UNKNOWN. Süre hedefi 3 saat.
