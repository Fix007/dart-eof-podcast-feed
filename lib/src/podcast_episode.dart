import 'package:meta/meta.dart';
import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';

import '../eof_podcast_feed.dart';

/// Class PodcastEpisodeEnclosure
class PodcastEpisodeEnclosure {
  /// Podcast Episode Enclosure
  PodcastEpisodeEnclosure({this.url, this.length, this.type});

  /// Generate from XML
  factory PodcastEpisodeEnclosure.fromXml(XmlElement element) =>
      PodcastEpisodeEnclosure(
        url: element.getAttribute('url'),
        length: element.getAttribute('length'),
        type: element.getAttribute('type'),
      );

  /// Podcast from JSON object
  factory PodcastEpisodeEnclosure.fromJson(Map<String, dynamic> json) =>
      PodcastEpisodeEnclosure(
          url: json[_url], length: json[_length], type: json[_type]);

  /// Podcast to JSON object
  Map<String, dynamic> toJson() => {_url: url, _length: length, _type: type};

  /// Podcast Mediafile
  final String url;
  static const _url = 'url';

  /// Podcast length
  final String length;
  static const _length = 'length';

  /// Podcast mime type
  final String type;
  static const _type = 'type';
}

/// Class Episode
/// Represents the Episode Entity and atributes
class PodcastEpisode {
  /// Constructor
  PodcastEpisode(
      {@required this.title,
      @required this.enclosure,
      this.parent,
      this.guid,
      this.description,
      this.duration,
      this.pubDate,
      this.iTunesImageUrl,
      this.iTunesTitle,
      this.iTunesEpisode,
      this.iTunesSeason,
      this.itunesDescription,
      this.link,
      this.iTunesEpisodeType,
      this.iTunesBlock,
      this.iTunesKeywords,
      this.lastPosition,
      this.notes});

  /// Constructor from XML
  factory PodcastEpisode.fromXml(XmlElement element, [Podcast parent]) {
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

    String notes;
    try {
      notes = element.findAllElements('content:encoded').first.text;
    } catch (e) {
      debugPrint('PodcastEpisode.notes: $e');
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

    String itunesDescription;
    try {
      itunesDescription = element.findElements('itunes:season').first.text;
    } catch (e) {}

    String link;
    try {
      link = element.findElements('link').first.text;
    } catch (e) {}

    String iTunesEpisodeType;
    try {
      iTunesEpisodeType = element.findElements('itunes:episodeType').first.text;
    } catch (e) {}

    String iTunesBlock;
    try {
      iTunesBlock = element.findElements('itunes:block').first.text;
    } catch (e) {}

    String iTunesKeywords;
    try {
      iTunesKeywords = element.findElements('itunes:keywords').first.text;
    } catch (e) {}

    return PodcastEpisode(
        parent: parent,
        title: title,
        enclosure: enclosure,
        guid: guid,
        description: description,
        notes: notes,
        duration: duration,
        pubDate: pubDate,
        iTunesImageUrl: iTunesImageUrl,
        iTunesTitle: iTunesTitle,
        iTunesEpisode: iTunesEpisode,
        iTunesSeason: iTunesSeason,
        itunesDescription: itunesDescription,
        link: link,
        iTunesEpisodeType: iTunesEpisodeType,
        iTunesBlock: iTunesBlock,
        iTunesKeywords: iTunesKeywords);
  }

  /// load PodcastEpisode from a JSON object
  factory PodcastEpisode.fromJson(Map<String, dynamic> json,
          [Podcast parent]) =>
      PodcastEpisode(
        parent: parent,
        title: json[_title],
        enclosure: PodcastEpisodeEnclosure.fromJson(json[_enclosure]),
        guid: json[_guid],
        description: json[_description],
        notes: json[_notes],
        duration: json[_duration],
        pubDate: json[_pubDate],
        iTunesImageUrl: json[_iTunesImageUrl],
        iTunesTitle: json[_iTunesTitle],
        iTunesEpisode: json[_iTunesEpisode],
        iTunesSeason: json[_iTunesSeason],
        itunesDescription: json[_itunesDescription],
        link: json[_link],
        iTunesEpisodeType: json[_iTunesEpisodeType],
        iTunesBlock: json[_iTunesBlock],
        iTunesKeywords: json[_iTunesKeywords],
        lastPosition: json[_lastPosition],
      );

  /// store PodcastEpisode in a JSON object
  Map<String, dynamic> toJson() => {
        _title: title,
        _enclosure: enclosure.toJson(),
        _guid: guid,
        _description: description,
        _notes: notes,
        _duration: duration,
        _pubDate: pubDate,
        _iTunesImageUrl: iTunesImageUrl,
        _iTunesTitle: iTunesTitle,
        _iTunesEpisode: iTunesEpisode,
        _iTunesSeason: iTunesSeason,
        _itunesDescription: itunesDescription,
        _link: link,
        _iTunesEpisodeType: iTunesEpisodeType,
        _iTunesKeywords: iTunesKeywords,
        _lastPosition: lastPosition,
      };

  /// Episode Podcast
  Podcast parent;

  /// Episode Title
  final String title;
  static const String _title = 'title';

  /// Episode File Url
  final PodcastEpisodeEnclosure enclosure;
  static const String _enclosure = 'enclosure';

  /// Episode guid
  final String guid;
  static const String _guid = 'guid';

  /// Episode Description
  final String description;
  static const String _description = 'description';

  /// Episode Itunes Description
  final String itunesDescription;
  static const String _itunesDescription = 'itunesDescription';

  /// merged [itunesDescription] and [description]
  String get episodeDescription => itunesDescription ?? description;

  /// Episode Notes
  final String notes;
  static const String _notes = 'notes';

  /// Episode Date
  final String pubDate;
  static const String _pubDate = 'pubDate';

  /// Episode Duration
  final String duration;
  static const String _duration = 'duration';

  /// Episode cover Url
  final String iTunesImageUrl;
  static const String _iTunesImageUrl = 'iTunesImageUrl';

  /// Episode Title for itunes
  final String iTunesTitle;
  static const String _iTunesTitle = 'iTunesTitle';

  /// Merged Episode Title
  String get episodeTitle => iTunesTitle ?? title;

  /// Episode number
  final String iTunesEpisode;
  static const String _iTunesEpisode = 'iTunesEpisode';

  /// Episode season number
  final String iTunesSeason;
  static const String _iTunesSeason = 'iTunesSeason';

  /// An episode link url
  final String link;
  static const String _link = 'LINK';

  /// The episode Type
  /// May be
  ///   Full (default)
  ///   Trailer
  ///   Bonus
  final String iTunesEpisodeType;
  static const String _iTunesEpisodeType = 'iTunesEpisodeType';

  /// The episode show or hide status.
  /// If 'Yes', the episode should not appear
  final String iTunesBlock;
  static const String _iTunesBlock = 'iTunesBlock';

  /// Episode keywords
  final String iTunesKeywords;
  static const String _iTunesKeywords = 'itunesKeywords';

  /// Last played position
  String lastPosition;
  static const String _lastPosition = 'lastPosition';
}
