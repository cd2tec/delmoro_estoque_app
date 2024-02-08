import 'package:flutter/material.dart';

class StockPage extends StatelessWidget {
  final Map<String, dynamic> stockItem;

  const StockPage({Key? key, required this.stockItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Estoque - ${stockItem['nroempresa']}'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implemente a funcionalidade de pesquisa aqui
            },
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              'Descrição: ${stockItem['descricao']}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Embalagem: ${stockItem['embalagem']}'),
            Text('Quantidade: ${stockItem['quantidadeembalagem']}'),
            Text('Preço Venda Normal: ${stockItem['precovendanormal']}'),
            Text('Preço Promocional: ${stockItem['precopromocional']}'),
            Text(
                'Data Início Promoção: ${stockItem['datainiciopromocao'] ?? 'N/A'}'),
            Text('Data Fim Promoção: ${stockItem['datafimpromocao'] ?? 'N/A'}'),
            Text('Estoque Loja: ${stockItem['estoqueloja']}'),
            Text('Estoque CD: ${stockItem['estoquedeposito']}'),
            Text('Média Venda Diária: ${stockItem['mediavendadiaria']}'),
            Text('Data Última Entrada: ${stockItem['dtaultentrada']}'),
            Text('Data Última Venda: ${stockItem['dtaultvenda']}'),
            Text('Média Venda Semanal: ${stockItem['mvendasemana']}'),
            Text('Média Venda Mensal: ${stockItem['mvendames']}'),
          ],
        ),
      ),
    );
  }
}
