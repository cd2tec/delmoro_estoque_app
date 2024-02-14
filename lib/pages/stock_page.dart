import 'package:flutter/material.dart';
import 'profile_page.dart';

class StockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Estoque'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Implemente as ações para cada item do menu
              if (value == 'consultaEstoque') {
                // Não faz nada, já estamos na página de Consultar Estoque
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
        child: Text('Página de Consulta de Estoque'),
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
}
