import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_mobile/app/config/colors.dart';
import 'package:rick_and_morty_mobile/app/config/translations.dart';
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
        color: AppColors.bgColor,
        border: Border.all(
          color: AppColors.colorBorder,
          width: 1,
        ),
        borderRadius: AppColors.borderRadiusCard,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          itemHeight: 50,
          value: currentValue,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.bgColor,
          ),
          iconSize: 24,
          dropdownColor: AppColors.bgColor,
          elevation: 4,
          style: const TextStyle(
            color: AppColors.primaryColor,
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
    return Container(
      color: AppColors.bgAside,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Buscar',
              style: TextStyle(
                color: AppColors.bgColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              autocorrect: true,
              controller: searchController,
              keyboardType: TextInputType.text,
              keyboardAppearance: Brightness.dark,
              style: const TextStyle(color: AppColors.primaryColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.bgColor,
                hintText: 'Nome do personagem...',
                hintStyle: TextStyle(
                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppColors.borderRadiusCard,
                  borderSide: const BorderSide(
                    color: AppColors.colorBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppColors.borderRadiusCard,
                  borderSide: const BorderSide(
                    color: AppColors.bgColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Filtros',
              style: TextStyle(
                color: AppColors.bgColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                _buildDropdown(
                  selectedStatus,
                  AppTranslations.statusFilters.keys.toList(),
                  (val) {
                    if (val != null) setState(() => selectedStatus = val);
                  },
                ),
                const SizedBox(height: 8),
                _buildDropdown(
                  selectedSpecies,
                  AppTranslations.speciesFilters.keys.toList(),
                  (val) {
                    if (val != null) setState(() => selectedSpecies = val);
                  },
                ),
                const SizedBox(height: 8),
                _buildDropdown(
                  selectedGender,
                  AppTranslations.genderFilters.keys.toList(),
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
                  backgroundColor: AppColors.bgColor,
                  foregroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppColors.borderRadiusCard,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.bgColor,
                  side: const BorderSide(color: AppColors.bgColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppColors.borderRadiusCard,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                child: const Text(
                  'Limpar Filtro',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
