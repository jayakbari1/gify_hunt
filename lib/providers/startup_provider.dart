import 'package:flutter/foundation.dart';

import '../models/startup.dart';
import '../services/firebase_service.dart';

class StartupProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Startup> _startups = [];
  List<Startup> _userSubmissions = [];
  List<Startup> get startups => _startups;
  List<Startup> get userSubmissions => _userSubmissions;

  void loadStartups() {
    _firebaseService
        .getApprovedStartups()
        .listen((firebaseStartups) {
          _startups = firebaseStartups;
          notifyListeners();
        })
        .onError((error) => debugPrint('Firebase load failed: $error'));
  }

  Future<void> addStartup(Startup startup) async {
    await _firebaseService.submitStartup(startup);
  }

  void loadAllSubmissions() {
    _firebaseService.getAllSubmissions().listen((submissions) {
      _userSubmissions = submissions;
      notifyListeners();
    });
  }
}
