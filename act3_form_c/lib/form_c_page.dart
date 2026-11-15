import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class FormCPage extends StatefulWidget {
  const FormCPage({super.key});

  @override
  State<FormCPage> createState() => _FormCPageState();
}

class _FormCPageState extends State<FormCPage> {
  static const String title = 'Jan González Romero';

  final _formKey = GlobalKey<FormBuilderState>();

  int _autocompleteGeneration = 0;

  static const _llenguatges = <String>[
    'Dart', 'Kotlin', 'Java', 'Swift', 'JavaScript', 'TypeScript',
    'Python', 'C#', 'C++', 'Go', 'Rust', 'PHP', 'Ruby',
  ];

  void _onChanged(dynamic val) => debugPrint(val.toString());

  void _enviar() {
    final form = _formKey.currentState!;
    if (form.saveAndValidate()) {
      alertDialog(context, _formatValors(form.value));
    } else {
      debugPrint('Validació fallida: ${form.value}');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('Revisa els camps marcats en vermell'),
        ));
    }
  }

  void _reset() {
    _formKey.currentState?.reset();
    setState(() => _autocompleteGeneration++);
  }

  String _formatValors(Map<String, dynamic> valors) {
    final data = DateFormat('dd/MM/yyyy');
    final hora = DateFormat('HH:mm');
    String format(String key, dynamic v) {
      if (v == null) return '-';
      if (v is DateTimeRange) {
        return '${data.format(v.start)} - ${data.format(v.end)}';
      }
      if (v is DateTime) return key == 'time' ? hora.format(v) : data.format(v);
      if (v is List) return v.isEmpty ? '-' : v.join(', ');
      return v.toString();
    }

    return valors.entries.map((e) => '${e.key}: ${format(e.key, e.value)}').join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final chipLabelStyle = TextStyle(color: scheme.onPrimary);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.inversePrimary,
        title: const Text(title),
        actions: [
          IconButton(
            tooltip: 'Esborrar formulari',
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              FormBuilderChoiceChips<String>(
                name: 'choice_chip',
                decoration: const InputDecoration(
                  labelText: 'Choice Chips',
                  border: OutlineInputBorder(),
                ),
                alignment: WrapAlignment.spaceEvenly,
                spacing: 8,
                runSpacing: 8,
                backgroundColor: scheme.primary,
                selectedColor: Colors.orange.shade700,
                labelStyle: chipLabelStyle,
                checkmarkColor: Colors.white,
                shape: const StadiumBorder(),
                options: const [
                  FormBuilderChipOption(
                    value: 'Flutter',
                    avatar: FlutterLogo(),
                  ),
                  FormBuilderChipOption(
                    value: 'Android',
                    avatar: Icon(Icons.android, color: Colors.lightGreenAccent),
                  ),
                  FormBuilderChipOption(
                    value: 'Chrome OS',
                    avatar: Icon(Icons.laptop_chromebook, color: Colors.white),
                  ),
                ],
                onChanged: _onChanged,
              ),
              const SizedBox(height: 16),
              FormBuilderSwitch(
                name: 'switch',
                title: const Text('This is a switch'),
                initialValue: false,
                decoration: const InputDecoration(
                  labelText: 'Switch',
                  border: OutlineInputBorder(),
                ),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'text_field',
                maxLength: 15,
                decoration: const InputDecoration(
                  labelText: 'Text Field',
                  prefixIcon: Icon(Icons.text_format),
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(10),
                ]),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 8),
              FormBuilderDropdown<String>(
                name: 'dropdown',
                decoration: const InputDecoration(
                  labelText: 'Dropdown Field',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
                items: const ['Option 1', 'Option 2', 'Option 3']
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 16),
              FormBuilderRadioGroup<String>(
                name: 'radio_group',
                orientation: OptionsOrientation.vertical,
                decoration: const InputDecoration(
                  labelText: 'Radio Group Model',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
                options: const ['Option 1', 'Option 2', 'Option 3', 'Option 4']
                    .map((o) => FormBuilderFieldOption(value: o))
                    .toList(),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 16),
              FormBuilderField<String>(
                key: ValueKey('autocomplete_$_autocompleteGeneration'),
                name: 'autocomplete',
                onChanged: _onChanged,
                builder: (FormFieldState<String> field) {
                  return Autocomplete<String>(
                    optionsBuilder: (TextEditingValue text) {
                      if (text.text.isEmpty) return const Iterable<String>.empty();
                      final q = text.text.toLowerCase();
                      return _llenguatges.where((l) => l.toLowerCase().contains(q));
                    },
                    onSelected: field.didChange,
                    fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: field.didChange,
                        onSubmitted: (_) => onSubmitted(),
                        decoration: InputDecoration(
                          labelText: 'Autocomplete',
                          hintText: 'Escriu un llenguatge (p.ex. "da")',
                          border: const OutlineInputBorder(),
                          errorText: field.errorText,
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'date',
                inputType: InputType.date,
                format: DateFormat('dd/MM/yyyy'),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                decoration: const InputDecoration(
                  labelText: 'Date Picker',
                  suffixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 16),
              FormBuilderDateRangePicker(
                name: 'date_range',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                format: DateFormat('dd/MM/yyyy'),
                decoration: InputDecoration(
                  labelText: 'Date Range',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        _formKey.currentState!.fields['date_range']?.didChange(null),
                  ),
                ),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'time',
                inputType: InputType.time,
                format: DateFormat('HH:mm'),
                decoration: const InputDecoration(
                  labelText: 'Time Picker',
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 16),
              FormBuilderFilterChips<String>(
                name: 'filter_chip',
                decoration: const InputDecoration(
                  labelText: 'Input Chips (Filter Chip)',
                  border: OutlineInputBorder(),
                ),
                alignment: WrapAlignment.center,
                spacing: 6,
                runSpacing: 6,
                backgroundColor: scheme.primary,
                selectedColor: Colors.orange.shade700,
                labelStyle: chipLabelStyle,
                checkmarkColor: Colors.white,
                shape: const StadiumBorder(),
                validator: FormBuilderValidators.maxLength(
                  3,
                  checkNullOrEmpty: false,
                  errorText: 'Tria com a màxim 3 tecnologies',
                ),
                options: const ['HTML', 'CSS', 'React', 'Dart', 'TypeScript', 'Angular']
                    .map((o) => FormBuilderChipOption(value: o))
                    .toList(),
                onChanged: _onChanged,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Enviar',
        onPressed: _enviar,
        child: const Icon(Icons.upload),
      ),
    );
  }
}

void alertDialog(BuildContext context, String contentText) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Submission Completed'),
      icon: const Icon(Icons.check_circle),
      content: SingleChildScrollView(child: Text(contentText)),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Tancar'),
          child: const Text('Tancar'),
        ),
      ],
    ),
  );
}
