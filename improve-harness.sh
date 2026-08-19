#!/usr/bin/env bash
set -euo pipefail

HARNESS="$HOME/salikhdev-harness"
cd "$HARNESS"

echo "==> 1. salikhdev-flow: talqin hisoboti qo'shilyapti"
python3 - << 'PY'
import pathlib
p = pathlib.Path("skills/salikhdev-flow/SKILL.md")
t = p.read_text()

anchor = "## 3 — darvozalar"
if anchor not in t:
    raise SystemExit("XATO: '## 3 — darvozalar' topilmadi")

new = """### Talqin hisoboti

Har bosqich oxirida, darvozadan oldin, o'zingdan so'ra: bu bosqichda
AC yoki spec matni noaniq bo'lgani uchun talqin qilishga to'g'ri
keldimi?

Bo'lsa — ro'yxat qilib ko'rsat, har biri uchun uchta narsa: AC raqami,
matn yana qanday o'qilishi mumkin edi, sen qaysi talqinni olding va
nega.

Foydalanuvchi tasdiqlamaguncha bosqich tugallangan hisoblanmaydi.
Talqinni jimgina qabul qilib davom etish — qoida buzilishi, keyin
`misses.md` ga tushadigan xato.

Talqin bo'lmasa, "talqin qilinmadi" deb bir qator yoz — bu ham
ma'lumot.

## 3 — darvozalar"""

p.write_text(t.replace(anchor, new, 1))
print("   salikhdev-flow yangilandi")
PY

echo "==> 2. spec-coverage: matn muvofiqligi tekshiruvi qo'shilyapti"
python3 - << 'PY'
import pathlib
p = pathlib.Path("skills/spec-coverage/SKILL.md")
t = p.read_text()

anchor = "4. Jadval chiqar:"
if anchor not in t:
    raise SystemExit("XATO: '4. Jadval chiqar:' topilmadi")

new = """4. Topilgan har bir test uchun **ikkinchi tekshiruv**: test AC
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

5. Jadval chiqar:"""

t = t.replace(anchor, new, 1)

# Keyingi raqamlarni surish
t = t.replace("5. Qoplanmagan AC'lar uchun test **nomlarini**",
              "6. Qoplanmagan va nomuvofiq AC'lar uchun test **nomlarini**", 1)

# Jadval ustunini yangilash
t = t.replace("| AC-2 | muddati o'tgan token | — | YO'Q |",
              "| AC-2 | muddati o'tgan token | — | YO'Q |\n| AC-4 | tarqalgan parol rad etiladi | PasswordTest#rejectsCommon | NOMUVOFIQ |", 1)

# Xulosa qatorini yangilash
t = t.replace("7 ta AC dan 5 tasi qoplangan, 1 tasi qoplanmagan, 1 tasi testlanmaydi.",
              "7 ta AC dan 4 tasi qoplangan, 1 tasi nomuvofiq, 1 tasi qoplanmagan, 1 tasi testlanmaydi.", 1)

t = t.replace("Qoplanmagan AC bor ekan, ish \"tayyor\" hisoblanmaydi.",
              "Qoplanmagan yoki nomuvofiq AC bor ekan, ish \"tayyor\" hisoblanmaydi.", 1)

p.write_text(t)
print("   spec-coverage yangilandi")
PY

echo "==> 3. salikhdev-spring-boot: test qatlami qoidasi"
python3 - << 'PY'
import pathlib
p = pathlib.Path("skills/salikhdev-spring-boot/SKILL.md")
t = p.read_text()

anchor = "- Test ma'lumotlari — builder/fixture klasslar orqali."
if anchor not in t:
    raise SystemExit("XATO: test bo'limi topilmadi")

new = """- Test ma'lumotlari — builder/fixture klasslar orqali.

**Qaysi qoida qayerda testlanadi.** Domen metodida yashaydigan qoida
domen unit testida tekshiriladi — HTTP orqali emas. `@SpringBootTest`
faqat qatlamlar orasidagi oqim uchun: so'rov keldi, saqlandi, javob
qaytdi. Qoidaning o'zi (chegara qiymatlar, rad etish shartlari,
holat o'zgarishi) domen testida.

O'lchov: agar domen unit testlari soni butun test to'plamining
ozchiligi bo'lsa, qoidalar noto'g'ri qatlamda testlanyapti. Domen
va entity ajratilgani aynan shu tez, izolyatsiyalangan testlar uchun
— aks holda ajratishning narxi to'lanadi, foydasi olinmaydi."""

t = t.replace(anchor, new, 1)

anchor2 = "- Domen qoidasini service ichida takrorlash (domen metodi bor turib)"
if anchor2 not in t:
    anchor2 = "- Biznes qoidasini service ichida takrorlash (domen metodi bor turib)"
if anchor2 not in t:
    raise SystemExit("XATO: ta'qiqlar ro'yxati topilmadi")

p.write_text(t.replace(anchor2, anchor2 + "\n- Domen qoidasini `@SpringBootTest` orqali testlash", 1))
print("   salikhdev-spring-boot yangilandi")
PY

echo "==> 4. Tekshirish"
grep -n "Talqin hisoboti" skills/salikhdev-flow/SKILL.md
grep -n "nomuvofiq\|NOMUVOFIQ" skills/spec-coverage/SKILL.md | head -4
grep -n "@SpringBootTest orqali testlash\|Qaysi qoida qayerda" skills/salikhdev-spring-boot/SKILL.md

echo "==> 5. Commit"
git add -A
git commit -m "fix: misses.md naqshlari bo'yicha uchta tuzatish (talqin hisoboti, test muvofiqligi, domen test qatlami)"

echo
echo "Tayyor. git push qilishni unutmang."
