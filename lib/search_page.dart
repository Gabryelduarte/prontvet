import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedSearchType = 'Animal';
  bool searchByName = false;
  bool searchById = false;
  bool searchByCpf = false;
  bool searchByCnpj = false;

  final TextEditingController animalNameController = TextEditingController();
  final TextEditingController animalIdController = TextEditingController();
  final TextEditingController farmNameController = TextEditingController();
  final TextEditingController farmCpfController = TextEditingController();
  final TextEditingController farmCnpjController = TextEditingController();

  List<DocumentSnapshot>? searchResults;

  void clearFields() {
    searchByName = false;
    searchById = false;
    searchByCpf = false;
    searchByCnpj = false;
    animalNameController.clear();
    animalIdController.clear();
    farmNameController.clear();
    farmCpfController.clear();
    farmCnpjController.clear();
    setState(() {
      searchResults = null;
    });
  }

  Future<void> performSearch() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (selectedSearchType == 'Animal') {
      if (searchByName && animalNameController.text.isNotEmpty) {
        searchResults = (await firestore
                .collection('animals')
                .where('name', isEqualTo: animalNameController.text)
                .get())
            .docs;
      } else if (searchById && animalIdController.text.isNotEmpty) {
        searchResults = (await firestore
                .collection('animals')
                .where('registrationNumber', isEqualTo: animalIdController.text)
                .get())
            .docs;
      }
    } else {
      if (searchByName && farmNameController.text.isNotEmpty) {
        searchResults = (await firestore
                .collection('farms')
                .where('name', isEqualTo: farmNameController.text)
                .get())
            .docs;
      }
      if (searchByCpf && farmCpfController.text.isNotEmpty) {
        searchResults = (await firestore
                .collection('farms')
                .where('cpf', isEqualTo: farmCpfController.text)
                .get())
            .docs;
      }
      if (searchByCnpj && farmCnpjController.text.isNotEmpty) {
        searchResults = (await firestore
                .collection('farms')
                .where('cnpj', isEqualTo: farmCnpjController.text)
                .get())
            .docs;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisa'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 150, 136, 1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80CBC4), Color(0xFF26A69A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Radio buttons para selecionar pesquisa de Animal ou Fazenda
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Animal'),
                              value: 'Animal',
                              groupValue: selectedSearchType,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedSearchType = value;
                                  clearFields();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Fazenda'),
                              value: 'Fazenda',
                              groupValue: selectedSearchType,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedSearchType = value;
                                  clearFields();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Campos para pesquisa de Animal ou Fazenda
                      if (selectedSearchType == 'Animal') ...[
                        _buildCheckbox(
                          label: 'Buscar por Nome',
                          value: searchByName,
                          onChanged: (bool? value) {
                            setState(() {
                              searchByName = value ?? false;
                              if (searchByName) searchById = false;
                            });
                          },
                        ),
                        if (searchByName)
                          _buildTextField(
                              animalNameController, 'Nome do Animal'),
                        const SizedBox(height: 10),
                        _buildCheckbox(
                          label: 'Buscar por Número de Registro',
                          value: searchById,
                          onChanged: (bool? value) {
                            setState(() {
                              searchById = value ?? false;
                              if (searchById) searchByName = false;
                            });
                          },
                        ),
                        if (searchById)
                          _buildTextField(
                            animalIdController,
                            'Número de Registro',
                            keyboardType: TextInputType.number,
                          ),
                      ] else ...[
                        _buildCheckbox(
                          label: 'Buscar por Nome',
                          value: searchByName,
                          onChanged: (bool? value) {
                            setState(() {
                              searchByName = value ?? false;
                              if (searchByName) {
                                searchByCpf = false;
                                searchByCnpj = false;
                                farmCpfController.clear();
                                farmCnpjController.clear();
                              }
                            });
                          },
                        ),
                        if (searchByName)
                          _buildTextField(
                              farmNameController, 'Nome da Fazenda'),
                        const SizedBox(height: 10),
                        _buildCheckbox(
                          label: 'Buscar por CPF',
                          value: searchByCpf,
                          onChanged: (bool? value) {
                            setState(() {
                              searchByCpf = value ?? false;
                              if (searchByCpf) {
                                searchByName = false;
                                searchByCnpj = false;
                                farmCnpjController.clear();
                              }
                            });
                          },
                        ),
                        if (searchByCpf)
                          _buildTextField(
                            farmCpfController,
                            'CPF',
                            keyboardType: TextInputType.number,
                          ),
                        const SizedBox(height: 10),
                        _buildCheckbox(
                          label: 'Buscar por CNPJ',
                          value: searchByCnpj,
                          onChanged: (bool? value) {
                            setState(() {
                              searchByCnpj = value ?? false;
                              if (searchByCnpj) {
                                searchByName = false;
                                searchByCpf = false;
                                farmCpfController.clear();
                              }
                            });
                          },
                        ),
                        if (searchByCnpj)
                          _buildTextField(
                            farmCnpjController,
                            'CNPJ',
                            keyboardType: TextInputType.number,
                          ),
                      ],

                      const SizedBox(height: 20),
                      // Centro para os botões de pesquisa e limpar campos
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton(
                              label: 'Pesquisar',
                              onPressed: performSearch,
                            ),
                            const SizedBox(width: 16), // Espaço entre os botões
                            _buildActionButton(
                              label: 'Limpar Campos',
                              onPressed: clearFields,
                              backgroundColor:
                                  Colors.grey, // Cor do botão Limpar Campos
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Exibição dos resultados
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults?.length ?? 0,
                  itemBuilder: (context, index) {
                    final data =
                        searchResults![index].data() as Map<String, dynamic>?;

                    final name = data?['name'] ?? 'Nome não disponível';
                    String identifier = '';

                    // Se estiver buscando por Animal, mostra o número de registro
                    if (selectedSearchType == 'Animal') {
                      identifier =
                          data?['registrationNumber'] ?? 'Sem Registro';
                    } else {
                      // Se estiver buscando por Fazenda, verifica CPF ou CNPJ
                      final cpf = data?['cpf'];
                      final cnpj = data?['cnpj'];

                      if (cpf != null && cpf.isNotEmpty) {
                        identifier = 'CPF: $cpf';
                      } else if (cnpj != null && cnpj.isNotEmpty) {
                        identifier = 'CNPJ: $cnpj';
                      } else {
                        identifier = 'Nenhum CPF ou CNPJ disponível';
                      }
                    }

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              identifier,
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Navegar para a página de detalhes
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(0, 150, 136, 1),
                              ),
                              child: const Text('Detalhes'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = const Color.fromRGBO(0, 150, 136, 1),
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(label),
    );
  }
}
