import 'package:flutter/material.dart';

class StockModal extends StatelessWidget {
  final List<Map<String, dynamic>> stockItems;

  const StockModal({Key? key, required this.stockItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxHeight = stockItems.length > 9 ? 900 : 500;
    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Estoque em cada loja:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: stockItems.length,
                itemBuilder: (context, index) {
                  final item = stockItems[index];
                  Color boxColor = Colors.green[100]!;
                  int estoqueLoja =
                      int.tryParse(item['estoqueloja'].toString()) ?? 0;
                  if (item['nroempresa'] == '13' ||
                      item['nroempresa'] == '16') {
                    boxColor = Colors.blue[100]!;
                  } else if (estoqueLoja < 0) {
                    boxColor = Colors.red[100]!;
                  } else if (estoqueLoja == 0) {
                    boxColor = Colors.yellow[100]!;
                  }
                  return Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Loja ${item['nroempresa']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item['estoqueloja']}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
