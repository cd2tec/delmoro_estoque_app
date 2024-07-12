// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings
import 'package:delmoro_estoque_app/services/api_service.dart';
import 'package:delmoro_estoque_app/widgets/stock/average_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/dates_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/info_description_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/pack_and_quantity_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/pending_request_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/prices_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/show_cost_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/stock_info_widget.dart';
import 'package:delmoro_estoque_app/widgets/stock/supplier_infor_widget.dart';
import 'package:flutter/material.dart';

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
                  InfoDescriptionWidget(
                      title: 'Descrição - $barcode',
                      stockItem: widget.stockItem),
                  StockInfoWidget(
                    title: 'Estoque',
                    stockItem: widget.stockItem,
                    stockAllStores: stockAllStores,
                  ),
                  PackAndQuantityInfoWidget(
                      title: 'Embalagens e Quantidades',
                      stockItem: widget.stockItem,
                      promoPrice: promoPrice),
                  PricesInfoWidget(
                      title: 'Preços', stockItem: widget.stockItem),
                  if (showCost)
                    ShowCostInfoWidget(
                      title: 'Custo Última Entrada',
                      stockItem: widget.stockItem,
                    ),
                  DatesInfoWidget(
                      title: 'Datas e Quantidade', stockItem: widget.stockItem),
                  AverageInfoWidget(
                      title: 'Médias', stockItem: widget.stockItem),
                  if (widget.stockItem['qtdsaldotransito'] != null)
                    PendingRequestWidget(
                        title: 'Pedido Pendente a Receber',
                        stockItem: widget.stockItem),
                  SupplierInfoWidget(
                      title: 'Fornecedor', stockItem: widget.stockItem),
                ],
              ),
            ),
    );
  }
}
