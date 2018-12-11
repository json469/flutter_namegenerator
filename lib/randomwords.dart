import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  createState() => new _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _renderFloatingActionBar(),
    );
  }

  Widget _renderFloatingActionBar() {
    return FloatingActionButton(
      onPressed: _pushAdd,
      tooltip: 'Add your own word',
      child: Icon(Icons.add),
    );
  }

  void _pushAdd() {
    print('@fab has been pressed!');
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a custom word'),
          content: _renderForm(),
          actions: <Widget>[
            FlatButton(
              child: Text('ADD'),
              onPressed: (_textController.text.isNotEmpty) ? () =>  _addNewPair() : null,
            ),
          ],
        );
      }
    );
  }
  void _addNewPair() {
    _textController.clear();
    
    Navigator.of(context).pop();
  }

  Widget _renderForm() {
    return Container(
      height: 50.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            autofocus: true,
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'RedPotato',
            ),
          ),
        ]
      )
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: _listViewItemBuilder,
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int i) {
    if (i.isOdd) { return Divider(); }
    final index = i ~/ 2;
    if (index >= _suggestions.length) {
      _suggestions.addAll(generateWordPairs().take(4));
    }
    return _buildRow(_suggestions[index]);
  }

  Widget _buildRow(WordPair pair) {
    final bool _alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        _displaySnackBar(this.context, pair.asPascalCase, _alreadySaved);
        setState(() {
          if (_alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }
    );
  }

  void _displaySnackBar(BuildContext context, String pair, bool alreadySaved) {
    final _message = alreadySaved ? "Removed $pair from favorites" : "Added $pair to faovrites";
    final _snack = new SnackBar(
      content: Text(_message),
      duration: Duration(milliseconds: 500),
    );
     _scaffoldKey.currentState.showSnackBar(_snack);
  }

  void _pushSaved() {
    Navigator.of(this.context).push(
      new MaterialPageRoute(
        builder: (context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
            .divideTiles(
              context: context,
              tiles: tiles,
            )
            .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}