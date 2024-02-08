import 'package:flutter/material.dart';
import 'package:delmoro_estoque_app/services/api_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'stock_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String token;
  final List<dynamic> users;
  final List<dynamic> permissions;

  const HomePage({
    Key? key,
    required this.username,
    required this.token,
    required this.users,
    required this.permissions,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiService _apiService;
  String barcode = '';
  List<int> storeIds = [];
  List<Map<String, dynamic>> storeInfo = [];
  bool isStockLoaded = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    storeIds = extractStoreIds(widget.permissions);
    storeInfo = extractStoreInfo(widget.permissions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.arrow_forward),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bem-vindo,'),
                      Text(extractUsername(widget.permissions)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.notifications),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBarcodeScannerInput(context, widget.token),
            if (isStockLoaded)
              _buildStockCarousel(), // Exibir o carrossel apenas se isStockLoaded for true
            Container(
              margin: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 16),
                  /*  _buildSquareButton(
                    context,
                    'Gerenciar Perfis',
                    () => _openManageProfilesPage(context),
                    Colors.green,
                  ), */
                ],
              ),
            ),
          ],
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
                  onChanged: (value) {
                    setState(() {
                      barcode = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(13),
                  ],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    hintText: 'Escaneie ou digite o código de barras',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (barcode.length == 13) {
                          // Chamar a função getStock apenas se o comprimento do código de barras for 13
                          _apiService
                              .getStock(token, barcode, storeIds)
                              .then((dynamic stockData) {
                            // Verificar se stockData não é nulo e se é uma lista
                            if (stockData != null && stockData is List) {
                              // Converter os dados de stockData para o tipo esperado
                              List<Map<String, dynamic>> stockList =
                                  stockData.cast<Map<String, dynamic>>();
                              // Atualizar o estado para indicar que os dados do estoque foram carregados
                              setState(() {
                                isStockLoaded = true;
                                storeInfo = stockList;
                              });
                            }
                          });
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
                  String? result = await FlutterBarcodeScanner.scanBarcode(
                      '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
                  if (result != '-1') {
                    setState(() {
                      barcode = result;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSquareButton(
      BuildContext context, String text, Function() onPressed, Color color) {
    return SizedBox(
      width: 150,
      height: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  void _openStockPage(BuildContext context, Map<String, dynamic>? storeData) {
    if (storeData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StockPage(stockItem: storeData),
        ),
      );
    } else {
      print('storeData is null');
    }
  }

  /*  void _openManageProfilesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  } */

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

  List<Map<String, dynamic>> extractStoreInfo(List<dynamic> permissions) {
    List<Map<String, dynamic>> storeInfo = [];

    if (permissions.isNotEmpty) {
      final firstPermission = permissions[0];

      if (firstPermission.containsKey('stores') &&
          firstPermission['stores'] is List) {
        final stores = firstPermission['stores'] as List<dynamic>;

        storeInfo = stores.map<Map<String, dynamic>>((store) {
          return {
            'id': store['id'],
            'storename': store['storename'],
            'storeData': store,
          };
        }).toList();
      }
    }

    return storeInfo;
  }

  Widget _buildStockCarousel() {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: storeInfo.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _openStockPage(context, storeInfo[index]);
            },
            child: _buildStoreCard(storeInfo[index]),
          );
        },
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> storeData) {
    return Container(
      width: 160.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ID: ${storeData['nroempresa']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              'Loja: ${storeData['storename']}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
