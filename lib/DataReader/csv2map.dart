import 'dart:ffi';

import 'package:pos_osman/DataReader/datafetch.dart';
import 'package:pos_osman/Items_screen_libs/CompanyInfo.dart';
import 'package:pos_osman/Items_screen_libs/item.dart';
import 'package:pos_osman/main.dart';

class CSV2Map {
  Future<Map<String, List<Item>>> getDataMap() async {
    String allDataString = await dataFetch().getItemsDataString();
    Map<String, List<Item>> tempMap = Map<String, List<Item>>();
    // {cat: [name : CompanyInfo()]}
    categories.forEach((category) {
      tempMap[category] = <Item>[];
    });
    List<String> lines = allDataString.split("\n");
    for (int i = 0; i < lines.length; i++) {
      try {
        String line = lines[i];
        List<String> data = line.split(",");

        if (data.length < 3) continue;
        String Category = data[0];
        String name = data[1];
        bool available = int.parse(data[2]) == 1 ? true : false;
        bool inHome = int.parse(data[3]) == 1 ? true : false;
        Map<String, CompanyInfo> details = {};
        for (int i = 4; i < data.length; i += 3) {
          try {
            details[data[i]] = CompanyInfo(
                price: double.parse(data[i + 1]),
                buyPrice: double.parse(data[i + 2]));
          } catch (e) {
            print('error in get data map from csv');
            print(e);
            print('-----------------------------------');
          }
        }
        // print("cat = " + Category + ".");
        // print("name = " + name);
        // details.forEach((key, value) {
        //   print(key + " " + value.toString());
        // });
        // print(tempMap[Category]!.length);
        tempMap[Category]!.add(Item(
            category: Category,
            name: name,
            available: available,
            inHome: inHome,
            details: details));
      } catch (e) {
        continue;
      }
    }
    return tempMap;
  }

  Future<void> saveDataMap() async {
    String newData = "\n";
    categories.forEach((category) {
      List<Item> itemsList = allItemsData[category]!;
      itemsList.forEach((item) {
        String dataLine = "";
        dataLine +=
            "\n${category},${item.name},${item.available ? 1 : 0},${item.inHome ? 1 : 0}";
        item.details.forEach((key, value) =>
            dataLine += ",${key},${value.price},${value.buyPrice}");
        print(dataLine);
        newData += dataLine;
      });
    });
    dataFetch().saveDataString(newData);
  }
}
