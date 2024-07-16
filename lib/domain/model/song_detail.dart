import 'dart:collection';

import 'package:icoc_admin_pannel/domain/model/identifable.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';

class SongDetail implements Identifiable {
  @override
  final int id;
  final Map? description;
  final Map title;
  final Map text;
  List<Resources>? resources;
  final Map? chords;
  String? searchTitle;
  String? searchText;
  String? searchLang;

  SongDetail(
      {required this.id,
      required this.title,
      this.description,
      required this.text,
      this.chords,
      this.resources,
      this.searchLang,
      this.searchText,
      this.searchTitle});

  factory SongDetail.fromJson(Map parsedJson, int id) {
    // log.d(parsedJson);
    // Logger().f(parsedJson['resources'].runtimeType);
    // Logger().f(parsedJson['resources']);
    final title = parsedJson['title'] as Map;
    title.removeWhere(
      (key, value) => value == null,
    );
    final text = parsedJson['text'] as Map;
    text.removeWhere(
      (key, value) => value == null,
    );
    final description = parsedJson['description'] as Map?;
    description?.removeWhere(
      (key, value) => value == null,
    );
    final chords = parsedJson['chords'] as Map?;
    chords?.removeWhere(
      (key, value) => value == null,
    );
    return SongDetail(
      id: id,
      title: title,
      text: text,
      description: description,
      resources: parsedJson['resources'] != null
          ? List<Resources>.from(parsedJson['resources']
              .map((resource) => Resources.fromJson(resource)))
          : null,
      chords: chords,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['text'] = text;
    if (description != null) {
      data['description'] = description;
    }
    if (resources != null) {
      data['resources'] = resources?.map((v) => v.toJson()).toList();
    }
    if (chords != null) {
      data['chords'] = chords;
    }
    return data;
  }

  SongDetail copyWith({
    int? id,
    Map? description,
    Map? title,
    Map? text,
    List<Resources>? resources,
    Map? chords,
    String? searchTitle,
    String? searchText,
    String? searchLang,
  }) {
    return SongDetail(
      id: id ?? this.id,
      description: description ?? this.description,
      title: title ?? this.title,
      text: text ?? this.text,
      resources: resources ?? this.resources,
      chords: chords ?? this.chords,
      searchTitle: searchTitle ?? this.searchTitle,
      searchText: searchText ?? this.searchText,
      searchLang: searchLang ?? this.searchLang,
    );
  }

  //provide list with all languages
  List<String> getAllTitleKeys() {
    final Set<String> allKeys = {};

    void collectKeys(Map? map) {
      if (map != null) {
        map.keys.forEach((key) {
          if (key != 'id_song')
          // Remove numbers and duplicates
          {
            final String cleanKey = key.replaceAll(RegExp(r'[0-9]'), '');

            allKeys.add(cleanKey);
          }
        });
      }
    }

    collectKeys(title);
    // collectKeys(this.description);
    //collectKeys(this.chords);
//todo replace in db all keys in shords to 'ru1', 'uk1' and so on Than uncomment line above to filter chords as well.  And than filter resourses as well
    return allKeys.toList();
  }

  List<String> getAllTextKeys() {
    final Set<String> allKeys = {};

    void collectKeys(Map? map) {
      if (map != null) {
        map.keys.forEach((key) {
          allKeys.add(key);
        });
      }
    }

    collectKeys(text);
    return allKeys.toList();
  }

  List<Resources> _sortResources(
      List<Resources> resources, List<String> orderLanguages) {
    resources.sort((a, b) {
      final int indexA = orderLanguages.indexOf(a.lang);
      final int indexB = orderLanguages.indexOf(b.lang);

      // If either language is not in orderLanguages, move it to the end
      if (indexA == -1) return 1;
      if (indexB == -1) return -1;

      return indexA.compareTo(indexB);
    });
    return resources;
  }

  Map _orderByLanguageInMap(Map? map, List<String> orderLanguages) {
    if (map == null) {
      return {};
    }
    if (map.entries.toList().length == 1) {
      return map;
    }
    // Create a LinkedHashMap to maintain insertion order:
    // ignore: prefer_collection_literals
    final sortedMap = LinkedHashMap();

    // Iterate through the desired language order:
    for (var language in orderLanguages) {
      for (MapEntry entry in map.entries) {
        if (entry.key.toString().contains(language)) {
          sortedMap[entry.key] = map[entry.key];
        }
      }
    }
    sortedMap.addAll(map);

    return sortedMap;
  }

  static SongDetail defaultSong() {
    return SongDetail(id: 0, title: {}, text: {});
  }
}

class SongInitial extends SongDetail {
  SongInitial({required super.id, required super.title, required super.text});
  static SongInitial defaultSong() {
    return SongInitial(id: 0, title: {}, text: {});
  }
}
