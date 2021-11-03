import 'package:onloop/models/tag.dart';

class ContentModal {
  final String title;
  final String description;
  final String thumbnailUrl;
  final String contentUrl;
  final List<Tag> tags;
  bool saved = false;
  final DateTime createdAt;

  ContentModal(
      {required this.title,
      required this.description,
      required this.contentUrl,
      required this.tags,
      required this.createdAt,
      required this.thumbnailUrl});

  ContentModal.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        description = map['description'],
        thumbnailUrl = map['thumbnail_url'],
        contentUrl = map['content_url'],
        createdAt = DateTime.parse(map['created_at']),
        tags = parseTags(map['tags'] as List);

  static parseTags(List<dynamic> tagMaps) =>
      tagMaps.map<Tag>((tag) => Tag(tag['name']!, tag['color']!)).toList();
}
