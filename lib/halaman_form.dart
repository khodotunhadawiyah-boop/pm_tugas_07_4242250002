import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'planner_model.dart';
import 'tugas_kuliah.dart';

class HalamanForm extends StatefulWidget {
  const HalamanForm({super.key});

  @override
  State<HalamanForm> createState() => _HalamanFormState();
}

class _HalamanFormState extends State<HalamanForm> {
  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  final _kunci = GlobalKey<FormState>();
  late DateTime _tenggat;

  @override
  void initState() {
    super.initState();
    // Dibuat sekali, saat State dibuat.
    _judul = TextEditingController();
    _mataKuliah = TextEditingController();
    _tenggat = DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    // Wajib dibuang agar tidak terjadi kebocoran memori.
    _judul.dispose();
    _mataKuliah.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tenggat,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    // Setelah await, widget mungkin sudah ditutup.
    if (!mounted) return;
    if (hasil != null) setState(() => _tenggat = hasil);
  }

  void _simpan() {
    if (!_kunci.currentState!.validate()) return;
    context.read<PlannerModel>().tambah(
          judul: _judul.text.trim(),
          mataKuliah: _mataKuliah.text.trim(),
          tenggat: _tenggat,
        );
    context.pop(); // kembali ke daftar
  }

  String? _wajib(String? v, String pesan) =>
      (v == null || v.trim().isEmpty) ? pesan : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: Form(
        key: _kunci,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judul,
              decoration: const InputDecoration(
                labelText: 'Judul tugas',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _wajib(v, 'Judul wajib diisi'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mataKuliah,
              decoration: const InputDecoration(
                labelText: 'Mata kuliah',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _wajib(v, 'Mata kuliah wajib diisi'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pilihTanggal,
              icon: const Icon(Icons.event),
              label: Text('Tenggat: ${_tenggat.tanggalIndonesia}'),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _simpan, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}