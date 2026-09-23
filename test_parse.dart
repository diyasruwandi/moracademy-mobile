import 'dart:convert';

void main() {
  final bodyStr = '''{
    "status": "success",
    "data": [
      {
        "id": 1,
        "perusahaan_id": 11,
        "judul": "besok libur",
        "konten": "mau liburan",
        "file_lampiran": null,
        "is_active": true,
        "created_at": "2026-09-23T07:26:24.000000Z",
        "updated_at": "2026-09-23T07:26:24.000000Z"
      }
    ]
  }''';

  try {
    final body = jsonDecode(bodyStr);
    if (body['status'] == 'success' && body['data'] != null) {
      final List dataList = body['data'];
      final mapped = dataList.map<Map<String, String>>((item) {
        String formattedDate = '';
        if (item['created_at'] != null) {
          try {
            final DateTime parsed = DateTime.parse(item['created_at']).toLocal();
            formattedDate = parsed.toString(); // simplified for test
          } catch (e) {
            formattedDate = item['created_at'].toString();
          }
        }

        return {
          'id': item['id']?.toString() ?? '',
          'category': 'Informasi Magang',
          'title': item['judul']?.toString() ?? 'Tanpa Judul',
          'date': formattedDate,
          'detail': item['konten']?.toString() ?? '',
          'file_lampiran': item['file_lampiran']?.toString() ?? '',
          'is_active': item['is_active']?.toString() ?? '1',
        };
      }).toList();
      print(mapped);
    }
  } catch (e) {
    print("Error: $e");
  }
}
