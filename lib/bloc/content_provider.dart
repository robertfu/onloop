import 'package:onloop/models/content_modal.dart';
import 'package:onloop/models/tag.dart';
import 'package:onloop/services/content_api.dart';
import 'package:rxdart/rxdart.dart';

class ContentProvider {
  final Tag tagForAll = Tag('All', 'black', selected: true);
  final BehaviorSubject<List<ContentModal>?> _contentsSubject =
      BehaviorSubject.seeded(null);
  final BehaviorSubject<List<Tag>?> _tagsSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<Tag?> _searchSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool> _savedSubject = BehaviorSubject.seeded(false);

  Function get showSaved => _savedSubject.add;
  
  Stream<List<Tag>?> get tags => _tagsSubject.stream;
  Stream<Tag?> get search => _searchSubject.stream;
  Stream<List<ContentModal>?> get contents =>
      Rx.combineLatest3(_contentsSubject.stream, _savedSubject.stream, search,
          (List<ContentModal>? allContent, bool savedOnly, Tag? searchedTag) {
        if (allContent == null) {
          return null;
        }

        List<ContentModal> filteredContents = allContent;
        if (savedOnly) {
          filteredContents = filteredContents.where((c) => c.saved).toList();
        } else if (searchedTag != null && searchedTag != tagForAll) {
          filteredContents = filteredContents
              .where((c) => c.tags.any((t) => t.name == searchedTag.name))
              .toList();
        }

        return filteredContents;
      });

  Future getContents() async {
    try {
      final allContents = await ContentApi.getContents();
      _contentsSubject.add(allContents);
    } catch (e) {
      _contentsSubject.addError(e);
    }
  }

  void selectTag(Tag tag) {
    final allTags = _tagsSubject.value;
    if (allTags != null) {
      for (var t in allTags) {
        t.selected = t == tag;
      }
    }
    _tagsSubject.add(allTags);
    _searchSubject.add(tag);
  }

  void toggleSaved(ContentModal contentModal) {
    contentModal.saved = !contentModal.saved;
    _contentsSubject.add(_contentsSubject.value);
  }

  Future getTags() async {
    try {
      final allTags = await ContentApi.getTags();
      allTags.insert(0, tagForAll);
      _tagsSubject.add(allTags);
    } catch (e) {
      _tagsSubject.addError(e);
    }
  }

  void dispose() {
    _contentsSubject.close();
    _tagsSubject.close();
    _searchSubject.close();
    _savedSubject.close();
  }
}
