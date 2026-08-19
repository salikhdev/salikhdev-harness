---
name: salikhdev-flutter
description: Salikhdev conventions for Flutter mobile work — folder structure, state management, API layer and snake_case mapping, navigation, i18n, and widget test style. Load before writing, editing, or reviewing Flutter/Dart code.
---

> TO'LDIRILISHI KERAK. Boshlang'ich karkas — `TODO` joylarini to'ldiring.

## Tuzilma

TODO: feature-first tuzilishni tavsiya qilaman, tasdiqlang yoki o'zgartiring:

```
lib/
  core/          umumiy: tarmoq, xatolik, tema, i18n
  features/
    auth/
      data/      dto, repository implementatsiyasi
      domain/    model, repository interfeysi
      presentation/  ekran, widget, state
  main.dart
```

## Holat boshqaruvi

TODO: nima ishlatasiz — Riverpod, Bloc, Provider? Bittasini tanlang.
Loyihalar orasida bir xil bo'lsin; aralashtirish eng katta chalkashlik manbai.

Tanlagandan keyin yozing: state qayerda e'lon qilinadi, UI unga qanday
ulanadi, side effect qayerda bajariladi.

## API qatlami

Backend `snake_case` qaytaradi, Dart `camelCase` ishlatadi.

TODO: `json_serializable` ishlatasizmi? Ishlatsangiz:

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
class StudentDto { ... }
```

Widget hech qachon DTO bilan ishlamaydi — faqat domen modeli bilan.
DTO → model o'girish `data/` qatlamida.

## Xatoliklar

- Tarmoq xatosi UI ga `Exception` bo'lib chiqmaydi — natija turi orqali
  (`Result` / `Either`) yoki state ichidagi `error` maydoni orqali.
- Backend `error_code` qaytaradi; UI shu kodni i18n kaliti sifatida ishlatadi,
  backend matnini ko'rsatmaydi.
- `catch (e) { print(e); }` yozilmaydi.

## Navigatsiya

TODO: `go_router` ishlatasizmi? Marshrutlar qayerda e'lon qilinadi?
Deep link kerakmi?

## i18n

- Matn widget ichida yozilmaydi.
- TODO: `flutter_localizations` + ARB fayllarmi yoki boshqa yechim?
- Standart til — ingliz.

## Widget qoidalari

- `build` metodi ichida og'ir hisob-kitob yoki API chaqiruvi yo'q.
- 100 qatordan uzun `build` bo'linadi.
- `setState` faqat lokal UI holati uchun (masalan animatsiya), biznes
  holati uchun emas.
- `const` konstruktor imkoni bo'lgan joyda ishlatiladi.

## Testlar

- Biznes mantiq → toza Dart unit test, Flutter'siz.
- Widget → `testWidgets`, repository mock qilinadi.
- TODO: mock uchun `mocktail` yoki `mockito`?
- Golden test — TODO: ishlatasizmi?
- AC raqami test nomida bo'lsin.

## Tekshiruv

```
flutter analyze && flutter test
```

`analyze` ogohlantirish bilan o'tsa ham, ogohlantirishlar tuzatiladi.
TODO: `analysis_options.yaml` da qaysi lint to'plamini ishlatasiz?
