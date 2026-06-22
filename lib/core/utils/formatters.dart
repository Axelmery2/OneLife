import 'package:intl/intl.dart';

class Formatters {
  static String formatAmount(
    double amount,
  ) {
    final formatter =
        NumberFormat('#,##0', 'fr_FR');

    return '${formatter.format(amount)} FCFA';
  }

  static String formatDate(
    DateTime date,
  ) {
    return DateFormat(
      'dd/MM/yyyy',
    ).format(date);
  }

  static String formatDateTime(
    DateTime date,
  ) {
    return DateFormat(
      'dd/MM/yyyy à HH:mm',
    ).format(date);
  }
}