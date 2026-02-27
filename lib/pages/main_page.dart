import 'package:flutter/material.dart';
import '../models/penghuni.dart';
import '../models/tagihan.dart';
import 'penghuni/penghuni_page.dart';
import 'keuangan/tagihan_page.dart';
import 'kamar/kamar_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late List<Penghuni> listPenghuni;
  late List<Tagihan> listTagihan;

  @override
  void initState() {
    super.initState();
    generateDummyData();
  }

  void generateDummyData() {
    listPenghuni = [
      Penghuni(
        id: "1",
        nama: "Ahmad Rizki",
        nim: "2409116001",
        noHp: "081234567890",
        kamar: "A1",
        bulanTerakhirBayar: 12,
        tahunTerakhirBayar: 2025,
      ),
      Penghuni(
        id: "2",
        nama: "Budi Santoso",
        nim: "2409116002",
        noHp: "081234567891",
        kamar: "B1",
        bulanTerakhirBayar: 2,
        tahunTerakhirBayar: 2026,
      ),
      Penghuni(
        id: "3",
        nama: "Leon S. K.",
        nim: "240911602345",
        noHp: "0812345678960",
        kamar: "B3",
        bulanTerakhirBayar: 11,
        tahunTerakhirBayar: 2025,
      ),
      Penghuni(
        id: "4",
        nama: "Nemesis",
        nim: "2409116234",
        noHp: "0812345671234",
        kamar: "A2",
        bulanTerakhirBayar: 1,
        tahunTerakhirBayar: 2026,
      ),
    ];

    listTagihan = []; // tidak dipakai lagi untuk hitung otomatis
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PenghuniPage(listPenghuni: listPenghuni, listTagihan: listTagihan),
          KamarPage(listPenghuni: listPenghuni),

          // 🔥 FIX DI SINI
          TagihanPage(listPenghuni: listPenghuni),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.lightBlue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Penghuni"),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room),
            label: "Kamar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "Keuangan",
          ),
        ],
      ),
    );
  }
}
