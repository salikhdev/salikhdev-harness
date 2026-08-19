# salikhdev-harness

Shaxsiy AI coding harness: global qoidalar, stack konvensiyalari,
SDLC orkestratori.

[mattpocock/skills](https://github.com/mattpocock/skills) (MIT) ustiga
qurilgan — uning skill'lari ko'chirilmagan, `/setup-salikhdev` ularni
o'zi o'rnatadi.

## O'rnatish

```bash
git clone <repo> ~/salikhdev-harness
cd ~/salikhdev-harness && ./install.sh
```

Keyin har bir loyihada bir marta:

```
/setup-salikhdev
```

## Tuzilma

```
claude/CLAUDE.md            global qoidalar (har so'rovda yuklanadi)
skills/
  setup-salikhdev/          loyihani sozlaydi
    templates/              yoziladigan fayl shablonlari
  salikhdev-flow/           SDLC orkestratori
  spec-coverage/            AC ↔ test qamrovini tekshiradi
  salikhdev-spring-boot/    backend konvensiyalari
  salikhdev-nextjs/         frontend konvensiyalari
  salikhdev-flutter/        mobile konvensiyalari
  salikhdev-gitlab-ci/      CI/CD va Docker konvensiyalari
install.sh                  symlink o'rnatgich
```

## Qatlamlar

| Qatlam | Qachon yuklanadi | Nima turadi |
|---|---|---|
| `claude/CLAUDE.md` | har doim | tilga bog'liq bo'lmagan qoidalar |
| loyiha `CLAUDE.md` | har doim | domen, skill jadvali, tekshiruv buyruqlari |
| `salikhdev-*` skill'lari | stack'ga tegilganda | stack konvensiyalari |
| Matt skill'lari | chaqirilganda | jarayon: spec, tdd, review |

Yangi qoida qo'shishdan oldin savol: **"bu Flutter ishida ham to'g'rimi?"**
Yo'q bo'lsa — global faylda emas, skill'da turishi kerak.

## Oqim

```
/salikhdev-flow
  ├─ fix      → diagnosing-bugs → implement → darvoza
  ├─ small    → to-spec → tdd → implement → darvoza → code-review
  ├─ feature  → grill-with-docs → to-spec → spec-coverage → to-tickets
  │             → (tdd → implement → darvoza) → code-review
  └─ arch     → improve-codebase-architecture → feature oqimi
```

## Holat

Boshlang'ich versiya. `salikhdev-*` skill'larida `TODO` bilan belgilangan joylar
o'z konvensiyalaringiz bilan to'ldirilishi kerak — ular to'ldirilmaguncha
harness'ning yarmi ishlamaydi.
