import 'package:flutter/material.dart';
import 'package:pos_osman/Items_screen_libs/CompanyInfo.dart';
import '../Items_screen_libs/item.dart';
import '../main.dart';

class InvoiceItem extends StatelessWidget {
  String category = "";
  String name = "";
  String details = "";
  double price = 1;
  int qty = 0;
  double get total {
    return price * qty;
  }

  double profit = 0;
  double get totalProfit {
    return profit * qty;
  }

  InvoiceItem(
      {Key? key,
      required this.category,
      required this.name,
      required this.details,
      required this.qty,
      required this.price,
      this.profit = 0})
      : super(key: key);

  Item getDataBaseItem() {
    Item theItem = Item(
        name: "",
        available: true,
        category: "ICT",
        details: {"Comp": CompanyInfo()});
    allItemsData[category]?.forEach((dataBaseItem) {
      if (dataBaseItem.name == this.name) {
        theItem = dataBaseItem;
      }
    });
    return theItem;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
