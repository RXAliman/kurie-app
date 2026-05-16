import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/submeter.dart';
import '../models/reading.dart';
import '../models/bill.dart';
import '../models/notification_item.dart';

class FirestoreSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  // Collection References
  DocumentReference get _userDoc => _firestore.collection('users').doc(uid);
  CollectionReference get _submetersCol => _userDoc.collection('submeters');
  CollectionReference get _readingsCol => _userDoc.collection('readings');
  CollectionReference get _billsCol => _userDoc.collection('bills');
  CollectionReference get _notificationsCol => _userDoc.collection('notifications');

  // Settings Sync
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    if (uid == null) return;
    await _userDoc.set({'settings': settings}, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getSettings() async {
    if (uid == null) return null;
    final doc = await _userDoc.get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return data['settings'] as Map<String, dynamic>?;
    }
    return null;
  }

  // Generic Sync Methods
  Future<void> saveSubmeter(Submeter submeter) async {
    if (uid == null) return;
    await _submetersCol.doc(submeter.id).set(submeter.toMap());
  }

  Future<void> saveReading(Reading reading) async {
    if (uid == null) return;
    await _readingsCol.doc(reading.id).set(reading.toMap());
  }

  Future<void> saveBill(Bill bill) async {
    if (uid == null) return;
    await _billsCol.doc(bill.id).set(bill.toMap());
  }

  Future<void> saveNotification(NotificationItem notification) async {
    if (uid == null) return;
    await _notificationsCol.doc(notification.id).set(notification.toMap());
  }

  Future<void> deleteSubmeter(String id) async {
    if (uid == null) return;
    await _submetersCol.doc(id).delete();
  }

  // Full Sync from Cloud to Local
  Future<Map<String, List>> fetchAllData() async {
    if (uid == null) return {};

    final submetersSnap = await _submetersCol.get();
    final readingsSnap = await _readingsCol.get();
    final billsSnap = await _billsCol.get();
    final notificationsSnap = await _notificationsCol.get();

    return {
      'submeters': submetersSnap.docs.map((d) => Submeter.fromMap(d.data() as Map<String, dynamic>)).toList(),
      'readings': readingsSnap.docs.map((d) => Reading.fromMap(d.data() as Map<String, dynamic>)).toList(),
      'bills': billsSnap.docs.map((d) => Bill.fromMap(d.data() as Map<String, dynamic>)).toList(),
      'notifications': notificationsSnap.docs.map((d) => NotificationItem.fromMap(d.data() as Map<String, dynamic>)).toList(),
    };
  }

  // Delete all data associated with the user
  Future<void> deleteAllUserData() async {
    if (uid == null) return;

    final batch = _firestore.batch();

    // Helper to add deletes to batch
    Future<void> addCollectionToBatch(CollectionReference col) async {
      final snap = await col.get();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
    }

    await addCollectionToBatch(_submetersCol);
    await addCollectionToBatch(_readingsCol);
    await addCollectionToBatch(_billsCol);
    await addCollectionToBatch(_notificationsCol);

    // Delete root user doc (contains settings)
    batch.delete(_userDoc);

    await batch.commit();
  }
}
