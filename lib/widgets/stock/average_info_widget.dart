import 'package:delmoro_estoque_app/widgets/stock/average_item_info_widget.dart';
import 'package:flutter/material.dart';

class AverageInfoWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> stockItem;

  const AverageInfoWidget({
    Key? key,
    required this.title,
    required this.stockItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int storeStock =
        int.tryParse(stockItem['estoqueloja']?.toString() ?? '0') ?? 0;
    String dailySalesValue = stockItem['mediavendadiaria']?.toString() ?? '0';
    dailySalesValue = dailySalesValue.replaceAll(',', '.');
    double averageDailySales = double.tryParse(dailySalesValue) ?? 0;

    String stockCoverage = (averageDailySales > 0)
        ? (storeStock / averageDailySales).toStringAsFixed(1)
        : 'N/A';

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AverageItemInfoWidget(
                        description: 'Média Venda Diária',
                        value: stockItem['mediavendadiaria'] ?? 'N/A'),
                    AverageItemInfoWidget(
                        description: 'Média Venda Semanal',
                        value: stockItem['mvendasemana'] ?? 'N/A'),
                    AverageItemInfoWidget(
                        description: 'Média Venda Mensal',
                        value: stockItem['mvendames'] ?? 'N/A'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AverageItemInfoWidget(
                        description: 'Cobertura de Estoque',
                        value: stockCoverage),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
