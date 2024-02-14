import 'search_barcode_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import 'stock_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, $username!'),
        actions: [
          PopupMenuButton<String>(
            iconSize: 30,
            onSelected: (value) {
              // Implemente as ações para cada item do menu
              if (value == 'consultaEstoque') {
                _openStockPage(context);
              } else if (value == 'gerenciarPerfis') {
                _openManageProfilesPage(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Consulta Estoque', 'Gerenciar Perfis'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase().replaceAll(' ', ''),
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _openStockPage(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: Text('Consultar Estoque'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _openManageProfilesPage(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: Text('Gerenciar Perfis'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _openBarcodeScanner,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: Text('Leitor de Código de Barras'),
              ),
            ),
            CarouselSlider(
              items: List.generate(10, (index) => _buildStoreItem(index)),
              options: CarouselOptions(
                height: 300.0,
                enlargeCenterPage: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreItem(int index) {
    String storeName =
        'Loja ${index + 1}'; // Substitua com a lógica para obter o nome da loja

    return GestureDetector(
      onTap: () {
        // _openStoreDetailsPage(context, storeName);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        color: Colors.green,
        child: Center(
          child: Text(
            storeName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _openStockPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockPage(),
      ),
    );
  }

  void _openManageProfilesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  void _openStoreDetailsPage(BuildContext context, String storeName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoreDetailsPage(storeName: storeName),
      ),
    );
  }
}

Future<void> _openBarcodeScanner() async {
  try {
    //  String barcode = await BarcodeScanner.scan(); // Escaneia o código de barras
    // _fetchProductDetails(barcode); // Chama a API com o código de barras
  } catch (e) {
    print('Erro ao escanear código de barras: $e');
  }
}

void _fetchProductDetails(String barcode) async {
  // Substitua a URL abaixo pela sua API de consulta de produtos
  final apiUrl = 'https://example.com/products/$barcode';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print('Erro ao consultar produto: ${response.statusCode}');
      // Sucesso na consulta
      /*  Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SearchBarcodePage(productDetails: response.body),
        ),
      ); */
    } else {
      // Falha na consulta
      print('Erro ao consultar produto: ${response.statusCode}');
    }
  } catch (e) {
    // Erro de conexão
    print('Erro de conexão: $e');
  }
}

class StoreDetailsPage extends StatelessWidget {
  final String storeName;

  StoreDetailsPage({required this.storeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(storeName),
      ),
      body: Center(
        child: Text('Detalhes da Loja: $storeName'),
      ),
    );
  }
}
