class Song {
  static const String TBL_NAME = 'song';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_URL = 'url';
  static const String COLUMN_IMAGE = 'image';
  static const String COLUMN_ARTIST = 'artist';
  static const String COLUMN_SONG = 'song';

  int id;
  String _url;
  String _image;
  String _artist;
  String _song;

  Song(this._url, this._image, this._artist, this._song, {this.id});

  bool get valid =>
      _url.isNotEmpty &&
      _image.isNotEmpty &&
      _artist.isNotEmpty &&
      _song.isNotEmpty;

  String get url => _url;

  String get image => _image;

  String get artist => _artist;

  String get song => _song;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      COLUMN_URL: _url,
      COLUMN_IMAGE: _image,
      COLUMN_ARTIST: _artist,
      COLUMN_SONG: _song
    };

    if (id != null) {
      map[COLUMN_ID] = id;
    }

    return map;
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      map[COLUMN_URL],
      map[COLUMN_IMAGE],
      map[COLUMN_ARTIST],
      map[COLUMN_SONG],
      id: map[COLUMN_ID],
    );
  }
}
