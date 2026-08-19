---
name: salikhdev-nextjs
description: Salikhdev conventions for Next.js frontend work — folder structure, server/client component boundaries, API client and snake_case mapping, state, forms, and test style. Load before writing, editing, or reviewing frontend code.
---

> TO'LDIRILISHI KERAK. Boshlang'ich karkas — `TODO` joylarini to'ldiring.

## Tuzilma

TODO: App Router ishlatasizmi? Papka tuzilishingizni yozing, masalan:

```
app/           marshrutlar, page va layout
components/    qayta ishlatiladigan UI
features/      feature bo'yicha guruhlangan mantiq
lib/api/       API client va mapper
lib/           yordamchi funksiyalar
```

## Server / client chegarasi

- Standart holat — server component. `"use client"` faqat kerak bo'lganda
  (state, event handler, brauzer API).
- `"use client"` daraxtning eng pastki qismiga qo'yiladi, sahifa darajasiga emas.
- Maxfiy ma'lumot (token, API kalit) client component'ga tushmaydi.

## API qatlami

Backend `snake_case` qaytaradi, TS kodi `camelCase` ishlatadi. O'girish
**bitta joyda** — `lib/api/` ichidagi mapper'da. Komponent hech qachon
`data.user_id` yozmaydi.

```ts
// lib/api/student.ts
type StudentDto = { student_id: number; full_name: string }
type Student = { studentId: number; fullName: string }

const toStudent = (dto: StudentDto): Student => ({
  studentId: dto.student_id,
  fullName: dto.full_name,
})
```

TODO: mapper'ni qo'lda yozasizmi yoki zod/ts-transform ishlatasizmi?

## Tiplar

- `any` yozilmaydi. Noma'lum tur uchun `unknown` va toraytirish.
- API javobi tipi qo'lda emas, TODO: OpenAPI generatsiyasidan olinadimi?
- Komponent prop'lari aniq tiplanadi, `React.FC` ishlatilmaydi.

## Holat (state)

TODO: server state uchun nima (React Query / SWR / server component)?
Client state uchun nima (useState / Zustand / Context)?
Bittasini tanlang va "qachon qaysi biri" qoidasini yozing.

## Formalar

TODO: react-hook-form + zod ishlatasizmi? Validatsiya sxemasi qayerda turadi?

## i18n

- Foydalanuvchiga ko'rinadigan matn kodda yozilmaydi.
- TODO: qaysi kutubxona (next-intl / i18next)? Kalitlar qayerda?
- Kalit nomlash: TODO, masalan `student.list.empty_state`.

## Testlar

- Komponent → TODO (Vitest + Testing Library?)
- E2E → TODO (Playwright?)
- Snapshot test yozilmaydi — u xatoni tutmaydi, faqat shovqin qiladi.
- AC raqami test nomida bo'lsin: `AC2: bo'sh ro'yxatda xabar ko'rsatiladi`.

## Ta'qiqlar

- `useEffect` ichida ma'lumot yuklash (server component yoki query kutubxonasi).
- Komponent ichida to'g'ridan-to'g'ri `fetch` — faqat `lib/api/` orqali.
- Inline style — TODO: Tailwind ishlatasizmi?
