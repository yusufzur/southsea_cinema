import 'package:path/path.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:sqflite/sqflite.dart';

class CinemaDatabase {
  CinemaDatabase._internal();

  static final CinemaDatabase instance = CinemaDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }

  Future<Database> get database async {
    final Database? cachedDatabase = _database;

    if (cachedDatabase != null) {
      return cachedDatabase;
    }

    final Database db = await _initDB('cinema_data.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String fileName) async {
    final String folder = await getDatabasesPath();
    final String filePath = join(folder, fileName);

    final Database db = await openDatabase(
      filePath,
      version: 1,
      onCreate: _createDB,
    );

    return db;
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createDB(Database db, int version) async {
    await createTables(db, version);

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1003,
      'summary': '2 x Eyes Wide Shut',
      'total': 15.00,
      'date': '22/10/2026 14:30',
    });

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1002,
      'summary': '1 x The Grand Budapest Hotel',
      'total': 7.50,
      'date': '21/10/2026 16:15',
    });

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1001,
      'summary': '3 x Eyes Wide Shut',
      'total': 22.50,
      'date': '20/10/2026 12:00',
    });
  }

  Future<int> insertBooking(Booking booking) async {
    final Database db = await database;
    final int id = await db.insert('bookings', booking.toMap());
    return id;
  }

  Future<List<Booking>> getAllBookings() async {
    final Database db = await database;

    final List<Map<String, Object?>> records = await db.query(
      'bookings',
      orderBy: 'booking_number DESC',
    );

    final List<Booking> bookings = [];

    for (final Map<String, Object?> row in records) {
      bookings.add(Booking.fromMap(row));
    }

    return bookings;
  }

  Future<int> getNextBookingNumber() async {
    final Database db = await database;

    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(booking_number) as max_num FROM bookings',
    );

    if (records.isEmpty) {
      return 1001;
    }

    final Object? maxValue = records[0]['max_num'];

    if (maxValue == null) {
      return 1001;
    }

    final int currentMax = maxValue as int;
    return currentMax + 1;
  }

  Future<void> close() async {
    final Database? cachedDatabase = _database;

    if (cachedDatabase != null) {
      await cachedDatabase.close();
      _database = null;
    }
  }
}
