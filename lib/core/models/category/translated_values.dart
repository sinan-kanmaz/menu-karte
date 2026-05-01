class TranslatedValues {
  Name? name;
  Description? description;

  TranslatedValues({
    this.name,
    this.description,
  });

  TranslatedValues.fromJson(dynamic json) {
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name?.toJson();
    map['description'] = description?.toJson();

    return map;
  }

  @override
  String toString() {
    return "TranslatedValues(name: $name, description: $description,)";
  }
}

class Name {
  String? en;
  String? de;
  String? nl;
  String? tr;
  String? fr;
  Name({
    this.en,
    this.de,
    this.nl,
    this.tr,
    this.fr,
  });

  Name.fromJson(dynamic json) {
    en = json['en'];
    de = json['de'];
    nl = json['nl'];
    tr = json['tr'];
    fr = json['fr'];
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

  String getStringName(String localeName) {
    switch (localeName) {
      case "en":
        return en.toString();
      case "de":
        return de.toString();
      case "nl":
        return nl.toString();
      case "tr":
        return tr.toString();
      case "fr":
        return fr.toString();
      default:
        return en.toString();
    }
  }
}

class Description {
  String? en;
  String? de;
  String? nl;
  String? tr;
  String? fr;

  Description({
    this.en,
    this.de,
    this.nl,
    this.tr,
    this.fr,
  });

  Description.fromJson(dynamic json) {
    en = json['en'];
    de = json['de'];
    nl = json['nl'];
    tr = json['tr'];
    fr = json['fr'];
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

  String getStringName(String localeName) {
    switch (localeName) {
      case "en":
        return en.toString();
      case "de":
        return de.toString();
      case "nl":
        return nl.toString();
      case "tr":
        return tr.toString();
      case "fr":
        return fr.toString();
      default:
        return en.toString();
    }
  }
}
