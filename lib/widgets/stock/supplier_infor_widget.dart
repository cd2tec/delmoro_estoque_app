import 'package:delmoro_estoque_app/widgets/stock/average_item_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/supplier_item_info_widget.dart';
import 'package:flutter/material.dart';

class SupplierInfoWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> stockItem;

  const SupplierInfoWidget({
    Key? key,
    required this.title,
    required this.stockItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4.0),
          SupplierItemInfoWidget(
              description: 'Fornecedor',
              value: stockItem['fornecedor'] ?? 'N/A'),
        ],
      ),
    );
  }
}
