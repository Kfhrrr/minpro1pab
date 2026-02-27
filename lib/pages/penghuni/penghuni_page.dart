import 'package:flutter/material.dart';
import '../../models/penghuni.dart';
import '../../models/tagihan.dart';
import 'form_penghuni.dart';

class PenghuniPage extends StatefulWidget {
  final List<Penghuni> listPenghuni;
  final List<Tagihan> listTagihan;

  const PenghuniPage({
    super.key,
    required this.listPenghuni,
    required this.listTagihan,
  });

  @override
  State<PenghuniPage> createState() => _PenghuniPageState();
}

class _PenghuniPageState extends State<PenghuniPage> {
  void tambahPenghuni(Penghuni penghuni) {
    setState(() {
      widget.listPenghuni.add(penghuni);

      // AUTO BUAT TAGIHAN SAAT TAMBAH PENGHUNI
      widget.listTagihan.add(
        Tagihan(
          id: penghuni.id,
          penghuniId: penghuni.id,
          namaPenghuni: penghuni.nama,
          bulan: "Mei 2026",
          nominal: 500000,
          isLunas: false,
        ),
      );
    });
  }

  void editPenghuni(Penghuni penghuniLama) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPenghuniPage(
          penghuni: penghuniLama,
          listPenghuni: widget.listPenghuni,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        int index = widget.listPenghuni.indexWhere((p) => p.id == result.id);
        widget.listPenghuni[index] = result;
      });
    }
  }

  void hapusPenghuni(String id) {
    setState(() {
      widget.listPenghuni.removeWhere((p) => p.id == id);

      // HAPUS TAGIHAN TERKAIT
      widget.listTagihan.removeWhere((t) => t.penghuniId == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("Data Penghuni"),
        backgroundColor: Colors.lightBlue,
      ),
      body: widget.listPenghuni.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : ListView.builder(
              itemCount: widget.listPenghuni.length,
              itemBuilder: (context, index) {
                final penghuni = widget.listPenghuni[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      penghuni.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "NIM: ${penghuni.nim}\n"
                      "Kamar: ${penghuni.kamar}",
                    ),
                    onTap: () => editPenghuni(penghuni), // ✅ TAMBAH INI
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editPenghuni(penghuni),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => hapusPenghuni(penghuni.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FormPenghuniPage(listPenghuni: widget.listPenghuni),
            ),
          );

          if (result != null) {
            tambahPenghuni(result);
          }
        },
      ),
    );
  }
}
