DENETİM (salt okur) — adsense-hazirlik yeni commit'leri cc34f43, 3d9ab44 (Koordinasyon T95: NPA rıza sinyaline bağlı, varsayılan NPA)
`git fetch origin`; fark: 8c6e06a..origin/adsense-hazirlik. Uygulayıcı raporu: ~/projects/reports/zepleron-adsense-hazirlik-20261121/rapor-npa-riza.md
1. Kod incelemesi (portal.js, zepleron-ads.js): rıza fonksiyonu her push ÖNCESİ okunuyor mu; sinyal yok/hata/zaman aşımı → NPA=1 (güvenli varsayılan); TCF amaç 1,3,4 + 2,7,9,10 (rıza/meşru menfaat) + Google satıcı 755 kriteri Google dokümanıyla uyumlu mu (doğrulayamazsan UNKNOWN); rıza sonradan gelince eski birim yeniden push EDİLMİYOR (tek push); etiket erken yüklenmiyor (T63).
2. check_ads.py yeni kuralı: negatif test (rıza mantığı silinirse FAIL) çalışıyor mu; build temiz; --release yer tutucuda FAIL.
3. Bağımsız ölç (sahte __tcfapi): API yok→npa=1; rıza yok→1; rıza var→0; sonradan rıza→eski birim yeniden push yok; CLS 0; LCP kabaca ≤2 sn.
4. Gizlilik/çerez metni ve dokunulmaz yollar hâlâ değişmemiş mi.
5. Sahibin kararı: ilk ekran kuralı kabul (H1/G1 gizlenmesi FAIL DEĞİL).
Çıktı: önceki rapora "## T95 yeniden denetim" bölümü ekle (~/projects/reports/zepleron-adsense-denetim-20261121/rapor.md), son satır VERDICT: PASS/FAIL.
