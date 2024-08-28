import 'package:delmoro_estoque_app/widgets/stock/pending_request_item_balance_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/pending_request_item_widget.dart';
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
          PendingRequestItemBalanceWidget(
              description: 'Quantidade Saldo Pedido',
              value: stockItem['qtdsaldotransito'] ?? 'N/A'),
          PendingRequestItemInfoWidget(
              description: 'Data Emissão Pedido',
              value: stockItem['dtaemissaotransito'] ?? 'N/A'),
        ],
      ),
    );
  }
}
