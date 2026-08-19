---
name: salikhdev-spring-boot
description: Salikhdev conventions for Spring Boot backend work — package layout, domain/persistence separation, mapping, snake_case API contract, error format, JPA and Liquibase rules, security, OpenFeign and RestClient integration, and test style. Load before writing, editing, or reviewing Java backend code.
---

Java 17, Gradle (Kotlin DSL), Spring Boot 3.x. Odatda bitta modul;
mikroservis bo'lsa har servis shu qoidalarga alohida amal qiladi.

## Paket tuzilishi

Feature-first. Root paket: `uz.salikhdev.<loyiha>`.

```
uz.salikhdev.lms
  student/
    controller/            StudentController
    dto/                   CreateStudentReq, UpdateStudentReq, StudentRes
    service/               StudentService — klass, interfeyssiz
    domain/
      model/               Student — sof Java, annotatsiyasiz
      repository/          StudentRepository — interfeys
    persistence/
      entity/              StudentEntity — JPA
      repository/          StudentJpaRepository, StudentRepositoryImpl
    mapper/                StudentApiMapper, StudentPersistenceMapper
  shared/                  config, exception, xavfsizlik, audit, integratsiya
```

Feature paketi boshqa feature'ning `domain`, `persistence` yoki
`repository` iga to'g'ridan-to'g'ri murojaat qilmaydi — faqat uning
`service` klassiga.

## Bog'liqlik yo'nalishi

Bu skill'dagi eng muhim qoida. **Domen markazda turadi va hech kimga
bog'liq emas.**

```
controller  →  service  →  domain  ←  persistence
```

- `domain/model` — sof Java. `@Entity`, `@Column`, `@Table`, `@Json*`,
  `@Component` — hech qanday annotatsiya yo'q. Spring, JPA va Jackson
  import qilinmaydi.
- `domain/repository` — interfeys. **Domen modelini qabul qiladi va
  qaytaradi**, entity emas. Bu interfeys `domain` paketida turadi,
  `persistence` da emas — bog'liqlikni teskari qiladigan nuqta shu.
- `persistence` — `domain` ga bog'liq (interfeysni implement qiladi),
  teskarisi emas.
- `service` faqat domen modeli bilan ishlaydi. `StudentEntity` service
  kodida umuman uchramaydi.
- Service interfeyssiz bo'lgani uchun Spring CGLIB proxy ishlatadi.
  Ya'ni `@Transactional` metodlar `public` va `final` bo'lmasligi kerak,
  klass ham `final` emas.
- `controller` HTTP va DTO bilan ishlaydi, domen modelini tashqariga
  chiqarmaydi.

Tekshirish oson: `service` paketidagi biror faylda `persistence` yoki
`jakarta.persistence` importi bo'lsa — qoida buzilgan.

## Qatlamlar

- Controller `ResponseEntity<ApiResponse<T>>` qaytaradi. Biznes mantiq yo'q.
- Service — oddiy klass, interfeyssiz. HTTP tiplarini bilmaydi, entity
  bilmaydi. Ikkinchi implementatsiya haqiqatan paydo bo'lganda interfeys
  ajratiladi — oldin emas.
- Repository implementatsiyasi `persistence` da: `StudentJpaRepository`
  (Spring Data) ni ichida ishlatadi, tashqariga domen modeli qaytaradi.
- Domen model — ma'lumot **va** biznes qoidalari.

Service boshqa service'ni chaqira oladi, lekin **faqat bir yo'nalishda**.
Ikki service bir-birini chaqirsa — bu dizayn xatosi; umumiy mantiqni
domenga yoki `shared` ga chiqaring.

## Repository interfeysi

```java
// domain/repository/StudentRepository.java
public interface StudentRepository {
    Optional<Student> findById(Long id);
    Page<Student> search(StudentFilter filter, Pageable pageable);
    Student save(Student student);
}
```

- Interfeys domen modeli bilan gaplashadi.
- Murakkab qidiruv uchun `StudentFilter` record'i — domen darajasidagi
  shart obyekti. Implementatsiya uni JPA `Specification` ga o'giradi.
  `Specification` domen paketida uchramaydi.

Bu interfeys YAGNI istisnosi emas: uning sababi bugun ishlaydi —
`domain` ning `persistence` ga bog'liq bo'lib qolishini to'xtatadi.
Service interfeysida bunday sabab yo'q, shuning uchun u yozilmaydi.
- `Pageable` / `Page` — Spring Data tipi, lekin ular framework'ning
  neytral qismi hisoblanadi va interfeysda ruxsat etiladi. Boshqa
  Spring tiplari ruxsat etilmaydi.

