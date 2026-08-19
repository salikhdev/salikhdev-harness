> Bu bo'lim `/setup-salikhdev` tomonidan yaratilgan.
> Loyihaga xos qoidalar shu faylda turadi. Universal qoidalar —
> `~/.claude/CLAUDE.md` da.

## Salikhdev harness

### Qaysi ishda qaysi skill

Quyidagi jadvaldagi ish turiga tegishli fayllarga tegishdan oldin mos
skill o'qiladi.

| Ish | Skill | Tekshiruv buyrug'i |
|---|---|---|
| Backend (Java / Spring Boot) | `salikhdev-spring-boot` | `./gradlew test` |
| Frontend (Next.js) | `salikhdev-nextjs` | `pnpm typecheck && pnpm test` |
| Mobile (Flutter) | `salikhdev-flutter` | `flutter analyze && flutter test` |
| CI/CD, Dockerfile | `salikhdev-gitlab-ci` | — |

> Setup faqat aniqlangan stack'lar uchun qator qoldiradi, qolganini o'chiradi.

### Ish oqimi

Yangi feature yoki notrivial o'zgarish — `/salikhdev-flow` orqali.
To'g'ridan-to'g'ri implementatsiyaga o'tilmaydi.

### Hujjatlar

| Fayl | Nima uchun |
|---|---|
| `CONTEXT.md` | domen lug'ati — `grill-with-docs` to'ldiradi |
| `docs/adr/` | qaytarib bo'lmaydigan qarorlar |
| `docs/agents/issue-tracker.md` | issue'lar qayerda |
| `docs/agents/misses.md` | o'tkazib yuborilgan case'lar jurnali |

## Mahsulot tili (i18n)

> Setup bu bo'limni faqat foydalanuvchi interfeysi bor loyihalarda qoldiradi.

- Standart til — ingliz.
- Foydalanuvchiga ko'rinadigan hech bir matn kodga qattiq yozilmaydi.
- Barcha matnlar tarjima kalitlari orqali boshqariladi.
- Yangi til qo'shish faqat tarjima faylini qo'shish bilan ishlashi kerak.

## Domen

> Bu yerni qo'lda to'ldiring yoki `/grill-with-docs` to'ldirsin.

TODO: bu loyiha nima qiladi, kim foydalanadi, asosiy domen tushunchalari.
