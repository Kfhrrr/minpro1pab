import 'package:flutter/material.dart';
import '../../models/penghuni.dart';

class FormPenghuniPage extends StatefulWidget {
  final List<Penghuni> listPenghuni;
  final Penghuni? penghuni; // ✅ TAMBAH INI

  const FormPenghuniPage({
    super.key,
    required this.listPenghuni,
    this.penghuni, // ✅ TAMBAH INI
  });

  @override
  State<FormPenghuniPage> createState() => _FormPenghuniPageState();
}

class _FormPenghuniPageState extends State<FormPenghuniPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final nimController = TextEditingController();
  final noHpController = TextEditingController();

  String? selectedKamar;

  final List<String> daftarKamar = ["A1", "A2", "A3", "B1", "B2", "B3"];

  int jumlahPenghuni(String kamar) {
    return widget.listPenghuni.where((p) => p.kamar == kamar).length;
  }

  void initState() {
    super.initState();

    if (widget.penghuni != null) {
      namaController.text = widget.penghuni!.nama;
      nimController.text = widget.penghuni!.nim;
      noHpController.text = widget.penghuni!.noHp;
      selectedKamar = widget.penghuni!.kamar;
    }
  }

  void simpan() {
    if (_formKey.currentState!.validate()) {
      if (jumlahPenghuni(selectedKamar!) >= 2 &&
          widget.penghuni?.kamar != selectedKamar) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kamar sudah penuh (maks 2 orang)"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final penghuniBaru = Penghuni(
        id: widget.penghuni?.id ?? DateTime.now().toString(),
        nama: namaController.text,
        nim: nimController.text,
        noHp: noHpController.text,
        kamar: selectedKamar!,
        bulanTerakhirBayar:
            widget.penghuni?.bulanTerakhirBayar ?? DateTime.now().month,
        tahunTerakhirBayar:
            widget.penghuni?.tahunTerakhirBayar ?? DateTime.now().year,
      );

      Navigator.pop(context, penghuniBaru);
    }
  }

  // ================= VALIDATORS =================

  String? validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return "Nama wajib diisi";
    }

    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(value)) {
      return "Nama hanya boleh huruf";
    }

    return null;
  }

  String? validateNim(String? value) {
    if (value == null || value.isEmpty) {
      return "NIM wajib diisi";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "NIM hanya boleh angka";
    }

    return null;
  }

  String? validateNoHp(String? value) {
    if (value == null || value.isEmpty) {
      return "No HP wajib diisi";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "No HP hanya boleh angka";
    }

    if (value.length < 11) {
      return "No HP minimal 11 digit";
    }

    return null;
  }

  // =================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(
          widget.penghuni == null ? "Tambah Penghuni" : "Edit Data Penghuni",
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
                validator: validateNama,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "NIM",
                  border: OutlineInputBorder(),
                ),
                validator: validateNim,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: noHpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "No HP",
                  border: OutlineInputBorder(),
                ),
                validator: validateNoHp,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedKamar,
                decoration: const InputDecoration(
                  labelText: "Nomor Kamar",
                  border: OutlineInputBorder(),
                ),
                items: daftarKamar.map((kamar) {
                  final sisa = 2 - jumlahPenghuni(kamar);
                  return DropdownMenuItem(
                    value: kamar,
                    child: Text("$kamar (Sisa: $sisa)"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKamar = value;
                  });
                },
                validator: (v) =>
                    v == null ? "Pilih kamar terlebih dahulu" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: simpan,
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
