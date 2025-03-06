// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Biodataservice {
  final FirebaseFirestore db;
  const Biodataservice(this.db);

  // tambahkan dokumen baru dengan id yang dihasilkan
  Future<String> add(Map<String, dynamic> data) async {
    final document = await db.collection('biodata').add(data);
    return document.id;
  }

  // mengambil data dari firebase
  Stream<QuerySnapshot<Map<String, dynamic>>> getBiodata() {
    return db.collection('biodata').snapshots();
  }

  // hapus dokumen berdasarkan id
  Future<void> delete(String documentId) async {
    await db.collection('biodata').doc(documentId).delete();
  }

  // memperbarui dokumen berdasarkan id
  Future<void> update(String documentId, Map<String, dynamic> data) async {
    await db.collection('biodata').doc(documentId).update(data);
  }
}
