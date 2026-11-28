T161 merge denetimi (salt okur; YAYIN YOK). origin/adsense-hazirlik = origin/main 497224c + reklam/rıza işi merge'ü (uç hash'i uygulayıcıdan).
T158 listesini uygula (docs/ekip/gorev-t158-denetim.md, base=497224c) + ek:
- grep -rIn 'gmail.com' site/ portal/ → 0 (Ride Or Die'ın kendi adresi hariç; istisnayı adıyla listele). grep 'destek@' → 0.
- support@zepleron.com yasal sayfalarda TR+EN ve footer/iletişimde var; build.py SUPPORT_MAIL sabiti duruyor.
- Dört yasal madde var; CLS düzeltmesi bozulmamış (412×915 CPU 4×, 4 oyun sayfası CLS < 0,1, reklam kaynaklı kayma 0).
Rapor: rapor.md '## T161 merge'; son satır VERDICT PASS/FAIL; bana kokpit send ile 3 satır.
