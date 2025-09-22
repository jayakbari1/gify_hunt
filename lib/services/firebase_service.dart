import 'package:firebase_database/firebase_database.dart';
import '../config/environment.dart';
import '../models/startup.dart';

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> submitStartup(Startup startup) async {
    final ref = _database.ref().child('${EnvironmentConfig.submissionsCollection}/${startup.id}');
    await ref.set(startup.copyWith(status: 'pending', submittedAt: DateTime.now()).toJson());
  }

  Stream<List<Startup>> getAllSubmissions() {
    final ref = _database.ref().child(EnvironmentConfig.submissionsCollection);
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      return data.values.map((e) => Startup.fromJson(Map<String, dynamic>.from(e))).toList();
    });
  }

  Stream<List<Startup>> getApprovedStartups() {
    final ref = _database.ref().child(EnvironmentConfig.submissionsCollection);
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      return data.values.map((e) => Startup.fromJson(Map<String, dynamic>.from(e))).where((s) => s.status == 'approved').toList();
    });
  }
}
