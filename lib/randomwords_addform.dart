import 'package:flutter/material.dart';

class RandomWordAddForm extends StatefulWidget {
  @override
  createState() => new _RandomWordAddFormState();
}

class _RandomWordAddFormState extends State<RandomWordAddForm> {

  final _formKey = GlobalKey<FormState>();
  final _textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            controller: _textController,
            validator: (String text) {
              final _words = text.split(' ');
              if (_words[0] == "") { return 'Please enter a word pair.'; }
              else if (RegExp('([a-z]*)([A-Z]*?)([A-Z][a-z]+){2}').hasMatch(_words.toString())) { return null; }  // Escape camelcased one word i.e. RedPotato
              else if (_words.length > 2) { return 'Too many words, please type a word pair.'; }
              else if (_words.length < 2) { return 'Not enough words, please type a word pair.'; }
            },
            decoration: InputDecoration(
              hintText: 'RedPotato or Red Potato',
            ),
          ),
          FlatButton(
            child: Text('ADD'),
            onPressed: () => (_formKey.currentState.validate()) ? _addNewPair() : null,
          ),
        ]
      ),
    );
  }

  void _addNewPair() {
    // final _word = _textController.text.split(' ');
    // setState(() => _suggestions.insert(0, (new WordPair(_word[0], _word[1]))));
    _textController.clear();
    Navigator.of(context).pop();
  }
}