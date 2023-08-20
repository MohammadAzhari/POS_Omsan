import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:pos_osman/DataReader/csv2map.dart';
import 'package:pos_osman/Items_screen_libs/item.dart';
import 'package:pos_osman/Items_screen_libs/CompanyInfo.dart';
import 'package:pos_osman/main.dart';

class AddItemToDataBaseScreen extends StatefulWidget {
  Item itemToAddOrEdit;
  bool checkBox_Available = true;
  bool checkBox_inHome = false;
  AddItemToDataBaseScreen({required this.itemToAddOrEdit}) {
    checkBox_Available = itemToAddOrEdit.available;
    checkBox_inHome = itemToAddOrEdit.inHome;
  }

  @override
  State<AddItemToDataBaseScreen> createState() =>
      _AddItemToDataBaseScreenState();
}

class _AddItemToDataBaseScreenState extends State<AddItemToDataBaseScreen> {
  List<TextEditingController> CompaniesTextControllers = [];
  List<TextEditingController> PricesTextController = [];
  List<TextEditingController> BuyPricesTextController = [];

  TextEditingController nameTextController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullScreenWidth / 1.2, // here was 1.5
      height: fullScreenHeight / 1.1,
      child: AddNewItemScreenWidget(),
    );
  }

  Widget AddNewItemScreenWidget() {
    Widget screen = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          StockEditing(),
          Container(
            width: 450,
            // padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.black,
              border: Border.all(color: Colors.amber, width: 3),
            ),
            child: ListView(
              children: allItems(),
            ),
          ),
        ],
      ),
    );

    return screen;
  }

  List<Widget> allItems() {
    List<Widget> temp = [CategoryName(), ItemName()];
    compAndPriceArray().forEach((element) {
      temp.add(element);
    });
    temp.add(Actions());
    return temp;
  }

  Widget CategoryName() {
    return Text(
      widget.itemToAddOrEdit.category,
      style: TextStyle(
          color: Colors.amber, fontSize: 25, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget ItemName() {
    nameTextController.text = widget.itemToAddOrEdit.name;
    return Container(
      // width: 150,
      height: 70,
      margin: EdgeInsets.only(top: 10, bottom: 5, right: 10, left: 10),
      child: TextField(
        controller: nameTextController,
        maxLength: 10,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Item Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
            )),
      ),
    );
  }

  List<Widget> compAndPriceArray() {
    List<Widget> createdArray = [];
    List<String> comps = [];
    List<double> prices = [];
    List<double> buyPrices = [];
    List<double> profits = [];

    widget.itemToAddOrEdit.details.forEach((componyName, companyInfo) {
      comps.add(componyName);
      prices.add(companyInfo.price);
      buyPrices.add(companyInfo.buyPrice ?? 0);
      profits.add(companyInfo.profit);
    });
    int n = comps.length;
    for (int i = 0; i < 6; i++) {
      CompaniesTextControllers.add(TextEditingController());
      PricesTextController.add(TextEditingController());
      BuyPricesTextController.add(TextEditingController());
      if (i < n) {
        CompaniesTextControllers[i].text = comps[i];

        PricesTextController[i].text = prices[i].toStringAsFixed(0);
        BuyPricesTextController[i].text = buyPrices[i].toStringAsFixed(0);
      }
      createdArray.add(CompAndPrice(pos: i));
    }
    return createdArray;
  }

  Widget CompAndPrice({int pos = 0}) {
    return Container(
      // width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 70,
            margin: EdgeInsets.only(right: 5),
            child: TextField(
              // onSubmitted: (x) {
              //   setState(() {});
              // },
              controller: CompaniesTextControllers[pos],
              maxLength: 12,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),

          ///Price
          Container(
            width: 100,
            height: 50,
            child: TextField(
              // onSubmitted: (x) {
              //   setState(() {});
              // },
              keyboardType: TextInputType.number,
              controller: PricesTextController[pos],
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
          Container(
            width: 100,
            height: 50,
            // color: const Color.fromARGB(255, 184, 184, 184),
            child: TextField(
              // onSubmitted: (x) {
              //   setState(() {});
              // },
              keyboardType: TextInputType.number,
              controller: BuyPricesTextController[pos],
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 184, 184, 184),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
          Container(
            width: 70,
            height: 50,
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(left: 4),
            child: Align(
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  profitStringOfIndex(pos),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: profitStringOfIndex(pos).startsWith('-')
                          ? Colors.red
                          : Colors.amber,
                      fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String profitStringOfIndex(int i) {
    String buyPrice = BuyPricesTextController[i]!.text;
    String price = PricesTextController[i]!.text;

    if (buyPrice.isEmpty || price.isEmpty) {
      return "";
    }
    double profit = (double.parse(price) - double.parse(buyPrice));
    return profit.toStringAsFixed(0);
  }

  int getItemIndex() {
    print(widget.itemToAddOrEdit.category);
    for (int i = 0;
        i < allItemsData[widget.itemToAddOrEdit.category]!.length;
        i++) {
      if (widget.itemToAddOrEdit.name ==
          allItemsData[widget.itemToAddOrEdit.category]![i].name) return i;
    }
    return allItemsData[widget.itemToAddOrEdit.category]!.length;
  }

  Item toSaveItem() {
    Map<String, CompanyInfo> details = {};
    for (int i = 0; i < 6; i++) {
      if (PricesTextController[i].text != "") {
        // double price = PricesTextController[i].text;
        details[CompaniesTextControllers[i].text] = CompanyInfo(
          price: parseDouble(PricesTextController[i].text),
          buyPrice: parseDouble(BuyPricesTextController[i].text),
        );
      }
    }
    if (details.length < 1) details = {"comp": CompanyInfo()};
    Item newItem = Item(
        category: widget.itemToAddOrEdit.category,
        name: nameTextController.text,
        details: details);
    newItem.available = widget.checkBox_Available;
    newItem.inHome = widget.checkBox_inHome;
    return newItem;
  }

  double parseDouble(String str) {
    Parser p = new Parser();
    Expression exp = p.parse(str);
    return exp.evaluate(EvaluationType.REAL, ContextModel());
  }

  void saveItemToDataBase() {
    int index = getItemIndex();
    if (index >= allItemsData[widget.itemToAddOrEdit.category]!.length) {
      allItemsData[widget.itemToAddOrEdit.category]!.add(toSaveItem());
    } else {
      allItemsData[widget.itemToAddOrEdit.category]![index] = toSaveItem();
    }
    ItemsStreamController.add(true); // i think it is here
    CSV2Map().saveDataMap();
    Navigator.pop(context);
  }

  void deletItem() {
    int index = getItemIndex();
    if (index >= allItemsData[widget.itemToAddOrEdit.category]!.length) {
      return;
    } else {
      allItemsData[widget.itemToAddOrEdit.category]!.removeAt(index);
    }
    ItemsStreamController.add(true);
    Navigator.pop(context);
  }

  Widget Actions() {
    return Container(
        // width: fullScreenWidth / 3,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                deletItem();
              },
              child: Text(
                'Delete',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                saveItemToDataBase();
              },
              child: Text(
                'Save',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ));
  }

  Widget StockEditing() {
    return Container(
      // width: fullScreenWidth / 4.8,
      height: fullScreenHeight / 0.9,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Column(
        children: StockOptionsWidgets(),
      ),
    );
  }

  List<Widget> StockOptionsWidgets() {
    List<Widget> temp = [
      AvailableCheckBoxWidget(),
      // AtHomeCheckBoxWidget(),
      // StockSize(),
      // ExpYear(),
      // ExpMonth()
    ];
    return temp;
  }

  Widget AvailableCheckBoxWidget() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Available",
            style: optionStyle(),
          ),
          Checkbox(
            fillColor: MaterialStateProperty.all(Colors.blue),
            overlayColor: MaterialStateProperty.all(Colors.white),
            value: widget.checkBox_Available,
            onChanged: (value) {
              setState(() {
                widget.checkBox_Available = value!;
              });
            },
          )
        ],
      ),
    );
  }

  Widget AtHomeCheckBoxWidget() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "In Home",
            style: optionStyle(),
          ),
          Checkbox(
            fillColor: MaterialStateProperty.all(Colors.blue),
            overlayColor: MaterialStateProperty.all(Colors.white),
            value: widget.checkBox_inHome,
            onChanged: (value) {
              setState(() {
                widget.checkBox_inHome = value!;
              });
            },
          )
        ],
      ),
    );
  }

  Widget StockSize() {
    stockController.text = widget.itemToAddOrEdit.stock.toString();
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Stock ",
            style: optionStyle(),
          ),
          Container(
            width: 100,
            height: 30,
            child: TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget ExpYear() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ExpireYear ",
            style: optionStyle(),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: DropdownButton(
              value: 2022,
              onChanged: (newVal) {},
              items: [for (int i = 2022; i < 2030; i++) i]
                  .map((e) => DropdownMenuItem(
                        child: Text(
                          "${e}",
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        value: e,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget ExpMonth() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ExpireYear ",
            style: optionStyle(),
          ),
          Container(
            // width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
            ),
            alignment: Alignment.center,
            child: DropdownButton(
              value: 12,
              onChanged: (newVal) {},
              items: [for (int i = 1; i <= 12; i++) i]
                  .map((e) => DropdownMenuItem(
                        child: Text(
                          "${e}",
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        value: e,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle optionStyle() {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.amber,
    );
    ;
  }
}
