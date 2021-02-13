import 'package:radio_javan/domain/song.dart';
import 'package:sqflite/sqflite.dart';

class SongProvider {
  SongProvider._();

  static final SongProvider instance = SongProvider._();

  Database database;

  open() async {
    database = await openDatabase('rj.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE ${Song.TBL_NAME} (
          ${Song.COLUMN_ID} integer primary key, 
          ${Song.COLUMN_URL} text,
          ${Song.COLUMN_SONG} text,
          ${Song.COLUMN_ARTIST} text,
          ${Song.COLUMN_IMAGE} text
        )''');
    });
  }

  Future<Song> create(Song song) async {
    song.id = await database.insert(Song.TBL_NAME, song.toMap());
    return song;
  }

  Future<Song> findById(int id) async {
    List<Map> maps = await database
        .query(Song.TBL_NAME, where: '${Song.COLUMN_ID} = ?', whereArgs: [id]);

    if (maps.length > 0) {
      return Song.fromMap(maps[0]);
    }

    return null;
  }

  Future<List<Song>> findAll() async {
    List<Song> items = List();
    (await database.query(Song.TBL_NAME)).forEach((map) {
      items.add(Song.fromMap(map));
    });

    return items;
  }

  Future<int> delete(int id) async {
    return await database
        .delete(Song.TBL_NAME, where: '${Song.COLUMN_ID} = ?', whereArgs: [id]);
  }

  Future<int> update(Song song) async {
    return await database.update(Song.TBL_NAME, song.toMap(),
        where: '${Song.COLUMN_ID} = ?', whereArgs: [song.id]);
  }

  dispose() async {
    await database.close();
  }
}
