import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'planner_model.dart';
import 'tugas_kuliah.dart';

enum FilterTugas { semua, aktif, selesai }

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  // Ephemeral state: hanya dipakai halaman ini, cukup setState.
  FilterTugas _filter = FilterTugas.semua;

  String _label(FilterTugas f) => switch (f) {
        FilterTugas.semua => 'Semua',
        FilterTugas.aktif => 'Aktif',
        FilterTugas.selesai => 'Selesai',
      };

  bool _lolos(TugasKuliah t) => switch (_filter) {
        FilterTugas.semua => true,
        FilterTugas.aktif => !t.selesai,
        FilterTugas.selesai => t.selesai,
      };

  @override
  Widget build(BuildContext context) {
    // watch: halaman dibangun ulang setiap state bersama berubah.
    final planner = context.watch<PlannerModel>();
    final skema = Theme.of(context).colorScheme;
    final tampil = planner.daftar.where(_lolos).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Planner Tugas Kuliah')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tambah'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                for (final f in FilterTugas.values)
                  FilterChip(
                    label: Text(_label(f)),
                    selected: _filter == f,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
              ],
            ),
          ),
          Expanded(
            child: tampil.isEmpty
                ? const Center(child: Text('Belum ada tugas'))
                : ListView.builder(
                    itemCount: tampil.length,
                    itemBuilder: (context, i) {
                      final t = tampil[i];
                      final terlambat =
                          !t.selesai && t.tenggat.isBefore(DateTime.now());
                      return ListTile(
                        leading: Checkbox(
                          value: t.selesai,
                          // read: di dalam callback, tidak perlu mendengarkan.
                          onChanged: (v) => context
                              .read<PlannerModel>()
                              .tandaiSelesai(t.id, v ?? false),
                        ),
                        title: Text(
                          t.judul,
                          style: TextStyle(
                            decoration:
                                t.selesai ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          '${t.mataKuliah} · ${t.tenggat.tanggalIndonesia}',
                          style: terlambat ? TextStyle(color: skema.error) : null,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              context.read<PlannerModel>().hapus(t.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}