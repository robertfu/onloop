import 'package:flutter/material.dart';
import 'package:onloop/bloc/content_provider.dart';
import 'package:onloop/models/content_modal.dart';
import 'package:onloop/widgets/content_component.dart';
import 'package:provider/provider.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({Key? key}) : super(key: key);

  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context);
    return StreamBuilder<List<ContentModal>?>(
      stream: provider.contents,
      builder:
          (BuildContext context, AsyncSnapshot<List<ContentModal>?> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error, please try again later'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.blue,
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, int index) {
            final c = data[index];
            return ContentComponent(contentModal: c);
          },
        );
      },
    );
  }
}
