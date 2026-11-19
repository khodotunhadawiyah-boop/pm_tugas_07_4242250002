import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'planner_model.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: angka ikut berubah otomatis saat tugas ditambah/diselesaikan.
    final p = context.watch<PlannerModel>();
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _KartuAngka(label: 'Total tugas', nilai: '${p.total}'),
          _KartuAngka(label: 'Selesai', nilai: '${p.jumlahSelesai}'),
          _KartuAngka(label: 'Aktif', nilai: '${p.jumlahAktif}'),
          const SizedBox(height: 16),
          Text(
            'Persentase selesai: ${p.persenSelesai.toStringAsFixed(0)}%',
            style: teks.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: p.persenSelesai / 100),
        ],
      ),
    );
  }
}

class _KartuAngka extends StatelessWidget {
  const _KartuAngka({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(nilai, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}