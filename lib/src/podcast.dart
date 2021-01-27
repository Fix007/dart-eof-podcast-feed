import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

import 'podcast_episode.dart';

/**
 * See 
 * https://help.apple.com/itc/podcasts_connect/#/itcb54353390
 * https://support.google.com/podcast-publishers/answer/9889544?hl=ja
 */

/// Class Podcast
/// Represents the Podcast Entity and atributes
///
class Podcast {
  /// PodcastConstructor
  Podcast({
    @required this.title,
    @required this.description,
    @required this.podcastCoverUrl,
    @required this.language,
    @required this.category,
    @required this.explicit,
    this.episodes,
    this.owner,
    this.url,
    this.author,
    this.copyright,
  });

  /// factory [Podcast]
  factory Podcast.fromXml(XmlDocument doc) {
    final element = doc.findElements('rss').first.findElements('channel').first;
    // Read the Podcast Author
    String _author;
    try {
      _author = element.findAllElements('googleplay:author').first.text;
    } catch (e) {}

    try {
      _author ??= element.findAllElements('itunes:author').first.text;
    } catch (e) {}

    // Read the Podcast Owner
    String _owner;
    try {
      _owner ??= element.findAllElements('googleplay:owner').first.text;
    } catch (e) {}

    try {
      _owner ??= element
          .findAllElements('itunes:owner')
          .first
          .findElements('itunes:email')
          .first
          .text;
    } catch (e) {}

    // Read the Podcast category
    String _category;
    try {
      _category ??= element
          .findAllElements('googleplay:category')
          .first
          .getAttribute('text');
    } catch (e) {}
    try {
      _category ??=
          element.findAllElements('itunes:category').first.getAttribute('text');
    } catch (e) {}

    // Read the Podcast Language
    String _language;
    try {
      _language ??= element.findAllElements('language').first.text;
    } catch (e) {}

    // Read the Podcast Title
    String _title;
    try {
      _title = element.findAllElements('title').first.text;
    } catch (e) {}

    // Read the Podcast URL
    String _url;
    try {
      _url = element.findAllElements('link').first.text;
    } catch (e) {}

    // Read the Podcast Copyright
    String _copyright;
    try {
      _copyright = element.findAllElements('copyright').first.text;
    } catch (e) {}

    // Read the Podcast Copyright
    bool _explicit;
    try {
      _explicit = element.findAllElements('explicit').first.text == 'true';
    } catch (e) {
      _explicit = false;
    }

    String _description;
    // Read the Podcast Description
    try {
      _description ??= element.findAllElements('description').first.text;
    } catch (e) {}

    try {
      _description ??=
          element.findAllElements('googleplay:description').first.text;
    } catch (e) {}

    try {
      _description ??= element.findAllElements('itunes:summary').first.text;
    } catch (e) {}

    // Read the Podcast Cover URL
    String _podcastCoverUrl;
    try {
      _podcastCoverUrl ??=
          element.findElements('googleplay:image').first.getAttribute('href');
    } catch (e) {}

    try {
      _podcastCoverUrl ??=
          element.findElements('itunes:image').first.getAttribute('href');
    } catch (e) {}

    try {
      _podcastCoverUrl ??=
          element.findElements('image').first.findElements('url').first.text;
    } catch (e) {}

    Podcast p = Podcast(
      title: _title,
      description: _description,
      podcastCoverUrl: _podcastCoverUrl,
      language: _language,
      category: _category,
      explicit: _explicit,
      owner: _owner,
      url: _url,
      author: _author,
      copyright: _copyright,
    );

    // Read the Podcast Episodes
    List<PodcastEpisode> _episodes;
    _episodes = element.findAllElements('item').expand<PodcastEpisode>((e) {
      try {
        return [PodcastEpisode.fromXml(e, p)];
      } catch (e) {
        debugPrint('PodcastEpisode.fromXml: $e');
        return [];
      }
    }).toList();

    p.episodes = _episodes;

    return p;
  }

  /// Class Podcast
  /// Imports the podcast from a JSON object.
  ///
  factory Podcast.fromJson(Map<String, dynamic> json) {
    var p = Podcast(
      category: json[CATEGORY],
      description: json[DESCRIPTION],
      explicit: json[EXPLICIT],
      language: json[LANGUAGE],
      podcastCoverUrl: json[PODCASTCOVERURL],
      title: json[TITLE],
      author: json[AUTHOR],
      copyright: json[COPYRIGHT],
      owner: json[OWNER],
      url: json[URL],
    );
    p.episodes = [
      for (var data in json[EPISODES]) PodcastEpisode.fromJson(data, p)
    ];
    return p;
  }

  /// Export to JSON.
  ///
  Map<String, dynamic> toJson() => {
        TITLE: title,
        DESCRIPTION: description,
        PODCASTCOVERURL: podcastCoverUrl,
        LANGUAGE: language,
        CATEGORY: category,
        EXPLICIT: explicit,
        EPISODES: episodes.map((episode) => episode.toJson()).toList(),
        OWNER: owner,
        URL: url,
        AUTHOR: author,
        COPYRIGHT: copyright
      };

  /// Episode List
  List<PodcastEpisode> episodes;
  static const String EPISODES = 'episodes';

  /// Podcast Title
  final String title;
  static const String TITLE = 'title';

  /// Podcast Owner
  final String owner;
  static const String OWNER = 'owner';

  /// Podcast Category
  final String category;
  static const String CATEGORY = 'category';

  /// Podcast Language
  final String language;
  static const String LANGUAGE = 'language';

  /// Podcast Url
  final String url;
  static const String URL = 'url';

  /// Podcast Cover Url
  final String podcastCoverUrl;
  static const String PODCASTCOVERURL = 'podcastCoverUrl';

  /// Podcast Author
  final String author;
  static const String AUTHOR = 'author';

  /// Podcast Copyright
  final String copyright;
  static const String COPYRIGHT = 'copyright';

  /// Podcast Description
  final String description;
  static const String DESCRIPTION = 'description';

  /// Podcast Explicit
  final bool explicit;
  static const String EXPLICIT = 'explicit';

  /// Init a Podcast Class with the Feed Address [uri]
  static Future<Podcast> fromFeed(String uri) async {
    try {
      final rssResponse = await http.get(uri);
      final document = XmlDocument.parse(utf8.decode(rssResponse.bodyBytes));
      return Podcast.fromXml(document);
    } catch (e) {
      return null;
    }
  }

  /// Return number of Show Episodes
  int get countEpisodes => episodes.length;

  /// Return if Show has Episodes
  bool get hasEpisodes => episodes.isNotEmpty;
}
