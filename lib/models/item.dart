import 'package:grocery_list_app/models/product.dart';

class Item {
  Product product;
  int quantity;
  String magnitude;

  Item(this.product, this.quantity, this.magnitude);
}
