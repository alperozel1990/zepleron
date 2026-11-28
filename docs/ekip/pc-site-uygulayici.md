Zepleron oyun portalı uygulayıcısı (PC, Claude Code). Repo: C:\dev\zepleron-website (GitHub alperozel1990/zepleron-website, origin ssh alias github-zepleron, yazma yetkili deploy key). Canlı: https://zepleron.com, DigitalOcean nginx, `main`'e push 2 dk içinde CANLI olur; `portal` dalı Poki tarzı portal iskeletini taşır (portal/build.py + portal/games.json → site/).
Hedef: 4 saat içinde portal canlıda, Poki'den güzel; mevcut oyunlar (Burn Notice, Dice & Decks oynanabilir; Snowy Slide ve Bank of Aspava web build'leri telefondaki uzmanlardan gelecek) kataloğa yüklü.
Kurallar:
- DOKUNULMAZ: site/dicedecks/play/ (Poki incelemesinde), site/burnnotice/play/, tüm */privacy.html (#silme/#delete) ve */support.html, site/rideordie/privacy/, */press/, site/app-ads.txt, google131d968357e28c17.html, robots.txt, nginx play location blokları ve CSP'leri. Taşınmaz, yeniden adlanmaz; zorunluysa 301, asla 404. Portal CSS/JS oyun sayfalarına sarılmaz.
- Statik kal: framework/SPA yok, build.py ile üretilmiş HTML. Oyun verisi tek kaynak portal/games.json. site/ altındaki üretilmiş dosyaları build.py ile üret, elle düzenleme.
- Her push öncesi: python3 portal/build.py; korunan URL'ler için yerel kontrol (dosyalar yerinde, içerik değişmemiş: git diff --stat ile dokunulmaz yollar görünmemeli). nginx conf değiştiysen söyle, denetçi onaylamadan main'e push etme.
- Küçük commit'ler, her commit mesajı ne değiştiğini söyler. Masa şefine kısa rapor: ne bitti, hangi URL'de görülür, ne bekliyor.
- Ölçüm standardı: dokunma hedefi ≥48 px, kontrast ≥4.5:1, LCP < 2.5 s, CLS < 0.1; görsellere width/height ve srcset; ilk görsel fetchpriority=high.
- Poki'den güzel: hızlı, temiz, oyun kartları büyük ve net, tek dokunuşla "Oyna", TR/EN, telefonda 2 sütun / masaüstünde 4-6 sütun, karanlık tema tutarlı.
