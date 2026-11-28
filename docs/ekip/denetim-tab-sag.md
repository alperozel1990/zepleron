DENETİM İSTEĞİ — oyun kabuğundaki Ana sayfa/Kapat düğmeleri (yayın öncesi kapı)

Depo: ~/projects/zepleron-website (kendi ayrı worktree'nde çalış; paylaşılan klonu değiştirme).
Aralık: origin/main (db9c746) .. origin/tab-sag (08207a1) — tek commit.
Sahip isteği (20 Kas): telefonda oyun açıkken sol kenarda yüzen Ana sayfa (ev) ve Kapat (x) düğmeleri D&D'de zar panelinin
üstüne biniyordu → "biraz küçült, sağ kenara taşı; 6 oyunda dikey+yatay çakışma olmasın; dokunma alanı ≥48 dp kalsın; güvenli
alanı (çentik) gözet".

Yapılan:
- site/assets/portal/portal.css (.stage__tabs / .stage__tab): varsayılan sağ kenar %50; boyanan kısım düğme başına ~30x44 px
  (::before), dokunma kutusu 48x48 px; --left ve --pbottom (yalnız dikeyde alt orta, ikonlar 90° dönük) varyantları;
  .is-full altında safe-area (right / left / bottom).
- portal/games.json: oyun başına "shell": dicedecks {"top":32,"top_portrait":57}, snowyslide {"side":"left","top":56}
  (sağ kenarında ilerleme çubuğu var), buynumbers {"side_portrait":"bottom"} (dikeyde oyun kendini yan çeviriyor, sağ kenar
  rakip panelleriyle dolu). Diğerleri varsayılan.
- portal/build.py: shell → sınıf + style="--tab-top:..;--tab-top-p:.." (.stage__tabs üzerinde).
- site/: build.py çıktısı (portal.css ?v= özeti değişti).
Kanıtlarım: ~/projects/reports/zepleron-tab-sag-20261120/ — gerçek telefon (Opera): son-dicedecks.jpg, son-snowy-btn.jpg,
oyun-burnnotice-2.jpg, oyun-quiver-1.jpg, oyun-aspava-2.jpg (son üçü 34 px genişlikli ilk sürümle, konum aynı); yatay
emülasyon (headless 915x412): yatay-6oyun.jpg, yatay-dicedecks.jpg. Ölçüm: her .stage__tab getBoundingClientRect 48x48.

Bakmanı istediklerim:
1. CSS doğruluğu: seçici özgüllüğü/sıra (--pbottom ve --left, .is-full safe-area kurallarını gerçekten eziyor mu), masaüstü
   tam ekranda (#frame:fullscreen) görünüm, klavye odağı (focus-visible) hâlâ görünür mü, dokunma kutusu 48x48 mi,
   boyanan alanın kontrastı (beyaz ikon / .62 siyah).
2. Satır içi style: portal sayfalarının CSP'si (site/deploy/nginx/portal-page.conf style-src) style="" özniteliğine izin
   veriyor mu; build.py'de int() ile yüzde dışında değer sızabilir mi.
3. build.py çıktısı güncel mi (python3 portal/build.py → git status boş), games.json geçerli mi, dokunulmaz yollar
   (site/*/play/, */privacy.html, */support.html, ads.txt, app-ads.txt, robots.txt) değişmemiş mi.
4. Bilinen kalanlar (yayın engeli mi, karar ver): (a) Bank of Aspava tam genişlik kaydırmalı arayüz, sağ ortadaki düğme
   içerik kenarına ~15 px biniyor (eskiden sol kenarda aynıydı); (b) Snowy Slide yatay tutulursa (oyun "dikey" beyanlı)
   menüde soldaki Karakter/Görevler düğmelerine kısmen biniyor — eski konumda da öyleydi; (c) D&D ve Snowy yatay oyun içi
   görüntü telefonda doğrulanamadı (headless'ta WebGL yok) = UNKNOWN.

Kısa rapor: bulgular (dosya:satır), yayın engeli olan/olmayan ayrımı. Son satır: VERDICT: PASS ya da VERDICT: FAIL
