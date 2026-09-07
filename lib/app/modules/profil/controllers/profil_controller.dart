import 'package:get/get.dart';
import '../../../../models/user_model.dart';

class ProfilController extends GetxController {
  final user = UserModel.dummy().obs;
}
