---
name: salikhdev-gitlab-ci
description: Salikhdev conventions for GitLab CI/CD and Docker — branch-to-server mapping, standard CI variable names, pipeline stages, and image tagging. Load before writing or editing .gitlab-ci.yml, Dockerfile, or deployment scripts.
---

Bu skill'ning maqsadi — har loyihada CI o'zgaruvchilari va bosqichlari
har xil chiqishini to'xtatish. Nomlar quyidagicha, o'zgartirilmaydi.

## Branch → server

| Branch | Server | Image tegi |
|---|---|---|
| `dev` | dev server | `<project>:dev` |
| `prod` | prod server | `<project>:prod` |

`dev` ga push → dev serverga deploy. Qo'lda tekshirilgach `prod` ga merge →
prod serverga deploy. Boshqa branch deploy qilmaydi.

## Standart CI o'zgaruvchilari

Bu nomlar barcha loyihalarda bir xil. Yangi nom o'ylab topilmaydi.

```
SSH_PRIVATE_KEY
DEV_HOST      PROD_HOST
DEV_USER      PROD_USER
DEV_PORT      PROD_PORT
DEV_ENVS      PROD_ENVS
```

Loyihaga xos qo'shimcha o'zgaruvchi kerak bo'lsa, `DEV_` / `PROD_`
prefiksi bilan yoziladi.

## Pipeline bosqichlari

```yaml
stages:
  - test
  - build
  - deploy
```

- `test` — har branch va har MR da ishlaydi. Yiqilsa keyingi bosqich yo'q.
- `build` — faqat `dev` va `prod` da.
- `deploy` — faqat `dev` va `prod` da.

Test bosqichini o'tkazib yuboradigan `only`/`rules` yozilmaydi.
Tekshiruv buyrug'i loyiha `CLAUDE.md` sidan olinadi.

## Docker

- `docker compose` deploy'da ishlatilmaydi — to'g'ridan-to'g'ri `docker run`.
- Multi-stage build: build bosqichi va runtime bosqichi alohida.
- Runtime image'da build vositalari (gradle, node_modules devDeps) qolmaydi.
- `latest` tegi ishlatilmaydi — faqat `dev` / `prod`.
- Konteyner root'dan ishlamaydi.

## Xavfsizlik

- Secret CI faylida yozilmaydi — faqat GitLab CI/CD Variables orqali.
- `DEV_ENVS` / `PROD_ENVS` `.env` faylga yoziladi va konteynerga uzatiladi;
  logga chiqarilmaydi.
- `SSH_PRIVATE_KEY` masked va protected bo'ladi.

## TODO

- Runner turi: shared yoki o'z runner'ingizmi?
- Registry: GitLab Container Registry yoki boshqasimi?
- Rollback qanday qilinadi? Hozircha yo'q bo'lsa, buni ochiq savol
  sifatida qoldiring va keyin to'ldiring.
