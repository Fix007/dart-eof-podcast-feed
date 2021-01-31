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
    this.lastBuildDate,
    this.pubDate,
    this.iTunesSubtitle,
    this.iTunesKeyWords,
    this.subscribed = false,
    this.notify = false,
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

    // new

    String _lastBuildDate;
    try {
      _lastBuildDate ??= element.findElements('lastBuildDate').first.text;
    } catch (e) {}

    String _pubDate;
    try {
      _pubDate ??= element.findElements('pubDate').first.text;
    } catch (e) {}

    String _iTunesSubtitle;
    try {
      _iTunesSubtitle ??= element.findElements('itunes:summary').first.text;
    } catch (e) {}

    String _iTunesKeyWords;
    try {
      _iTunesKeyWords ??= element.findElements('itunes:keywords').first.text;
    } catch (e) {}

    final Podcast p = Podcast(
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
        lastBuildDate: _lastBuildDate,
        pubDate: _pubDate,
        iTunesSubtitle: _iTunesSubtitle,
        iTunesKeyWords: _iTunesKeyWords);

    // Retrieve podcast episodes
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
    final p = Podcast(
      category: json[_category],
      description: json[_description],
      explicit: json[_explicit],
      language: json[_language],
      podcastCoverUrl: json[_podcastCoverUrl],
      title: json[_title],
      author: json[_author],
      copyright: json[_copyright],
      owner: json[_owner],
      url: json[_url],
      lastBuildDate: json[_lastBuildDate],
      pubDate: json[_pubDate],
      iTunesKeyWords: json[_iTunesKeyWords],
      iTunesSubtitle: json[_iTunesSubtitle],
      subscribed: json[_subscribed],
      notify: json[_notify],
    );
    p.episodes = [
      for (var data in json[_episodes]) PodcastEpisode.fromJson(data, p)
    ];
    return p;
  }

  /// Export to JSON.
  ///
  Map<String, dynamic> toJson() => {
        _title: title,
        _description: description,
        _podcastCoverUrl: podcastCoverUrl,
        _language: language,
        _category: category,
        _explicit: explicit,
        _episodes: episodes.map((episode) => episode.toJson()).toList(),
        _owner: owner,
        _url: url,
        _author: author,
        _copyright: copyright,
        _lastBuildDate: lastBuildDate,
        _pubDate: pubDate,
        _iTunesSubtitle: iTunesSubtitle,
        _iTunesKeyWords: iTunesKeyWords,
        _subscribed: subscribed,
        _notify: notify,
      };

  /// Episode List
  List<PodcastEpisode> episodes;
  static const String _episodes = 'episodes';

  /// Podcast Title
  final String title;
  static const String _title = 'title';

  /// Podcast Owner
  final String owner;
  static const String _owner = 'owner';

  /// Podcast Category
  final String category;
  static const String _category = 'category';

  /// Podcast Language
  final String language;
  static const String _language = 'language';

  /// Podcast Url
  final String url;
  static const String _url = 'url';

  /// Podcast Cover Url
  final String podcastCoverUrl;
  static const String _podcastCoverUrl = 'podcastCoverUrl';

  /// Podcast Author
  final String author;
  static const String _author = 'author';

  /// Podcast Copyright
  final String copyright;
  static const String _copyright = 'copyright';

  /// Podcast Description
  final String description;
  static const String _description = 'description';

  /// Podcast Explicit
  final bool explicit;
  static const String _explicit = 'explicit';

  // TODO(Fix007): add additional fields, lastBuild date, pubDate, iTunesSubtitle, iTunesKeyWords

  /// Podcast last build date
  final String lastBuildDate;
  static const String _lastBuildDate = 'lastBuildDate';

  /// Podcast PubDate
  final String pubDate;
  static const String _pubDate = 'pubDate';

  /// Podcast iTunes subtitle
  final String iTunesSubtitle;
  static const String _iTunesSubtitle = 'iTunesSubtitle';

  /// Podcast iTunesKeyWords
  final String iTunesKeyWords;
  static const String _iTunesKeyWords = 'iTunesKeyWords';

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

  ///
  bool subscribed;
  static const String _subscribed = 'subscribed';

  ///
  bool notify;
  static const String _notify = 'notify';
}
