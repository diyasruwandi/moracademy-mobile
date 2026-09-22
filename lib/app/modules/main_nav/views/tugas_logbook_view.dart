import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_menu_button.dart';
import '../../tugas/views/tugas_view.dart';
import '../../logbook/views/logbook_view.dart';
import '../controllers/main_nav_controller.dart';

class TugasLogbookView extends StatelessWidget {
  const TugasLogbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () {
              if (Get.isRegistered<MainNavController>()) {
                Get.find<MainNavController>().changePage(0);
              } else {
                Get.back();
              }
            },
          ),
          title: const Text(
            'Tugas & Logbook',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          actions: const [
            AppMenuButton(),
          ],
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: [
              Tab(
                child: Text('Tugas',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              Tab(
                child: Text('Logbook',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TugasView(),
            LogbookView(),
          ],
        ),
      ),
    );
  }
}
