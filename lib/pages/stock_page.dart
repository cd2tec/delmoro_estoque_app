// ignore_for_file: library_private_types_in_public_api
import 'package:delmoro_estoque_app/services/api_service.dart';
import 'package:flutter/material.dart';

class StockPage extends StatefulWidget {
  final Map<String, dynamic> stockItem;
  final String token;
  final String showCost;

  const StockPage(
      {Key? key,
      required this.token,
      required this.showCost,
      required this.stockItem})
      : super(key: key);

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<Map<String, dynamic>>? promoPrice;

  @override
  void initState() {
    super.initState();
    _getPrice();
  }

  void _getPrice() async {
    ApiService apiService = ApiService();

    try {
      Map<String, dynamic> response = await apiService.getPrice(
          widget.token, widget.stockItem['seqproduto']);

      List<Map<String, dynamic>> storeInfo = [];

      if (response.isNotEmpty) {
        final storeNumber = widget.stockItem['nroempresa'].toString();
        if (response.containsKey(storeNumber)) {
          storeInfo = List<Map<String, dynamic>>.from(response[storeNumber]);
        } else {
          setState(() {
            promoPrice = null;
          });
          return;
        }
      } else {
        setState(() {
          promoPrice = null;
        });
        return;
      }

      setState(() {
        promoPrice = storeInfo;
      });
    } catch (e) {
      setState(() {
        promoPrice = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loja ${widget.stockItem['nroempresa']}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14.0),
            _buildInfoDescription(
                'Descrição', widget.stockItem['descricao'] ?? 'N/A'),
            _buildInfoSupplier('Fornecedor', widget.stockItem),
            _buildInfoStock('Estoque', widget.stockItem),
            _buildInfoPackingAndQuantity(
                'Embalagens e Quantidades', widget.stockItem),
            _buildInfoPrices('Preços', widget.stockItem),
            _buildInfoDates('Datas', widget.stockItem),
            _buildInfoAverage('Médias', widget.stockItem),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoDescription(String title, String value) {
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
          const SizedBox(height: 4.0),
          _buildInfoItem(value),
        ],
      ),
    );
  }

  Widget _buildInfoSupplier(String title, Map<String, dynamic> stockItem) {
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
          const SizedBox(height: 4.0),
          _buildSupplierItem(
              'Fornecedor', widget.stockItem['fornecedor'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoStock(String title, Map<String, dynamic> stockItem) {
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
            children: [
              Expanded(
                child: _buildInfoStockItem(
                    'Estoque Loja', stockItem['estoqueloja'] ?? 'N/A'),
              ),
              Expanded(
                child: _buildInfoStockItem(
                    'Estoque CD', stockItem['estoquedeposito'] ?? 'N/A'),
              ),
            ],
          ),
          if (stockItem.containsKey('estoquetroca'))
            _buildInfoStockItem(
                'Estoque Troca', stockItem['estoquetroca'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoPrices(String title, Map<String, dynamic> stockItem) {
    final bool showCost = widget.showCost == "1";

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
          _buildInfoPricesItem(
              'Preço Venda Normal', stockItem['precovendanormal'] ?? 'N/A'),
          _buildInfoPricesItem('Preço Venda Promocional',
              stockItem['precopromocional'] ?? 'N/A'),
          if (showCost)
            _buildInfoPricesItem(
              'Custo Última Entrada',
              stockItem['custoultentrada'] ?? 'N/A',
            ),
        ],
      ),
    );
  }

  Widget _buildInfoPackingAndQuantity(
      String title, Map<String, dynamic> stockItem) {
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
                              child: _buildInfoPackingAndQuantityItem(
                                'Embalagem',
                                price['embalagem'] ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: _buildInfoPackingAndQuantityItem(
                                'Quantidade',
                                price['qtdembalagem'].toString() ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: _buildInfoPackingAndQuantityItem(
                                'Preço',
                                price['precobase'].toString() ?? 'N/A',
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
                  child: _buildInfoPackingAndQuantityItem(
                    'Embalagem',
                    stockItem['embalagem'] ?? 'N/A',
                  ),
                ),
                Expanded(
                  child: _buildInfoPackingAndQuantityItem(
                    'Quantidade',
                    stockItem['quantidadeembalagem'] ?? 'N/A',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoDates(String title, Map<String, dynamic> stockItem) {
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
          _buildInfoDatesItem(
              'Data Início Promoção', stockItem['datainiciopromocao'] ?? 'N/A'),
          _buildInfoDatesItem(
              'Data Fim Promoção', stockItem['datafimpromocao'] ?? 'N/A'),
          _buildInfoDatesItem(
              'Data Última Entrada', stockItem['dtaultentrada'] ?? 'N/A'),
          _buildInfoDatesItem(
              'Data Última Venda', stockItem['dtaultvenda'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoAverage(String title, Map<String, dynamic> stockItem) {
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
          _buildInfoAverageItem('Média Venda Diária',
              widget.stockItem['mediavendadiaria'] ?? 'N/A'),
          _buildInfoAverageItem(
              'Média Venda Semanal', widget.stockItem['mvendasemana'] ?? 'N/A'),
          _buildInfoAverageItem(
              'Média Venda Mensal', widget.stockItem['mvendames'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green, // Cor verde para o título
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1.0),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierItem(String description, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1.0),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStockItem(String description, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1.0),
          Text(
            description,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPricesItem(String description, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1.0),
          Text(
            description,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPackingAndQuantityItem(String description, dynamic value) {
    String formattedValue = 'N/A';
    if (value != null && value != 'N/A') {
      if (description == 'Preço') {
        formattedValue = double.parse(value.toString()).toStringAsFixed(5);
      } else {
        formattedValue = value.toString();
      }
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1.0),
          Text(
            description,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            formattedValue,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDatesItem(String description, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1.0),
          Text(
            description,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoAverageItem(String description, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1.0),
          Text(
            description,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
