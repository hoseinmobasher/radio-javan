class Song {
  String _url;
  String _image;
  String _artist;
  String _song;

  Song(this._url, this._image, this._artist, this._song);

  bool get valid =>
      _url.isNotEmpty &&
      _image.isNotEmpty &&
      _artist.isNotEmpty &&
      _song.isNotEmpty;

  String get url => _url;

  String get image => _image;

  String get artist => _artist;

  String get song => _song;
}
