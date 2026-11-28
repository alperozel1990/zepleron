DENETİM (salt okur, KISA) — adsense-hazirlik 0461019 (LCP düzeltmesi: reklam adaptörü <head>'den çıkarıldı, portal.js load sonrası boşta yüklüyor). git fetch; fark 612f1d6..origin/adsense-hazirlik. Rapor: ~/projects/reports/zepleron-adsense-hazirlik-20261121/rapor-lcp.md
1. Kod: adaptör geç yüklenirken rıza kararı/push sırası bozulmuyor mu (adaptör gelmeden önce push/etiket/pauseAdRequests yarışı; Kabul'e basılırsa adaptör henüz yüklenmediyse ne oluyor; noads yolu).
2. Davranış regresyonu (vm testi tekrar): T73 senaryoları (TR seçim yok→istek 0; Kabul→npa yok; Reddet→0; ABD→pencere yok; belirsiz→pencere; AEA taklidi), tek push/birim, CLS 0.
3. Ana sayfa LCP: aynı telefonda main fc4b67f vs dal, 390×844 CPU 4x Fast 4G, 3×3; dal−main ≤+100 ms ve mutlak ≤1,5 sn mı. Ölçütün kendi kendine gevşetilmediğini rapordan teyit et. Aspava = T63 tabanı (ayrı satır).
4. check_ads.py + build temiz; dokunulmaz yollar boş.
Çıktı: rapor.md'ye "## T74 LCP denetimi" bölümü, son satır VERDICT: PASS/FAIL.
