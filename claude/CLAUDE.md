> Joylashuv: `~/.claude/CLAUDE.md`. Bu fayl BARCHA loyihalarga ta'sir qiladi.
> Shuning uchun bu yerda faqat **sohadan qat'i nazar** (backend / frontend /
> mobile / devops) o'zgarmaydigan qoidalar bo'ladi.
>
> - Stack'ga xos qoidalar → tegishli skill'da (`spring-boot-conventions`,
>   `nextjs-conventions`, `flutter-conventions`, `gitlab-ci-conventions`)
> - Loyihaga xos qoidalar → o'sha loyihaning `CLAUDE.md` sida
>
> Yangi qoida qo'shishdan oldin savol: "bu Flutter ishida ham to'g'rimi?"
> Yo'q bo'lsa — bu yerda turmasligi kerak.

## Muloqot tili

- Men bilan suhbat — **o'zbek tilida**.
- Kod ichidagi kommentariyalar va hujjatlar (docstring, JavaDoc, izohlar) — **o'zbek tilida**.
- Texnik atamalar (snake_case, SOLID, idempotent, race condition, ...) ingliz tilida qoladi, tarjima qilinmaydi.

## Kod sifati

- Maqsad tartibi: **to'g'rilik → o'qiluvchanlik → soddalik → tezlik**. Ziddiyat chiqqanda shu tartibda qaror qilinadi. "Aqlli" kod emas, ravshan kod.
- Composition > inheritance. Past bog'lanish (low coupling), yuqori jipslik (high cohesion).
- Har bir funksiya/klass bitta vazifani bajaradi. Katta bloklar bo'linadi.

## Nomlash va API shartnomasi

- **Tashqi API shartnomasi `snake_case` bo'ladi**: HTTP request/response body, query va path paramlar, JSON kalitlari.
    - Misol: `{ "user_id": 12, "created_at": "...", "status": "in_progress" }`
    - Misol: `?sort_by=created_at&order=desc&page_size=20`
- **Kod ichidagi nomlash har bir tilning o'z idiomasiga bo'ysunadi** — `snake_case` kodga majburlanmaydi.
- O'girish **serializatsiya qatlamida** bajariladi, qo'lda emas. Aniq mexanizm — tegishli stack skill'ida.
- Nomlar mazmunli va aniq bo'ladi; tushunarsiz qisqartmalardan qochiladi; nom niyatni ifodalaydi.

## Tugallanganlik (definition of done)

- "Tayyor" deyishdan oldin loyihaning tekshiruv buyruqlarini **o'zim ishga tushiraman** va natijani ko'rsataman. Testni ishga tushirmasdan "ishlaydi" deb aytmayman.
- Har bir acceptance criteria uchun kamida bitta test bo'ladi.
- Test yozib bo'lmaydigan holat bo'lsa — sababini aytaman, jimgina o'tkazib yubormayman.
- **Testni o'tkazish uchun testni o'zgartirmayman.** Test yiqilsa — kod tuzatiladi yoki muammo aytiladi.
- Yiqilgan test, `TODO` yoki ishlamaydigan qism qolgan bo'lsa, ish "tayyor" deb belgilanmaydi.

## Ishlash uslubi

- **Aniq bo'lmagan talab uchun taxmin qilmayman — so'rayman.** Ikki xil talqin mumkin bo'lsa, ikkalasini ko'rsatib tanlashni so'rayman.
- Notrivial ish (yangi funksiya, arxitektura o'zgarishi, ko'p faylga teguvchi yoki bir nechta yondashuv mumkin bo'lgan vazifa) oldidan avval **qisqa reja** taklif qilaman, tasdiqlangandan keyin bajaraman.
- Avval loyihadagi mavjud konvensiya va patternlarni o'qib chiqaman, so'ng ularga moslayman. Yangi pattern o'ylab topishdan oldin mavjudini ishlataman.
- O'zgarishlar kichik va atomik bo'ladi.

## Xatoliklarni boshqarish

- Xatolar yutib yuborilmaydi (no silent catch). Har bir xato yo to'g'ri qayta ishlanadi, yo yuqoriga aniq ko'tariladi.
- Xato xabarlari aniq va kontekstli bo'ladi.
- Maxfiy ma'lumot (parol, token, PII, kalit) HECH QACHON logga yozilmaydi.

## Xavfsizlik (baza)

- Maxfiy ma'lumotlar (secret, API key, parol) kodda yoki gitda saqlanmaydi — `.env` yoki secret manager orqali.
- Barcha tashqi kirish (input) validatsiya va sanitatsiya qilinadi.
- Auth/authz tekshiruvlari aniq qatlamda va har bir so'rovda bajariladi.

## Git boshqaruvi

- **Commit xabariga AI/Claude haqida hech qanday trailer, footer yoki belgi qo'shilmaydi.** Commit faqat mening nomimdan qilingandek bo'ladi.
- Commit formati — **Conventional Commits**: `<type>(<scope>): <qisqa tavsif>`
    - type'lar: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `build`, `ci`, `perf`, `style`.
    - type prefiksi inglizcha, tavsif esa o'zbek tilida.
    - Misol: `feat(auth): refresh token oqimi qo'shildi`
    - Misol: `fix(order): bo'sh savatda summa noto'g'ri hisoblangani tuzatildi`
- Bitta commit — bitta mantiqiy o'zgarish. Aloqasiz o'zgarishlar aralashtirilmaydi.
- Branch nomi: `<type>/<qisqa-nom>` — kichik harf va chiziqcha. Misol: `feat/refresh-token`, `fix/login-redirect`.
- Secret, `.env`, kalit yoki maxfiy ma'lumot HECH QACHON commit qilinmaydi (`.gitignore` tekshiriladi).
- Push qilishdan oldin ish holati toza bo'lsin: ortiqcha debug log, izohga olingan kod, vaqtinchalik fayllar qoldirilmaydi.
