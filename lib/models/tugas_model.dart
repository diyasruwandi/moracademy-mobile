class TugasModel {
  final String id;
  final String dari;
  final String ke;
  final String judul;
  final String deskripsi;

  TugasModel({
    required this.id,
    required this.dari,
    required this.ke,
    required this.judul,
    required this.deskripsi,
  });

  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: json['id']?.toString() ?? '',
      dari: json['dari'] ?? '',
      ke: json['ke'] ?? '',
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
    );
  }

  static List<TugasModel> dummyList() {
    return [
      TugasModel(
        id: '1',
        dari: 'Zidan Rifki',
        ke: 'Ardiansyah',
        judul: 'Sql eror saat mengakses data pasien',
        deskripsi:
            'Melakukan integrasi API Midtrans untuk proses checkout. Mengalami sedikit...',
      ),
      TugasModel(
        id: '2',
        dari: 'Zidan Rifki',
        ke: 'Dion S',
        judul: 'Sql eror saat mengakses data pasien',
        deskripsi:
            'Melakukan integrasi API Midtrans untuk proses checkout. Mengalami sedikit...',
      ),
      TugasModel(
        id: '3',
        dari: 'Zidan Rifki',
        ke: 'Nanda Ferdi',
        judul: 'Sql eror saat mengakses data pasien',
        deskripsi:
            'Melakukan integrasi API Midtrans untuk proses checkout. Mengalami sedikit...',
      ),
      TugasModel(
        id: '4',
        dari: 'Zidan Rifki',
        ke: 'Diyas R',
        judul: 'Sql eror saat mengakses data pasien',
        deskripsi:
            'Melakukan integrasi API Midtrans untuk proses checkout. Mengalami sedikit...',
      ),
    ];
  }
}
