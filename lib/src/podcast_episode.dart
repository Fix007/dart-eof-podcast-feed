import 'package:meta/meta.dart';
import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';

/// Class PodcastEpisodeEnclosure
class PodcastEpisodeEnclosure {
  /// Podcast Episode Enclosure
  const PodcastEpisodeEnclosure({
    this.url,
    this.length,
    this.type,
  });

  /// Generate from XML
  factory PodcastEpisodeEnclosure.fromXml(XmlElement element) =>
      PodcastEpisodeEnclosure(
        url: element.getAttribute('url'),
        length: element.getAttribute('length'),
        type: element.getAttribute('type'),
      );

  /// Podcast Mediafile
  final String url;

  /// Podcast length
  final String length;

  /// Podcast mime type
  final String type;
}

/// Class Episode
/// Represents the Episode Entity and atributes
class PodcastEpisode {
  /// Constructor
  const PodcastEpisode({
    @required this.title,
    @required this.enclosure,
    this.guid,
    this.description,
    this.duration,
    this.pubDate,
    this.iTunesImageUrl,
    this.iTunesTitle,
    this.iTunesEpisode,
    this.iTunesSeason,
  });

  /// Constructor from XML
  factory PodcastEpisode.fromXml(XmlElement element) {
    final PodcastEpisodeEnclosure enclosure = PodcastEpisodeEnclosure.fromXml(
        element.findElements('enclosure').first);

    final String title = element.findElements('title').first.text;

    String description;
    try {
      description = element.findElements('description').first.text;
    } catch (e) {
      debugPrint('PodcastEpisode.description: $e');
    }
    try {
      description ??= element.findElements('googleplay:description').first.text;
    } catch (e) {
      debugPrint('PodcastEpisode.description: $e');
    }
    try {
      description ??= element.findElements('itunes:summary').first.text;
    } catch (e) {
      debugPrint('PodcastEpisode.description: $e');
    }

    String pubDate;
    try {
      pubDate = element.findElements('pubDate').first.text;
    } catch (e) {}

    String duration;
    try {
      duration = element.findElements('itunes:duration').first.text;
    } catch (e) {}

    String guid;
    try {
      guid = element.findElements('guid').first.text;
    } catch (e) {}

    String iTunesImageUrl;
    try {
      iTunesImageUrl =
          element.findElements('itunes:image').first.getAttribute('href');
    } catch (e) {}

    iTunesImageUrl ??= iTunesImageUrl;

    String iTunesTitle;
    try {
      iTunesTitle = element.findElements('itunes:title').first.text;
    } catch (e) {}

    String iTunesEpisode;
    try {
      iTunesEpisode = element.findElements('itunes:episode').first.text;
    } catch (e) {}

    String iTunesSeason;
    try {
      iTunesEpisode = element.findElements('itunes:season').first.text;
    } catch (e) {}

    return PodcastEpisode(
      title: title,
      enclosure: enclosure,
      guid: guid,
      description: description,
      duration: duration,
      pubDate: pubDate,
      iTunesImageUrl: iTunesImageUrl,
      iTunesTitle: iTunesTitle,
      iTunesEpisode: iTunesEpisode,
      iTunesSeason: iTunesSeason,
    );
  }

  /// Episode Title
  final String title;

  /// Episode File Url
  final PodcastEpisodeEnclosure enclosure;

  /// Episode guid
  final String guid;

  /// Episode Description
  final String description;

  /// Episode Date
  final String pubDate;

  /// Episode Duration
  final String duration;

  /// Episode cover Url
  final String iTunesImageUrl;

  /// Episode number
  final String iTunesTitle;

  /// Episode number
  final String iTunesEpisode;

  /// Episode season number
  final String iTunesSeason;

  /// Merged Episode Title
  String get episodeTitle => iTunesTitle ?? title;
}
