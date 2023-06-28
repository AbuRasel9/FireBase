import 'package:cloud_firestore/cloud_firestore.dart';

import 'Book.dart';

class CloudStoreHelper{
  final db=FirebaseFirestore.instance;

  Future<List<Book>>GetAllBooks() async {
    List<Book> ListOfBook=[];
    final result=await db.collection('Books').get();

    for (var element in result.docs){
      Book  book=Book(
          element.get('name'),
          element.get('type'),
          element.get('date').toString(),
          double.tryParse(element.get('price').toString()) ?? 0
      );
      ListOfBook.add(book);



    }
    return ListOfBook;
  }

  //data update korle auto update hoye jabe screen refresh na korei
  Stream<QuerySnapshot<Map<String, dynamic>>> ListenAllBookCollection(){
    return db.collection('Books').snapshots();
}

}