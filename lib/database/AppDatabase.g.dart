// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MessagesDao? _messagesDaoInstance;

  MessageEmojiDao? _messageEmojiDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Message` (`messageID` INTEGER NOT NULL, `messageDate` TEXT NOT NULL, `messageTime` TEXT NOT NULL, `senderName` TEXT NOT NULL, `messageText` TEXT NOT NULL, PRIMARY KEY (`messageID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MessageEmojis` (`emojiID` INTEGER NOT NULL, `messageID` INTEGER NOT NULL, `messageDate` TEXT NOT NULL, `messageTime` TEXT NOT NULL, `senderName` TEXT NOT NULL, `emoji` TEXT NOT NULL, PRIMARY KEY (`emojiID`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MessagesDao get messagesDao {
    return _messagesDaoInstance ??= _$MessagesDao(database, changeListener);
  }

  @override
  MessageEmojiDao get messageEmojiDao {
    return _messageEmojiDaoInstance ??=
        _$MessageEmojiDao(database, changeListener);
  }
}

class _$MessagesDao extends MessagesDao {
  _$MessagesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _messageInsertionAdapter = InsertionAdapter(
            database,
            'Message',
            (Message item) => <String, Object?>{
                  'messageID': item.messageID,
                  'messageDate': item.messageDate,
                  'messageTime': item.messageTime,
                  'senderName': item.senderName,
                  'messageText': item.messageText
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Message> _messageInsertionAdapter;

  @override
  Future<List<Message>> getAllMessages() async {
    return _queryAdapter.queryList('select * from Message',
        mapper: (Map<String, Object?> row) => Message(
            row['messageID'] as int,
            row['messageDate'] as String,
            row['messageTime'] as String,
            row['senderName'] as String,
            row['messageText'] as String));
  }

  @override
  Future<Iterable<String>?> getMessageCount() async {
    await _queryAdapter.queryNoReturn('SELECT COUNT(*) FROM Message');
  }

  @override
  Future<String?> getMessageCountFor(String senderName) async {
    await _queryAdapter.queryNoReturn(
        'select count(*) from Message where senderName = ?1',
        arguments: [senderName]);
  }

  @override
  Future<Iterable<String>?> getParticipants() async {
    await _queryAdapter
        .queryNoReturn('select distinct senderName from Message');
  }

  @override
  Future<void> clearAllMessages() async {
    await _queryAdapter.queryNoReturn('delete from Message');
  }

  @override
  Future<void> insertMessage(Message message) async {
    await _messageInsertionAdapter.insert(message, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertAllMessage(List<Message> messages) async {
    await _messageInsertionAdapter.insertList(
        messages, OnConflictStrategy.abort);
  }
}

class _$MessageEmojiDao extends MessageEmojiDao {
  _$MessageEmojiDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _messageEmojisInsertionAdapter = InsertionAdapter(
            database,
            'MessageEmojis',
            (MessageEmojis item) => <String, Object?>{
                  'emojiID': item.emojiID,
                  'messageID': item.messageID,
                  'messageDate': item.messageDate,
                  'messageTime': item.messageTime,
                  'senderName': item.senderName,
                  'emoji': item.emoji
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MessageEmojis> _messageEmojisInsertionAdapter;

  @override
  Future<void> clearAllEmojis() async {
    await _queryAdapter.queryNoReturn('delete from MessageEmojis');
  }

  @override
  Future<Map<String, Object>?> getUniqueEmojiCount() async {
    await _queryAdapter
        .queryNoReturn('SELECT COUNT(distinct emoji) FROM MessageEmojis');
  }

  @override
  Future<Map<String, Object>?> getUsagePerEmoji() async {
    await _queryAdapter.queryNoReturn(
        'SELECT emoji, COUNT(emoji) as count FROM MessageEmojis group by emoji order by count desc');
  }

  @override
  Future<Map<String, Object>?> getMessageCountFor(String senderName) async {
    await _queryAdapter.queryNoReturn(
        'select count(*) from MessageEmojis where senderName = ?1',
        arguments: [senderName]);
  }

  @override
  Future<Map<String, Object>?> getParticipants() async {
    await _queryAdapter
        .queryNoReturn('select distinct senderName from MessageEmojis');
  }

  @override
  Future<void> insertMessageEmojis(List<MessageEmojis> emojis) async {
    await _messageEmojisInsertionAdapter.insertList(
        emojis, OnConflictStrategy.abort);
  }
}
