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

  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book List"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  //padding use korle keybord er opor form feild gula uthe jabe
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Add New Book"),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              hintText: "Name", border: OutlineInputBorder()),
                        ),
                        TextFormField(
                          controller: typeController,
                          decoration: const InputDecoration(
                              hintText: "Type", border: OutlineInputBorder()),
                        ),
                        TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(
                              hintText: "Price", border: OutlineInputBorder()),
                        ),
                        TextFormField(
                          controller: dateController,
                          decoration: const InputDecoration(
                              hintText: "Date", border: OutlineInputBorder()),
                        ),
                        ElevatedButton(
                            onPressed: ()  async {
                              Book book = Book(
                                nameController.text,
                                typeController.text,

                                dateController.text,
                                double.tryParse(priceController.text)??0,
                              );
                              await cloudstore.addNewBook(book).then((value) {
                                nameController.clear();
                                typeController.clear();
                                dateController.clear();
                                priceController.clear();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Done")));
                              });
                            },
                            child: const Text("Add"))
                      ],
                    ),
                  ),
                );
              });




        },
        child: const Icon(Icons.add),

      ),
      body: StreamBuilder(
        stream: cloudstore.ListenAllBookCollection(),
        builder: (context, snapshot) {
          //inprogress handle
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
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
          } else {
            return const Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }
}
