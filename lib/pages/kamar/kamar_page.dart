import 'package:flutter/material.dart';
import '../../models/penghuni.dart';

class KamarPage extends StatelessWidget {
  final List<Penghuni> listPenghuni;

  const KamarPage({super.key, required this.listPenghuni});

  @override
  Widget build(BuildContext context) {
    final kamarList = ["A1", "A2", "A3", "B1", "B2", "B3"];

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("Data Kamar"),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView.builder(
        itemCount: kamarList.length,
        itemBuilder: (context, index) {
          final kamar = kamarList[index];
          final penghuniKamar = listPenghuni
              .where((p) => p.kamar == kamar)
              .length;

          final sisa = 2 - penghuniKamar;
          final isFull = penghuniKamar >= 2;

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.meeting_room),
              title: Text("Kamar $kamar"),
              subtitle: Text("Terisi: $penghuniKamar/2\nSisa: $sisa"),
              trailing: Chip(
                label: Text(isFull ? "Penuh" : "Tersedia"),
                backgroundColor: isFull ? Colors.red : Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
