import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'halaman_daftar.dart';
import 'halaman_form.dart';
import 'halaman_statistik.dart';
import 'planner_model.dart';

void main() => runApp(
      // Satu objek PlannerModel untuk seluruh aplikasi.
      ChangeNotifierProvider(
        create: (_) => PlannerModel()
          ..tambah(
            judul: 'Laporan Praktikum Flutter',
            mataKuliah: 'Pemrograman Mobile',
            tenggat: DateTime(2026, 11, 25),
          )
          ..tambah(
            judul: 'Kuis Basis Data',
            mataKuliah: 'Basis Data',
            tenggat: DateTime(2026, 12, 2),
          ),
        child: const PlannerApp(),
      ),
    );

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => KerangkaNavigasi(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HalamanDaftar(),
              routes: [
                GoRoute(
                  path: 'tambah', // URL lengkap: /tambah
                  builder: (context, state) => const HalamanForm(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/statistik',
              builder: (context, state) => const HalamanStatistik(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Planner Tugas Kuliah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C6BC0)),
      ),
      routerConfig: _router,
    );
  }
}

/// Kerangka navigasi dengan badge jumlah tugas aktif.
class KerangkaNavigasi extends StatelessWidget {
  const KerangkaNavigasi({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    // select: hanya dibangun ulang bila jumlahAktif berubah.
    final aktif = context.select((PlannerModel m) => m.jumlahAktif);

    Widget ikonTugas(IconData ikon) => Badge.count(
          count: aktif,
          isLabelVisible: aktif > 0,
          child: Icon(ikon),
        );

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: ikonTugas(Icons.checklist_outlined),
            selectedIcon: ikonTugas(Icons.checklist),
            label: 'Tugas',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}