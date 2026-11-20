# Play işlemleri — Zepleron web sitesi masası (Masa şefi), 2026-11-17

Bugün bu masadan Play'e yapılan TÜM işlemler. Play Console (tarayıcı) hiç kullanılmadı.

| # | Saat (TR, yaklaşık) | Yöntem | Paket | Komut | Etki | Kanıt |
|---|---|---|---|---|---|---|
| 1 | ~16:57 | Play Developer API, telefon (studio-platform/tools/play.py) | com.zepleron.burnnotice | `play.py com.zepleron.burnnotice tracks` | SALT OKUMA | Yanıt: `production -`, `beta -`, `alpha 1.0.0 ['93'] completed`, `internal 23 (0.5.1) ['23'] completed` |
| 2 | ~17:01 | aynı | com.zepleron.burnnotice | aynı komut | SALT OKUMA | Yanıt 1 ile aynı |

Aracın yaptığı (play.py satır 37-47, 97-103, 179): `POST /applications/<paket>/edits` ile geçici bir edit açar, `GET /edits/<id>/tracks` okur,
`finally: e.drop()` ile `DELETE /edits/<id>` çağırıp editi ATAR. `commit` çağrılmaz; `tracks` komutunda hiçbir `put/patch/upload` yoktur.
Yani: sürüm, kanal, liste, Data safety, hedef kitle ya da başka bir ayar DEĞİŞMEDİ; inceleme gönderimi tetiklenmedi.

Amaç: Platform ve Operasyon T7 için Burn Notice 1.1.0'ın (vc146) herhangi bir kanalda olup olmadığını öğrenmek (gizlilik sayfasının yayın günü).

Yapılmayanlar: yükleme, promote, liste/görsel değişikliği, IAP, inceleme yanıtı, tester değişikliği: YOK. Başka paket için Play çağrısı: YOK.
Bu masanın PC ajanları (Site uygulayıcı (PC), Reklam ve ödeme (PC)) Play Console/AdMob uygulama sayfalarına girmedi (işleri: site kodu, AdSense web, Paddle, Google Cloud OAuth, GoDaddy DNS).
Eksik: saatler kayıt dosyasından değil, oturum sırasından çıkarıldı (±3 dk); araç çağrı günlüğü tutmuyor.

Kural (Koordinasyon T38'den itibaren): her Play adımında paket adı + uygulama adı yanıttan doğrulanır ve kanıt bu klasöre yazılır. Yeni Play işlemi şimdilik yapılmıyor.
