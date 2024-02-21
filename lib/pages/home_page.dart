import 'package:delmoro_estoque_app/pages/login_page.dart';
import 'package:delmoro_estoque_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
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

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    storeIds = extractStoreIds(widget.permissions);
    storeIdAndName = extractStoreIdAndName(widget.permissions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.green,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: LogoUserWidget(),
                  ),
                  const SizedBox(width: 10),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bem-vindo,',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        extractUsername(widget.permissions),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
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
              _buildBarcodeScannerInput(context, widget.token),
              const SizedBox(height: 50),
              if (isStockLoaded) _buildStockCarousel(),
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
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () async {
                        if (_barcodeController.text.isNotEmpty) {
                          _searchBarcode(context, token);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Código de barras inválido. Necessário ter 13 caracteres numéricos.'),
                            ),
                          );
                        }
                      },
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
    _apiService.getStock(token, result, storeIds).then((dynamic stockData) {
      if (stockData != null && stockData is List && stockData.isNotEmpty) {
        List<Map<String, dynamic>> stockList =
            stockData.cast<Map<String, dynamic>>();

        setState(() {
          isStockLoaded = true;
          isStockLoading = false;
          storeInfo = stockList;
        });
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
      _apiService.getStock(token, result, storeIds).then((dynamic stockData) {
        if (stockData != null && stockData is List && stockData.isNotEmpty) {
          List<Map<String, dynamic>> stockList =
              stockData.cast<Map<String, dynamic>>();

          setState(() {
            isStockLoaded = true;
            isStockLoading = false;
            storeInfo = stockList;
          });
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

  Widget _buildStockCarousel() {
    List<Map<String, dynamic>> filteredStoreInfo = storeInfo.where((item) {
      String storeId = item['nroempresa'];

      return storeIdAndName.any((store) => store['id'] == int.parse(storeId));
    }).toList();

    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredStoreInfo.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _openStockPage(context, filteredStoreInfo[index]);
            },
            child: _buildStoreCard(filteredStoreInfo[index], storeIdAndName),
          );
        },
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> filteredStoreInfo,
      List<Map<String, dynamic>> storeIdAndName) {
    final String storeId = filteredStoreInfo['nroempresa'].toString();
    final Map<String, dynamic>? storeData = storeIdAndName
        .firstWhereOrNull((store) => store['id'] == int.parse(storeId));
    final String storeName = storeData != null ? storeData['storename'] : 'N/A';

    return Container(
      width: 160.0,
      height: 200.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'LOJA: $storeId',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 8),
              Text(
                storeName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openStockPage(
    BuildContext context,
    Map<String, dynamic>? storeData,
  ) {
    if (storeData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StockPage(
              token: widget.token,
              showCost: widget.showCost,
              stockItem: storeData),
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

  String extractUsername(List<dynamic> permissions) {
    if (permissions.isNotEmpty) {
      final firstPermission = permissions[0];

      if (firstPermission.containsKey('name') &&
          firstPermission['name'] is String) {
        final username = firstPermission['name'];

        return username;
      }
    }

    return 'Usuário';
  }

  List<int> extractStoreIds(List<dynamic> permissions) {
    if (permissions.isNotEmpty) {
      final firstPermission = permissions[0];

      if (firstPermission.containsKey('stores') &&
          firstPermission['stores'] is List) {
        final stores = firstPermission['stores'] as List<dynamic>;

        return stores.map<int>((store) => store['id'] as int).toList();
      }
    }

    return [];
  }

  List<Map<String, dynamic>> extractStoreIdAndName(List<dynamic> permissions) {
    List<Map<String, dynamic>> storeInfo = [];

    if (permissions.isNotEmpty) {
      final firstPermission = permissions[0];

      if (firstPermission.containsKey('stores') &&
          firstPermission['stores'] is List) {
        final stores = firstPermission['stores'] as List<dynamic>;

        storeIdAndName = stores.map<Map<String, dynamic>>((store) {
          return {
            'id': store['id'],
            'storename': store['storename'],
          };
        }).toList();
      }
    }

    return storeIdAndName;
  }
}
