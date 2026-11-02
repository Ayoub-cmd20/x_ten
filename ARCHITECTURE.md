# هيكلة تطبيق Flutter

نتبعو **Clean Architecture حسب الميزة (feature-first)** مع **Cubit واحد لكل ميزة**.
كل كلاس (أو use case) في ملفو، واسم الملف = اسم الكلاس بـ snake_case.

## شكل كل ميزة

```
lib/features/<feature>/
├── <feature>_injection.dart        ← تسجيل كل شي في get_it
├── data/
│   ├── datasources/                ← نداءات الـ API (Dio)
│   │   └── <feature>_remote_data_source.dart
│   ├── models/                     ← fromJson / toJson (يورثو من الـ entities)
│   │   └── <name>_model.dart
│   └── repositories/               ← تطبيق الـ repository (try/catch → Result)
│       └── <feature>_repository_impl.dart
├── domain/
│   ├── entities/                   ← كلاسات البيانات الصافية (Equatable، بلا JSON)
│   │   └── <name>.dart
│   ├── repositories/               ← الواجهة (abstract interface class)
│   │   └── <feature>_repository.dart
│   └── usecases/                   ← use case واحد في كل ملف + الـ Params تاعو
│       └── <action>_usecase.dart
└── presentation/
    ├── cubit/                      ← <feature>_cubit.dart + <feature>_state.dart (part)
    ├── pages/                      ← الشاشات الكاملة (Scaffold)
    ├── steps/                      ← مراحل الـ wizard (إذا كاين)
    ├── widgets/                    ← الويدجتات الخاصة بالميزة
    ├── <feature>_routes.dart       ← أسماء الروابط
    └── <feature>_labels.dart       ← نصوص l10n للـ enums (extension على AppLocalizations)
```

## القواعد

- **الاتجاه:** `presentation → domain ← data`. الـ domain ما يعرف حتى حاجة على Flutter ولا Dio.
- **الشاشة** تقرا من الـ Cubit (`context.watch/select`) وتنادي دوالو (`context.read<…>()`). ما تنادي حتى API مباشرة.
- **الـ Cubit** ينادي use cases برك، ويرجع حالة وحدة (`status` + `action` + البيانات).
- **الـ use case** يدير التنظيف والتحقق (trim، أرقام…) قبل الـ repository، ويرجع `Result<T>` (`Ok` / `Err`).
- **الـ repository impl** يحوّل الأخطاء لـ `Failure` عبر `guard(...)`.
- **النصوص** كامل في `lib/l10n/app_*.arb` (ar هو القالب) و `context.l10n.xxx`. ما كاش نص مكتوب في الكود.
- **الألوان والمسافات** من `core/theme` (`AppColors`, `AppSpacing`, `AppRadius`, `context.textTheme`).
- **مفاتيح JSON** من `core/constants/api_keys.dart`، و **الروابط** من `core/constants/api_endpoints.dart`.

## `core/` (مشترك بين الميزات)

| المجلد | المحتوى |
|---|---|
| `constants/` | `ApiKeys`, `ApiEndpoints`, ثوابت التطبيق |
| `di/` | `sl` (get_it) و `initDependencies()` |
| `errors/` | `Failure`s، تحويل الأخطاء، رسائل الأخطاء المترجمة |
| `network/` | Dio، الـ interceptors |
| `navigation/` | `app_router.dart` (go_router) |
| `theme/` | الألوان، الخطوط، المسافات |
| `utils/` | `Result`, `UploadFile`, `Validators`, قواعد الملفات |
| `widgets/` | ويدجتات مشتركة (`PrimaryButton`, `StepBody`, `ErrorView`…) |
| `catalog/` | قوائم ثابتة مشتركة (الدول، الفئات) |

## كي تزيد ميزة جديدة

1. `domain/entities/` ← الكلاسات.
2. `domain/repositories/` ← الواجهة.
3. `domain/usecases/` ← use case لكل عملية.
4. `data/models/` + `data/datasources/` + `data/repositories/`.
5. `presentation/cubit/` ← Cubit + State.
6. `presentation/pages/` و `widgets/`.
7. `<feature>_injection.dart` ← سجّل كلش، ونادي `init<Feature>Feature()` من `core/di/injection_container.dart`.
8. الروابط في `core/navigation/app_router.dart`.
9. `flutter gen-l10n && flutter analyze && flutter test`.
