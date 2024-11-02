import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontvet/Animal/add_animal_page.dart';
import 'package:prontvet/Fazenda/add_farm_page.dart';
import 'package:prontvet/GerarProntuario/gerar_prontuario_page.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove o botão de voltar
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ProntVet',
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              _showProfileMenu(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fundo com gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF80CBC4), Color(0xFF26A69A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Cards de ação no centro
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionCard(
                    context,
                    icon: FontAwesomeIcons.horse,
                    label: 'Adicionar Animal',
                    color: Colors.teal,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddAnimalPage()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildActionCard(
                    context,
                    icon: FontAwesomeIcons.tractor,
                    label: 'Adicionar Fazenda',
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddFarmPage()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildActionCard(
                    context,
                    icon: Icons.search,
                    label: 'Pesquisar',
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildActionCard(
                    context,
                    icon: Icons.note_add,
                    label: 'Gerar Prontuário',
                    color: Colors.blue, // Cor do novo botão
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GerarProntuarioPage()), // Navegando para GerarProntuarioPage
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para criar cards de ação com animação e sombra
  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white, // Cor de fundo do card
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para mostrar o menu de perfil como um bottom sheet
  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nome do Usuário',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.teal),
                title: const Text('Minha Conta'),
                onTap: () {
                  // Lógica para abrir "Minha Conta"
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.teal),
                title: const Text('Ajuda e Suporte'),
                onTap: () {
                  // Lógica para abrir "Ajuda e Suporte"
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Sair'),
                onTap: () {
                  // Lógica para sair
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
