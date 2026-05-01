import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/utils/constants.dart';

import 'pdf_theme.dart';

Future<Uint8List> generatePdfStyle2(
    PdfPageFormat format, Map<String, List<Menu>> menus) async {
  final pdf = pw.Document(
    version: PdfVersion.pdf_1_5,
    compress: true,
  );
  // final logo = pw.MemoryImage(
  //   (await rootBundle.load('assets/images/pongarten_logo.png'))
  //       .buffer
  //       .asUint8List(),
  // );

  final titleFont = await PdfGoogleFonts.notoSerifBold();
  final descriptionFont = await PdfGoogleFonts.handleeRegular();
  final bodyFont = await PdfGoogleFonts.openSansRegular();

  final pageTheme = await myPageTheme(format, 2);

  pdf.addPage(
    pw.MultiPage(
      maxPages: 50,
      pageTheme: pageTheme,
      // pageFormat: PdfPageFormat.a4,
      build: (context) => [
        // pw.Row(
        //   mainAxisAlignment: pw.MainAxisAlignment.center,
        //   children: [
        //     pw.Image(logo, width: 200, height: 100, fit: pw.BoxFit.contain),
        //   ],
        // ),
        // pw.Row(
        //   mainAxisAlignment: pw.MainAxisAlignment.center,
        //   children: [
        //     pw.Text(
        //       selectedTab!.en!,
        //       textAlign: pw.TextAlign.center,
        //       style: pw.TextStyle(
        //         // font: titleFont,
        //         fontSize: 18,
        //         fontWeight: pw.FontWeight.bold,
        //         color: PdfColor.fromHex("be3900"),
        //       ),
        //     ),
        //   ],
        // ),
        pw.Center(
          child: pw.Wrap(
            direction: pw.Axis.vertical,
            crossAxisAlignment: pw.WrapCrossAlignment.center,
            spacing: 15,
            children: List.generate(
              menus.length,
              (index) {
                String title = menus.keys.toList()[index];
                List<Menu> menuData = menus.values.toList()[index];

                return pw.Container(
                  margin: const pw.EdgeInsets.symmetric(horizontal: 10),
                  width: 230,
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      if (title != "COCKTAILS2")
                        pw.Text(
                          title,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: titleFont,
                            fontSize: 11,
                            color: PdfColor.fromHex("c01e36"),
                          ),
                        ),
                      pw.SizedBox(height: 10),
                      pw.Column(
                        children: List.generate(
                          menuData.length,
                          (index2) => pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                      menuData[index2].translateValues!.name!
                                      // .translated!
                                      // .name!
                                      // .getStringName("de"),
                                      ,
                                      style: pw.TextStyle(
                                        font: bodyFont,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  if (menuData[index2].amounts!.isEmpty)
                                    pw.Text(
                                      AppConstant.currencyFormat(
                                          "de", menuData[index2].price!),
                                      style: pw.TextStyle(
                                          font: titleFont, fontSize: 8),
                                    ),
                                  if (menuData[index2].amounts!.isNotEmpty)
                                    pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.end,
                                        children: List.generate(
                                          menuData[index2].amounts!.length,
                                          (amountsIndex) => pw.Padding(
                                            padding: const pw.EdgeInsets.only(
                                                right: 10),
                                            child: pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                                pw.Row(children: [
                                                  pw.Text(
                                                    menuData[index2]
                                                        .amounts![amountsIndex]
                                                        .amount
                                                        .toString(),
                                                    style: pw.TextStyle(
                                                        font: bodyFont,
                                                        fontSize: 8),
                                                  ),
                                                  pw.Text(
                                                    menuData[index2]
                                                        .amounts![amountsIndex]
                                                        .unit
                                                        .toString(),
                                                    style: pw.TextStyle(
                                                        font: bodyFont,
                                                        fontSize: 8),
                                                  ),
                                                ]),
                                                pw.Text(
                                                  AppConstant.currencyFormat(
                                                      "de",
                                                      menuData[index2]
                                                          .amounts![
                                                              amountsIndex]
                                                          .unitPrice!),
                                                  style: pw.TextStyle(
                                                      font: titleFont,
                                                      fontSize: 8),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                ],
                              ),
                              // if (menuData[index2].amounts!.isNotEmpty)
                              //   pw.Column(
                              //     children: List.generate(
                              //         menuData[index2].amounts!.length,
                              //         (amountsIndex) => pw.Row(
                              //                 mainAxisAlignment: pw
                              //                     .MainAxisAlignment
                              //                     .spaceBetween,
                              //                 children: [
                              //                   pw.Text(
                              //                     "${menuData[index2].amounts![amountsIndex].amount.toString()} ${menuData[index2].amounts![amountsIndex].unit.toString()}",
                              //                     style: pw.TextStyle(
                              //                         font: bodyFont,
                              //                         fontSize: 7),
                              //                   ),
                              //                   pw.Text(
                              //                     AppConstant.currencyFormat(
                              //                         "de",
                              //                         menuData[index2]
                              //                             .amounts![
                              //                                 amountsIndex]
                              //                             .unitPrice!),
                              //                     style: pw.TextStyle(
                              //                         font: bodyFont,
                              //                         fontSize: 6),
                              //                   )
                              //                 ])),
                              //   ),

                              pw.SizedBox(
                                width: 150,
                                child: pw.Row(
                                  children: [
                                    pw.Expanded(
                                      child: pw.Text(
                                        menuData[index2]
                                            .translateValues!
                                            .description!
                                        // .description
                                        // .toString(),
                                        ,
                                        textAlign: pw.TextAlign.start,
                                        style: pw.TextStyle(
                                            font: descriptionFont, fontSize: 6),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // if (index == menus.length - 1) pw.SizedBox(height: 20),
                      // if (index == menus.length - 1)
                      //   buildAdditives(titleFont, bodyFont),
                      // if (index == menus.length - 1) pw.SizedBox(height: 10),
                      // if (index == menus.length - 1)
                      //   buildAllergens(titleFont, bodyFont)
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );

  return pdf.save();
}
