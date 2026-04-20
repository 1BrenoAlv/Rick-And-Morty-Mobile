import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_mobile/app/viewmodels/character_viewmodel.dart';

class DrawerHome extends StatefulWidget {
  const DrawerHome({super.key});

  @override
  State<DrawerHome> createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  final TextEditingController searchController = TextEditingController();

  String selectedStatus = 'Todos os status';
  String selectedSpecies = 'Todas as espécies';
  String selectedGender = 'Todos os gêneros';

  Widget _buildDropdown(
    String currentValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(164, 158, 158, 158),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          itemHeight: 50,
          value: currentValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
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
          onChanged: onChanged,
        ),
      ),
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
          const Text('Buscar'),
          TextFormField(
            autocorrect: true,
            controller: searchController,
            keyboardType: TextInputType.text,
            keyboardAppearance: Brightness.dark,
          ),
          const SizedBox(height: 16),
          const Text('Filtros'),
          const SizedBox(height: 8),
          Column(
            children: [
              _buildDropdown(
                selectedStatus,
                ['Todos os status', 'Alive', 'Dead', 'Unknown'],
                (val) {
                  if (val != null) setState(() => selectedStatus = val);
                },
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                selectedSpecies,
                ['Todas as espécies', 'Human', 'Alien'],
                (val) {
                  if (val != null) setState(() => selectedSpecies = val);
                },
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                selectedGender,
                ['Todos os gêneros', 'Male', 'Female', 'Unknown'],
                (val) {
                  if (val != null) setState(() => selectedGender = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF55cc44),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<CharacterViewmodel>().filterAplly(
                  search: searchController.text,
                  status: selectedStatus,
                  species: selectedSpecies,
                  gender: selectedGender,
                );
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Aplicar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  searchController.clear();
                  selectedStatus = 'Todos os status';
                  selectedSpecies = 'Todas as espécies';
                  selectedGender = 'Todos os gêneros';
                });

                context.read<CharacterViewmodel>().clearFilter();

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Limpar Filtro'),
            ),
          ),
        ],
      ),
    );
  }
}
