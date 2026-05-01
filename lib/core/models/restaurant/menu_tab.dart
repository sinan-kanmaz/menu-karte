class MenuTab {
  String? en;
  String? de;
  String? nl;
  String? fr;
  String? tr;

  MenuTab({
    this.en,
    this.de,
    this.nl,
    this.fr,
    this.tr,
  });

  MenuTab.fromJson(dynamic json) {
    en = json['en'];
    de = json['de'];
    nl = json['nl'];
    fr = json['fr'];
    tr = json['tr'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['en'] = en;
    map['de'] = de;
    map['nl'] = nl;
    map['fr'] = fr;
    map['tr'] = tr;

    return map;
  }

  String getLacalName(String localeName) {
    switch (localeName) {
      case "en":
        return en.toString();

      case "de":
        return de.toString();
      case "nl":
        return nl.toString();
      case "fr":
        return fr.toString();
      case "tr":
        return tr.toString();
      default:
        return "";
    }
  }
}
