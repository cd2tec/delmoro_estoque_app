import 'package:flutter/material.dart';

class PackAndQuantityItemInfoWidget extends StatelessWidget {
  final String description;
  final dynamic value;

  const PackAndQuantityItemInfoWidget(
      {Key? key, required this.description, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedValue = 'N/A';
    if (value != null && value != 'N/A') {
      if (description == 'Preço') {
        formattedValue = double.parse(value.toString()).toStringAsFixed(2);
      } else {
        if (value is num && value >= 1000) {
          formattedValue = value.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]}.',
              );
          if (value >= 1000000) {
            formattedValue = formattedValue.replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]}.',
                ) +
                'M';
          }
        } else {
          formattedValue = value.toString();
        }
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
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            formattedValue,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
