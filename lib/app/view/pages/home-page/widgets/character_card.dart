import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/config/colors.dart';
import 'package:rick_and_morty_mobile/app/config/translations.dart';
import 'package:rick_and_morty_mobile/app/model/character.dart';
import 'package:rick_and_morty_mobile/app/view/pages/home-page/widgets/modal_character.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({super.key, required this.character});
  final Character character;
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ModalCharacter.show(context, character),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppColors.borderRadiusCard,
          side: const BorderSide(color: AppColors.colorBorder, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  character.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off,
                            color: AppColors.colorBorder,
                            size: 40,
                          ),
                          const Text(
                            'Sem imagem',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: _statusColor(character.status),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${AppTranslations.status(character.status)} - ${AppTranslations.species(character.species)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
