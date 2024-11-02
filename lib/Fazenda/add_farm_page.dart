import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AddFarmPage extends StatefulWidget {
  const AddFarmPage({super.key});

  @override
  _AddFarmPageState createState() => _AddFarmPageState();
}

class _AddFarmPageState extends State<AddFarmPage> {
  final List<String> states = [
    'Acre',
    'Alagoas',
    'Amapá',
    'Amazonas',
    'Bahia',
    'Ceará',
    'Distrito Federal',
    'Espírito Santo',
    'Goiás',
    'Maranhão',
    'Mato Grosso',
    'Mato Grosso do Sul',
    'Minas Gerais',
    'Pará',
    'Paraíba',
    'Paraná',
    'Pernambuco',
    'Piauí',
    'Rio de Janeiro',
    'Rio Grande do Norte',
    'Rio Grande do Sul',
    'Rondônia',
    'Roraima',
    'Santa Catarina',
    'São Paulo',
    'Sergipe',
    'Tocantins',
  ];

  String? selectedState;
  String? cityName;

  final TextEditingController farmNameController = TextEditingController();
  final TextEditingController cpfCnpjController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController logradouroController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isCpfSelected = false;
  bool isCnpjSelected = false;

  Future<void> saveFarm() async {
    try {
      // Prepare data to save
      final data = {
        'name': farmNameController.text,
        'cep': cepController.text,
        'logradouro': logradouroController.text,
        'number': numberController.text,
        'state': selectedState,
        'city': cityName,
        'phone': phoneController.text,
      };

      // Check if CPF or CNPJ is selected and add to data
      if (isCpfSelected) {
        data['cpf'] = cpfCnpjController.text; // Save CPF
      } else if (isCnpjSelected) {
        data['cnpj'] = cpfCnpjController.text; // Save CNPJ
      }

      await FirebaseFirestore.instance.collection('farms').add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fazenda salva com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Fazenda'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 150, 136, 1),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height, // Ajustando a altura
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80CBC4), Color(0xFF26A69A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Adicionar Fazenda',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 105, 92, 1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(farmNameController, 'Nome da Fazenda',
                        Icons.agriculture),
                    const SizedBox(height: 10),
                    // Checkboxes for CPF and CNPJ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isCpfSelected,
                          onChanged: (value) {
                            setState(() {
                              isCpfSelected = value ?? false;
                              isCnpjSelected =
                                  false; // Uncheck CNPJ if CPF is selected
                              cpfCnpjController.text = ''; // Clear the field
                            });
                          },
                        ),
                        const Text('CPF'),
                        const SizedBox(width: 20),
                        Checkbox(
                          value: isCnpjSelected,
                          onChanged: (value) {
                            setState(() {
                              isCnpjSelected = value ?? false;
                              isCpfSelected =
                                  false; // Uncheck CPF if CNPJ is selected
                              cpfCnpjController.text = ''; // Clear the field
                            });
                          },
                        ),
                        const Text('CNPJ'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Text field for CPF or CNPJ with conditional text
                    _buildTextField(
                      cpfCnpjController,
                      isCpfSelected
                          ? 'Digite o CPF'
                          : isCnpjSelected
                              ? 'Digite o CNPJ'
                              : 'Selecione acima CPF ou CNPJ',
                      Icons.person,
                      keyboardType: TextInputType.number,
                      enabled: true, // Always enabled for user input
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(cepController, 'CEP', Icons.location_on,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildTextField(
                        logradouroController, 'Logradouro', Icons.streetview),
                    const SizedBox(height: 10),
                    _buildTextField(
                        numberController, 'Número', Icons.format_list_numbered,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildTextField(
                        phoneController, 'Telefone para Contato', Icons.phone,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    const SizedBox(height: 10),
                    _buildStateDropdown(),
                    const SizedBox(height: 10),
                    _buildTextField(
                      TextEditingController(text: cityName),
                      'Nome da Cidade',
                      Icons.location_city,
                      onChanged: (value) {
                        cityName = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await saveFarm();
                        },
                        child: const Text('Salvar Fazenda'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {Function(String)? onChanged,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildStateDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Selecione um Estado',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      value: selectedState,
      onChanged: (value) {
        setState(() {
          selectedState = value;
        });
      },
      items: states.map((state) {
        return DropdownMenuItem<String>(
          value: state,
          child: Text(state),
        );
      }).toList(),
      validator: (value) =>
          value == null ? 'Por favor, selecione um estado' : null,
    );
  }
}
