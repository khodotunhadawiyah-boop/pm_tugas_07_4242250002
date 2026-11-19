import 'package:flutter_test/flutter_test.dart';
import 'package:pm_tugas_07/planner_model.dart';

void main() {
  final tenggat = DateTime(2026, 11, 30);

  test('tambah menambah tugas dan memberi notifikasi', () {
    final model = PlannerModel();
    var notifikasi = 0;
    model.addListener(() => notifikasi++);

    model.tambah(judul: 'Laporan', mataKuliah: 'Mobile', tenggat: tenggat);

    expect(model.total, 1);
    expect(model.jumlahAktif, 1);
    expect(notifikasi, 1);
  });

  test('tandaiSelesai mengubah statistik', () {
    final model = PlannerModel();
    model.tambah(judul: 'A', mataKuliah: 'Mobile', tenggat: tenggat);
    model.tambah(judul: 'B', mataKuliah: 'Mobile', tenggat: tenggat);

    model.tandaiSelesai(model.daftar.first.id, true);

    expect(model.jumlahSelesai, 1);
    expect(model.jumlahAktif, 1);
    expect(model.persenSelesai, 50);
  });

  test('hapus membuang tugas yang dipilih saja', () {
    final model = PlannerModel();
    model.tambah(judul: 'A', mataKuliah: 'Mobile', tenggat: tenggat);
    model.tambah(judul: 'B', mataKuliah: 'Mobile', tenggat: tenggat);

    model.hapus(model.daftar.first.id);

    expect(model.total, 1);
    expect(model.daftar.first.judul, 'B');
  });

  test('persentase 0 saat daftar kosong', () {
    expect(PlannerModel().persenSelesai, 0);
  });
}