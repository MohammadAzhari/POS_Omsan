import 'package:flutter/material.dart';
import 'package:pos_osman/Header%20libs/header.dart';
import 'package:pos_osman/Items_screen_libs/CompanyInfo.dart';
import '../Items_screen_libs/catedory.dart';
import '../Items_screen_libs/specificationScreen.dart';
import '../main.dart';

import 'item.dart';

//###########################################################
//#############  items screen to show all items #############
//###########################################################

//build with one column contain 2 raws each one with 3 columns called category
//####Category#####
//    class that get input(category name,number of horizental elemnts,number of Vertical elemnts,Color)

class ItemsWidget extends StatefulWidget {
  final Stream<bool> stream;
  const ItemsWidget({Key? key, required this.stream}) : super(key: key);

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  Item toSaleItem = Item(details: {"Company": CompanyInfo()});

  callback(item) {
    setState(() {
      toSaleItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.stream.listen((event) {
      refresh();
    });
  }

  refresh() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
        child: ListView(
          children: [
            Header(),
            Category(
              name: "ICT",
              h: 2,
              w: 7,
              color: Color.fromARGB(136, 255, 82, 82),
              setItemFunction: callback,
            ),
            Category(
              name: "Containers",
              w: 7,
              h: 3,
              color: Color.fromARGB(120, 50, 170, 220),
              setItemFunction: callback,
            ),
            Category(
                name: "LAB",
                w: 7,
                h: 5,
                color: Color.fromARGB(120, 15, 150, 109),
                setItemFunction: callback),
            Category(
                name: "Reagents",
                w: 7,
                h: 5,
                color: Color.fromARGB(120, 233, 124, 0),
                setItemFunction: callback),
            Category(
                name: "Devices",
                w: 7,
                h: 5,
                color: Color.fromARGB(120, 112, 112, 220),
                setItemFunction: callback)
          ],
        ),
      ),
    );
  }
}
