import 'package:flutter/material.dart';

import 'Book.dart';
import 'CloudFireStore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool inprogress = true;
  List<Book> ListOfBooks = [];

  //create instance
  final cloudstore = CloudStoreHelper();

  @override
  void initState() {
    super.initState();
    // //get all book information and return value set ListOfBooks
    // cloudstore.GetAllBooks().then((value) {
    //   ListOfBooks = value;
    //
    //   inprogress = false;
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book List"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: cloudstore.ListenAllBookCollection(),
        builder: (context, snapshot) {
          //inprogress handle
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          //error state
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            ListOfBooks.clear();
            for (var element in snapshot.data!.docs) {
              Book book = Book(
                  element.get('name'),
                  element.get('type'),
                  element.get('date').toString(),
                  double.tryParse(element.get('price').toString()) ?? 0);
              ListOfBooks.add(book);
            }

            return ListView.builder(
                itemCount: ListOfBooks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(ListOfBooks[index].name),
                    trailing: Text(ListOfBooks[index].type),
                    subtitle: Text(ListOfBooks[index].date),
                    leading: Text(ListOfBooks[index].price.toString()),
                  );
                });

          }else{
            return const Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }
}
