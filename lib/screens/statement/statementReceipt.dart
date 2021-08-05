
import 'dart:io';
import 'package:flutter/material.dart' as Material;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:rex_money/models/statementData.dart';
class StatementReceiptScreen {
  final bgProvider = const Material.AssetImage("assets/pdfLogo.png");
  final headerImageProvider =
  const Material.AssetImage("assets/board.jpg");
  final logoImageProvider = const Material.AssetImage("assets/logoW.png");
  PdfImage bgImage;
  PdfImage headerImage;
  PdfImage logoImage;

  final StatementReceiptData statementReceiptData;

  Document pdf = Document();

  StatementReceiptScreen({this.statementReceiptData});

  Future<void> getBackgroundImage() async {
    bgImage =
    await pdfImageFromImageProvider(pdf: pdf.document, image: bgProvider);
  }

  final stampProvider = const Material.AssetImage("assets/stamp.png");

  PdfImage stampImage;

  Future<void> getHeaderImage() async {
    headerImage = await pdfImageFromImageProvider(
        pdf: pdf.document, image: headerImageProvider);
    logoImage = await pdfImageFromImageProvider(
        pdf: pdf.document, image: logoImageProvider);
    stampImage = await pdfImageFromImageProvider(
        pdf: pdf.document, image: stampProvider);
  }

  requestPermission() async {
    bool  permissions = await Permission.storage.isGranted;
//    Material.debugPrint("Permission: $permissions");
  }
  formatDate(String date) {
    if (date == null) {
      return date ?? "";
    }
  }


  formatAmount(String amount) {
    if (amount != "0") {
      return NumberFormat.currency(name: 'NGN', symbol: '')
          .format(double.parse(amount.replaceAll("USD", "").replaceAll(",", "").replaceAll("NGN", "").replaceAll("\n","")));
    }

    return amount + ".00";
  }
  TextStyle headerStyle =
  TextStyle(color: PdfColor.fromHex("#0D3E53"), fontSize: 20);

