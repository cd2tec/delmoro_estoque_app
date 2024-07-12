import 'package:delmoro_estoque_app/widgets/stock/average_item_info_widget.dart';
import 'package:flutter/material.dart';

class PendingRequestWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> stockItem;

  const PendingRequestWidget({
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
          const SizedBox(height: 1.0),
          AverageItemInfoWidget(
              description: 'Média Venda Diária',
              value: stockItem['mediavendadiaria'] ?? 'N/A'),
          AverageItemInfoWidget(
              description: 'Média Venda Semanal',
              value: stockItem['mvendasemana'] ?? 'N/A'),
          AverageItemInfoWidget(
              description: 'Média Venda Mensal',
              value: stockItem['mvendames'] ?? 'N/A'),
          //  _buildInfoAverageItem('Cobertura de Estoque', value)
        ],
      ),
    );
  }
}
