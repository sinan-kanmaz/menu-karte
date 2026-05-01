import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/utils/constants.dart';

import 'alerts_widgets.dart';
import 'pdf_theme.dart';

Future<Uint8List> generatePdfStyleOne(
    PdfPageFormat format, Map<String, List<Menu>> menus) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  final titleFont = await PdfGoogleFonts.bodoniModaSemiBold();
  final bodyFont = await PdfGoogleFonts.openSansRegular();
  final currencyFont = await PdfGoogleFonts.openSansBold();
  final allergenFont = await PdfGoogleFonts.poppinsLight();

  // List<Menu> allergenList = [];

  // allergens.forEach((key, value) {
  //   allergenList.add(
  //     Menu(
  //         restaurantId: "restaurantId",
  //         order: 1,
  //         translateValues: TranslateValues(name: value),
  //         price: 5),
  //   );
  // });

  // menus["ALLERGENE"] = allergenList;

  final menuDivider =
      await rootBundle.loadString('assets/svg/menu_divider.svg');
  // final logo = pw.MemoryImage(
  //   (await rootBundle.load('assets/images/pongarten_logo.png'))
  //       .buffer
  //       .asUint8List(),
  // );

  final pageTheme = await myPageTheme(format, 1);

  pdf.addPage(
    pw.MultiPage(
      // pageFormat: PdfPageFormat.a4,
      // margin: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 6),
      // margin: const pw.EdgeInsets.only(left: 40, top: 6),
      pageTheme: pageTheme,

      build: (context) {
        return [
          // pw.Row(
          //   mainAxisAlignment: pw.MainAxisAlignment.center,
          //   children: [
          //     pw.Image(logo, width: 200, height: 100, fit: pw.BoxFit.contain),
          //   ],
          // ),
          pw.Center(
            child: pw.Wrap(
              direction: pw.Axis.vertical,
              crossAxisAlignment: pw.WrapCrossAlignment.center,
              spacing: 20,
              children: List.generate(
                menus.length,
                (index) {
                  String? title;
                  List<Menu>? menuData;

                  title = menus.keys.toList()[index];
                  menuData = menus.values.toList()[index];

                  return buildCategoryItem(
                      title,
                      titleFont,
                      menuDivider,
                      menuData,
                      allergenFont,
                      bodyFont,
                      currencyFont,
                      index == menus.length - 1);
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

buildCategoryItem(String title, titleFont, menuDivider, menuData, allergenFont,
    bodyFont, currencyFont, bool isLast) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          children: List.generate(
            menuData!.length,
            (index2) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.RichText(
                          text: pw.TextSpan(
                            text: menuData![index2].translateValues!.name!,

                            // .translated!
                            // .name!
                            // .getStringName("de"),
                            children: getAllergens(
                                menuData[index2].allergens, allergenFont),

                            style: pw.TextStyle(font: bodyFont, fontSize: 10),
                          ),
                        ),
                      ),
                      pw.Text(
                        AppConstant.currencyFormat(
                            "de", menuData[index2].price!),
                        style: pw.TextStyle(font: currencyFont, fontSize: 12),
                      ),
                    ],
                  ),
                  if (title == "GEFÜLLTE PIZZABRÖTCHEN" ||
                      title == "PIZZA" ||
                      title == "SKALOPPINEN & MEDAILLONS")
                    pw.Text(
                      menuData[index2].translateValues!.description!,
                      // .translated!
                      // .name!
                      // .getStringName("de"),
                      style: pw.TextStyle(font: bodyFont, fontSize: 8),
                    ),
                ],
              );
            },
          ),
        ),
        if (isLast) pw.SizedBox(height: 20),
        if (isLast) buildAdditives(titleFont, bodyFont),
        if (isLast) pw.SizedBox(height: 10),
        if (isLast) buildAllergens(titleFont, bodyFont)
      ],
    ),
  );
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
