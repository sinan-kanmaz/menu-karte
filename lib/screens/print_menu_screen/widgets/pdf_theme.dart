import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<pw.PageTheme> myPageTheme(PdfPageFormat format, int style) async {
  late pw.MemoryImage background;

  pw.EdgeInsets margin = const pw.EdgeInsets.only(left: 40, top: 6);

  if (style == 1) {
    margin = const pw.EdgeInsets.only(left: 40, top: 110);

    background = pw.MemoryImage(
      (await rootBundle.load('assets/images/menu_background_1.png'))
          .buffer
          .asUint8List(),
    );
  }

  if (style == 2) {
    margin = const pw.EdgeInsets.only(left: 40, top: 20, bottom: 0);

    background = pw.MemoryImage(
      // (await rootBundle.load('assets/images/menu_background.jpg'))
      (await rootBundle.load('assets/images/menu_background_3.jpg'))
          .buffer
          .asUint8List(),
    );
  }

  if (style == 3) {
    margin = const pw.EdgeInsets.only(left: 40, top: 0, right: 40);

    background = pw.MemoryImage(
      (await rootBundle.load('assets/images/menu_background_3.jpg'))
          .buffer
          .asUint8List(),
    );
  }

  // format = format.applyMargin(left: 6, top: 20, right: 6, bottom: 20);

  return pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    margin: margin,
    theme: pw.ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.Image(background, fit: pw.BoxFit.cover),
      );
    },
  );
}
