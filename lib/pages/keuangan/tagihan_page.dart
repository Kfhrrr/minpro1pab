import 'package:flutter/material.dart';
import '../../models/penghuni.dart';

class TagihanPage extends StatefulWidget {
  final List<Penghuni> listPenghuni;

  const TagihanPage({super.key, required this.listPenghuni});

  @override
  State<TagihanPage> createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  final int iuranPerBulan = 150000;

  int hitungTotalTunggakan(Penghuni penghuni) {
    final now = DateTime.now();

    int totalBulanSekarang = now.year * 12 + now.month;
    int totalBulanTerakhirBayar =
        penghuni.tahunTerakhirBayar * 12 + penghuni.bulanTerakhirBayar;

    int selisih = totalBulanSekarang - totalBulanTerakhirBayar;

    if (selisih < 0) selisih = 0;

    return selisih * iuranPerBulan;
  }

  String getStatus(int totalTunggakan) {
    return totalTunggakan == 0 ? "LUNAS" : "MENUNGGAK";
  }

  void updatePembayaran(Penghuni penghuni) {
    int selectedMonth = penghuni.bulanTerakhirBayar;
    int selectedYear = penghuni.tahunTerakhirBayar;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Pembayaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: selectedMonth == 0 ? null : selectedMonth,
                decoration: const InputDecoration(
                  labelText: "Pilih Bulan",
                  border: OutlineInputBorder(),
                ),
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text("Bulan ${index + 1}"),
                  );
                }),
                onChanged: (value) {
                  selectedMonth = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectedYear,
                decoration: const InputDecoration(
                  labelText: "Pilih Tahun",
                  border: OutlineInputBorder(),
                ),
                items: List.generate(6, (index) {
                  int year = 2024 + index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (value) {
                  selectedYear = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
              ),
              onPressed: () {
                setState(() {
                  penghuni.bulanTerakhirBayar = selectedMonth;
                  penghuni.tahunTerakhirBayar = selectedYear;
                });
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("Menu Keuangan Asrama"),
        backgroundColor: Colors.lightBlue,
      ),
      body: widget.listPenghuni.isEmpty
          ? const Center(child: Text("Belum ada data penghuni"))
          : ListView.builder(
              itemCount: widget.listPenghuni.length,
              itemBuilder: (context, index) {
                final penghuni = widget.listPenghuni[index];
                final totalTunggakan = hitungTotalTunggakan(penghuni);
                final status = getStatus(totalTunggakan);

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      penghuni.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Kamar: ${penghuni.kamar}\n"
                      "Terakhir Bayar: Bulan ${penghuni.bulanTerakhirBayar} ${penghuni.tahunTerakhirBayar}\n"
                      "Tunggakan: Rp $totalTunggakan\n"
                      "Status: $status",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () => updatePembayaran(penghuni),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
