import 'package:flutter/material.dart';

class PendingRequestItemBalanceWidget extends StatelessWidget {
  final String description;
  final String value;

  const PendingRequestItemBalanceWidget(
      {Key? key, required this.description, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedValue = '0';

    if (value != null && value != '0') {
      double numericValue = double.tryParse(value.replaceAll(',', '.')) ?? 0;
      if (numericValue >= 1000) {
        formattedValue = numericValue.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
        if (numericValue >= 1000000) {
          formattedValue = formattedValue.replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]}.') +
              'M';
        }
      } else {
        formattedValue = value;
      }
    }
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
            formattedValue,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
