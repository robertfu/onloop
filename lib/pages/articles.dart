import 'package:flutter/material.dart';
import 'package:onloop/bloc/content_provider.dart';
import 'package:onloop/pages/saved_articles.dart';
import 'package:onloop/widgets/content_widget.dart';
import 'package:onloop/widgets/icon_container.dart';
import 'package:onloop/widgets/tag_widget.dart';
import 'package:provider/provider.dart';

class Article extends StatefulWidget {
  const Article({Key? key}) : super(key: key);

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  void initState() {
    super.initState();
    Provider.of<ContentProvider>(context, listen: false).getContents();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learn',
          style: TextStyle(color: Colors.black38),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                provider.showSaved(true);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SavedArticles()),
                );
              },
              icon: const IconContainer(iconData: Icons.bookmark_outline))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).orientation == Orientation.portrait? 120.0: 50.0,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const TagWidget()),
          ),
          const Expanded(child: ContentWidget())
        ],
      ),
    );
  }
}
