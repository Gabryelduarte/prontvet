import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnimalListPage extends StatelessWidget {
  const AnimalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Animais'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('animals').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar animais.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum animal encontrado.'));
          }

          final animalDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: animalDocs.length,
            itemBuilder: (context, index) {
              final animal = animalDocs[index];
              return ListTile(
                title: Text(animal['name'] ?? 'Sem Nome'),
                subtitle: Text(
                  'Raça: ${animal['breed'] ?? 'Não informada'} | '
                  'Gênero: ${animal['gender'] ?? 'Não informado'}',
                ),
                onTap: () {
                  // Adicione uma ação se necessário (ex.: detalhes do animal)
                },
              );
            },
          );
        },
      ),
    );
  }
}
