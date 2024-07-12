import 'package:delmoro_estoque_app/widgets/stock/pack_and_quantity_item_info_widget.dart';
import 'package:flutter/material.dart';

class PackAndQuantityInfoWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> stockItem;
  final List<Map<String, dynamic>>? promoPrice;

  const PackAndQuantityInfoWidget({
    Key? key,
    required this.title,
    required this.stockItem,
    required this.promoPrice,
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
          if (promoPrice != null && promoPrice!.isNotEmpty)
            ...promoPrice!
                .map<Widget>((price) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: PackAndQuantityItemInfoWidget(
                                description: 'Embalagem',
                                value: price['embalagem'] ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: PackAndQuantityItemInfoWidget(
                                description: 'Quantidade',
                                value:
                                    price['qtdembalagem']?.toString() ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: PackAndQuantityItemInfoWidget(
                                description: 'Preço',
                                value: price['precobase']?.toString() ?? 'N/A',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))
                .toList(),
          if (promoPrice == null)
            Row(
              children: [
                Expanded(
                  child: PackAndQuantityItemInfoWidget(
                    description: 'Embalagem',
                    value: stockItem['embalagem'] ?? 'N/A',
                  ),
                ),
                Expanded(
                  child: PackAndQuantityItemInfoWidget(
                    description: 'Quantidade',
                    value:
                        stockItem['quantidadeembalagem']?.toString() ?? 'N/A',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
