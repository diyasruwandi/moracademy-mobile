import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/api_service.dart';

class InformasiController extends GetxController {
  final searchController = ''.obs;
  final searchTextController = TextEditingController();
  final isLoading = false.obs;
  final informations = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInformasi();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> fetchInformasi() async {
    try {
      isLoading.value = true;
      final response = await ApiService.to.getInformasiMagang();

      if (response.isOk && response.body != null) {
        final body = response.body;
        debugPrint("FETCH INFORMASI SUCCESS: $body");
        if (body['status'] == 'success' && body['data'] != null) {
          final List dataList = body['data'];
          final mapped = dataList.map<Map<String, String>>((item) {
            String formattedDate = '';
            if (item['created_at'] != null) {
              try {
                final DateTime parsed =
                    DateTime.parse(item['created_at']).toLocal();
                formattedDate =
                    DateFormat('d MMMM yyyy', 'id_ID').format(parsed);
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
          informations.assignAll(mapped);
        }
      }
    } catch (e) {
      debugPrint("Error fetching informasi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, String>> get filteredInformations {
    final query = searchController.value.trim().toLowerCase();
    if (query.isEmpty) return informations.toList();

    return informations.where((information) {
      return information.values.any(
        (value) => value.toLowerCase().contains(query),
      );
    }).toList();
  }

  void search() {
    searchController.value = searchTextController.text;
  }
}
