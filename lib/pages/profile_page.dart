/* import 'package:flutter/material.dart';
import 'stock_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Perfis'),
        actions: [
          PopupMenuButton<String>(/*  */
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
      body: Center(
        child: Text('Página de Gerenciamento de Perfis'),
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
    // Não faz nada, já estamos na página de Gerenciar Perfis
  }
}
 */
