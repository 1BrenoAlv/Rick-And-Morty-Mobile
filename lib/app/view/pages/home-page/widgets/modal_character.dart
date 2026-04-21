import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/config/colors.dart';
import 'package:rick_and_morty_mobile/app/config/translations.dart';
import 'package:rick_and_morty_mobile/app/model/character.dart';

class ModalCharacter {
  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static void show(BuildContext context, Character character) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 40,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagem do personagem
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.colorBorder,
                        child: const Center(
                          child: Icon(
                            Icons.wifi_off,
                            color: AppColors.primaryColor,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Conteúdo
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome
                      Text(
                        character.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Status badge + Espécie - Gênero
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(character.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              AppTranslations.status(character.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${AppTranslations.species(character.species)} - ${AppTranslations.gender(character.gender)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Divider
                      Divider(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        height: 1,
                      ),
                      const SizedBox(height: 12),

                      // Origem
                      _buildInfoRow('Origem', character.origin),
                      const SizedBox(height: 10),

                      // Localização
                      _buildInfoRow('Localização', character.location),
                      const SizedBox(height: 10),

                      // Episódios
                      _buildInfoRow(
                        'Episódios',
                        character.episodeCount.toString(),
                      ),
                      const SizedBox(height: 20),

                      // Botão Fechar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bgAside,
                            foregroundColor: AppColors.bgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppColors.borderRadiusCard,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Fechar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.primaryColor.withValues(alpha: 0.5),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
