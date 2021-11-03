import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onloop/bloc/content_provider.dart';
import 'package:onloop/models/content_modal.dart';
import 'package:onloop/widgets/tag_component.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentComponent extends StatelessWidget {
  const ContentComponent({
    Key? key,
    required this.contentModal,
  }) : super(key: key);

  final ContentModal contentModal;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context);

    return InkWell(
      onTap: () async {
        await canLaunch(contentModal.contentUrl)
            ? await launch(contentModal.contentUrl)
            : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Can not launch url')),
              );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        padding: const EdgeInsets.only(top: 10, left: 5.0, right: 5.0),
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  createImage(),
                  const SizedBox(width: 5.0),
                  createDescription(provider)
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            createFooter()
          ],
        ),
      ),
    );
  }

  Expanded createDescription(ContentProvider provider) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createTopLine(provider),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            contentModal.title,
            style: const TextStyle(
              fontSize: 14.0,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 2.0,
          ),
          Text(
            contentModal.description,
            maxLines: 2,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Row createTopLine(ContentProvider provider) {
    final formatter = DateFormat.yMMMMd();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.article_outlined),
            Text('Article - ${formatter.format(contentModal.createdAt)}')
          ],
        ),
        IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            alignment: Alignment.topRight,
            onPressed: () => provider.toggleSaved(contentModal),
            icon: Icon(contentModal.saved
                ? Icons.bookmark
                : Icons.bookmark_border_outlined))
      ],
    );
  }

  Row createFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shared by Onloop', style: TextStyle(fontSize: 14.0)),
            TagComponent(tag: contentModal.tags[0], onSelectTag: null)
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.thumb_up_outlined,
                size: 34,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.thumb_down_outlined,
                size: 34,
              ),
            ),
          ],
        )
      ],
    );
  }

  Container createImage() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          contentModal.thumbnailUrl,
          width: 80.0,
          height: 80.0,
        ),
      ),
    );
  }
}
