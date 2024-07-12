import 'package:delmoro_estoque_app/widgets/stock/show_cost_item_info_widget.dart';
import 'package:flutter/material.dart';

class ShowCostInfoWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> stockItem;

  const ShowCostInfoWidget({
    Key? key,
    required this.title,
    required this.stockItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 1.0),
          ShowCostItemInfoWidget(value: stockItem['custoultentrada']),
        ],
      ),
    );
  }
}
