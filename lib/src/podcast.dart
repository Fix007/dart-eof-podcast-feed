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
  const Podcast({
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

    // Read the Podcast Episodes
    List<PodcastEpisode> _episodes;
    _episodes = element.findAllElements('item').expand<PodcastEpisode>((e) {
      try {
        return [PodcastEpisode.fromXml(e)];
      } catch (e) {
        debugPrint('PodcastEpisode.fromXml: $e');
        return [];
      }
    }).toList();

    return Podcast(
      title: _title,
      description: _description,
      podcastCoverUrl: _podcastCoverUrl,
      language: _language,
      category: _category,
      explicit: _explicit,
      episodes: _episodes,
      owner: _owner,
      url: _url,
      author: _author,
      copyright: _copyright,
    );
  }

  /// Episode List
  final List<PodcastEpisode> episodes;

  /// Podcast Title
  final String title;

  /// Podcast Owner
  final String owner;

  /// Podcast Category
  final String category;

  /// Podcast Language
  final String language;

  /// Podcast Url
  final String url;

  /// Podcast Cover Url
  final String podcastCoverUrl;

  /// Podcast Author
  final String author;

  /// Podcast Copyright
  final String copyright;

  /// Podcast Description
  final String description;

  /// Podcast Explicit
  final bool explicit;

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
