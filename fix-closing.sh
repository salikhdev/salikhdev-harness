#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/salikhdev-harness"

echo "==> salikhdev-flow: yopish bosqichiga kirish nuqtasi"
python3 - << 'PY'
import pathlib, re
p = pathlib.Path("skills/salikhdev-flow/SKILL.md")
t = p.read_text()

# 1) Yopish bosqichini kuchaytirish
pat = re.compile(r"## 4 — yopish\n.*?(?=## flow-state\.md formati)", re.DOTALL)
if not pat.search(t):
    raise SystemExit("XATO: '## 4 — yopish' bo'limi topilmadi")

new = """## 4 — yopish

**Bu bosqich majburiy.** Oxirgi ish bosqichi (odatda `code-review`)
tugab, uning topilmalari yopilgach — darhol shu yerga o't. Foydalanuvchi
so'ramaydi, sen o'zing boshlaysan. `code-review` tugadi degani ish
tugadi degani emas.

Tartib:

1. Yakuniy darvoza: tekshiruv buyruqlarini oxirgi marta ishga tushir
   va natijani ko'rsat.

2. `docs/agents/misses.md` ni och va **o'zing to'ldir**. Foydalanuvchidan
   so'rab kutma — sen bu ishda nima bo'lganini eslaysan, u eslamaydi.

   Yoziladigan narsa: "tayyor" deb belgilangandan keyin topilgan har
   bir muammo. Manbalar:
   - `code-review` topgan hamma narsa (u ta'rifi bo'yicha "tayyor"
     dan keyin ishlaydi)
   - Darvoza yiqilgan holatlar
   - Talqin hisobotida chiqqan, keyin noto'g'ri bo'lib chiqqan qarorlar
   - Sen o'zing yo'l-yo'lakay tan olgan xatolar

   Har yozuv uchtala ustunni to'ldirsin. Uchinchisi — "qaysi darvoza
   uni tutishi kerak edi" — eng muhimi; uni tashlab ketma.

   Yozib bo'lgach foydalanuvchiga ko'rsat va so'ra: sen bilmagan,
   qo'shilishi kerak bo'lgan narsa bormi?

3. Naqshni tekshir: `misses.md` da bitta bosqich uch va undan ko'p
   marta takrorlangan bo'lsa, buni alohida ayt — bu skill tuzatishga
   asos.

4. `flow-state.md` ni tozala.

5. Yakuniy xulosa: qaysi yo'ldan yurildi, nechta AC bor edi, nechtasi
   test bilan qoplandi, qaysi darvozalar o'tdi, `misses.md` ga nechta
   yozuv qo'shildi.

Beshtasi ham bajarilmaguncha ish yopilgan hisoblanmaydi.

"""

t = pat.sub(new, t, count=1)

# 2) Yurgizish bo'limiga eslatma
anchor = "**Bosqichlar avtomatik zanjirlanmaydi.**"
if anchor not in t:
    raise SystemExit("XATO: yurgizish bo'limi topilmadi")

t = t.replace(anchor,
  "Oxirgi ish bosqichi tugagach to'xtama — 4-bosqich (yopish) qoladi va\nu majburiy.\n\n" + anchor, 1)

p.write_text(t)
print("   salikhdev-flow yangilandi")
PY

echo "==> Tekshirish"
grep -n "Bu bosqich majburiy\|o'zing to'ldir\|Beshtasi ham" skills/salikhdev-flow/SKILL.md

echo "==> Commit"
git add -A
git commit -m "fix: yopish bosqichi majburiy qilindi, misses.md ni agent to'ldiradi"

echo
echo "Tayyor. git push qiling."
