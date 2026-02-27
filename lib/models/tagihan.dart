class Tagihan {
  final String id;
  final String penghuniId;
  final String namaPenghuni;
  final String bulan;
  final int nominal;
  bool isLunas;

  Tagihan({
    required this.id,
    required this.penghuniId,
    required this.namaPenghuni,
    required this.bulan,
    required this.nominal,
    this.isLunas = false,
  });
}
