import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Importa o pacote para ícones

class AddAnimalPage extends StatefulWidget {
  const AddAnimalPage({super.key});

  @override
  _AddAnimalPageState createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registrationNumberController =
      TextEditingController();
  String? selectedGender;
  DateTime? birthDate;
  String? selectedBreed;
  String? registrationStatus;
  final TextEditingController historyController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
        birthDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> saveAnimal() async {
    try {
      await FirebaseFirestore.instance.collection('animals').add({
        'name': nameController.text,
        'registrationNumber': registrationNumberController.text,
        'gender': selectedGender,
        'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
        'breed': selectedBreed,
        'registrationStatus': registrationStatus,
        'history': historyController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Animal salvo com sucesso!')),
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
        title: const Text('Adicionar Animal'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 150, 136, 1),
      ),
      body: Container(
        width:
            double.infinity, // Garantindo que o container ocupe toda a largura
        height:
            double.infinity, // Garantindo que o container ocupe toda a altura
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80CBC4), Color(0xFF26A69A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Adicionando padding
          child: SingleChildScrollView(
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
                    Text(
                      'Adicionar Animal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Animal',
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(FontAwesomeIcons.horse), // Ícone de cavalo
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Status do Registro:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text(
                              'S/ Registro',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: 'sem_registro',
                            groupValue: registrationStatus,
                            onChanged: (value) {
                              setState(() {
                                registrationStatus = value;
                                registrationNumberController.clear();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text(
                              'Registrado',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: 'registrado',
                            groupValue: registrationStatus,
                            onChanged: (value) {
                              setState(() {
                                registrationStatus = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: registrationNumberController,
                      enabled: registrationStatus == 'registrado',
                      decoration: const InputDecoration(
                        labelText: 'Número de Registro',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.assignment),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedBreed,
                      decoration: const InputDecoration(
                        labelText: 'Raça',
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(FontAwesomeIcons.horse), // Ícone de cavalo
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: <String>['Mangalarga', 'Quarto de Milha']
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBreed = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gênero',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.transgender),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: <String>['Macho', 'Fêmea']
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGender = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: birthDateController,
                      readOnly: true,
                      onTap: () => _selectBirthDate(context),
                      decoration: const InputDecoration(
                        labelText: 'Data de Nascimento',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: historyController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Histórico de Atendimentos',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.history),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: saveAnimal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Salvar Animal'),
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
}
