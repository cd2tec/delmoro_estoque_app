import 'package:delmoro_estoque_app/widgets/stock/item_stock_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/stock_modal_widget.dart';
import 'package:flutter/material.dart';

class StockInfoWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> stockItem;
  final List<dynamic>? stockAllStores;

  const StockInfoWidget({
    Key? key,
    required this.title,
    required this.stockItem,
    required this.stockAllStores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasStock = stockAllStores != null && stockAllStores!.isNotEmpty;

    final bool showStockTroca = stockItem.containsKey('estoquetroca') &&
        int.tryParse(stockItem['estoquetroca'] ?? '0')! > 0;

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
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 1.0),
          Row(
            children: [
              Expanded(
                child: ItemStockInfoWidget(
                    description: 'Loja',
                    value: stockItem['estoqueloja'] ?? 'N/A'),
              ),
              Expanded(
                child: ItemStockInfoWidget(
                    description: 'CD',
                    value: stockItem['estoquedeposito'] ?? 'N/A'),
              ),
              if (showStockTroca)
                Expanded(
                  child: ItemStockInfoWidget(
                    description: 'Estoque Troca',
                    value: stockItem['estoquetroca'],
                  ),
                ),
            ],
          ),
          if (hasStock)
            GestureDetector(
              onTap: () {
                _showStockModal(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Tooltip(
                    message: 'Estoque Lojas',
                    child: IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.indigo,
                      ),
                      onPressed: () {
                        _showStockModal(context);
                      },
                    ),
                  ),
                  const Text(
                    'Estoque Lojas',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showStockModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StockModal(
            stockItems: stockAllStores != null
                ? stockAllStores!.cast<Map<String, dynamic>>()
                : []);
      },
    );
  }
}
