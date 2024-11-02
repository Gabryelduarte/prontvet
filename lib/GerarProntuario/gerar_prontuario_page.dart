import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Importa o pacote
import 'dart:typed_data'; // Para manipular dados em bytes
import 'package:pdf/widgets.dart' as pw; // Widgets para PDF
import 'package:firebase_storage/firebase_storage.dart'; // Para o Firebase Storage
import 'package:path_provider/path_provider.dart'; // Para obter o diretório do dispositivo
import 'package:open_file/open_file.dart'; // Para abrir o PDF gerado

class GerarProntuarioPage extends StatefulWidget {
  const GerarProntuarioPage({super.key});

  @override
  _GerarProntuarioPageState createState() => _GerarProntuarioPageState();
}

class _GerarProntuarioPageState extends State<GerarProntuarioPage> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerContactController = TextEditingController();
  final TextEditingController _animalNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _anamnesisController = TextEditingController();
  final TextEditingController _dateController =
      TextEditingController(); // Controller para a data do atendimento

  bool _isRegistrationNumberProvided = false;
  String? _selectedBreed; // Variável para armazenar a raça selecionada
  DateTime? _selectedDate; // Variável para armazenar a data selecionada

  // Lista de raças de cavalo que existem no Brasil
  final List<String> _breeds = [
    'Mangalarga Marchador',
    'Crioulo',
    'Thoroughbred',
    'Quarto de Milha',
    'Paint Horse',
    'Percheron',
    'Selle Français',
    'Arabian',
    'Appaloosa',
    // Adicione mais raças conforme necessário
  ];

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Column(
          children: [
            pw.Text('Prontuário do Animal',
                style: const pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text('Nome do Proprietário: ${_ownerNameController.text}'),
            pw.Text('Contato do Proprietário: ${_ownerContactController.text}'),
            pw.Text('Data do Atendimento: ${_dateController.text}'),
            pw.Text('Nome do Animal: ${_animalNameController.text}'),
            pw.Text('Raça: ${_selectedBreed ?? "Não especificado"}'),
            pw.Text(
                'Número de Registro: ${_registrationNumberController.text}'),
            pw.Text('Sexo: ${_sexController.text}'),
            pw.Text('Anamnese Geral: ${_anamnesisController.text}'),
          ],
        ),
      );
    }));

    // Salvar PDF em bytes
    final Uint8List pdfInBytes = await pdf.save();

    // Nome do arquivo baseado no nome do animal
    String fileName = "${_animalNameController.text.replaceAll(' ', '_')}.pdf";

    // Salvar PDF no dispositivo
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/$fileName";
    final file = File(filePath);

    await file.writeAsBytes(pdfInBytes);

    // Upload para o Firebase Storage
    try {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('prontuarios/$fileName');
      await storageRef.putData(pdfInBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Prontuário gerado e enviado com sucesso!')),
      );

      // Abrir o PDF
      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar o prontuário: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.toLocal()}".split(' ')[0]; // Formata a data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerar Prontuário'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(
              _ownerNameController,
              'Nome do Proprietário',
              Icons.person,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              _ownerContactController,
              'Contato do Proprietário',
              Icons.phone,
            ),
            const SizedBox(height: 10),
            _buildDateField(), // Adiciona o campo de data
            const SizedBox(height: 10),
            _buildTextField(
              _animalNameController,
              'Nome do Animal',
              FontAwesomeIcons.horse, // Usando o ícone de cavalo
            ),
            const SizedBox(height: 10),
            _buildDropdownField(), // Chama o método para o dropdown
            const SizedBox(height: 10),
            _buildTextField(
              _registrationNumberController,
              'Número de Registro (opcional)',
              Icons.assignment,
              onChanged: (value) {
                setState(() {
                  _isRegistrationNumberProvided = value.isNotEmpty;
                });
              },
            ),
            if (_isRegistrationNumberProvided) ...[
              const SizedBox(height: 10),
              _buildTextField(
                _sexController,
                'Sexo',
                Icons.transgender,
              ),
            ],
            const SizedBox(height: 10),
            _buildTextField(
              _anamnesisController,
              'Anamnese Geral',
              Icons.note,
              maxLines: 5,
              isMultiline: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _generatePDF();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Gerar Prontuário'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {int maxLines = 1,
      bool isMultiline = false,
      Function(String)? onChanged}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
          maxLines: isMultiline ? maxLines : 1,
          keyboardType:
              isMultiline ? TextInputType.multiline : TextInputType.text,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: _dateController,
          decoration: const InputDecoration(
            labelText: 'Data do Atendimento',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          readOnly: true, // Torna o campo somente leitura
          onTap: () => _selectDate(context), // Abre o DatePicker ao tocar
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: DropdownButtonFormField<String>(
          value: _selectedBreed,
          hint: const Text('Selecione a Raça'),
          icon: const Icon(Icons.arrow_drop_down),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedBreed = newValue;
            });
          },
          items: _breeds.map<DropdownMenuItem<String>>((String breed) {
            return DropdownMenuItem<String>(
              value: breed,
              child: Text(breed),
            );
          }).toList(),
        ),
      ),
    );
  }
}
