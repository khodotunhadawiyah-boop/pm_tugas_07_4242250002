import 'package:flutter/foundation.dart';

import 'tugas_kuliah.dart';

/// State bersama (app state): dipakai halaman daftar, form, statistik, dan badge.
/// Tidak mengimpor pustaka UI, sehingga mudah diuji tanpa widget.
class PlannerModel extends ChangeNotifier {
  final List<TugasKuliah> _daftar = [];
  int _idBerikut = 1;

  List<TugasKuliah> get daftar => List.unmodifiable(_daftar);
  int get total => _daftar.length;
  int get jumlahSelesai => _daftar.where((t) => t.selesai).length;
  int get jumlahAktif => total - jumlahSelesai;
  double get persenSelesai => total == 0 ? 0 : jumlahSelesai / total * 100;

  void tambah({
    required String judul,
    required String mataKuliah,
    required DateTime tenggat,
  }) {
    _daftar.add(TugasKuliah(
      id: _idBerikut++,
      judul: judul,
      mataKuliah: mataKuliah,
      tenggat: tenggat,
    ));
    notifyListeners(); // beri tahu semua widget yang mendengarkan
  }

  void tandaiSelesai(int id, bool nilai) {
    final i = _daftar.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _daftar[i] = _daftar[i].copyWith(selesai: nilai);
    notifyListeners();
  }

  void hapus(int id) {
    _daftar.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}