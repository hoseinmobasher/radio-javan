class PlaylistItem {
  String _url;
  String _image;
  String _artist;
  String _song;

  PlaylistItem(this._url, this._image, this._artist, this._song);

  String get url => _url;

  String get image => _image;

  String get artist => _artist;

  String get song => _song;
}
