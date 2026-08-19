#!/usr/bin/env bash
set -euo pipefail

HARNESS="$HOME/salikhdev-harness"
cd "$HARNESS"

echo "==> 1. setup-salikhdev: 2-bosqich almashtirilyapti"
python3 - << 'PY'
import pathlib, re
p = pathlib.Path("skills/setup-salikhdev/SKILL.md")
t = p.read_text()

new = """## 2-bosqich — Matt Pocock skill'lari

`grill-with-docs`, `to-spec`, `to-tickets`, `implement`, `tdd`,
`code-review` mavjudligini tekshir.

Yo'q bo'lsa — foydalanuvchiga ayt va tasdiq so'ragach o'rnat:

```
npx skills@latest add mattpocock/skills -g
```

`docs/agents/issue-tracker.md` bor-yo'qligini qara.

**Yo'q bo'lsa — shu yerda to'xta.** `setup-matt-pocock-skills` ni
chaqirishga urinma: uning frontmatter'ida `disable-model-invocation`
bor, ya'ni uni faqat foydalanuvchi o'zi ishga tushira oladi. Uning
ishini boshqa yo'l bilan ham takrorlama — fayllarini o'rniga yozma.

Foydalanuvchiga shunday ayt va turni tugat:

> Avval `/setup-matt-pocock-skills` ni ishga tushiring, keyin
> `/setup-salikhdev` ni qayta yozing — qolganini davom ettiraman.

Keyingi bosqichlarga o'tma.

"""

pat = re.compile(r"## 2-bosqich — Matt Pocock skill'lari\n.*?(?=## 3-bosqich)", re.DOTALL)
if not pat.search(t):
    raise SystemExit("XATO: 2-bosqich topilmadi")
p.write_text(pat.sub(new, t, count=1))
print("   setup-salikhdev yangilandi")
PY

echo "==> 2. salikhdev-flow: chaqirish qoidasi qo'shilyapti"
python3 - << 'PY'
import pathlib
p = pathlib.Path("skills/salikhdev-flow/SKILL.md")
t = p.read_text()

old = "### Muhim ketma-ketlik qoidasi"
new = """### Skill'ni qanday ishga tushirish

Ba'zi skill'lar `disable-model-invocation` bilan belgilangan — ularni
sen chaqira olmaysan, faqat foydalanuvchi yoza oladi.

Har bosqichdan oldin tegishli `SKILL.md` ning frontmatter'ini tekshir:

- **`disable-model-invocation` yo'q** → skill'ni o'zing chaqir
- **bor** → foydalanuvchiga aniq ayt: "Endi `/<skill-nomi>` ni yozing.
  Tugagach menga ayting, davom ettiraman." Va turni tugat.

Chaqira olmagan skill'ning ishini boshqa yo'l bilan takrorlama —
bosqichni o'zing bajarib qo'yma.

### Muhim ketma-ketlik qoidasi"""

if old not in t:
    raise SystemExit("XATO: bo'lim topilmadi")
p.write_text(t.replace(old, new, 1))
print("   salikhdev-flow yangilandi")
PY

echo "==> 3. Tekshirish"
grep -n "disable-model-invocation" skills/setup-salikhdev/SKILL.md skills/salikhdev-flow/SKILL.md

echo "==> 4. Commit"
git add -A
git commit -m "fix: disable-model-invocation skill'larini chaqirishga urinish to'xtatildi"

echo
echo "Tayyor. git push qilishni unutmang."
