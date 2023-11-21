import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? nombre;
  String? torre;
  String? apartamento;
  String? profilePictureUrl;

  void setUserData({
    String? nombre,
    String? torre,
    String? apartamento,
    String? profilePictureUrl,
  }) {
    this.nombre = nombre;
    this.torre = torre;
    this.apartamento = apartamento;
    this.profilePictureUrl = profilePictureUrl;

    notifyListeners();
  }
}
