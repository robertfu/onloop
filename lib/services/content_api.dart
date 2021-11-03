import 'dart:convert';
import 'package:http/http.dart';
import 'package:onloop/models/content_modal.dart';
import 'package:onloop/models/tag.dart';

class ContentApi {
  static Future<List<ContentModal>> getContents() async {
    const String url =
        'https://run.mocky.io/v3/742454fc-089b-47df-b7c1-4c1ce4091586';
    final response = await get(Uri.parse(url));

    final List<ContentModal> contents = [];
    final contentMaps = jsonDecode(response.body)['learn_content'];

    for (var content in contentMaps) {
      contents.add(ContentModal.fromMap(content));
    }

    return contents;
  }

  static Future<List<Tag>> getTags() async {
    const String url =
        'https://run.mocky.io/v3/c498ac6a-5be7-4ac3-b407-b703af3e2247';
    final response = await get(Uri.parse(url));

    final contentMaps = jsonDecode(response.body)['tags'];

    return ContentModal.parseTags(contentMaps);
  }
}
