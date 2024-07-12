import 'package:delmoro_estoque_app/widgets/stock/item_info_widget.dart';
import 'package:flutter/material.dart';

class InfoDescriptionWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> stockItem;

  const InfoDescriptionWidget(
      {Key? key, required this.title, required this.stockItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        stockItem['inativo'] == "I" ? Colors.red : Colors.green;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
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
          ItemInfoWidget(
            description: stockItem['descricao'] ?? 'Produto sem descrição',
            backgroundColor: backgroundColor,
          ),
        ],
      ),
    );
  }
}
