import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();

  static final CloudFirestoreHelper cloudFireStoreHelper =
      CloudFirestoreHelper._();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  int author_id = 3;

  Future<void> getAuthorID() async {
    CollectionReference counterID = firebaseFirestore.collection("id_counter");
    DocumentSnapshot authorDocument = await counterID.doc("author_id").get();
    author_id = authorDocument.get("id");
  }

  Future updateAuthorID({required int id}) async {
    CollectionReference counterID = firebaseFirestore.collection("id_counter");
    await counterID.doc("author_id").update({'id': id});
  }

  Future addAuthor({required String author_name, required List<String> author_books}) async {
    CollectionReference authors = firebaseFirestore.collection("Authors");

    await getAuthorID();

    await authors.doc("author_$author_id").set({
      'author_name': author_name,
      'bookes' : author_books
    }).then((value) async {
      await updateAuthorID(id: author_id + 1);
    });
  }

 Stream<QuerySnapshot> authorQuerySnapshotStream()  {
    Stream<QuerySnapshot> collectionStream = firebaseFirestore.collection("Authors").snapshots();
    return collectionStream;
}

}
