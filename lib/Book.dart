class Book {
  final String name,type,date;
  final double price;

  Book(this.name, this.type, this.date, this.price);


  //create map for add value
  Map<String,dynamic>toMap(){
    Map<String,dynamic>map={};
    map['name']=name;
    map['price']=price;
    map['type']=type;
    map['date']=date;
    return map;
  }

}