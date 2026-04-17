import 'package:flutter/material.dart';

class DrawerHome extends StatefulWidget {
  const DrawerHome({super.key});

  @override
  State<DrawerHome> createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  final TextEditingController searchController = TextEditingController();

  Widget _buildDropdown(String type, List<String> options) {
    String? selected;
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(164, 158, 158, 158),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: DropdownButton<String>(
            hint: Text(type),
            itemHeight: 50,
            value: selected,
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            iconEnabledColor: const Color.fromARGB(129, 0, 0, 0),
            elevation: 4,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            items: options
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => selected = val);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Buscar'),
          TextFormField(
            autocorrect: true,
            controller: searchController,
            keyboardType: TextInputType.text,
            keyboardAppearance: Brightness.dark,
          ),
          SizedBox(height: 8),
          Text('Filtros'),
          SizedBox(height: 8),
          Column(
            children: [
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
            ],
          ),

          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF55cc44),
              ),
              onPressed: () {
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text('Aplicar'),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Limpar Filtro'),
            ),
          ),
        ],
      ),
    );
  }
}
