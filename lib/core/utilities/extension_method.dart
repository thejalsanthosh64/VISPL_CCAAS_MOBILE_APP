extension StringExt on String {
  String get capitalizeFirstLetterOfTwoWords {
    if (trim().isEmpty) {
      return '';
    }

    List<String> nameParts = split(' ');

    String firstInitial = nameParts[0].trim().isNotEmpty
        ? nameParts[0][0].trim().toUpperCase()
        : '';
    String secondInitial = '';

    if (nameParts.length > 1 && nameParts[1].trim().isNotEmpty) {
      secondInitial = nameParts[1][0].trim().toUpperCase();
    }

    return secondInitial.isNotEmpty
        ? '$firstInitial$secondInitial'
        : firstInitial;
  }
}
