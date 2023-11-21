import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  TextEditingController torreController = TextEditingController();
  TextEditingController apartamentoController = TextEditingController();

  void updateUserData(Map<String, dynamic> userData) {
    torreController.text = userData['torre'] ?? "Torre no especificada";
    apartamentoController.text = userData['apartamento'] ?? "Apartamento no especificado";
    notifyListeners();
  }
}
