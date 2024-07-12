import 'package:delmoro_estoque_app/widgets/stock/prices_item_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/prices_promo_item_info_widget.dart';
import 'package:flutter/material.dart';

class PricesInfoWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> stockItem;

  const PricesInfoWidget({
    Key? key,
    required this.title,
    required this.stockItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? pricePromo = stockItem['precopromocional'];

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
          PricesItemInfoWidget(
              description: 'Preço Venda Normal',
              value: stockItem['precovendanormal']),
          if (pricePromo != null && pricePromo != '0')
            PricesPromoItemInfoWidget(
                description: 'Preço Venda Promocional', value: pricePromo),
        ],
      ),
    );
  }
}