  Future<void> buildReceipt() async {
    pdf = Document();
    await requestPermission();
    await getBackgroundImage();
    await getHeaderImage();
    var page = MultiPage(
      pageFormat: PdfPageFormat(42 * (72.0/ 2.54), 59.4  * (72.0/ 2.54)),
      margin: EdgeInsets.zero,
      maxPages: 300,
      build: (context) {
        return [
          Stack(
            children: [
              Opacity(
                opacity: 0.15,
                child: Center(
                  child: Image(bgImage, height: 300, width: 300),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: headerImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 25),
                                    Text(
                                      "ACCOUNT NAME",
                                      style: TextStyle(
                                          color: PdfColor.fromHex("#ffffff"),
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      statementReceiptData.accountName
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: PdfColor.fromHex("#ffffff"),
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "OPENING BALANCE",
                                      style: TextStyle(
                                          color: PdfColor.fromHex("#ffffff"),
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "NGN ${statementReceiptData.openingBalance}"
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: PdfColor.fromHex("#ffffff"),
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "CLOSING BALANCE",
                                      style: TextStyle(
                                          color: PdfColor.fromHex("#ffffff"),
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "NGN ${statementReceiptData.closingBalance}"
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: PdfColor.fromHex("#ffffff"),
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 22),
                                  ],
                                ),
                              ),
                              Transform.translate(
                                offset: PdfPoint(3, 0),
                                child: Image(
                                  logoImage,
                                  width: 400,
                                  height: 400,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: PdfColor.fromHex("#ffffff")),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 25),
                                  Text(
                                    "ACCOUNT NUMBER",
                                    style: TextStyle(
                                        color: PdfColor.fromHex("#ffffff"),
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    statementReceiptData.accountNumber
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: PdfColor.fromHex("#ffffff"),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 25),
                                  Text(
                                    "CURRENCY",
                                    style: TextStyle(
                                        color: PdfColor.fromHex("#ffffff"),
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "NAIRA".toUpperCase(),
                                    style: TextStyle(
                                      color: PdfColor.fromHex("#ffffff"),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 25),
                                  Text(
                                    "PERIOD REQUESTED",
                                    style: TextStyle(
                                        color: PdfColor.fromHex("#ffffff"),
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    statementReceiptData.requestedPeriod
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: PdfColor.fromHex("#ffffff"),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 25),
                                  Text(
                                    "DATE CREATED",
                                    style: TextStyle(
                                        color: PdfColor.fromHex("#ffffff"),
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    formatDate(DateTime.now().toString()),
                                    style: TextStyle(
                                      color: PdfColor.fromHex("#ffffff"),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                              child:
                              Text("TRANSACTION ID", style: headerStyle)),
                          SizedBox(width: 5),
                          Expanded(child: Text("   DATE", style: headerStyle)),
                          SizedBox(width: 5),
                          Expanded(child: Text("DEBIT", style: headerStyle)),
                          SizedBox(width: 5),
                          Expanded(child: Text("CREDIT", style: headerStyle)),
                          SizedBox(width: 5),
                          Expanded(child: Text("BALANCE", style: headerStyle)),
                          SizedBox(width: 5),
                          Expanded(child: Text("REMARKS", style: headerStyle)),
                        ],
                      ),
                      SizedBox(height: 28),
                    ]),
                  ),
                ],
              )
            ],
          ),
          ...List.generate(
            statementReceiptData.statementItem.length,
                (index) {
              var item = statementReceiptData.statementItem[index];
              bool isDebit = item.type.toString().toLowerCase().contains("deb");
              String ref = "";
              for (int i = 0; i < item.txnRef.toString().length; i++) {
                if (i != 0 && i % 11 == 0) {
                  ref += item.txnRef.toString()[i] + "\n";
                } else {
                  ref += item.txnRef.toString()[i];
                }
              }
              String rem = "";
              for (int i = 0; i < item.remark.toString().length; i++) {
                if (i != 0 && i % 13 == 0) {
                  rem += item.remark.toString()[i] + "\n";
                } else {
                  rem += item.remark.toString()[i];
                }
              }
              String amo = "";
              for (int i = 0; i < item.amount.toString().length; i++) {
                if (i != 0 && i % 6 == 0) {
                  amo += item.amount.toString()[i] + "\n";
                } else {
                  amo += item.amount.toString()[i];
                }
              }
              String cb = "";
              for (int i = 0; i < item.currentBalance.toString().length; i++) {
                if (i != 0 && i % 6 == 0) {
                  cb += item.currentBalance.toString()[i] + "\n";
                } else {
                  cb += item.currentBalance.toString()[i];
                }
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(ref,
                                style: headerStyle.copyWith(
                                    fontWeight: FontWeight.bold))),
                        SizedBox(width: 5),
                        Expanded(
                            child: Text("   ${formatDate(item.createdAt)}",
                                style: headerStyle.copyWith(
                                    fontWeight: FontWeight.bold))),
                        SizedBox(width: 5),
                        Expanded(
                            child: Text(
                                "${isDebit ? "-" + formatAmount(amo) : ""}",
                                style: headerStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColor.fromHex("#ff3b0f")))),
                        SizedBox(width: 5),
                        Expanded(
                            child: Text("${!isDebit ? formatAmount(amo) : ""}",
                                style: headerStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColor.fromHex("#06c756")))),
                        SizedBox(width: 5),
                        Expanded(
                            child: Text("${cb}",
                                style: headerStyle.copyWith(
                                    fontWeight: FontWeight.bold))),
                        SizedBox(width: 5),
                        Expanded(
                            child: Text("$rem",
                                style: headerStyle.copyWith(
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 5),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "DISCLAIMER",
              style: TextStyle(
                color: PdfColor.fromHex("#858282"),
                fontSize: 25,
              ),
            ),
          ),
          Divider(color: PdfColor.fromHex("#D3D3D3")),
          Text(
            "This is a computer generated statement and it represents our records of your transactions with us. Any exception must be adviced to the bank immediately. If we do not hear from you within 2 weeks, we will assume that you are in agreement with the details stated. For any enquiries, please contact Glade's customer care team via email at support@glade.ng",
            style: TextStyle(
              color: PdfColor.fromHex("#858282"),
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
          Transform.translate(
            offset: PdfPoint(0, 37),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 200,
                width: 200,
                child: Image(stampImage),
              ),
            ),
          ),
        ];
      },
    );
    pdf.addPage(page);
  }

  Future<bool> downloadReceipt() async {
    await buildReceipt();
    final file = File(
        "/storage/emulated/0/Download/Statement-${statementReceiptData.requestedPeriod}-${DateTime.now().toString()}.pdf");
    await file.writeAsBytes(pdf.save());
    return true;

  }

  printPdf() async {
    // wait for name to load
//    print("print");
    await buildReceipt();
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  sharePdf() async {
    // wait for name to load
    await buildReceipt();
    await Printing.sharePdf(
      bytes: pdf.save(),
      filename:
      "Statement-${statementReceiptData.requestedPeriod}-${DateTime.now().toString()}.pdf",
    );
  }
}