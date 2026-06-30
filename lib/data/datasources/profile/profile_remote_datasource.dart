import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/errors/exceptions.dart';
import '../../models/user_profile_model.dart';

/// Contract for Firestore profile operations.
abstract class ProfileRemoteDataSource {
  Future<UserProfileModel?> getProfile(String uid);
  Future<void> saveProfile(UserProfileModel profile, {bool isNew});
  Stream<UserProfileModel?> watchProfile(String uid);
}

/// Concrete Firestore implementation.
/// All Cloud Firestore SDK code is isolated here.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid);

  @override
  Future<UserProfileModel?> getProfile(String uid) async {
    try {
      final snap = await _doc(uid).get();
      if (!snap.exists || snap.data() == null) return null;
      return UserProfileModel.fromFirestore(snap);
    } catch (e) {
      throw AuthException('Failed to fetch profile: ${e.toString()}');
    }
  }

  @override
  Future<void> saveProfile(UserProfileModel profile, {bool isNew = false}) async {
    try {
      await _doc(profile.uid).set(
        profile.toFirestore(isNew: isNew),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw AuthException('Failed to save profile: ${e.toString()}');
    }
  }

  @override
  Stream<UserProfileModel?> watchProfile(String uid) {
    return _doc(uid).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return UserProfileModel.fromFirestore(snap);
    });
  }
}