## Domen modeli

Biznes qoidalari **shu yerda yashaydi**, service'da emas.

```java
public class Group {
    private final int capacity;
    private final List<Long> studentIds;

    public boolean hasSpace() {
        return studentIds.size() < capacity;
    }

    public void enroll(Long studentId) {
        if (!hasSpace()) {
            throw new GroupFullException(id);
        }
        studentIds.add(studentId);
    }
}
```

Service qoidani takrorlamaydi — domen metodini chaqiradi va natijaga
qarab ish ko'radi. `if (group.getStudents().size() >= group.getCapacity())`
service ichida yozilishi — qoida buzilishi.

Setter'lar imkon qadar yozilmaydi. Holat o'zgarishi mazmunli metod orqali
bo'ladi: `enroll()`, `deactivate()`, `changeTariff()`.

## Mapping

Ikkita mapper, ikkalasi ham MapStruct:

| Mapper | Yo'nalish | Joyi |
|---|---|---|
| `StudentApiMapper` | DTO ↔ domen | `mapper/` |
| `StudentPersistenceMapper` | domen ↔ entity | `mapper/` |

- Qo'lda `toDto()` yozilmaydi.
- Service mapping qilmaydi — controller `ApiMapper` ni, repository
  implementatsiyasi `PersistenceMapper` ni chaqiradi.
- DTO — `record`. Har entity uchun alohida: `CreateXReq`, `UpdateXReq`,
  `XRes`. Bitta universal DTO yozilmaydi.
- Entity va domen model hech qachon controller'dan qaytarilmaydi.

> Narxi: har feature uchun ikki marta mapping va bitta qo'shimcha klass
> to'plami. MapStruct kodning katta qismini generatsiya qiladi, lekin
> qo'shimcha yuk baribir bor. Bu ataylab qabul qilingan narx —
> biznes qoidalari ko'p domenlarda (to'lov, obuna, bank) u o'zini
> oqlaydi.

## API shartnomasi

Base path `/api/v1/...`, versiya URL'da.

**Kirish ham, chiqish ham `snake_case`.** Request body, query param,
response body — hammasi. Jackson global strategiya bilan:

```java
builder.propertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);
```

DTO'larda `@JsonProperty` yozilmaydi. Java kodi `camelCase` qoladi.

Javob doim wrapper ichida:

```json
{ "success": true, "data": { }, "message": null }
```

Ro'yxat qaytarilganda `pagination` bloki `data` yonida turadi — ichida emas.
So'rov: `?page=0&page_size=20`.

```json
{
  "success": true,
  "data": [ ],
  "pagination": {
    "total": 143,
    "page": 0,
    "page_size": 20,
    "total_pages": 8,
    "has_next": true,
    "has_previous": false
  },
  "message": null
}
```

- `page` **0 dan** boshlanadi.
- `pagination` faqat ro'yxatli javoblarda bo'ladi; bitta obyekt qaytganda
  maydon umuman yozilmaydi.
- `has_next` / `has_previous` — boolean. To'liq URL qaytarilmaydi.
- Spring'ning `Page` obyekti shundayligicha qaytarilmaydi.
- Sana — ISO-8601 UTC: `2026-08-19T10:30:00Z`.
- ID — `Long`, auto-increment.

## Xatoliklar

`@RestControllerAdvice` da markazlashgan. Formati:

```json
{
  "success": false,
  "error_code": "STUDENT_NOT_FOUND",
  "message": "Talaba topilmadi",
  "details": { "email": "email formati noto'g'ri" }
}
```

- `error_code` — `UPPER_SNAKE_CASE`, doim `enum` da e'lon qilinadi.
- `message` — backend i18n orqali tarjima qiladi, `Accept-Language` ga qarab.
- Validatsiya xatolari `details` ichida: maydon nomi → xabar.
- Ierarxiya: bitta `BusinessException` bazasi, undan `StudentNotFoundException`
  kabi subclass'lar. `RuntimeException` to'g'ridan-to'g'ri tashlanmaydi.
- Domen exception'lari `domain` paketida turadi va Spring'ga bog'liq emas.

## Validatsiya

- Kirish shakli (format, uzunlik, null) — Bean Validation annotatsiyalari DTO'da.
- Biznes qoidalari — domen modeli ichida (yuqoridagi `Group` misoliga qarang).
- `Optional` faqat qaytish qiymatida ishlatiladi.

