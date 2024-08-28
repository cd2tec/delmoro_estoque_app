import 'package:delmoro_estoque_app/utils/format_dates_utils.dart';
import 'package:flutter/material.dart';

class PendingRequestItemInfoWidget extends StatelessWidget {
  final String description;
  final String value;

  const PendingRequestItemInfoWidget(
      {Key? key, required this.description, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FormatDatesUtils formatDatesUtils = FormatDatesUtils();
    String formattedDate = formatDatesUtils.formatDate(value);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1.0),
          Text(
            description,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            formattedDate,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
