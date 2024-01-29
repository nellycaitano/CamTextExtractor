import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class PhotoScreen extends StatefulWidget {
  final String text;

  const PhotoScreen({Key? key, required this.text}) : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultat'),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              _copyToClipboard(context, _textEditingController.text);
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _shareText(context, _textEditingController.text);
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveText(context, _textEditingController.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: TextField(
          controller: _textEditingController,
          maxLines: null, 
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    final snackBar = SnackBar(
      content: Text('Texte copié dans le presse-papiers'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _shareText(BuildContext context, String text) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final String subject = 'Text Extracted';
    Share.share(text, subject: subject);
  }

  void _saveText(BuildContext context, String text) {
    
    final snackBar = SnackBar(
      content: Text('Texte sauvegardé avec succès'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
