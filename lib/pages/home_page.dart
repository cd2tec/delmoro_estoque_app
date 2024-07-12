import 'package:delmoro_estoque_app/pages/login_page.dart';
import 'package:delmoro_estoque_app/utils/permissions_utils.dart';
import 'package:delmoro_estoque_app/widgets/home/app_bar_widgter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:delmoro_estoque_app/services/api_service.dart';
import 'package:delmoro_estoque_app/services/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'stock_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String token;
  final String showCost;
  final List<dynamic> permissions;

  const HomePage({
    Key? key,
    required this.username,
    required this.token,
    required this.showCost,
    required this.permissions,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiService _apiService;
  AuthService service = AuthService();
  String barcode = '';
  final TextEditingController _barcodeController = TextEditingController();
  List<int> storeIds = [];
  List<Map<String, dynamic>> storeInfo = [];
  List<Map<String, dynamic>> storeIdAndName = [];
  bool isStockLoaded = false;
  bool isStockLoading = false;
  int? selectedStoreId;
  List<int> storesNotSelected = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    storeIds = extractStoreIds(widget.permissions);
    storeIdAndName = extractStoreIdAndName(widget.permissions);

    if (storeIds.length == 1) {
      selectedStoreId = storeIds.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(username: extractUsername(widget.permissions)),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                _logout(context);
              },
              title: const Text("Sair do app"),
              leading: const Icon(Icons.logout),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (storeIds.length > 1) _buildStoreSelection(),
              _buildBarcodeScannerInput(context, widget.token),
              const SizedBox(height: 50),
              if (isStockLoading) const CircularProgressIndicator(),
              Container(
                margin: const EdgeInsets.all(16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreSelection() {
    storesNotSelected = storeIds.where((id) => id != selectedStoreId).toList();

    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Selecione a loja',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                width: 300,
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: selectedStoreId,
                  onChanged: (value) {
                    setState(() {
                      selectedStoreId = value;
                    });
                    storesNotSelected =
                        storeIds.where((id) => id != selectedStoreId).toList();
                  },
                  underline: Container(
                    height: 0,
                  ),
                  items: storeIds.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Loja $value'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeScannerInput(BuildContext context, String token) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Leitor de Código de Barras',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _barcodeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    hintText: 'Escaneie ou digite',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () async {
                            if (_barcodeController.text.isNotEmpty) {
                              _searchBarcode(context, token);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Digite ou escaneie um código de barras.'),
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _barcodeController.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () async {
                  _scanBarcode(context, token);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _searchBarcode(BuildContext context, String token) {
    setState(() {
      isStockLoaded = false;
      isStockLoading = true;
    });

    String result = _barcodeController.text;
    _apiService
        .getStock(token, result, [selectedStoreId!]).then((dynamic stockData) {
      if (stockData != null && stockData is List && stockData.isNotEmpty) {
        List<Map<String, dynamic>> stockList =
            stockData.cast<Map<String, dynamic>>();

        setState(() {
          isStockLoaded = true;
          isStockLoading = false;
          storeInfo = stockList;
        });

        _openStockPage(context, stockList.first, result, storesNotSelected);
      } else {
        setState(() {
          isStockLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Produto não encontrado. Escaneie ou digite um outro código de barras.'),
          ),
        );
      }
    }).catchError((error) {
      setState(() {
        isStockLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao buscar o produto'),
        ),
      );
    });
  }

  void _scanBarcode(BuildContext context, String token) async {
    String? result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    if (result != '-1') {
      setState(() {
        barcode = result;
        _barcodeController.text = barcode;
        isStockLoading = true;
      });
      _apiService.getStock(token, result, [selectedStoreId!]).then(
          (dynamic stockData) {
        if (stockData != null && stockData is List && stockData.isNotEmpty) {
          List<Map<String, dynamic>> stockList =
              stockData.cast<Map<String, dynamic>>();

          setState(() {
            isStockLoaded = true;
            isStockLoading = false;
            storeInfo = stockList;
          });

          _openStockPage(context, stockList.first, result, storesNotSelected);
        } else {
          setState(() {
            isStockLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto não encontrado'),
            ),
          );
        }
      }).catchError((error) {
        setState(() {
          isStockLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao buscar o produto'),
          ),
        );
      });
    }
  }

  void _openStockPage(BuildContext context, Map<String, dynamic>? storeData,
      String barcode, List<int> storesNotSelected) {
    if (storeData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StockPage(
              token: widget.token,
              showCost: widget.showCost,
              barcode: barcode,
              stockItem: storeData,
              permittedStores: storesNotSelected),
        ),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    service.revokeToken().then((_) async {
      final prefs = await SharedPreferences.getInstance();
      return prefs;
    }).then((prefs) {
      final savedUsername = prefs.getString('username');
      final savedPassword = prefs.getString('password');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                savedUsername: savedUsername, savedPassword: savedPassword)),
        (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      final snackBar = SnackBar(
        content: Text(
          'Ocorreu um erro durante o logout: $error',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
