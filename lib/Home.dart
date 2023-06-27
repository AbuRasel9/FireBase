

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
    // TODO: implement initState
    super.initState();
    //get all book information and return value set ListOfBooks
    cloudstore.GetAllBooks().then((value) {
      ListOfBooks = value;

      inprogress = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Book List"),
          centerTitle: true,
        ),
        body:Visibility(
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          visible: inprogress==false,
          child: ListView.builder(
              itemCount: ListOfBooks.length,
              itemBuilder: (context,index){

                return  ListTile(
                  title: Text(ListOfBooks[index].name),
                  trailing: Text(ListOfBooks[index].type),
                  subtitle: Text(ListOfBooks[index].date),
                  leading: Text(ListOfBooks[index].price.toString()),
                );


              }),
        )
    );
  }
}


