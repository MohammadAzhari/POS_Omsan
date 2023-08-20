import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pos_osman/Items_screen_libs/addItemToDataBaseScreen.dart';
import 'package:pos_osman/Items_screen_libs/CompanyInfo.dart';
import '../Invoice_libs/invoice_item.dart';
import '../Items_screen_libs/specificationScreen.dart';
import '../main.dart';
import 'package:flutter/services.dart';
import 'item.dart';

class ItemWidget extends StatefulWidget {
  Item item;
  Function setItemFunction;
  ItemWidget({Key? key, required this.item, required this.setItemFunction}) {
    if (item.name == "") item.name = "_";
    if (item.details.length < 1) {
      item.details = {"comp": CompanyInfo()};
    }
  }

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 1000,
      // height: 300,
      alignment: Alignment.center,
      child: Material(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        color: widget.item.available ? Colors.white : Colors.grey,
        child: InkWell(
          onTap: () {
            if (widget.item.available) {
              addItem2Invoice();
              InvoiceStreamController.add(true);
              // // AudioPlayer().play(AssetSource('audio/my_audio.mp3'));
            }
          },
          onDoubleTap: () {
            showQTYchangePopScreen(context, widget.item);
          },
          onLongPress: () {
            showDataEditPopScreen(context);
          },
          onHover: (hovering) {
            setState(() => isHovering = hovering);
          },
          splashColor: Colors.amber,
          child: Column(
            children: [
              // name Box
              Container(
                alignment: Alignment.center,
                // width: 0.1 * fullScreenWidth,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  widget.item.name,
                  style: nameStyle(isHovering ? 8 : 10),
                ),
              ),
              //price Box
              Container(
                alignment: Alignment.center,
                // width: 0.1 * fullScreenWidth,
                // height: 0.04 * fullScreenHeight,
                child: Text(
                  (widget.item.details.keys.first == null
                          ? 0
                          : widget.item.details[widget.item.details.keys.first]!
                              .price)
                      .toStringAsFixed(0),
                  style: priceStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle nameStyle(double size) {
    return TextStyle(
      fontFamily: "Roboto",
      fontSize: size,
      color: Colors.black,
      fontWeight: FontWeight.w900,
    );
  }

  TextStyle priceStyle() {
    return TextStyle(
      fontFamily: "Roboto",
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    );
  }

  void addItem2Invoice() {
    int index = -1;
    currentCustomer.invoiceItems.forEach((item) {
      if (item.name == widget.item.name)
        index = currentCustomer.invoiceItems.indexOf(item);
    });
    if (index > -1) {
      currentCustomer.invoiceItems[index].qty += 1;
    } else {
      currentCustomer.invoiceItems.add(InvoiceItem(
        category: widget.item.category,
        name: widget.item.name,
        details: widget.item.details.keys.first,
        price: widget.item.details[widget.item.details.keys.first]!.price ?? 1,
        profit:
            widget.item.details[widget.item.details.keys.first]!.profit ?? 0,
        qty: 1,
      ));
    }
  }

  Future<void> showQTYchangePopScreen(BuildContext, Item) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
          content: SpecificationScreen(toSaleItem: Item),
        );
      },
    );
  }

  Future<void> showDataEditPopScreen(BuildContext context) async {
    await showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          content: AddItemToDataBaseScreen(
            itemToAddOrEdit: widget.item,
          ),
        );
      },
    );
  }
}
