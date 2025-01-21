import 'package:get/get.dart';

import '../models/user.model.dart';

class UserController extends GetxController {
  // Observable User model
  var user = User().obs;
  var prenom = "".obs;
  var nom = "".obs;

  // Method to update user
  void setUser(User newUser) {
    user.value = newUser;
  }

  // Method to update user
  void fullNmae(String fisrtName, String lastName) {
    prenom.value = fisrtName;
    nom.value = lastName;
  }
}
