import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qrmenu/core/models/menu/amount.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/utils/constants.dart';

import 'alerts_widgets.dart';
import 'pdf_theme.dart';

Future<Uint8List> generatePdfStyleThree(
    PdfPageFormat format, Map<String, List<Menu>> menus) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  final titleFont = await PdfGoogleFonts.bodoniModaSemiBold();
  final bodyFont = await PdfGoogleFonts.openSansRegular();
  final currencyFont = await PdfGoogleFonts.openSansBold();
  final allergenFont = await PdfGoogleFonts.poppinsLight();

  final menuDivider =
      await rootBundle.loadString('assets/svg/menu_divider.svg');

  final pageTheme = await myPageTheme(format, 3);

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      build: (context) {
        return [
          pw.SizedBox(height: 40),
          pw.Center(
            child: pw.Text(
              "Mittagskarte",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: titleFont, fontSize: 32),
            ),
          ),
          pw.Center(
            child: pw.Wrap(
              direction: pw.Axis.vertical,
              crossAxisAlignment: pw.WrapCrossAlignment.center,
              spacing: 20,
              children: List.generate(
                menus.length,
                (index) {
                  String title = menus.keys.toList()[index];
                  List<Menu> menuData = menus.values.toList()[index];

                  return pw.Container(
                    margin: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    width: 230,
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          title.toUpperCase(),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(font: titleFont, fontSize: 14),
                        ),
                        pw.SvgImage(svg: menuDivider),
                        pw.SizedBox(height: 20),
                        pw.Column(
                          children: List.generate(menuData.length, (index2) {
                            List<Amount>? amounts = menuData[index2].amounts;
                            double? unitPrice;
                            if (amounts != null) {
                              if (amounts.isNotEmpty) {
                                amounts.sort(
                                    (a, b) => a.amount!.compareTo(b.amount!));
                                unitPrice = amounts.last.unitPrice;
                              }
                            }
                            return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Expanded(
                                      child: pw.RichText(
                                        text: pw.TextSpan(
                                          text: menuData[index2]
                                              .translateValues!
                                              .name!,

                                          // .translated!
                                          // .name!
                                          // .getStringName("de"),
                                          children: getAllergens(
                                              menuData[index2].allergens,
                                              allergenFont),

                                          style: pw.TextStyle(
                                              font: bodyFont, fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    if (menuData[index2].amounts == null)
                                      pw.Text(
                                        AppConstant.currencyFormat(
                                            "de", menuData[index2].price!),
                                        style: pw.TextStyle(
                                            font: currencyFont, fontSize: 10),
                                      ),
                                    if (menuData[index2].amounts != null)
                                      if (menuData[index2].amounts!.isEmpty)
                                        pw.Text(
                                          AppConstant.currencyFormat(
                                              "de", menuData[index2].price!),
                                          style: pw.TextStyle(
                                              font: currencyFont, fontSize: 10),
                                        ),
                                    if (unitPrice != null)
                                      pw.Text(
                                        AppConstant.currencyFormat(
                                            "de", unitPrice),
                                        style: pw.TextStyle(
                                            font: currencyFont, fontSize: 10),
                                      ),
                                  ],
                                ),
                                if (menuData[index2].description != null)
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
                                                font: bodyFont, fontSize: 6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                        if (index == menus.length - 1) pw.SizedBox(height: 160),
                        if (index == menus.length - 1) pw.SizedBox(height: 20),
                        if (index == menus.length - 1)
                          buildAdditives(titleFont, bodyFont),
                        if (index == menus.length - 1) pw.SizedBox(height: 10),
                        if (index == menus.length - 1)
                          buildAllergens(titleFont, bodyFont)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ];
      },
    ),
  );

  return pdf.save();
}

List<pw.TextSpan>? getAllergens(List<String>? allergens, allergenFont) {
  List<pw.TextSpan> allergenList = [];

  if (allergens == null) return allergenList;

  for (int i = 0; i < allergens.length + 1; i++) {
    late String text;

    if (i == 0) {
      text = " ";
    } else if (i == allergens.length) {
      text = allergens[i - 1];
    } else {
      text = '${allergens[i - 1]}, ';
    }
    final algrn = pw.TextSpan(
      text: text,
      style: pw.TextStyle(font: allergenFont, fontSize: 6, height: 0.5),
    );
    allergenList.add(algrn);
  }

  return allergenList;
}
