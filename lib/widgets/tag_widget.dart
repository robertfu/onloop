import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onloop/bloc/content_provider.dart';
import 'package:onloop/models/tag.dart';
import 'package:onloop/widgets/tag_component.dart';
import 'package:provider/provider.dart';

class TagWidget extends StatefulWidget {
  const TagWidget({Key? key}) : super(key: key);

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<ContentProvider>(context, listen: false).getTags();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context);
    return StreamBuilder<List<Tag>?>(
      stream: provider.tags,
      builder: (BuildContext context, AsyncSnapshot<List<Tag>?> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error, please try again later'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        final data = snapshot.data!;
        // there is a known issue here based on the mockup - "Wrap" here is working like a "Table" for some reason.
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            direction: Axis.vertical,
            spacing: -15,
            runSpacing: -2,
            children: data
                .map((tag) => TagComponent(
                      tag: tag,
                      onSelectTag: provider.selectTag,
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
