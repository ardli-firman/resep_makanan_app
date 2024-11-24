import 'package:flutter/material.dart';
import 'package:resep_makanan_app/feature/auth/login_screen.dart';
import 'package:resep_makanan_app/feature/auth/registrasi_screen.dart';
import 'package:resep_makanan_app/feature/home/home_screen.dart';
import 'package:resep_makanan_app/feature/resep/detail_resep_screen.dart';
import 'package:resep_makanan_app/feature/resep/tambah_resep_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debug show check untuk menghilangkan debug label
      debugShowCheckedModeBanner: false,
      // initial route untuk menampilkan halaman awal
      initialRoute: '/login',
      // theme data untuk mengatur tema aplikasi
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        // thema appbar untuk mengatur tema appbar
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.green[400],
          // shape border agar border appbar menjadi di bottom
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
        ),
      ),
      // list route untuk menampilkan halaman
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrasiScreen(),
        '/detail-resep': (context) => const DetailResepScreen(),
        '/tambah-resep': (context) => const TambahResepScreen(),
      },
    );
  }
}
