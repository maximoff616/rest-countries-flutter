# Country Explorer — Flutter

Aplikasi Flutter untuk menjelajahi data negara melalui **REST Countries API**. Antarmuka menggunakan tema gelap dan aksen biru, dengan pencarian, filter wilayah, bendera, ibu kota, populasi, bahasa, dan mata uang.

## API
- Endpoint: `https://restcountries.com/v3.1/all`
- Field yang diminta: `name,capital,population,languages,currencies,flags,region,cca2`
- Data negara dimuat dari API; daftar negara tidak di-hardcode.

## Struktur folder
```text
lib/
├── main.dart
├── models/
│   └── country.dart
├── services/
│   └── countries_service.dart
└── ui/
    ├── screens/
    │   └── countries_screen.dart
    └── widgets/
        ├── country_card.dart
        ├── country_search_field.dart
        └── summary_tile.dart
```

- `models`: model immutable dengan `factory Country.fromJson`.
- `services`: satu-satunya tempat pemanggilan package `http`.
- `ui/screens`: mengatur state loading, sukses, error, pencarian, filter, dan retry.
- `ui/widgets`: komponen presentasi menerima data/callback melalui constructor.

## Menjalankan
Pastikan Flutter SDK sudah terpasang, lalu jalankan:

```bash
flutter pub get
flutter analyze
flutter run
```

Aplikasi memerlukan koneksi internet untuk mengambil data negara dan memuat gambar bendera.
