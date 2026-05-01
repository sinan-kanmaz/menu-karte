class TranslateValues {
  String? name;
  String? description;

  TranslateValues({
    this.name,
    this.description,
  });

  TranslateValues.fromJson(dynamic json) {
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['description'] = description;
    return map;
  }

  @override
  String toString() {
    return "TranslateValues(name: $name, description: $description,)";
  }
}
