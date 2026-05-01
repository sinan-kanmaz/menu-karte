import 'package:qrmenu/core/utils/constants.dart';
import 'package:pdf/widgets.dart' as pw;

buildAllergens(titleFont, bodyFont) {
  Map<String, String> allergens = AppConstant.allergens;

  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    width: 230,
    child: pw.Column(
      children: [
        pw.Text(
          "ALLERGENE",
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: titleFont, fontSize: 8),
        ),
        pw.Column(
          children: List.generate(
            allergens.length,
            (index) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 10),
                  child: pw.Text(
                    allergens.keys.toList()[index],
                    style: pw.TextStyle(font: bodyFont, fontSize: 6),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    allergens.values.toList()[index],
                    textAlign: pw.TextAlign.end,
                    style: pw.TextStyle(font: bodyFont, fontSize: 6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

buildAdditives(titleFont, bodyFont) {
  Map<String, String> additives = AppConstant.additives;
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    width: 230,
    child: pw.Column(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(right: 10),
          child: pw.Text(
            "ZUSATZSTOFFE",
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: titleFont, fontSize: 8),
          ),
        ),
        pw.Column(
          children: List.generate(
            additives.length,
            (index) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 10),
                  child: pw.Text(
                    additives.keys.toList()[index],
                    style: pw.TextStyle(font: bodyFont, fontSize: 6),
                  ),
                ),
                pw.Text(
                  additives.values.toList()[index],
                  style: pw.TextStyle(font: bodyFont, fontSize: 6),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
