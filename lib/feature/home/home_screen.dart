import 'package:flutter/material.dart';
import 'package:resep_makanan_app/feature/home/widgets/item_resep_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/login');
            },
          )
        ],
      ),
      // menggunakan grid view untuk menampilkan item resep
      body: GridView.builder(
        // tampilkan 2 item
        itemCount: 2,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          // max cross axis extent digunakan untuk menentukan lebar grid
          maxCrossAxisExtent: 400,
          // main axis extent digunakan untuk menentukan tinggi grid
          mainAxisExtent: 250,
          // cross axis spacing digunakan untuk menentukan jarak antara grid item
          crossAxisSpacing: 8,
          // main axis spacing digunakan untuk menentukan jarak antara grid item
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          // mengembalikan widget item resep yang ada di file widgets/item_resep_widget.dart
          return ItemResepWidget(
            onTap: () {
              Navigator.pushNamed(context, '/detail-resep');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/tambah-resep');
        },
        label: const Text("Tambah Resep"),
      ),
    );
  }
}
