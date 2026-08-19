---
name: spec-coverage
description: Check that every acceptance criterion in a spec has at least one corresponding test. Reports uncovered criteria as a gap list. Use after to-spec and before implementation, or as a gate before calling work done.
---

Spec bilan testlar orasidagi bo'shliqni topasan. Kod sifatini baholamaysan —
faqat **qamrov**: har bir acceptance criteria uchun test bormi.

## Ish tartibi

1. Spec faylni top (`docs/specs/`, yoki foydalanuvchi ko'rsatgan joy).
   Topolmasang — so'ra, taxmin qilma.

2. Barcha acceptance criteria'larni ajratib ol. Odatda `AC-1`, `AC-2` ...
   ko'rinishida. Raqamlanmagan bo'lsa — o'zing raqamla va spec'ga
   raqamlarni yozib qo'yishni taklif qil.

3. Test fayllarini o'qi. Har AC uchun mos test qidir. Moslik belgilari,
   ishonchlilik tartibida:
   - Test nomida AC raqami bor (`AC-3`, `ac3`)
   - Test nomi AC ni tavsiflaydi
   - Test tanasi AC dagi shartni tekshiradi

4. Topilgan har bir test uchun **ikkinchi tekshiruv**: test AC
   *matnidagi* shartni tekshiryaptimi, yoki o'zi qo'ygan boshqa
   shartnimi?

   Ogohlantiruvchi belgilar:
   - Testda spec'da umuman yo'q qiymat ishlatilgan
   - Test o'zi yaratgan to'plamni tekshiradi (haqiqiy manba o'rniga)
   - AC "5 marta" desa, test 6 ni tekshiradi
   - Test nomi AC ga mos, tanasi esa boshqa narsani da'vo qiladi

   Bunday holatni **"nomuvofiq"** deb belgila — test mavjud bo'lsa
   ham qoplangan hisoblanmaydi. Farqni aniq yoz: AC nima deydi,
   test nimani tekshiryapti.

5. Jadval chiqar:

```
| AC | Tavsif | Test | Holat |
|----|--------|------|-------|
| AC-1 | to'g'ri parol bilan kirish | AuthServiceTest#loginWithValidPassword | ✓ |
| AC-2 | muddati o'tgan token | — | YO'Q |
| AC-4 | tarqalgan parol rad etiladi | PasswordTest#rejectsCommon | NOMUVOFIQ |
```

6. Qoplanmagan va nomuvofiq AC'lar uchun test **nomlarini** taklif qil — test kodini emas.
   Kod yozish `tdd` skill'ining ishi.

## Qoidalar

- **Faqat mavjud testlarni hisobga ol.** Rejadagi, izohga olingan yoki
  `@Disabled` / `skip` qo'yilgan test qoplama hisoblanmaydi.
- Bitta test bir nechta AC ni qoplashi mumkin — bu normal, ikkalasiga ham yoz.
- Bitta AC bir nechta testga bo'linishi mumkin — bu ham normal.
- **AC ning o'zi noaniq bo'lsa, buni aloqida ayt.** "Tizim tez ishlashi kerak"
  — bu AC emas, test yozib bo'lmaydi. Bunday qatorlarni "testlanmaydi"
  deb belgilab, spec'ni aniqlashtirishni taklif qil.
- Hech narsa yozmaysan va tuzatmaysan — faqat hisobot berasan.

## Chiqish

Oxirida bitta qator xulosa:

```
7 ta AC dan 4 tasi qoplangan, 1 tasi nomuvofiq, 1 tasi qoplanmagan, 1 tasi testlanmaydi.
```

Qoplanmagan yoki nomuvofiq AC bor ekan, ish "tayyor" hisoblanmaydi.
