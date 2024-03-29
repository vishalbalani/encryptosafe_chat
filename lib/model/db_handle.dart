import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  static Database? _database;
  static const messagesTable = 'messages';
  static final DatabaseHandler instance = DatabaseHandler._init();

  DatabaseHandler._init();

  static const privateKeyTable = 'private_key';
  static const privateKeyD = 'd';
  static const privateKeyN = 'n';
  static const uId = 'id'; // Primary key (optional if needed)

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('encryptosafe.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> addOrUpdateMessages(String chatRoomId, String message) async {
    final db = await instance.database;

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $messagesTable (
        chatRoomId TEXT PRIMARY KEY,
        messages TEXT
      )
    ''');

    final List<Map<String, dynamic>> result = await db.query(
      messagesTable,
      where: 'chatRoomId = ?',
      whereArgs: [chatRoomId],
    );

    if (result.isNotEmpty) {
      final String existingMessages = result[0]['messages'];
      final List<String> messagesList = existingMessages.split(',');

      messagesList.add(message);

      await db.update(
        messagesTable,
        {
          'messages': messagesList.join(','),
        },
        where: 'chatRoomId = ?',
        whereArgs: [chatRoomId],
      );
    } else {
      await db.insert(
        messagesTable,
        {
          'chatRoomId': chatRoomId,
          'messages': message,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<String>> getMessagesForChatRoomId(String chatRoomId) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query(
      messagesTable,
      where: 'chatRoomId = ?',
      whereArgs: [chatRoomId],
    );

    if (result.isNotEmpty) {
      final String messages = result[0]['messages'];
      final List<String> messageList = messages.split(',');
      return messageList;
    }

    return [];
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $privateKeyTable (
        $uId TEXT PRIMARY KEY,
        $privateKeyD INT,
        $privateKeyN INT
      )
    ''');
  }

  Future<void> addPrivateKey(int d, int n, String x) async {
    final db = await instance.database;

    // Check if a record already exists in the private_key table
    final existingKeys = await getPrivateKey();
    if (existingKeys != null) {
      // Update the existing record
      await db.update(
        privateKeyTable,
        {
          uId: x,
          privateKeyD: d,
          privateKeyN: n,
        },
      );
    } else {
      // Insert a new record
      await db.insert(
        privateKeyTable,
        {
          uId: x,
          privateKeyD: d,
          privateKeyN: n,
        },
      );
    }
  }

  Future<Map<String, dynamic>?> getPrivateKey() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(privateKeyTable);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}
