import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/environment.dart';
import '../models/startup.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _submissionsCollection => 
      _firestore.collection(EnvironmentConfig.submissionsCollection);

  /// Submit a new startup to Firestore
  Future<void> submitStartup(Startup startup) async {
    try {
      await _submissionsCollection.doc(startup.id).set({
        ...startup.toJson(),
        'status': 'pending',
        'submittedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit startup: $e');
    }
  }

  /// Get all submissions (for admin use)
  Stream<List<Startup>> getAllSubmissions() {
    return _submissionsCollection
        .snapshots()
        .map((snapshot) {
      final startups = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Startup.fromJson({
          'id': doc.id,
          ...data,
          // Convert Firestore Timestamp to DateTime string
          'submittedAt': (data['submittedAt'] as Timestamp?)?.toDate().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
      
      // Sort in Dart instead of Firestore to avoid index requirements
      startups.sort((a, b) {
        if (a.submittedAt == null && b.submittedAt == null) return 0;
        if (a.submittedAt == null) return 1;
        if (b.submittedAt == null) return -1;
        return b.submittedAt!.compareTo(a.submittedAt!);
      });
      
      return startups;
    });
  }

  /// Get only approved startups (for public display)
  Stream<List<Startup>> getApprovedStartups() {
    return _submissionsCollection
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snapshot) {
      final startups = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Startup.fromJson({
          'id': doc.id,
          ...data,
          'submittedAt': (data['submittedAt'] as Timestamp?)?.toDate().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
      
      // Sort in Dart instead of Firestore to avoid index requirements
      startups.sort((a, b) {
        if (a.submittedAt == null && b.submittedAt == null) return 0;
        if (a.submittedAt == null) return 1;
        if (b.submittedAt == null) return -1;
        return b.submittedAt!.compareTo(a.submittedAt!);
      });
      
      return startups;
    });
  }

  /// Update startup status (for admin approval/rejection)
  Future<void> updateStartupStatus(String startupId, String status, {String? message}) async {
    try {
      await _submissionsCollection.doc(startupId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
        if (message != null) 'adminMessage': message,
      });
    } catch (e) {
      throw Exception('Failed to update startup status: $e');
    }
  }

  /// Delete a startup
  Future<void> deleteStartup(String startupId) async {
    try {
      await _submissionsCollection.doc(startupId).delete();
    } catch (e) {
      throw Exception('Failed to delete startup: $e');
    }
  }

  /// Get startup by ID
  Future<Startup?> getStartupById(String startupId) async {
    try {
      final doc = await _submissionsCollection.doc(startupId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Startup.fromJson({
          'id': doc.id,
          ...data,
          'submittedAt': (data['submittedAt'] as Timestamp?)?.toDate().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get startup: $e');
    }
  }
}
