// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Biodataservice {
  final FirebaseFirestore db;
  const Biodataservice(this.db);

  Future<String> add(Map<String, dynamic> data) async {
    final document = await db.collection('biodata').add(data);
    return document.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBiodata() {
    return db.collection('biodata').snapshots();
  }

  Future<void> delete(String documentId) async {
    await db.collection('biodata').doc(documentId).delete();
  }

  Future<void> update(String documentId, Map<String, dynamic> data) async {
    await db.collection('biodata').doc(documentId).update(data);
  }
}
