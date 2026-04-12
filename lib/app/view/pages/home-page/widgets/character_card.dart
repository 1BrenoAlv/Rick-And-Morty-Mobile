import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/model/character.dart';

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
    return Card(
      child: Column(
        children: [
          ClipRRect(
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(character.image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Column(
              children: [
                Text(character.name),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: _statusColor(character.status),
                    ),
                    SizedBox(height: 4),
                    Text(character.species),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
