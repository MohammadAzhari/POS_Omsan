import 'dart:io';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_osman/Customerslibs/customer.dart';

class dataFetch {
  Future<String> getItemsDataString() async {
    final directory = await getApplicationDocumentsDirectory();
    print("the path is ${directory.path}");
    Future<String> data;

    File csvFile = File("${directory.path}/ItemsData.csv");
    if (!await csvFile.exists()) {
      csvFile = await File("${directory.path}/ItemsData.csv").writeAsString('''
          ICT,Malaria-AG,1,1,RighSign,4300.0,Alltest,4500.0,cart(112),481600.0,pcs,200.0,Cart(echo),229600.0
          LAB,Gloves,1,0,box,1700.0,cart(powder),16000.0,su  gloves ,10000.0
          Containers,Apendorf ,1,0,,2000.0
          Reagents,Wiedal,1,0,Biosciene,2100.0,Animol,2100.0
          Devices,Microscope,1,0,107,125000.0
    ''');
    }
    data = csvFile.readAsString();
    return data;
  }

  Future<void> saveDataString(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    File("${directory.path}/ItemsData.csv").writeAsString(data, flush: true);
  }

  Future<void> saveCustomerData(Customer customer) async {
    final directory = await getApplicationDocumentsDirectory();

    String path =
        "${directory.path}/OldInvoices/${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}/";
    String fileName = customer.orderNo.toString() + ".csv";
    File(path + fileName)
        .create(recursive: true)
        .then((file) => file.writeAsString(customer.GetInvoiceAsCSV()));
  }

  Future<List<String>> getAllCustomerStringInDate(
      int year, int month, int day) async {
    List<String> res = [];
    final directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/OldInvoices/${year}/${month}/${day}";
    try {
      List<FileSystemEntity> allfiles = await Directory(path).list().toList();
      for (final file in allfiles) {
        if (await file.exists()) res.add(await (file as File).readAsString());
      }
    } catch (e) {
      print("no files");
    }

    return res;
  }
}
