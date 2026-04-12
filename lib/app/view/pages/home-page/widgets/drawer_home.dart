import 'package:flutter/material.dart';

class DrawerHome extends StatefulWidget {
  const DrawerHome({super.key});

  @override
  State<DrawerHome> createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  Widget _buildDropdown(String type, List<String> options) {
    String? selected;
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          child: DropdownButton<String>(
            value: selected,
            items: options
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => selected = val),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Buscar'),
        TextField(),
        Text('Filtros'),
        _buildDropdown('Todos os status', [
          'Todos os status',
          'Alive',
          'Dead',
          'Unknown',
        ]),
        SizedBox(height: 8),
        _buildDropdown('Todas as espécies', [
          'Todas as espécies',
          'Human',
          'Alien',
        ]),
        SizedBox(height: 8),
        _buildDropdown('Todos os gêneros', [
          'Todos os gêneros',
          'Male',
          'Female',
          'Unknown',
        ]),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () {}, child: Text('Aplicar')),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () {}, child: Text('Limpar Filtro')),
        ),
      ],
    );
  }
}
