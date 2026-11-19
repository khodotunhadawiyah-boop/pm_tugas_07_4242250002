# Tugas Rutin 7: Planner Tugas Kuliah dengan State Management

Mata kuliah Pemrograman Mobile, Pertemuan 7.

Aplikasi pencatat tugas kuliah dengan tiga halaman yang berbagi state: daftar tugas, form tambah tugas, dan statistik. State bersama dikelola dengan Provider (`ChangeNotifier`), navigasi dengan `go_router`.

## a. Identitas
- Nama: Khodotun Hadawiyah. M
- NIM: 4242250002
- Kelas: PSIK 24D

## b. Tangkapan layar (Infinix SMART 9, Android 14)

| Halaman daftar | Halaman form | Halaman statistik |
|---|---|---|
| ![daftar](screenshots/daftar.jpeg) | ![form](screenshots/form.jpeg) | ![statistik](screenshots/statistik.jpeg) |

## c. Letak setiap state dan alasannya

```
ChangeNotifierProvider<PlannerModel>        [STATE BERSAMA di atas pohon]
└── MaterialApp.router
    └── KerangkaNavigasi (NavigationBar)
        │     └── badge tugas aktif         -> context.select(jumlahAktif)
        ├── HalamanDaftar        [Stateful]
        │     ├── _filter                   -> LOKAL (setState)
        │     └── daftar tugas              -> context.watch(PlannerModel)
        ├── HalamanForm          [Stateful]
        │     ├── TextEditingController     -> LOKAL (initState / dispose)
        │     ├── _tenggat                  -> LOKAL (setState)
        │     └── tombol Simpan             -> context.read(PlannerModel).tambah()
        └── HalamanStatistik     [Stateless]
              └── total, selesai, persen    -> context.watch(PlannerModel)
```

| State | Letak | Alasan |
|---|---|---|
| Filter Semua/Aktif/Selesai | Lokal, `setState` di `HalamanDaftar` | Hanya dipakai satu halaman dan tidak perlu diketahui halaman lain (ephemeral state) |
| Controller dan tenggat form | Lokal di `HalamanForm` | Hanya hidup selama form terbuka |
| Daftar tugas (tambah, selesai, hapus) | Bersama, `PlannerModel` | Dipakai daftar, form, statistik, dan badge, serta harus bertahan saat berpindah halaman (app state) |

## d. Penjelasan lifecycle dan pilihan state management

Pada halaman form, TextEditingController untuk judul dan mata kuliah saya buat di initState karena hanya perlu dibuat sekali ketika State dibuat, bersama nilai awal tenggat. Di dispose, kedua controller saya buang agar tidak terjadi kebocoran memori ketika halaman ditutup. Setelah await showDatePicker, saya memeriksa mounted sebelum memanggil setState supaya tidak error jika widget sudah dibuang. Filter Semua, Aktif, dan Selesai di halaman daftar saya simpan sebagai ephemeral state dengan setState, karena hanya dipakai satu widget dan tidak perlu diketahui halaman lain. Daftar tugas beserta operasi tambah, tandai selesai, dan hapus adalah app state yang dipakai tiga halaman, sehingga saya simpan di PlannerModel (ChangeNotifier) yang disediakan ChangeNotifierProvider di atas MaterialApp. Saya memilih Provider daripada Cubit karena kebutuhan aplikasi ini sederhana, boilerplate-nya sedikit, dan model yang tidak mengimpor UI tetap mudah diuji dengan unit test. Halaman daftar dan statistik memakai context.watch agar otomatis diperbarui, tombol aksi memakai context.read karena hanya memanggil method, dan badge di navigasi memakai context.select pada jumlahAktif supaya hanya dibangun ulang ketika angka itu berubah.

## e. Pernyataan penggunaan AI

Saya menggunakan Claude (Anthropic) sebagai asisten untuk memandu langkah pengerjaan, membantu menyusun kode aplikasi dan unit test, serta merapikan draf penjelasan pada bagian d. Seluruh langkah dijalankan sendiri di laptop dan perangkat saya, dan saya telah membaca penjelasannya.