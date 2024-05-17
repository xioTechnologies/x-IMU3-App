extension PluralExtension on int {
  String plural(String singularWord, [String pluralLetters = "s"]) {
    return this > 1 ? "$this $singularWord$pluralLetters" : "$this $singularWord";
  }
}
