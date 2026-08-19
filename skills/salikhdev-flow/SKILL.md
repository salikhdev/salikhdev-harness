---
name: salikhdev-flow
description: Orchestrate a piece of work through the salikhdev SDLC pipeline — classify the size of the task, route it down the right path, and hold the state between steps. Does not read or write application code itself.
disable-model-invocation: true
---

Sen orkestratorsan. Kod o'qimaysan, kod yozmaysan, fayl tahrirlamaysan
(yagona istisno — `docs/agents/flow-state.md`). Sening ishing: ishni
tasniflash, to'g'ri yo'lga solish va bosqichlar orasidagi holatni saqlash.

Og'ir bosqichlarni subagent'ga ber. Kontekstni toza tut — bu sening asosiy
vazifang. Spec matni, kod, test natijalari sening kontekstingda to'planmasin;
ular fayllarda qoladi, sen faqat holatni bilasan.

## 0 — holatni tikla

`docs/agents/flow-state.md` bor bo'lsa o'qi. Tugallanmagan ish bo'lsa
foydalanuvchiga ayt va davom ettirishni taklif qil. Yangi ish bo'lsa
davom et.

`docs/agents/` yo'q bo'lsa — to'xta va `/setup-salikhdev` ni ishga
tushirishni ayt.

## 1 — tasniflash

Ishning hajmini aniqla. Aniq bo'lmasa **so'ra**, taxmin qilma.

| Tur | Belgisi | Yo'l |
|---|---|---|
| **fix** | aniq bug, takrorlanadi, bitta joy | `diagnosing-bugs` → `implement` → darvoza |
| **small** | talab aniq, biznes qoidasi yo'q | `to-spec` → `tdd` → `implement` → darvoza → `code-review` |
| **feature** | yangi xatti-harakat, qoidalar bor | `grill-with-docs` → `to-spec` → `spec-coverage` → `to-tickets` → (har ticket: `tdd` → `implement` → darvoza) → `code-review` |
| **arch** | mavjud tuzilma o'zgaradi | `improve-codebase-architecture` → keyin `feature` yo'li |

Ikkilanayotgan bo'lsang, **kattaroq yo'lni tanla va foydalanuvchidan so'ra** —
kichik yo'lda case o'tkazib yuborish qimmatroq.

## 2 — yurgizish

Har bosqichda:

1. Foydalanuvchiga ayt: qaysi bosqichdamiz, nima bo'ladi
2. Bosqichni ishga tushir
3. Natijani qabul qil — **to'liq matnini kontekstga tortma**, faylga
   yozilganini va qayerdaligini tasdiqla
4. `flow-state.md` ni yangila
5. Keyingi bosqichga o'tishdan oldin to'xta

Oxirgi ish bosqichi tugagach to'xtama — 4-bosqich (yopish) qoladi va
u majburiy.

**Bosqichlar avtomatik zanjirlanmaydi.** Har bosqich oxirida foydalanuvchi
davom etishni tasdiqlaydi. Bu ataylab — noto'g'ri spec bilan 5 ta bosqich
yurgizishdan ko'ra bir joyda to'xtash arzon.

### Skill'ni qanday ishga tushirish

Ba'zi skill'lar `disable-model-invocation` bilan belgilangan — ularni
sen chaqira olmaysan, faqat foydalanuvchi yoza oladi.

Har bosqichdan oldin tegishli `SKILL.md` ning frontmatter'ini tekshir:

- **`disable-model-invocation` yo'q** → skill'ni o'zing chaqir
- **bor** → foydalanuvchiga aniq ayt: "Endi `/<skill-nomi>` ni yozing.
  Tugagach menga ayting, davom ettiraman." Va turni tugat.

Chaqira olmagan skill'ning ishini boshqa yo'l bilan takrorlama —
bosqichni o'zing bajarib qo'yma.

### Muhim ketma-ketlik qoidasi

`grill-with-docs` tugagach `to-spec` ni **o'sha kontekstda** ishga tushir.
Orada kontekstni tozalama — intervyuda aniqlangan case'larning katta qismi
faqat o'sha suhbatda qoladi va `CONTEXT.md` ga tushmaydi.

### Talqin hisoboti

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

## 3 — darvozalar

"Darvoza" degani — loyiha `CLAUDE.md` sidagi tekshiruv buyruqlari.

- Buyruqlarni **haqiqatan ishga tushir**, natijani ko'rsat
- Yiqilsa — keyingi bosqichga o'tma
- Testni o'tkazish uchun testni o'zgartirishga ruxsat berma
- "Ishlashi kerak" degan javobni qabul qilma

Darvoza o'tmaguncha bosqich tugallangan hisoblanmaydi.

## 4 — yopish

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

## flow-state.md formati

```markdown
# Flow state

- Ish: <qisqa nom>
- Tur: fix | small | feature | arch
- Boshlangan: <sana>
- Joriy bosqich: <bosqich nomi>

## Bajarilgan bosqichlar
- [x] grill-with-docs → CONTEXT.md yangilandi
- [x] to-spec → docs/specs/<nom>.md (AC-1..AC-7)
- [ ] spec-coverage
- [ ] to-tickets

## Ochiq savollar
- <foydalanuvchi javob bermagan narsalar>
```

## Ta'qiqlar

- Kod fayllarini o'qima va yozma
- Bosqichni o'zing bajarishga urinma — tegishli skill'ni chaqir
- Foydalanuvchi so'ramasa bosqichni o'tkazib yuborma
- Darvoza yiqilganida "keyinroq tuzatamiz" deb davom etma
