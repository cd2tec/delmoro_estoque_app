class FormatDatesUtils {
  String formatDate(String dateString) {
    if (dateString.isEmpty || dateString == '0') {
      return '';
    }

    try {
      DateTime date = DateTime.parse(dateString);

      String formattedDate = '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year.toString()}';

      return formattedDate;
    } catch (e) {
      return '$e';
    }
  }
}
