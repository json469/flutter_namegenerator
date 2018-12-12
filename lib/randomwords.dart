import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'randomwords_addform.dart';

class RandomWords extends StatefulWidget {
  @override
  createState() => new _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      onPressed: () => _showAddDialog(),
      tooltip: 'Add your own word',
      child: Icon(Icons.add),
    );
  }

  void _showAddDialog() async {
    await showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add a custom Word Pair'),
          contentPadding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
          children: <Widget>[
            RandomWordAddForm(),
          ],
        );
      },
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
    return _buildRow(context, _suggestions[index]);
  }

  Widget _buildRow(BuildContext context, WordPair pair) {
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
        _displaySnackBar(context, pair.asPascalCase, _alreadySaved);
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
      duration: Duration(milliseconds: 750),
    );
    Scaffold.of(context).showSnackBar(_snack);
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
              title: const Text('Favorites'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}