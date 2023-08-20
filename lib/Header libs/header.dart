import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:pos_osman/BlueToothPrinter/connection_screen.dart';
import 'package:pos_osman/DataReader/csv2map.dart';
import 'package:pos_osman/DataReader/datafetch.dart';
import 'package:window_manager/window_manager.dart';
import '../Header%20libs/header_icon.dart';
import '../HotRestart.dart';
import '../Invoice_libs/invoice_item.dart';
import '../Items_screen_libs/item.dart';
import '../Customerslibs/customer_screen.dart';
import '../main.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

class Header extends StatefulWidget {
  Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final _textController = TextEditingController();
  BuildContext? _context;
  bool databaseHover = false;
  String Emptyname = "";
  String Emptyprice = "0";
  String Emptyqty = "1";
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      // width: fullScreenWidth,
      height: 30,
      color: const Color.fromARGB(255, 27, 27, 27),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          // Expanded(child: SizedBox()),
          // Expanded(child: SizedBox()),
          functionaIcons(),
        ],
      ),
    );
  }

  Widget functionaIcons() {
    return Container(
      width: fullScreenWidth / 1.5,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        EmptyItemIcon(),
        importData(),
        exportData(),
        historyIcon(),
        ConnectIcon(),
        allPricesIcon()
      ]),
    );
  }

  Widget historyIcon() {
    return HeaderIcon(
      icon: const Icon(
        Icons.new_label,
        size: 24,
      ),
      tapFunction: showHistory,
    );
  }

  Widget importData() {
    return HeaderIcon(
      icon: const Icon(
        Icons.import_contacts,
        size: 24,
      ),
      tapFunction: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Import Data'),
                content: TextField(
                  // multiline
                  maxLines: 200,
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Paste Data String Here',
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      // Do something with the text input
                      final text = _textController.text;
                      await dataFetch().saveDataString(text);

                      allItemsData = await CSV2Map().getDataMap();
                      ItemsStreamController.add(true);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Import'),
                  )
                ],
              );
            });
      },
    );
  }

  Widget ConnectIcon() {
    return HeaderIcon(
      icon: Icon(
        Icons.bluetooth,
        color: isConnectedToBlueToothPrinter ? Colors.green : Colors.red,
        size: 24,
      ),
      tapFunction: OpenBluetoothConnection,
    );
  }

  Widget EmptyItemIcon() {
    return HeaderIcon(
      icon: const Icon(
        Icons.add,
        size: 24,
      ),
      tapFunction: addEmpty,
    );
  }

  void showHistory() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              content: CustomerScreen(),
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
            ));
  }

  void addEmpty() {
    showPopScreen(_context);
  }

  Future<void> showPopScreen(BuildContext) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: EmptyScreen(),
          actions: [
            HeaderIcon(
                tapFunction: addEmptyToInvoice,
                icon: Icon(
                  Icons.add,
                  size: 40,
                )),
          ],
        );
      },
    );
  }

  void OpenBluetoothConnection() {
    /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ConnectionScreen(title: "connect to Bluettoth"),
    ));*/
  }

  Widget EmptyScreen() {
    return Container(
      height: fullScreenHeight / 1,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Name
            Container(
              height: 50,
              padding: const EdgeInsets.all(0.0),
              margin: EdgeInsets.all(3),
              child: TextField(
                onChanged: (x) {
                  Emptyname = x;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),

            // price
            Container(
              height: 50,
              padding: const EdgeInsets.all(0.0),
              margin: EdgeInsets.all(3),
              child: TextField(
                onChanged: (x) {
                  Emptyprice = x;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.euro),
                  border: OutlineInputBorder(),
                ),
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),

            // Quantity
            Container(
              height: 50,
              padding: const EdgeInsets.all(0.0),
              margin: EdgeInsets.only(left: 3, right: 3, top: 3),
              child: TextField(
                onChanged: (x) {
                  Emptyqty = x;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ]),
    );
  }

  void addEmptyToInvoice() {
    currentCustomer.invoiceItems.add(InvoiceItem(
      category: "LAB",
      name: Emptyname,
      details: "",
      price: double.parse(Emptyprice),
      qty: int.parse(Emptyqty),
    ));
    HotRestartController.performHotRestart(context);
  }

  void GetAllItemsPrices() {
    // // AudioPlayer().play(AssetSource('audio/my_audio.mp3'));
    String temp =
        "prices for ${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}";
    categories.forEach((cat) {
      temp += "\n###### ${cat} ######\n";
      allItemsData[cat]!.forEach((item) {
        if (item.available) {
          item.details.forEach((comp, value) {
            temp +=
                "\n ${item.name} [${comp}] = " + value.price.toStringAsFixed(0);
          });
        }
      });
    });
    Clipboard.setData(ClipboardData(text: temp));
  }

  Widget allPricesIcon() {
    return HeaderIcon(
      icon: const Icon(
        Icons.price_change,
        size: 24,
      ),
      tapFunction: GetAllItemsPrices,
    );
  }

  Widget exportData() {
    return HeaderIcon(
      icon: const Icon(
        Icons.outbond,
        size: 24,
      ),
      tapFunction: () async {
        String temp = await dataFetch().getItemsDataString();
        Clipboard.setData(ClipboardData(text: temp));
      },
    );
  }
}
