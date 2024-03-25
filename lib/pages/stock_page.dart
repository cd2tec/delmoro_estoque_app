// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings
import 'package:delmoro_estoque_app/services/api_service.dart';
import 'package:delmoro_estoque_app/widgets/stock_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/pulse_widget.dart';

class StockPage extends StatefulWidget {
  final Map<String, dynamic> stockItem;
  final String token;
  final String showCost;
  final String barcode;
  final List<int> permittedStores;

  const StockPage(
      {Key? key,
      required this.token,
      required this.showCost,
      required this.barcode,
      required this.stockItem,
      required this.permittedStores,
      int? selectedStoreId})
      : super(key: key);

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<Map<String, dynamic>>? promoPrice;
  List<dynamic>? stockAllStores;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getPrice();
    _getStock();
  }

  void _getStock() async {
    ApiService apiService = ApiService();
    try {
      List<dynamic> response = await apiService.getStock(
        widget.token,
        widget.barcode,
        widget.permittedStores,
      );

      if (response != null && response.isNotEmpty) {
        List<Map<String, dynamic>> stockList =
            response.cast<Map<String, dynamic>>();
        setState(() {
          stockAllStores = response;
        });
      } else {
        setState(() {
          stockAllStores = null;
        });
      }
    } catch (e) {
      setState(() {
        stockAllStores = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final barcode = widget.barcode;
    final bool showCost = widget.showCost == "1";
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14.0),
                  _buildInfoDescription(
                      'Descrição - $barcode', widget.stockItem),
                  _buildInfoSupplier('Fornecedor', widget.stockItem),
                  _buildInfoStock('Estoque', widget.stockItem),
                  _buildInfoPackingAndQuantity(
                      'Embalagens e Quantidades', widget.stockItem),
                  _buildInfoPrices('Preços', widget.stockItem),
                  if (showCost)
                    _buildShowCost(
                      'Custo Última Entrada',
                      widget.stockItem,
                    ),
                  _buildInfoDates('Datas', widget.stockItem),
                  _buildInfoAverage('Médias', widget.stockItem),
                  if (widget.stockItem['qtdsaldotransito'] != null)
                    _buildPendingRequest(
                        'Pedido Pendente a Receber', widget.stockItem),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoDescription(String title, Map<String, dynamic> stockItem) {
    Color backgroundColor = Colors.green;

    if (stockItem['inativo'] == "I") {
      backgroundColor = Colors.red;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
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
          _buildInfoItem(widget.stockItem['descricao'], backgroundColor),
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
                child: _buildInfoStockItem(
                    'Loja', stockItem['estoqueloja'] ?? 'N/A'),
              ),
              Expanded(
                child: _buildInfoStockItem(
                    'CD', stockItem['estoquedeposito'] ?? 'N/A'),
              ),
              if (showStockTroca)
                Expanded(
                  child: _buildInfoStockItem(
                    'Estoque Troca',
                    stockItem['estoquetroca'],
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

  Widget _buildInfoPrices(String title, Map<String, dynamic> stockItem) {
    final bool showCost = widget.showCost == "1";
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
          _buildInfoPricesItem(
              'Preço Venda Normal', stockItem['precovendanormal']),
          if (pricePromo != null && pricePromo != '0')
            _buildInfoPricesPromoItem('Preço Venda Promocional', pricePromo),
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
                                price['qtdembalagem']?.toString() ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: _buildInfoPackingAndQuantityItem(
                                'Preço',
                                price['precobase']?.toString() ?? 'N/A',
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
                    stockItem['quantidadeembalagem']?.toString() ?? 'N/A',
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
          if (stockItem['datainiciopromocao'] != null)
            _buildInfoDatesItem('Data Início Promoção',
                _formatDate(stockItem['datainiciopromocao'])),
          if (stockItem['datafimpromocao'] != null)
            _buildInfoDatesItem(
                'Data Fim Promoção', _formatDate(stockItem['datafimpromocao'])),
          _buildInfoDatesItem('Data Última Entrada',
              _formatDate(stockItem['dtaultentrada'] ?? '0')),
          _buildInfoDatesItem('Data Última Venda',
              _formatDate(stockItem['dtaultvenda'] ?? '0')),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty || dateString == '0') {
      return '';
    }

    try {
      DateTime date = DateTime.parse(dateString);

      String formattedDate = '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year.toString()}';

      return formattedDate;
    } catch (e) {
      return '$e';
    }
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

  Widget _buildInfoItem(String value, Color backgroundColor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
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
    String formattedValue = '0';

    if (value != null && value != '0') {
      double numericValue = double.tryParse(value.replaceAll(',', '.')) ?? 0;
      if (numericValue >= 1000) {
        formattedValue = numericValue.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}.',
            );
        if (numericValue >= 1000000) {
          formattedValue = formattedValue.replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          );
        }
      } else {
        formattedValue = numericValue.toString();
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
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPricesPromoItem(String description, String value) {
    return PulseAnimationWidget(
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: 400.0,
        height: 140.0,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
            )
          ],
          image: const DecorationImage(
            image: AssetImage('images/star.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              description,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPackingAndQuantityItem(String description, dynamic value) {
    String formattedValue = 'N/A';
    if (value != null && value != 'N/A') {
      if (description == 'Preço') {
        formattedValue = double.parse(value.toString()).toStringAsFixed(2);
      } else {
        if (value is num && value >= 1000) {
          formattedValue = value.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]}.',
              );
          if (value >= 1000000) {
            formattedValue = formattedValue.replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]}.',
                ) +
                'M';
          }
        } else {
          formattedValue = value.toString();
        }
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
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            formattedValue,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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

  Widget _buildPendingRequest(
      String description, Map<String, dynamic> stockItem) {
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
          const SizedBox(height: 1.0),
          _buildPendingRequestBalanceItem(
              'Quantidade Saldo Pedido', stockItem['qtdsaldotransito']),
          _buildPendingRequestItem('Data Emissão Pedido',
              _formatDate(stockItem['dtaemissaotransito'])),
        ],
      ),
    );
  }

  Widget _buildPendingRequestBalanceItem(String description, String value) {
    String formattedValue = '0';

    if (value != null && value != '0') {
      double numericValue = double.tryParse(value.replaceAll(',', '.')) ?? 0;
      if (numericValue >= 1000) {
        formattedValue = numericValue.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
        if (numericValue >= 1000000) {
          formattedValue = formattedValue.replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]}.') +
              'M';
        }
      } else {
        formattedValue = numericValue.toString();
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

  Widget _buildPendingRequestItem(String description, String value) {
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

  Widget _buildShowCost(String description, Map<String, dynamic> stockItem) {
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
          const SizedBox(height: 1.0),
          _buildShowCostItem(stockItem['custoultentrada']),
        ],
      ),
    );
  }

  Widget _buildShowCostItem(String value) {
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
}
