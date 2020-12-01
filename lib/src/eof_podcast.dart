import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'eof_episode.dart';
import 'eof_playback_state.dart';

/// Class Podcast
/// Represents the Podcast Entity and atributes
///
class EOFPodcast {
  /// Constructor
  /// XmlDocument [_docXML]
  EOFPodcast(XmlDocument _docXML) {
    // Read the Podcast Author
    try {
      author = _docXML.findAllElements('itunes:author').isEmpty
          ? _docXML.findAllElements('author').first.text
          : _docXML.findAllElements('itunes:author').first.text;
    } catch (e) {}

    // Read the Podcast Title
    try {
      title = _docXML.findAllElements('title').first.text;
    } catch (e) {}

    // Read the Podcast URL
    try {
      url = _docXML.findAllElements('link').first.text;
    } catch (e) {}

    // Read the Podcast Copyright
    try {
      copyright = _docXML.findAllElements('copyright').first.text;
    } catch (e) {}

    // Read the Podcast Description
    try {
      description = _docXML.findAllElements('description').first.text;
    } catch (e) {}

    // Read the Podcast Cover URL
    try {
      podcastCoverUrl =
          _docXML.findAllElements('image').first.findElements('url').first.text;
    } catch (e) {}

    try {
      podcastCoverUrl ??=
          _docXML.findAllElements('itunes:image').first.getAttribute('href');
    } catch (e) {}

    // Read the Podcast Episodes
    episodes = _docXML.findAllElements('item').map((e) {
      String title = '';
      try {
        title = e.findElements('title').first.text;
      } catch (e) {}

      String description = '';
      try {
        description = e.findElements('description').first.text;
      } catch (e) {}

      String pubDate = '';
      try {
        pubDate = e.findElements('pubDate').first.text;
      } catch (e) {}

      String url = '';
      try {
        url = e.findElements('enclosure').isEmpty
            ? ''
            : e.findElements('enclosure').first.getAttribute('url');
      } catch (e) {}

      String cover = '';
      try {
        cover = e.findElements('itunes:image').isNotEmpty
            ? e.findElements('itunes:image').first.getAttribute('href')
            : _docXML
                .findAllElements('image')
                .first
                .findElements('url')
                .first
                .text;
      } catch (e) {}

      return EOFEpisode(
        title: title,
        description: description,
        pubDate: pubDate,
        url: url,
        cover: cover,
      );
    }).toList();
  }

  /// Episode List
  List<EOFEpisode> episodes = [];

  /// Podcast Title
  String title;

  /// Podcast Url
  String url;

  /// Podcast Cover Url
  String podcastCoverUrl;

  /// Podcast Author
  String author;

  /// Podcast Copyright
  String copyright;

  /// Podcast Description
  String description;

  /// Current Episde Playing index
  int _playingIndex = -1;

  /// Init a Podcast Class with the Feed Address [uri]
  static Future<EOFPodcast> fromFeed(String uri) async {
    try {
      final rssResponse = await http.get(uri);
      final document = parse(rssResponse.body);
      return EOFPodcast(document);
    } catch (e) {
      return null;
    }
  }

  /// Return number of Show Episodes
  int get countEpisodes => episodes.length;

  /// Return if Show has Episodes
  bool get hasEpisodes => episodes.isNotEmpty;

  /// Set currente playing episode index [i]
  void isPlaying(int i) =>
      (_playingIndex >= 0) ? _playingIndex = i : _playingIndex = -1;

  /// Return current Playerback State
  EOFPlaybackState get playbackState => (_playingIndex >= 0)
      ? nowPlaying.playbackState
      : EOFPlaybackState.stopped;

  /// Return Episode now laying
  EOFEpisode get nowPlaying =>
      (_playingIndex >= 0) ? episodes[_playingIndex] : null;
}
