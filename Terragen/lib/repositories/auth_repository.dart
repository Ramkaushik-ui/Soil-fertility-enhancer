import 'package:flutter/foundation.dart';
import '../models/models.dart';

class AuthRepository extends ChangeNotifier {
  static final AuthRepository _instance = AuthRepository._internal();
  factory AuthRepository() => _instance;
  AuthRepository._internal();

  User? _currentUser = User(
    id: 'usr_101',
    fullName: 'Ram Kaushik',
    email: 'farmer@terragen.ag',
    phoneNumber: '+91 98765 43210',
    farmName: 'PSG Green Agro Farm',
    farmLocation: 'Coimbatore, Tamil Nadu',
    soilType: 'Red Loamy Soil',
  );

  bool _isLoggedIn = true;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  bool login(String email, String pass) {
    if (email.isNotEmpty && pass.isNotEmpty) {
      _currentUser = _currentUser?.copyWith(email: email) ??
          User(
            id: 'usr_101',
            fullName: 'Ram Kaushik',
            email: email,
            phoneNumber: '+91 98765 43210',
            farmName: 'PSG Green Agro Farm',
            farmLocation: 'Coimbatore, Tamil Nadu',
            soilType: 'Red Loamy Soil',
          );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String farmName,
    required String farmLocation,
    required String soilType,
  }) {
    _currentUser = User(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      farmName: farmName,
      farmLocation: farmLocation,
      soilType: soilType,
    );
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  void updateProfile(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}