## Ma'lumotlar bazasi

PostgreSQL. Migratsiya — Liquibase. `ddl-auto: validate`.
Sxema faqat migratsiya orqali o'zgaradi.

Quyidagilarning hammasi **entity darajasidagi masala** — domen modeli
ularni bilmaydi:

- Jadval nomlari ko'plikda: `students`, `groups`.
- Barcha bog'lanishlar `LAZY`. `EAGER` yozilmaydi.
- `created_at` / `updated_at` — `@MappedSuperclass` bazaviy entity'dan.
- Soft delete — `deleted_at` maydoni. Foydalanuvchi ma'lumoti, to'lov,
  biznes tarixi bo'lgan hamma narsa uchun. Lug'at/ma'lumotnoma jadvallar
  (status, tur) hard delete.

**Filtratsiya doim DB darajasida.** `findAll()` chaqirib keyin Java stream
bilan filtrlash — qat'iy taqiqlanadi. Murakkab shart bo'lsa `StudentFilter`
→ `Specification` yo'lidan boring.

## Tranzaksiyalar

- `@Transactional` — service metodida. Controller, repository yoki
  domen modelida emas.
- O'qish metodlari — `@Transactional(readOnly = true)`.
- Bir nechta yozish amali bitta metodda bo'lsa, u albatta tranzaksiyada.

## Xavfsizlik

- JWT: access + refresh. Refresh token DB'da saqlanadi, access saqlanmaydi.
- Ruxsat — permission-based, rol emas. `@PreAuthorize` metod ustida:

```java
@PreAuthorize("hasAuthority('STUDENT_READ')")
```

- Permission nomlari `UPPER_SNAKE_CASE`, enum da e'lon qilinadi.
- Har endpoint ruxsat tekshiruvidan o'tadi. Ochiq endpoint `@PermitAll`
  bilan aniq belgilanadi — e'tiborsizlikdan ochiq qolmaydi.

## Mikroservislar orasidagi muloqot

Bitta modulli loyihada bu bo'lim ishlamaydi.

**Ichki chaqiruvlar — OpenFeign.** Client interfeysi `<feature>/client/` da:

```java
@FeignClient(name = "payment-service", path = "/api/v1/payments")
public interface PaymentClient {
    ApiResponse<PaymentRes> findById(@PathVariable Long id);
}
```

- Feign va `RestClient` bir maqsadda aralashtirilmaydi: ichki servislar
  Feign, tashqi API'lar `RestClient`.
- Javob turi — o'sha `ApiResponse<T>` wrapper'i.
- Har client'da timeout va retry aniq belgilanadi.
- Feign xatosi `ErrorDecoder` orqali `BusinessException` ga o'giriladi;
  `FeignException` yuqoriga chiqmaydi.
- Circuit breaker — Resilience4j.

**Tashqi integratsiyalar — RestClient.** To'lov tizimi, SMS, OnlinePBX
kabi tashqi API'lar uchun. Har integratsiya `shared/integration/<nom>/`
da alohida client klassga o'raladi — service to'g'ridan-to'g'ri
HTTP client chaqirmaydi.

```java
@Component
public class SmsClient {
    private final RestClient client;

    public SmsClient(RestClient.Builder builder,
                     @Value("${integration.sms.base-url}") String baseUrl) {
        this.client = builder.baseUrl(baseUrl).build();
    }

    public SmsStatus send(String phone, String text) {
        return client.post()
            .uri("/messages")
            .body(new SendSmsReq(phone, text))
            .retrieve()
            .body(SmsStatus.class);
    }
}
```

