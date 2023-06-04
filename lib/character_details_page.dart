import 'package:flutter/material.dart';

const Color textColor = const Color(0xFFFFFFFF);

class CharacterDetailsPage extends StatelessWidget {
  final Map<String, dynamic> character;

  CharacterDetailsPage({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Personagem'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              '${character['thumbnail']['path']}.${character['thumbnail']['extension']}',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            Text(
              character['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Descrição: ${character['description'] != null && character['description'].isNotEmpty ? character['description'] : 'Descrição não disponível'}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
