import 'package:delmoro_estoque_app/widgets/stock/dates_item_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/dates_item_quantity_info_widget.dart';
import 'package:flutter/material.dart';

class DatesInfoWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> stockItem;

  const DatesInfoWidget({
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
          if (stockItem['datainiciopromocao'] != null)
            DatesItemInfoWidget(
                description: 'Data Início Promoção',
                value: stockItem['datainiciopromocao']),
          if (stockItem['datafimpromocao'] != null)
            DatesItemInfoWidget(
                description: 'Data Fim Promoção',
                value: stockItem['datafimpromocao']),
          DatesItemInfoWidget(
              description: 'Data Última Entrada',
              value: stockItem['dtaultentrada'] ?? '0'),
          DatesItemQuantityInfoWidget(
              description: 'Quantidade Última Entrada',
              value: stockItem['qtdultentrada'] ?? '0'),
          DatesItemInfoWidget(
              description: 'Data Última Venda',
              value: stockItem['dtaultvenda'] ?? '0'),
        ],
      ),
    );
  }
}
