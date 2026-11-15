import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IA03 - Diàlegs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  String get _valor =>
      myController.text.isEmpty ? '(no has escrit res)' : myController.text;

  void _mostraAlertDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        icon: const Icon(Icons.info_outline),
        title: const Text('AlertDialog'),
        content: Text('Has escrit: $_valor'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel·lar'),
            child: const Text('Cancel·lar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    ).then((resposta) => _snack('AlertDialog tancat amb: ${resposta ?? "-"}'));
  }

  void _mostraSimpleDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text('SimpleDialog\nHas escrit: $_valor'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Majúscules'),
            child: const Text('Mostra-ho en MAJÚSCULES'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Minúscules'),
            child: const Text('Mostra-ho en minúscules'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Invertit'),
            child: const Text('Mostra-ho al revés'),
          ),
        ],
      ),
    ).then((opcio) {
      if (opcio == null) return;
      final text = myController.text;
      final resultat = switch (opcio) {
        'Majúscules' => text.toUpperCase(),
        'Minúscules' => text.toLowerCase(),
        _ => text.split('').reversed.join(),
      };
      _snack('$opcio: $resultat');
    });
  }

  void _mostraBottomSheet() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('ModalBottomSheet',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_valor),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tancar BottomSheet'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostraCupertinoDialog() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('CupertinoAlertDialog'),
        content: Text('Has escrit: $_valor'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              myController.clear();
              Navigator.pop(context);
            },
            child: const Text('Esborrar'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('D\'acord'),
          ),
        ],
      ),
    );
  }

  void _snack(String missatge) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(missatge)));
  }

  Widget _botoDialeg(String text, IconData icona, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: onPressed,
        icon: Icon(icona),
        label: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Recuperar el valor d\'un camp de text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escriu alguna cosa',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 20),
            _botoDialeg('1. AlertDialog', Icons.warning_amber,
                Colors.deepPurple, _mostraAlertDialog),
            _botoDialeg('2. SimpleDialog', Icons.list,
                Colors.teal, _mostraSimpleDialog),
            _botoDialeg('3. BottomSheet', Icons.vertical_align_bottom,
                Colors.orange.shade800, _mostraBottomSheet),
            _botoDialeg('4. CupertinoAlertDialog', Icons.phone_iphone,
                Colors.pink, _mostraCupertinoDialog),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: _mostraBottomSheet,
        tooltip: 'Mostra el valor!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