- Har client uchun `RestClient` alohida `Builder` dan quriladi; bitta
  umumiy bean hamma integratsiyaga ulashilmaydi (base URL, timeout,
  header'lar har xil).
- Timeout aniq belgilanadi — standart qiymatga tashlab ketilmaydi.
- Tashqi xato `BusinessException` ga o'giriladi; `RestClientException`
  service qatlamiga chiqmaydi.
- Tashqi API javobi domen modeliga o'giriladi — DTO'si service'ga
  o'tmaydi.

> `RestTemplate` Spring 5 dan beri maintenance rejimida — yangi kodda
> ishlatilmaydi. Mavjud loyihalarda bo'lsa, o'sha fayl tegilganda
> `RestClient` ga o'tkaziladi; birdan migratsiya shart emas.

**Tranzaksiyalar — Saga.** Bir necha servisga tegadigan amal uchun
distributed tranzaksiya ishlatilmaydi:

- Har qadam o'z lokal tranzaksiyasida bajariladi
- Har qadam uchun kompensatsiya amali yoziladi (`cancelPayment`)
- Saga holati DB'da saqlanadi
- Har qadam idempotent bo'ladi

TODO: orkestratsiya (markaziy koordinator) yoki xoreografiya (hodisalar
orqali)? Yakka ishlaganda orkestratsiya osonroq kuzatiladi — tavsiya shu.

## Prinsiplar amalda

**Bitta sabab — bitta o'zgarish.** Klass o'zgarishiga bittadan ortiq sabab
bo'lsa, u bo'linadi. `StudentService` ichida ham ro'yxatga olish, ham
to'lov hisoblash, ham xabar yuborish bo'lsa — uchta sabab.

**Kengaytirish, o'zgartirmaslik.** Yangi holat qo'shilganda mavjud
`switch` / `if-else` zanjiriga qator qo'shish o'rniga polimorfizm.
Uchinchi `else if` — signal.

**Takrorlanish.** Bir xil biznes qoidasi ikki joyda uchrasa, u domen
metodiga chiqariladi. Lekin tashqi ko'rinishi o'xshash, sababi boshqa
bo'lgan ikki kod birlashtirilmaydi — bu noto'g'ri abstraksiya.

**Soddalik.** Ikki yechim bir xil natija bersa, o'qishga oson bo'lgani
tanlanadi. Generic, refleksiya, dinamik proxy — faqat oddiy yo'l
ishlamaganda.

**Kerak bo'lmaganini qurmaslik.** "Keyin kerak bo'ladi" asosida
konfiguratsiya yoki abstraksiya qatlami yozilmaydi. Shu jumladan bitta
implementatsiyali service interfeysi ham — u yozilmaydi.

Repository interfeysi bunga zid emas: uning sababi kelajakdagi ikkinchi
implementatsiya emas, balki bugungi bog'liqlik yo'nalishi. Abstraksiya
hozirgi muammoni yechsa — qoladi; faqat kelajakni taxmin qilsa — yo'q.

## Testlar

JUnit 5 + AssertJ + Mockito. Integratsiya testlari — Testcontainers.

- **Domen modeli → toza unit test.** Spring ham, mock ham kerak emas.
  Ajratishning asosiy foydasi shu — biznes qoidalari eng tez va eng
  oson testlanadigan joyda turadi.
- Service → unit test, repository interfeysi mock qilinadi. Service
  klassini mock qilish kerak bo'lsa Mockito interfeyssiz ham ishlaydi —
  bu interfeys yozishga sabab emas.
- Controller → `@WebMvcTest` + MockMvc, service mock qilinadi.
- Repository implementatsiyasi → Testcontainers. H2 ishlatilmaydi.
- Test ma'lumotlari — builder/fixture klasslar orqali.

Test nomlash: `metod_holat_natija`, oldiga AC raqami:

```java
AC3_login_expiredToken_throws()
AC5_enroll_groupFull_throws()
```

Minimal talab: har acceptance criteria uchun kamida bitta test.
Coverage foizi maqsad qilinmaydi.

## Ta'qiqlar

- `domain/model` ichida biror annotatsiya (`@Entity`, `@Component`, `@Json*`)
- `service` paketida `persistence` yoki `jakarta.persistence` importi
- Bitta implementatsiyali service interfeysi (`XService` + `XServiceImpl`)
- Entity yoki domen modelini controller'dan qaytarish
- Biznes qoidasini service ichida takrorlash (domen metodi bor turib)
- Field injection (`@Autowired` maydonda)
- `catch (Exception e)` bo'sh yoki faqat log bilan
- Service ichida `HttpServletRequest` yoki boshqa HTTP tipi
- `EAGER` fetch
- Biznes mantiq controller'da
- `System.out.println`
- `@Transactional` bo'lmagan ko'p bosqichli yozish
- Konstantaga chiqarilmagan magic string yoki raqam
- `findAll()` + stream orqali filtrlash
- `@JsonProperty` bilan qo'lda nom berish
- Spring `Page` obyektini to'g'ridan-to'g'ri qaytarish
- Service ichida to'g'ridan-to'g'ri HTTP client chaqirish (client klass orqali)
- Yangi kodda `RestTemplate` (`RestClient` ishlatiladi)
- Feign va `RestClient` ni bir maqsadda aralashtirish
- Servislararo amalda distributed tranzaksiya (Saga ishlatiladi)
