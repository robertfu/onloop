import 'package:flutter/material.dart';
import 'package:onloop/bloc/content_provider.dart';
import 'package:onloop/widgets/content_widget.dart';
import 'package:onloop/widgets/icon_container.dart';
import 'package:provider/provider.dart';

class SavedArticles extends StatelessWidget {
  const SavedArticles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved for later',
          style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            provider.showSaved(false);
            Navigator.of(context).pop();
          },
          icon: const IconContainer(iconData: Icons.close_outlined),
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            provider.showSaved(false);
            return true;
          },
          child: const ContentWidget()),
    );
  }
}
