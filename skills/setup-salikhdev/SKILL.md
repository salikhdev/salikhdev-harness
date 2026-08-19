---
name: setup-salikhdev
description: Configure the current repo for the salikhdev harness — detect the stack, wire up the engineering skills, and write the per-repo config files. Run once per repo before using salikhdev-flow or any engineering skill.
disable-model-invocation: true
---

Bu repo'ni salikhdev harness uchun sozlaysan. Bu deterministik skript emas —
avval o'rgan, topganingni ko'rsat, tasdiqlat, keyin yoz.

## 1-bosqich — o'rganish (savol bermasdan)

Repo'ni o'qi. Taxmin qilma, faylni ko'r:

- `git remote -v` — GitHub, GitLab yoki remote yo'q?
- Ildizda `CLAUDE.md` yoki `AGENTS.md` bormi? Ichida `## Salikhdev harness` bo'limi bormi?
- `docs/agents/` papkasi bormi?
- Stack belgilari (bir nechtasi bo'lishi mumkin — hammasini yoz):

| Topilgan fayl | Stack | Skill | Tekshiruv buyrug'i |
|---|---|---|---|
| `build.gradle*`, `pom.xml` | backend | `salikhdev-spring-boot` | `./gradlew test` yoki `mvn test` |
| `next.config.*` | frontend | `salikhdev-nextjs` | `pnpm typecheck && pnpm test` |
| `pubspec.yaml` | mobile | `salikhdev-flutter` | `flutter analyze && flutter test` |
| `.gitlab-ci.yml` yoki GitLab remote | devops | `salikhdev-gitlab-ci` | — |

Paket menejerini ham aniqla (`pnpm-lock.yaml` / `yarn.lock` / `package-lock.json`)
va tekshiruv buyrug'ini shunga moslab yoz. Gradle wrapper yo'q bo'lsa `gradle test`.

## 2-bosqich — Matt Pocock skill'lari

`grill-with-docs`, `to-spec`, `to-tickets`, `implement`, `tdd`, `code-review`
mavjudligini tekshir.

Yo'q bo'lsa — foydalanuvchiga ayt va tasdiq so'ragach o'rnat:

```
npx skills@latest add mattpocock/skills -g
```

Bor bo'lsa, `docs/agents/issue-tracker.md` bor-yo'qligini qara. Yo'q bo'lsa
`setup-matt-pocock-skills` skill'ini chaqir va u tugagach shu yerga qayt.
Uning yozgan fayllarini qayta yozma.

## 3-bosqich — savollar

Har bo'limni tavsiya qilingan javob bilan boshla, foydalanuvchi bir so'z bilan
qabul qila olsin. Aniqlab bo'lgan narsani so'rama.

**A — Issue tracker.** `setup-matt-pocock-skills` bu savolni bergan bo'lsa,
umuman so'rama. Bermagan bo'lsa: GitLab remote bo'lsa GitLab taklif qil,
aks holda lokal markdown.

**B — Mahsulot tili (i18n).** Bu loyihada foydalanuvchiga ko'rinadigan matn
bormi? Bor bo'lsa i18n bloki loyiha CLAUDE.md ga yoziladi, yo'q bo'lsa
(kutubxona, CLI, bot) yozilmaydi. Standart javob: frontend yoki mobile
stack topilgan bo'lsa — ha, aks holda — yo'q.

**C — Tekshiruv buyruqlari.** 1-bosqichda aniqlaganingni ko'rsat va
tasdiqlashini so'ra. Buyruqlarni haqiqatan ishga tushirib ko'r — ishlamasa
buni ayt, jimgina yozib qo'yma.

## 4-bosqich — qoralamani ko'rsat

Yozishdan oldin nima yozilishini to'liq ko'rsat. Foydalanuvchi tahrirlashi
mumkin. Tasdiqsiz yozma.

## 5-bosqich — yozish

`shu skill papkasidagi templates/project-CLAUDE.md` va `templates/misses.md` shablonlaridan
foydalanib quyidagilarni yarat:

```
CLAUDE.md              ← "## Salikhdev harness" bo'limi qo'shiladi
                         (fayl bor bo'lsa tahrirlanadi, yo'q bo'lsa yaratiladi)
CONTEXT.md             ← bo'sh glossariy karkasi
docs/adr/.gitkeep
docs/agents/misses.md
```

`docs/agents/issue-tracker.md`, `domain.md`, `triage-labels.md` —
bularni `setup-matt-pocock-skills` yozadi, sen tegma.

## 6-bosqich — xulosa

Foydalanuvchiga ayt:

- Qaysi stack'lar aniqlandi va qaysi skill'lar ulandi
- Qaysi fayllar yaratildi
- Keyingi qadam: yangi feature uchun `/salikhdev-flow`
- `docs/agents/*.md` fayllarini keyin qo'lda tahrirlash mumkin;
  bu skill'ni qayta ishga tushirish faqat stack o'zgarganda kerak

## Muhim

- Hech qanday skill faylini o'zgartirma. `~/.agents/` yoki `~/.claude/skills/`
  ichidagi biror narsa o'zgargan bo'lsa — xato ketgan.
- Loyihaga skill nusxalama. Skill'lar globalda qoladi, bu yerda faqat
  ularni yo'naltiradigan konfiguratsiya turadi.
