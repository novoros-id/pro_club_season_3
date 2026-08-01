// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GoalkeepersTable extends Goalkeepers
    with TableInfo<$GoalkeepersTable, Goalkeeper> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalkeepersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _handMeta = const VerificationMeta('hand');
  @override
  late final GeneratedColumn<String> hand = GeneratedColumn<String>(
    'hand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCurrentMeta = const VerificationMeta(
    'isCurrent',
  );
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
    'is_current',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_current" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    firstName,
    lastName,
    hand,
    email,
    birthDate,
    isCurrent,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goalkeepers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goalkeeper> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('hand')) {
      context.handle(
        _handMeta,
        hand.isAcceptableOrUnknown(data['hand']!, _handMeta),
      );
    } else if (isInserting) {
      context.missing(_handMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('is_current')) {
      context.handle(
        _isCurrentMeta,
        isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goalkeeper map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goalkeeper(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      hand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hand'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      isCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_current'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $GoalkeepersTable createAlias(String alias) {
    return $GoalkeepersTable(attachedDatabase, alias);
  }
}

class Goalkeeper extends DataClass implements Insertable<Goalkeeper> {
  final int id;
  final String uuid;
  final String firstName;
  final String lastName;
  final String hand;
  final String? email;
  final DateTime? birthDate;
  final bool isCurrent;
  final String? photoPath;
  const Goalkeeper({
    required this.id,
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.hand,
    this.email,
    this.birthDate,
    required this.isCurrent,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['hand'] = Variable<String>(hand);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    map['is_current'] = Variable<bool>(isCurrent);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  GoalkeepersCompanion toCompanion(bool nullToAbsent) {
    return GoalkeepersCompanion(
      id: Value(id),
      uuid: Value(uuid),
      firstName: Value(firstName),
      lastName: Value(lastName),
      hand: Value(hand),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      isCurrent: Value(isCurrent),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory Goalkeeper.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goalkeeper(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      hand: serializer.fromJson<String>(json['hand']),
      email: serializer.fromJson<String?>(json['email']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'hand': serializer.toJson<String>(hand),
      'email': serializer.toJson<String?>(email),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'isCurrent': serializer.toJson<bool>(isCurrent),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  Goalkeeper copyWith({
    int? id,
    String? uuid,
    String? firstName,
    String? lastName,
    String? hand,
    Value<String?> email = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    bool? isCurrent,
    Value<String?> photoPath = const Value.absent(),
  }) => Goalkeeper(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    hand: hand ?? this.hand,
    email: email.present ? email.value : this.email,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    isCurrent: isCurrent ?? this.isCurrent,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  Goalkeeper copyWithCompanion(GoalkeepersCompanion data) {
    return Goalkeeper(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      hand: data.hand.present ? data.hand.value : this.hand,
      email: data.email.present ? data.email.value : this.email,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goalkeeper(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('hand: $hand, ')
          ..write('email: $email, ')
          ..write('birthDate: $birthDate, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    firstName,
    lastName,
    hand,
    email,
    birthDate,
    isCurrent,
    photoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goalkeeper &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.hand == this.hand &&
          other.email == this.email &&
          other.birthDate == this.birthDate &&
          other.isCurrent == this.isCurrent &&
          other.photoPath == this.photoPath);
}

class GoalkeepersCompanion extends UpdateCompanion<Goalkeeper> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> hand;
  final Value<String?> email;
  final Value<DateTime?> birthDate;
  final Value<bool> isCurrent;
  final Value<String?> photoPath;
  const GoalkeepersCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.hand = const Value.absent(),
    this.email = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  GoalkeepersCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String firstName,
    required String lastName,
    required String hand,
    this.email = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.photoPath = const Value.absent(),
  }) : uuid = Value(uuid),
       firstName = Value(firstName),
       lastName = Value(lastName),
       hand = Value(hand);
  static Insertable<Goalkeeper> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? hand,
    Expression<String>? email,
    Expression<DateTime>? birthDate,
    Expression<bool>? isCurrent,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (hand != null) 'hand': hand,
      if (email != null) 'email': email,
      if (birthDate != null) 'birth_date': birthDate,
      if (isCurrent != null) 'is_current': isCurrent,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  GoalkeepersCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? hand,
    Value<String?>? email,
    Value<DateTime?>? birthDate,
    Value<bool>? isCurrent,
    Value<String?>? photoPath,
  }) {
    return GoalkeepersCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      hand: hand ?? this.hand,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      isCurrent: isCurrent ?? this.isCurrent,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (hand.present) {
      map['hand'] = Variable<String>(hand.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalkeepersCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('hand: $hand, ')
          ..write('email: $email, ')
          ..write('birthDate: $birthDate, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $MatchesTable extends Matches with TableInfo<$MatchesTable, Matche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _goalkeeperIdMeta = const VerificationMeta(
    'goalkeeperId',
  );
  @override
  late final GeneratedColumn<int> goalkeeperId = GeneratedColumn<int>(
    'goalkeeper_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goalkeepers (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opponentMeta = const VerificationMeta(
    'opponent',
  );
  @override
  late final GeneratedColumn<String> opponent = GeneratedColumn<String>(
    'opponent',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<String> score = GeneratedColumn<String>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gameTimeMeta = const VerificationMeta(
    'gameTime',
  );
  @override
  late final GeneratedColumn<String> gameTime = GeneratedColumn<String>(
    'game_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personalTasksMeta = const VerificationMeta(
    'personalTasks',
  );
  @override
  late final GeneratedColumn<String> personalTasks = GeneratedColumn<String>(
    'personal_tasks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gameDurationMeta = const VerificationMeta(
    'gameDuration',
  );
  @override
  late final GeneratedColumn<int> gameDuration = GeneratedColumn<int>(
    'game_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _goalsConcededMeta = const VerificationMeta(
    'goalsConceded',
  );
  @override
  late final GeneratedColumn<int> goalsConceded = GeneratedColumn<int>(
    'goals_conceded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _savesMeta = const VerificationMeta('saves');
  @override
  late final GeneratedColumn<int> saves = GeneratedColumn<int>(
    'saves',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _savePercentageMeta = const VerificationMeta(
    'savePercentage',
  );
  @override
  late final GeneratedColumn<double> savePercentage = GeneratedColumn<double>(
    'save_percentage',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodRatingMeta = const VerificationMeta(
    'moodRating',
  );
  @override
  late final GeneratedColumn<int> moodRating = GeneratedColumn<int>(
    'mood_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warmupRatingMeta = const VerificationMeta(
    'warmupRating',
  );
  @override
  late final GeneratedColumn<int> warmupRating = GeneratedColumn<int>(
    'warmup_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceRatingMeta = const VerificationMeta(
    'confidenceRating',
  );
  @override
  late final GeneratedColumn<int> confidenceRating = GeneratedColumn<int>(
    'confidence_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _greatSavesRatingMeta = const VerificationMeta(
    'greatSavesRating',
  );
  @override
  late final GeneratedColumn<int> greatSavesRating = GeneratedColumn<int>(
    'great_saves_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commentsMeta = const VerificationMeta(
    'comments',
  );
  @override
  late final GeneratedColumn<String> comments = GeneratedColumn<String>(
    'comments',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    goalkeeperId,
    date,
    opponent,
    score,
    gameTime,
    personalTasks,
    gameDuration,
    goalsConceded,
    saves,
    savePercentage,
    moodRating,
    warmupRating,
    confidenceRating,
    greatSavesRating,
    comments,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'matches';
  @override
  VerificationContext validateIntegrity(
    Insertable<Matche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('goalkeeper_id')) {
      context.handle(
        _goalkeeperIdMeta,
        goalkeeperId.isAcceptableOrUnknown(
          data['goalkeeper_id']!,
          _goalkeeperIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goalkeeperIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('opponent')) {
      context.handle(
        _opponentMeta,
        opponent.isAcceptableOrUnknown(data['opponent']!, _opponentMeta),
      );
    } else if (isInserting) {
      context.missing(_opponentMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('game_time')) {
      context.handle(
        _gameTimeMeta,
        gameTime.isAcceptableOrUnknown(data['game_time']!, _gameTimeMeta),
      );
    }
    if (data.containsKey('personal_tasks')) {
      context.handle(
        _personalTasksMeta,
        personalTasks.isAcceptableOrUnknown(
          data['personal_tasks']!,
          _personalTasksMeta,
        ),
      );
    }
    if (data.containsKey('game_duration')) {
      context.handle(
        _gameDurationMeta,
        gameDuration.isAcceptableOrUnknown(
          data['game_duration']!,
          _gameDurationMeta,
        ),
      );
    }
    if (data.containsKey('goals_conceded')) {
      context.handle(
        _goalsConcededMeta,
        goalsConceded.isAcceptableOrUnknown(
          data['goals_conceded']!,
          _goalsConcededMeta,
        ),
      );
    }
    if (data.containsKey('saves')) {
      context.handle(
        _savesMeta,
        saves.isAcceptableOrUnknown(data['saves']!, _savesMeta),
      );
    }
    if (data.containsKey('save_percentage')) {
      context.handle(
        _savePercentageMeta,
        savePercentage.isAcceptableOrUnknown(
          data['save_percentage']!,
          _savePercentageMeta,
        ),
      );
    }
    if (data.containsKey('mood_rating')) {
      context.handle(
        _moodRatingMeta,
        moodRating.isAcceptableOrUnknown(data['mood_rating']!, _moodRatingMeta),
      );
    }
    if (data.containsKey('warmup_rating')) {
      context.handle(
        _warmupRatingMeta,
        warmupRating.isAcceptableOrUnknown(
          data['warmup_rating']!,
          _warmupRatingMeta,
        ),
      );
    }
    if (data.containsKey('confidence_rating')) {
      context.handle(
        _confidenceRatingMeta,
        confidenceRating.isAcceptableOrUnknown(
          data['confidence_rating']!,
          _confidenceRatingMeta,
        ),
      );
    }
    if (data.containsKey('great_saves_rating')) {
      context.handle(
        _greatSavesRatingMeta,
        greatSavesRating.isAcceptableOrUnknown(
          data['great_saves_rating']!,
          _greatSavesRatingMeta,
        ),
      );
    }
    if (data.containsKey('comments')) {
      context.handle(
        _commentsMeta,
        comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Matche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Matche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      goalkeeperId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goalkeeper_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      opponent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opponent'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}score'],
      ),
      gameTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_time'],
      ),
      personalTasks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_tasks'],
      ),
      gameDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_duration'],
      )!,
      goalsConceded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goals_conceded'],
      )!,
      saves: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saves'],
      )!,
      savePercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}save_percentage'],
      ),
      moodRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_rating'],
      ),
      warmupRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warmup_rating'],
      ),
      confidenceRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confidence_rating'],
      ),
      greatSavesRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}great_saves_rating'],
      ),
      comments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comments'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MatchesTable createAlias(String alias) {
    return $MatchesTable(attachedDatabase, alias);
  }
}

class Matche extends DataClass implements Insertable<Matche> {
  final int id;
  final String uuid;
  final int goalkeeperId;
  final DateTime date;
  final String opponent;
  final String? score;
  final String? gameTime;
  final String? personalTasks;
  final int gameDuration;
  final int goalsConceded;
  final int saves;
  final double? savePercentage;
  final int? moodRating;
  final int? warmupRating;
  final int? confidenceRating;
  final int? greatSavesRating;
  final String? comments;
  final DateTime createdAt;
  const Matche({
    required this.id,
    required this.uuid,
    required this.goalkeeperId,
    required this.date,
    required this.opponent,
    this.score,
    this.gameTime,
    this.personalTasks,
    required this.gameDuration,
    required this.goalsConceded,
    required this.saves,
    this.savePercentage,
    this.moodRating,
    this.warmupRating,
    this.confidenceRating,
    this.greatSavesRating,
    this.comments,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['goalkeeper_id'] = Variable<int>(goalkeeperId);
    map['date'] = Variable<DateTime>(date);
    map['opponent'] = Variable<String>(opponent);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<String>(score);
    }
    if (!nullToAbsent || gameTime != null) {
      map['game_time'] = Variable<String>(gameTime);
    }
    if (!nullToAbsent || personalTasks != null) {
      map['personal_tasks'] = Variable<String>(personalTasks);
    }
    map['game_duration'] = Variable<int>(gameDuration);
    map['goals_conceded'] = Variable<int>(goalsConceded);
    map['saves'] = Variable<int>(saves);
    if (!nullToAbsent || savePercentage != null) {
      map['save_percentage'] = Variable<double>(savePercentage);
    }
    if (!nullToAbsent || moodRating != null) {
      map['mood_rating'] = Variable<int>(moodRating);
    }
    if (!nullToAbsent || warmupRating != null) {
      map['warmup_rating'] = Variable<int>(warmupRating);
    }
    if (!nullToAbsent || confidenceRating != null) {
      map['confidence_rating'] = Variable<int>(confidenceRating);
    }
    if (!nullToAbsent || greatSavesRating != null) {
      map['great_saves_rating'] = Variable<int>(greatSavesRating);
    }
    if (!nullToAbsent || comments != null) {
      map['comments'] = Variable<String>(comments);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MatchesCompanion toCompanion(bool nullToAbsent) {
    return MatchesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      goalkeeperId: Value(goalkeeperId),
      date: Value(date),
      opponent: Value(opponent),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      gameTime: gameTime == null && nullToAbsent
          ? const Value.absent()
          : Value(gameTime),
      personalTasks: personalTasks == null && nullToAbsent
          ? const Value.absent()
          : Value(personalTasks),
      gameDuration: Value(gameDuration),
      goalsConceded: Value(goalsConceded),
      saves: Value(saves),
      savePercentage: savePercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(savePercentage),
      moodRating: moodRating == null && nullToAbsent
          ? const Value.absent()
          : Value(moodRating),
      warmupRating: warmupRating == null && nullToAbsent
          ? const Value.absent()
          : Value(warmupRating),
      confidenceRating: confidenceRating == null && nullToAbsent
          ? const Value.absent()
          : Value(confidenceRating),
      greatSavesRating: greatSavesRating == null && nullToAbsent
          ? const Value.absent()
          : Value(greatSavesRating),
      comments: comments == null && nullToAbsent
          ? const Value.absent()
          : Value(comments),
      createdAt: Value(createdAt),
    );
  }

  factory Matche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Matche(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      goalkeeperId: serializer.fromJson<int>(json['goalkeeperId']),
      date: serializer.fromJson<DateTime>(json['date']),
      opponent: serializer.fromJson<String>(json['opponent']),
      score: serializer.fromJson<String?>(json['score']),
      gameTime: serializer.fromJson<String?>(json['gameTime']),
      personalTasks: serializer.fromJson<String?>(json['personalTasks']),
      gameDuration: serializer.fromJson<int>(json['gameDuration']),
      goalsConceded: serializer.fromJson<int>(json['goalsConceded']),
      saves: serializer.fromJson<int>(json['saves']),
      savePercentage: serializer.fromJson<double?>(json['savePercentage']),
      moodRating: serializer.fromJson<int?>(json['moodRating']),
      warmupRating: serializer.fromJson<int?>(json['warmupRating']),
      confidenceRating: serializer.fromJson<int?>(json['confidenceRating']),
      greatSavesRating: serializer.fromJson<int?>(json['greatSavesRating']),
      comments: serializer.fromJson<String?>(json['comments']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'goalkeeperId': serializer.toJson<int>(goalkeeperId),
      'date': serializer.toJson<DateTime>(date),
      'opponent': serializer.toJson<String>(opponent),
      'score': serializer.toJson<String?>(score),
      'gameTime': serializer.toJson<String?>(gameTime),
      'personalTasks': serializer.toJson<String?>(personalTasks),
      'gameDuration': serializer.toJson<int>(gameDuration),
      'goalsConceded': serializer.toJson<int>(goalsConceded),
      'saves': serializer.toJson<int>(saves),
      'savePercentage': serializer.toJson<double?>(savePercentage),
      'moodRating': serializer.toJson<int?>(moodRating),
      'warmupRating': serializer.toJson<int?>(warmupRating),
      'confidenceRating': serializer.toJson<int?>(confidenceRating),
      'greatSavesRating': serializer.toJson<int?>(greatSavesRating),
      'comments': serializer.toJson<String?>(comments),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Matche copyWith({
    int? id,
    String? uuid,
    int? goalkeeperId,
    DateTime? date,
    String? opponent,
    Value<String?> score = const Value.absent(),
    Value<String?> gameTime = const Value.absent(),
    Value<String?> personalTasks = const Value.absent(),
    int? gameDuration,
    int? goalsConceded,
    int? saves,
    Value<double?> savePercentage = const Value.absent(),
    Value<int?> moodRating = const Value.absent(),
    Value<int?> warmupRating = const Value.absent(),
    Value<int?> confidenceRating = const Value.absent(),
    Value<int?> greatSavesRating = const Value.absent(),
    Value<String?> comments = const Value.absent(),
    DateTime? createdAt,
  }) => Matche(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    goalkeeperId: goalkeeperId ?? this.goalkeeperId,
    date: date ?? this.date,
    opponent: opponent ?? this.opponent,
    score: score.present ? score.value : this.score,
    gameTime: gameTime.present ? gameTime.value : this.gameTime,
    personalTasks: personalTasks.present
        ? personalTasks.value
        : this.personalTasks,
    gameDuration: gameDuration ?? this.gameDuration,
    goalsConceded: goalsConceded ?? this.goalsConceded,
    saves: saves ?? this.saves,
    savePercentage: savePercentage.present
        ? savePercentage.value
        : this.savePercentage,
    moodRating: moodRating.present ? moodRating.value : this.moodRating,
    warmupRating: warmupRating.present ? warmupRating.value : this.warmupRating,
    confidenceRating: confidenceRating.present
        ? confidenceRating.value
        : this.confidenceRating,
    greatSavesRating: greatSavesRating.present
        ? greatSavesRating.value
        : this.greatSavesRating,
    comments: comments.present ? comments.value : this.comments,
    createdAt: createdAt ?? this.createdAt,
  );
  Matche copyWithCompanion(MatchesCompanion data) {
    return Matche(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      goalkeeperId: data.goalkeeperId.present
          ? data.goalkeeperId.value
          : this.goalkeeperId,
      date: data.date.present ? data.date.value : this.date,
      opponent: data.opponent.present ? data.opponent.value : this.opponent,
      score: data.score.present ? data.score.value : this.score,
      gameTime: data.gameTime.present ? data.gameTime.value : this.gameTime,
      personalTasks: data.personalTasks.present
          ? data.personalTasks.value
          : this.personalTasks,
      gameDuration: data.gameDuration.present
          ? data.gameDuration.value
          : this.gameDuration,
      goalsConceded: data.goalsConceded.present
          ? data.goalsConceded.value
          : this.goalsConceded,
      saves: data.saves.present ? data.saves.value : this.saves,
      savePercentage: data.savePercentage.present
          ? data.savePercentage.value
          : this.savePercentage,
      moodRating: data.moodRating.present
          ? data.moodRating.value
          : this.moodRating,
      warmupRating: data.warmupRating.present
          ? data.warmupRating.value
          : this.warmupRating,
      confidenceRating: data.confidenceRating.present
          ? data.confidenceRating.value
          : this.confidenceRating,
      greatSavesRating: data.greatSavesRating.present
          ? data.greatSavesRating.value
          : this.greatSavesRating,
      comments: data.comments.present ? data.comments.value : this.comments,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Matche(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('goalkeeperId: $goalkeeperId, ')
          ..write('date: $date, ')
          ..write('opponent: $opponent, ')
          ..write('score: $score, ')
          ..write('gameTime: $gameTime, ')
          ..write('personalTasks: $personalTasks, ')
          ..write('gameDuration: $gameDuration, ')
          ..write('goalsConceded: $goalsConceded, ')
          ..write('saves: $saves, ')
          ..write('savePercentage: $savePercentage, ')
          ..write('moodRating: $moodRating, ')
          ..write('warmupRating: $warmupRating, ')
          ..write('confidenceRating: $confidenceRating, ')
          ..write('greatSavesRating: $greatSavesRating, ')
          ..write('comments: $comments, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    goalkeeperId,
    date,
    opponent,
    score,
    gameTime,
    personalTasks,
    gameDuration,
    goalsConceded,
    saves,
    savePercentage,
    moodRating,
    warmupRating,
    confidenceRating,
    greatSavesRating,
    comments,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Matche &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.goalkeeperId == this.goalkeeperId &&
          other.date == this.date &&
          other.opponent == this.opponent &&
          other.score == this.score &&
          other.gameTime == this.gameTime &&
          other.personalTasks == this.personalTasks &&
          other.gameDuration == this.gameDuration &&
          other.goalsConceded == this.goalsConceded &&
          other.saves == this.saves &&
          other.savePercentage == this.savePercentage &&
          other.moodRating == this.moodRating &&
          other.warmupRating == this.warmupRating &&
          other.confidenceRating == this.confidenceRating &&
          other.greatSavesRating == this.greatSavesRating &&
          other.comments == this.comments &&
          other.createdAt == this.createdAt);
}

class MatchesCompanion extends UpdateCompanion<Matche> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> goalkeeperId;
  final Value<DateTime> date;
  final Value<String> opponent;
  final Value<String?> score;
  final Value<String?> gameTime;
  final Value<String?> personalTasks;
  final Value<int> gameDuration;
  final Value<int> goalsConceded;
  final Value<int> saves;
  final Value<double?> savePercentage;
  final Value<int?> moodRating;
  final Value<int?> warmupRating;
  final Value<int?> confidenceRating;
  final Value<int?> greatSavesRating;
  final Value<String?> comments;
  final Value<DateTime> createdAt;
  const MatchesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.goalkeeperId = const Value.absent(),
    this.date = const Value.absent(),
    this.opponent = const Value.absent(),
    this.score = const Value.absent(),
    this.gameTime = const Value.absent(),
    this.personalTasks = const Value.absent(),
    this.gameDuration = const Value.absent(),
    this.goalsConceded = const Value.absent(),
    this.saves = const Value.absent(),
    this.savePercentage = const Value.absent(),
    this.moodRating = const Value.absent(),
    this.warmupRating = const Value.absent(),
    this.confidenceRating = const Value.absent(),
    this.greatSavesRating = const Value.absent(),
    this.comments = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MatchesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int goalkeeperId,
    required DateTime date,
    required String opponent,
    this.score = const Value.absent(),
    this.gameTime = const Value.absent(),
    this.personalTasks = const Value.absent(),
    this.gameDuration = const Value.absent(),
    this.goalsConceded = const Value.absent(),
    this.saves = const Value.absent(),
    this.savePercentage = const Value.absent(),
    this.moodRating = const Value.absent(),
    this.warmupRating = const Value.absent(),
    this.confidenceRating = const Value.absent(),
    this.greatSavesRating = const Value.absent(),
    this.comments = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : uuid = Value(uuid),
       goalkeeperId = Value(goalkeeperId),
       date = Value(date),
       opponent = Value(opponent);
  static Insertable<Matche> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? goalkeeperId,
    Expression<DateTime>? date,
    Expression<String>? opponent,
    Expression<String>? score,
    Expression<String>? gameTime,
    Expression<String>? personalTasks,
    Expression<int>? gameDuration,
    Expression<int>? goalsConceded,
    Expression<int>? saves,
    Expression<double>? savePercentage,
    Expression<int>? moodRating,
    Expression<int>? warmupRating,
    Expression<int>? confidenceRating,
    Expression<int>? greatSavesRating,
    Expression<String>? comments,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (goalkeeperId != null) 'goalkeeper_id': goalkeeperId,
      if (date != null) 'date': date,
      if (opponent != null) 'opponent': opponent,
      if (score != null) 'score': score,
      if (gameTime != null) 'game_time': gameTime,
      if (personalTasks != null) 'personal_tasks': personalTasks,
      if (gameDuration != null) 'game_duration': gameDuration,
      if (goalsConceded != null) 'goals_conceded': goalsConceded,
      if (saves != null) 'saves': saves,
      if (savePercentage != null) 'save_percentage': savePercentage,
      if (moodRating != null) 'mood_rating': moodRating,
      if (warmupRating != null) 'warmup_rating': warmupRating,
      if (confidenceRating != null) 'confidence_rating': confidenceRating,
      if (greatSavesRating != null) 'great_saves_rating': greatSavesRating,
      if (comments != null) 'comments': comments,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MatchesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? goalkeeperId,
    Value<DateTime>? date,
    Value<String>? opponent,
    Value<String?>? score,
    Value<String?>? gameTime,
    Value<String?>? personalTasks,
    Value<int>? gameDuration,
    Value<int>? goalsConceded,
    Value<int>? saves,
    Value<double?>? savePercentage,
    Value<int?>? moodRating,
    Value<int?>? warmupRating,
    Value<int?>? confidenceRating,
    Value<int?>? greatSavesRating,
    Value<String?>? comments,
    Value<DateTime>? createdAt,
  }) {
    return MatchesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      goalkeeperId: goalkeeperId ?? this.goalkeeperId,
      date: date ?? this.date,
      opponent: opponent ?? this.opponent,
      score: score ?? this.score,
      gameTime: gameTime ?? this.gameTime,
      personalTasks: personalTasks ?? this.personalTasks,
      gameDuration: gameDuration ?? this.gameDuration,
      goalsConceded: goalsConceded ?? this.goalsConceded,
      saves: saves ?? this.saves,
      savePercentage: savePercentage ?? this.savePercentage,
      moodRating: moodRating ?? this.moodRating,
      warmupRating: warmupRating ?? this.warmupRating,
      confidenceRating: confidenceRating ?? this.confidenceRating,
      greatSavesRating: greatSavesRating ?? this.greatSavesRating,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (goalkeeperId.present) {
      map['goalkeeper_id'] = Variable<int>(goalkeeperId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (opponent.present) {
      map['opponent'] = Variable<String>(opponent.value);
    }
    if (score.present) {
      map['score'] = Variable<String>(score.value);
    }
    if (gameTime.present) {
      map['game_time'] = Variable<String>(gameTime.value);
    }
    if (personalTasks.present) {
      map['personal_tasks'] = Variable<String>(personalTasks.value);
    }
    if (gameDuration.present) {
      map['game_duration'] = Variable<int>(gameDuration.value);
    }
    if (goalsConceded.present) {
      map['goals_conceded'] = Variable<int>(goalsConceded.value);
    }
    if (saves.present) {
      map['saves'] = Variable<int>(saves.value);
    }
    if (savePercentage.present) {
      map['save_percentage'] = Variable<double>(savePercentage.value);
    }
    if (moodRating.present) {
      map['mood_rating'] = Variable<int>(moodRating.value);
    }
    if (warmupRating.present) {
      map['warmup_rating'] = Variable<int>(warmupRating.value);
    }
    if (confidenceRating.present) {
      map['confidence_rating'] = Variable<int>(confidenceRating.value);
    }
    if (greatSavesRating.present) {
      map['great_saves_rating'] = Variable<int>(greatSavesRating.value);
    }
    if (comments.present) {
      map['comments'] = Variable<String>(comments.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('goalkeeperId: $goalkeeperId, ')
          ..write('date: $date, ')
          ..write('opponent: $opponent, ')
          ..write('score: $score, ')
          ..write('gameTime: $gameTime, ')
          ..write('personalTasks: $personalTasks, ')
          ..write('gameDuration: $gameDuration, ')
          ..write('goalsConceded: $goalsConceded, ')
          ..write('saves: $saves, ')
          ..write('savePercentage: $savePercentage, ')
          ..write('moodRating: $moodRating, ')
          ..write('warmupRating: $warmupRating, ')
          ..write('confidenceRating: $confidenceRating, ')
          ..write('greatSavesRating: $greatSavesRating, ')
          ..write('comments: $comments, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _matchIdMeta = const VerificationMeta(
    'matchId',
  );
  @override
  late final GeneratedColumn<int> matchId = GeneratedColumn<int>(
    'match_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES matches (id)',
    ),
  );
  static const VerificationMeta _goalTypeIdMeta = const VerificationMeta(
    'goalTypeId',
  );
  @override
  late final GeneratedColumn<int> goalTypeId = GeneratedColumn<int>(
    'goal_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toZoneXMeta = const VerificationMeta(
    'toZoneX',
  );
  @override
  late final GeneratedColumn<double> toZoneX = GeneratedColumn<double>(
    'to_zone_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toZoneYMeta = const VerificationMeta(
    'toZoneY',
  );
  @override
  late final GeneratedColumn<double> toZoneY = GeneratedColumn<double>(
    'to_zone_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromZoneXMeta = const VerificationMeta(
    'fromZoneX',
  );
  @override
  late final GeneratedColumn<double> fromZoneX = GeneratedColumn<double>(
    'from_zone_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromZoneYMeta = const VerificationMeta(
    'fromZoneY',
  );
  @override
  late final GeneratedColumn<double> fromZoneY = GeneratedColumn<double>(
    'from_zone_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  @override
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
    'zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromZoneMeta = const VerificationMeta(
    'fromZone',
  );
  @override
  late final GeneratedColumn<String> fromZone = GeneratedColumn<String>(
    'from_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    matchId,
    goalTypeId,
    toZoneX,
    toZoneY,
    fromZoneX,
    fromZoneY,
    zone,
    fromZone,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('match_id')) {
      context.handle(
        _matchIdMeta,
        matchId.isAcceptableOrUnknown(data['match_id']!, _matchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_matchIdMeta);
    }
    if (data.containsKey('goal_type_id')) {
      context.handle(
        _goalTypeIdMeta,
        goalTypeId.isAcceptableOrUnknown(
          data['goal_type_id']!,
          _goalTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goalTypeIdMeta);
    }
    if (data.containsKey('to_zone_x')) {
      context.handle(
        _toZoneXMeta,
        toZoneX.isAcceptableOrUnknown(data['to_zone_x']!, _toZoneXMeta),
      );
    }
    if (data.containsKey('to_zone_y')) {
      context.handle(
        _toZoneYMeta,
        toZoneY.isAcceptableOrUnknown(data['to_zone_y']!, _toZoneYMeta),
      );
    }
    if (data.containsKey('from_zone_x')) {
      context.handle(
        _fromZoneXMeta,
        fromZoneX.isAcceptableOrUnknown(data['from_zone_x']!, _fromZoneXMeta),
      );
    }
    if (data.containsKey('from_zone_y')) {
      context.handle(
        _fromZoneYMeta,
        fromZoneY.isAcceptableOrUnknown(data['from_zone_y']!, _fromZoneYMeta),
      );
    }
    if (data.containsKey('zone')) {
      context.handle(
        _zoneMeta,
        zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta),
      );
    }
    if (data.containsKey('from_zone')) {
      context.handle(
        _fromZoneMeta,
        fromZone.isAcceptableOrUnknown(data['from_zone']!, _fromZoneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      matchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}match_id'],
      )!,
      goalTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_type_id'],
      )!,
      toZoneX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}to_zone_x'],
      ),
      toZoneY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}to_zone_y'],
      ),
      fromZoneX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}from_zone_x'],
      ),
      fromZoneY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}from_zone_y'],
      ),
      zone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone'],
      ),
      fromZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_zone'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final int id;
  final int matchId;
  final int goalTypeId;
  final double? toZoneX;
  final double? toZoneY;
  final double? fromZoneX;
  final double? fromZoneY;
  final String? zone;
  final String? fromZone;
  final DateTime createdAt;
  const Goal({
    required this.id,
    required this.matchId,
    required this.goalTypeId,
    this.toZoneX,
    this.toZoneY,
    this.fromZoneX,
    this.fromZoneY,
    this.zone,
    this.fromZone,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['match_id'] = Variable<int>(matchId);
    map['goal_type_id'] = Variable<int>(goalTypeId);
    if (!nullToAbsent || toZoneX != null) {
      map['to_zone_x'] = Variable<double>(toZoneX);
    }
    if (!nullToAbsent || toZoneY != null) {
      map['to_zone_y'] = Variable<double>(toZoneY);
    }
    if (!nullToAbsent || fromZoneX != null) {
      map['from_zone_x'] = Variable<double>(fromZoneX);
    }
    if (!nullToAbsent || fromZoneY != null) {
      map['from_zone_y'] = Variable<double>(fromZoneY);
    }
    if (!nullToAbsent || zone != null) {
      map['zone'] = Variable<String>(zone);
    }
    if (!nullToAbsent || fromZone != null) {
      map['from_zone'] = Variable<String>(fromZone);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      matchId: Value(matchId),
      goalTypeId: Value(goalTypeId),
      toZoneX: toZoneX == null && nullToAbsent
          ? const Value.absent()
          : Value(toZoneX),
      toZoneY: toZoneY == null && nullToAbsent
          ? const Value.absent()
          : Value(toZoneY),
      fromZoneX: fromZoneX == null && nullToAbsent
          ? const Value.absent()
          : Value(fromZoneX),
      fromZoneY: fromZoneY == null && nullToAbsent
          ? const Value.absent()
          : Value(fromZoneY),
      zone: zone == null && nullToAbsent ? const Value.absent() : Value(zone),
      fromZone: fromZone == null && nullToAbsent
          ? const Value.absent()
          : Value(fromZone),
      createdAt: Value(createdAt),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<int>(json['id']),
      matchId: serializer.fromJson<int>(json['matchId']),
      goalTypeId: serializer.fromJson<int>(json['goalTypeId']),
      toZoneX: serializer.fromJson<double?>(json['toZoneX']),
      toZoneY: serializer.fromJson<double?>(json['toZoneY']),
      fromZoneX: serializer.fromJson<double?>(json['fromZoneX']),
      fromZoneY: serializer.fromJson<double?>(json['fromZoneY']),
      zone: serializer.fromJson<String?>(json['zone']),
      fromZone: serializer.fromJson<String?>(json['fromZone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'matchId': serializer.toJson<int>(matchId),
      'goalTypeId': serializer.toJson<int>(goalTypeId),
      'toZoneX': serializer.toJson<double?>(toZoneX),
      'toZoneY': serializer.toJson<double?>(toZoneY),
      'fromZoneX': serializer.toJson<double?>(fromZoneX),
      'fromZoneY': serializer.toJson<double?>(fromZoneY),
      'zone': serializer.toJson<String?>(zone),
      'fromZone': serializer.toJson<String?>(fromZone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Goal copyWith({
    int? id,
    int? matchId,
    int? goalTypeId,
    Value<double?> toZoneX = const Value.absent(),
    Value<double?> toZoneY = const Value.absent(),
    Value<double?> fromZoneX = const Value.absent(),
    Value<double?> fromZoneY = const Value.absent(),
    Value<String?> zone = const Value.absent(),
    Value<String?> fromZone = const Value.absent(),
    DateTime? createdAt,
  }) => Goal(
    id: id ?? this.id,
    matchId: matchId ?? this.matchId,
    goalTypeId: goalTypeId ?? this.goalTypeId,
    toZoneX: toZoneX.present ? toZoneX.value : this.toZoneX,
    toZoneY: toZoneY.present ? toZoneY.value : this.toZoneY,
    fromZoneX: fromZoneX.present ? fromZoneX.value : this.fromZoneX,
    fromZoneY: fromZoneY.present ? fromZoneY.value : this.fromZoneY,
    zone: zone.present ? zone.value : this.zone,
    fromZone: fromZone.present ? fromZone.value : this.fromZone,
    createdAt: createdAt ?? this.createdAt,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      matchId: data.matchId.present ? data.matchId.value : this.matchId,
      goalTypeId: data.goalTypeId.present
          ? data.goalTypeId.value
          : this.goalTypeId,
      toZoneX: data.toZoneX.present ? data.toZoneX.value : this.toZoneX,
      toZoneY: data.toZoneY.present ? data.toZoneY.value : this.toZoneY,
      fromZoneX: data.fromZoneX.present ? data.fromZoneX.value : this.fromZoneX,
      fromZoneY: data.fromZoneY.present ? data.fromZoneY.value : this.fromZoneY,
      zone: data.zone.present ? data.zone.value : this.zone,
      fromZone: data.fromZone.present ? data.fromZone.value : this.fromZone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('matchId: $matchId, ')
          ..write('goalTypeId: $goalTypeId, ')
          ..write('toZoneX: $toZoneX, ')
          ..write('toZoneY: $toZoneY, ')
          ..write('fromZoneX: $fromZoneX, ')
          ..write('fromZoneY: $fromZoneY, ')
          ..write('zone: $zone, ')
          ..write('fromZone: $fromZone, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    matchId,
    goalTypeId,
    toZoneX,
    toZoneY,
    fromZoneX,
    fromZoneY,
    zone,
    fromZone,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.matchId == this.matchId &&
          other.goalTypeId == this.goalTypeId &&
          other.toZoneX == this.toZoneX &&
          other.toZoneY == this.toZoneY &&
          other.fromZoneX == this.fromZoneX &&
          other.fromZoneY == this.fromZoneY &&
          other.zone == this.zone &&
          other.fromZone == this.fromZone &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<int> id;
  final Value<int> matchId;
  final Value<int> goalTypeId;
  final Value<double?> toZoneX;
  final Value<double?> toZoneY;
  final Value<double?> fromZoneX;
  final Value<double?> fromZoneY;
  final Value<String?> zone;
  final Value<String?> fromZone;
  final Value<DateTime> createdAt;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.matchId = const Value.absent(),
    this.goalTypeId = const Value.absent(),
    this.toZoneX = const Value.absent(),
    this.toZoneY = const Value.absent(),
    this.fromZoneX = const Value.absent(),
    this.fromZoneY = const Value.absent(),
    this.zone = const Value.absent(),
    this.fromZone = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required int matchId,
    required int goalTypeId,
    this.toZoneX = const Value.absent(),
    this.toZoneY = const Value.absent(),
    this.fromZoneX = const Value.absent(),
    this.fromZoneY = const Value.absent(),
    this.zone = const Value.absent(),
    this.fromZone = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : matchId = Value(matchId),
       goalTypeId = Value(goalTypeId);
  static Insertable<Goal> custom({
    Expression<int>? id,
    Expression<int>? matchId,
    Expression<int>? goalTypeId,
    Expression<double>? toZoneX,
    Expression<double>? toZoneY,
    Expression<double>? fromZoneX,
    Expression<double>? fromZoneY,
    Expression<String>? zone,
    Expression<String>? fromZone,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (matchId != null) 'match_id': matchId,
      if (goalTypeId != null) 'goal_type_id': goalTypeId,
      if (toZoneX != null) 'to_zone_x': toZoneX,
      if (toZoneY != null) 'to_zone_y': toZoneY,
      if (fromZoneX != null) 'from_zone_x': fromZoneX,
      if (fromZoneY != null) 'from_zone_y': fromZoneY,
      if (zone != null) 'zone': zone,
      if (fromZone != null) 'from_zone': fromZone,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GoalsCompanion copyWith({
    Value<int>? id,
    Value<int>? matchId,
    Value<int>? goalTypeId,
    Value<double?>? toZoneX,
    Value<double?>? toZoneY,
    Value<double?>? fromZoneX,
    Value<double?>? fromZoneY,
    Value<String?>? zone,
    Value<String?>? fromZone,
    Value<DateTime>? createdAt,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      goalTypeId: goalTypeId ?? this.goalTypeId,
      toZoneX: toZoneX ?? this.toZoneX,
      toZoneY: toZoneY ?? this.toZoneY,
      fromZoneX: fromZoneX ?? this.fromZoneX,
      fromZoneY: fromZoneY ?? this.fromZoneY,
      zone: zone ?? this.zone,
      fromZone: fromZone ?? this.fromZone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (matchId.present) {
      map['match_id'] = Variable<int>(matchId.value);
    }
    if (goalTypeId.present) {
      map['goal_type_id'] = Variable<int>(goalTypeId.value);
    }
    if (toZoneX.present) {
      map['to_zone_x'] = Variable<double>(toZoneX.value);
    }
    if (toZoneY.present) {
      map['to_zone_y'] = Variable<double>(toZoneY.value);
    }
    if (fromZoneX.present) {
      map['from_zone_x'] = Variable<double>(fromZoneX.value);
    }
    if (fromZoneY.present) {
      map['from_zone_y'] = Variable<double>(fromZoneY.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (fromZone.present) {
      map['from_zone'] = Variable<String>(fromZone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('matchId: $matchId, ')
          ..write('goalTypeId: $goalTypeId, ')
          ..write('toZoneX: $toZoneX, ')
          ..write('toZoneY: $toZoneY, ')
          ..write('fromZoneX: $fromZoneX, ')
          ..write('fromZoneY: $fromZoneY, ')
          ..write('zone: $zone, ')
          ..write('fromZone: $fromZone, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DailyTasksTable extends DailyTasks
    with TableInfo<$DailyTasksTable, DailyTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _goalkeeperIdMeta = const VerificationMeta(
    'goalkeeperId',
  );
  @override
  late final GeneratedColumn<int> goalkeeperId = GeneratedColumn<int>(
    'goalkeeper_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goalkeepers (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceTypeMeta = const VerificationMeta(
    'recurrenceType',
  );
  @override
  late final GeneratedColumn<String> recurrenceType = GeneratedColumn<String>(
    'recurrence_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('daily'),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalkeeperId,
    title,
    description,
    recurrenceType,
    isEnabled,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goalkeeper_id')) {
      context.handle(
        _goalkeeperIdMeta,
        goalkeeperId.isAcceptableOrUnknown(
          data['goalkeeper_id']!,
          _goalkeeperIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goalkeeperIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_type')) {
      context.handle(
        _recurrenceTypeMeta,
        recurrenceType.isAcceptableOrUnknown(
          data['recurrence_type']!,
          _recurrenceTypeMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalkeeperId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goalkeeper_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      recurrenceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_type'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $DailyTasksTable createAlias(String alias) {
    return $DailyTasksTable(attachedDatabase, alias);
  }
}

class DailyTask extends DataClass implements Insertable<DailyTask> {
  final int id;
  final int goalkeeperId;
  final String title;
  final String? description;
  final String recurrenceType;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const DailyTask({
    required this.id,
    required this.goalkeeperId,
    required this.title,
    this.description,
    required this.recurrenceType,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goalkeeper_id'] = Variable<int>(goalkeeperId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['recurrence_type'] = Variable<String>(recurrenceType);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  DailyTasksCompanion toCompanion(bool nullToAbsent) {
    return DailyTasksCompanion(
      id: Value(id),
      goalkeeperId: Value(goalkeeperId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      recurrenceType: Value(recurrenceType),
      isEnabled: Value(isEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory DailyTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyTask(
      id: serializer.fromJson<int>(json['id']),
      goalkeeperId: serializer.fromJson<int>(json['goalkeeperId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      recurrenceType: serializer.fromJson<String>(json['recurrenceType']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalkeeperId': serializer.toJson<int>(goalkeeperId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'recurrenceType': serializer.toJson<String>(recurrenceType),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  DailyTask copyWith({
    int? id,
    int? goalkeeperId,
    String? title,
    Value<String?> description = const Value.absent(),
    String? recurrenceType,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => DailyTask(
    id: id ?? this.id,
    goalkeeperId: goalkeeperId ?? this.goalkeeperId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    recurrenceType: recurrenceType ?? this.recurrenceType,
    isEnabled: isEnabled ?? this.isEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  DailyTask copyWithCompanion(DailyTasksCompanion data) {
    return DailyTask(
      id: data.id.present ? data.id.value : this.id,
      goalkeeperId: data.goalkeeperId.present
          ? data.goalkeeperId.value
          : this.goalkeeperId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      recurrenceType: data.recurrenceType.present
          ? data.recurrenceType.value
          : this.recurrenceType,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyTask(')
          ..write('id: $id, ')
          ..write('goalkeeperId: $goalkeeperId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalkeeperId,
    title,
    description,
    recurrenceType,
    isEnabled,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyTask &&
          other.id == this.id &&
          other.goalkeeperId == this.goalkeeperId &&
          other.title == this.title &&
          other.description == this.description &&
          other.recurrenceType == this.recurrenceType &&
          other.isEnabled == this.isEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class DailyTasksCompanion extends UpdateCompanion<DailyTask> {
  final Value<int> id;
  final Value<int> goalkeeperId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> recurrenceType;
  final Value<bool> isEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const DailyTasksCompanion({
    this.id = const Value.absent(),
    this.goalkeeperId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.recurrenceType = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  DailyTasksCompanion.insert({
    this.id = const Value.absent(),
    required int goalkeeperId,
    required String title,
    this.description = const Value.absent(),
    this.recurrenceType = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : goalkeeperId = Value(goalkeeperId),
       title = Value(title);
  static Insertable<DailyTask> custom({
    Expression<int>? id,
    Expression<int>? goalkeeperId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? recurrenceType,
    Expression<bool>? isEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalkeeperId != null) 'goalkeeper_id': goalkeeperId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (recurrenceType != null) 'recurrence_type': recurrenceType,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  DailyTasksCompanion copyWith({
    Value<int>? id,
    Value<int>? goalkeeperId,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? recurrenceType,
    Value<bool>? isEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return DailyTasksCompanion(
      id: id ?? this.id,
      goalkeeperId: goalkeeperId ?? this.goalkeeperId,
      title: title ?? this.title,
      description: description ?? this.description,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalkeeperId.present) {
      map['goalkeeper_id'] = Variable<int>(goalkeeperId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (recurrenceType.present) {
      map['recurrence_type'] = Variable<String>(recurrenceType.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyTasksCompanion(')
          ..write('id: $id, ')
          ..write('goalkeeperId: $goalkeeperId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyTaskCompletionsTable extends DailyTaskCompletions
    with TableInfo<$DailyTaskCompletionsTable, DailyTaskCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyTaskCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_tasks (id)',
    ),
  );
  static const VerificationMeta _occurrenceDateMeta = const VerificationMeta(
    'occurrenceDate',
  );
  @override
  late final GeneratedColumn<DateTime> occurrenceDate =
      GeneratedColumn<DateTime>(
        'occurrence_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, occurrenceDate, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_task_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyTaskCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('occurrence_date')) {
      context.handle(
        _occurrenceDateMeta,
        occurrenceDate.isAcceptableOrUnknown(
          data['occurrence_date']!,
          _occurrenceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurrenceDateMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, occurrenceDate};
  @override
  DailyTaskCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyTaskCompletion(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      occurrenceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurrence_date'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $DailyTaskCompletionsTable createAlias(String alias) {
    return $DailyTaskCompletionsTable(attachedDatabase, alias);
  }
}

class DailyTaskCompletion extends DataClass
    implements Insertable<DailyTaskCompletion> {
  final int taskId;
  final DateTime occurrenceDate;
  final DateTime completedAt;
  const DailyTaskCompletion({
    required this.taskId,
    required this.occurrenceDate,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<int>(taskId);
    map['occurrence_date'] = Variable<DateTime>(occurrenceDate);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  DailyTaskCompletionsCompanion toCompanion(bool nullToAbsent) {
    return DailyTaskCompletionsCompanion(
      taskId: Value(taskId),
      occurrenceDate: Value(occurrenceDate),
      completedAt: Value(completedAt),
    );
  }

  factory DailyTaskCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyTaskCompletion(
      taskId: serializer.fromJson<int>(json['taskId']),
      occurrenceDate: serializer.fromJson<DateTime>(json['occurrenceDate']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<int>(taskId),
      'occurrenceDate': serializer.toJson<DateTime>(occurrenceDate),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  DailyTaskCompletion copyWith({
    int? taskId,
    DateTime? occurrenceDate,
    DateTime? completedAt,
  }) => DailyTaskCompletion(
    taskId: taskId ?? this.taskId,
    occurrenceDate: occurrenceDate ?? this.occurrenceDate,
    completedAt: completedAt ?? this.completedAt,
  );
  DailyTaskCompletion copyWithCompanion(DailyTaskCompletionsCompanion data) {
    return DailyTaskCompletion(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      occurrenceDate: data.occurrenceDate.present
          ? data.occurrenceDate.value
          : this.occurrenceDate,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyTaskCompletion(')
          ..write('taskId: $taskId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, occurrenceDate, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyTaskCompletion &&
          other.taskId == this.taskId &&
          other.occurrenceDate == this.occurrenceDate &&
          other.completedAt == this.completedAt);
}

class DailyTaskCompletionsCompanion
    extends UpdateCompanion<DailyTaskCompletion> {
  final Value<int> taskId;
  final Value<DateTime> occurrenceDate;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const DailyTaskCompletionsCompanion({
    this.taskId = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyTaskCompletionsCompanion.insert({
    required int taskId,
    required DateTime occurrenceDate,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       occurrenceDate = Value(occurrenceDate);
  static Insertable<DailyTaskCompletion> custom({
    Expression<int>? taskId,
    Expression<DateTime>? occurrenceDate,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (occurrenceDate != null) 'occurrence_date': occurrenceDate,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyTaskCompletionsCompanion copyWith({
    Value<int>? taskId,
    Value<DateTime>? occurrenceDate,
    Value<DateTime>? completedAt,
    Value<int>? rowid,
  }) {
    return DailyTaskCompletionsCompanion(
      taskId: taskId ?? this.taskId,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (occurrenceDate.present) {
      map['occurrence_date'] = Variable<DateTime>(occurrenceDate.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyTaskCompletionsCompanion(')
          ..write('taskId: $taskId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GoalkeepersTable goalkeepers = $GoalkeepersTable(this);
  late final $MatchesTable matches = $MatchesTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $DailyTasksTable dailyTasks = $DailyTasksTable(this);
  late final $DailyTaskCompletionsTable dailyTaskCompletions =
      $DailyTaskCompletionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    goalkeepers,
    matches,
    goals,
    dailyTasks,
    dailyTaskCompletions,
  ];
}

typedef $$GoalkeepersTableCreateCompanionBuilder =
    GoalkeepersCompanion Function({
      Value<int> id,
      required String uuid,
      required String firstName,
      required String lastName,
      required String hand,
      Value<String?> email,
      Value<DateTime?> birthDate,
      Value<bool> isCurrent,
      Value<String?> photoPath,
    });
typedef $$GoalkeepersTableUpdateCompanionBuilder =
    GoalkeepersCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> hand,
      Value<String?> email,
      Value<DateTime?> birthDate,
      Value<bool> isCurrent,
      Value<String?> photoPath,
    });

final class $$GoalkeepersTableReferences
    extends BaseReferences<_$AppDatabase, $GoalkeepersTable, Goalkeeper> {
  $$GoalkeepersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MatchesTable, List<Matche>> _matchesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.matches,
    aliasName: $_aliasNameGenerator(db.goalkeepers.id, db.matches.goalkeeperId),
  );

  $$MatchesTableProcessedTableManager get matchesRefs {
    final manager = $$MatchesTableTableManager(
      $_db,
      $_db.matches,
    ).filter((f) => f.goalkeeperId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DailyTasksTable, List<DailyTask>>
  _dailyTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyTasks,
    aliasName: $_aliasNameGenerator(
      db.goalkeepers.id,
      db.dailyTasks.goalkeeperId,
    ),
  );

  $$DailyTasksTableProcessedTableManager get dailyTasksRefs {
    final manager = $$DailyTasksTableTableManager(
      $_db,
      $_db.dailyTasks,
    ).filter((f) => f.goalkeeperId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dailyTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GoalkeepersTableFilterComposer
    extends Composer<_$AppDatabase, $GoalkeepersTable> {
  $$GoalkeepersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hand => $composableBuilder(
    column: $table.hand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> matchesRefs(
    Expression<bool> Function($$MatchesTableFilterComposer f) f,
  ) {
    final $$MatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.goalkeeperId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableFilterComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dailyTasksRefs(
    Expression<bool> Function($$DailyTasksTableFilterComposer f) f,
  ) {
    final $$DailyTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyTasks,
      getReferencedColumn: (t) => t.goalkeeperId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyTasksTableFilterComposer(
            $db: $db,
            $table: $db.dailyTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalkeepersTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalkeepersTable> {
  $$GoalkeepersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hand => $composableBuilder(
    column: $table.hand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalkeepersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalkeepersTable> {
  $$GoalkeepersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get hand =>
      $composableBuilder(column: $table.hand, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<bool> get isCurrent =>
      $composableBuilder(column: $table.isCurrent, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  Expression<T> matchesRefs<T extends Object>(
    Expression<T> Function($$MatchesTableAnnotationComposer a) f,
  ) {
    final $$MatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.goalkeeperId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dailyTasksRefs<T extends Object>(
    Expression<T> Function($$DailyTasksTableAnnotationComposer a) f,
  ) {
    final $$DailyTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyTasks,
      getReferencedColumn: (t) => t.goalkeeperId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalkeepersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalkeepersTable,
          Goalkeeper,
          $$GoalkeepersTableFilterComposer,
          $$GoalkeepersTableOrderingComposer,
          $$GoalkeepersTableAnnotationComposer,
          $$GoalkeepersTableCreateCompanionBuilder,
          $$GoalkeepersTableUpdateCompanionBuilder,
          (Goalkeeper, $$GoalkeepersTableReferences),
          Goalkeeper,
          PrefetchHooks Function({bool matchesRefs, bool dailyTasksRefs})
        > {
  $$GoalkeepersTableTableManager(_$AppDatabase db, $GoalkeepersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalkeepersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalkeepersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalkeepersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> hand = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
              }) => GoalkeepersCompanion(
                id: id,
                uuid: uuid,
                firstName: firstName,
                lastName: lastName,
                hand: hand,
                email: email,
                birthDate: birthDate,
                isCurrent: isCurrent,
                photoPath: photoPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String firstName,
                required String lastName,
                required String hand,
                Value<String?> email = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
              }) => GoalkeepersCompanion.insert(
                id: id,
                uuid: uuid,
                firstName: firstName,
                lastName: lastName,
                hand: hand,
                email: email,
                birthDate: birthDate,
                isCurrent: isCurrent,
                photoPath: photoPath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalkeepersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({matchesRefs = false, dailyTasksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (matchesRefs) db.matches,
                    if (dailyTasksRefs) db.dailyTasks,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (matchesRefs)
                        await $_getPrefetchedData<
                          Goalkeeper,
                          $GoalkeepersTable,
                          Matche
                        >(
                          currentTable: table,
                          referencedTable: $$GoalkeepersTableReferences
                              ._matchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalkeepersTableReferences(
                                db,
                                table,
                                p0,
                              ).matchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalkeeperId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyTasksRefs)
                        await $_getPrefetchedData<
                          Goalkeeper,
                          $GoalkeepersTable,
                          DailyTask
                        >(
                          currentTable: table,
                          referencedTable: $$GoalkeepersTableReferences
                              ._dailyTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalkeepersTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalkeeperId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GoalkeepersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalkeepersTable,
      Goalkeeper,
      $$GoalkeepersTableFilterComposer,
      $$GoalkeepersTableOrderingComposer,
      $$GoalkeepersTableAnnotationComposer,
      $$GoalkeepersTableCreateCompanionBuilder,
      $$GoalkeepersTableUpdateCompanionBuilder,
      (Goalkeeper, $$GoalkeepersTableReferences),
      Goalkeeper,
      PrefetchHooks Function({bool matchesRefs, bool dailyTasksRefs})
    >;
typedef $$MatchesTableCreateCompanionBuilder =
    MatchesCompanion Function({
      Value<int> id,
      required String uuid,
      required int goalkeeperId,
      required DateTime date,
      required String opponent,
      Value<String?> score,
      Value<String?> gameTime,
      Value<String?> personalTasks,
      Value<int> gameDuration,
      Value<int> goalsConceded,
      Value<int> saves,
      Value<double?> savePercentage,
      Value<int?> moodRating,
      Value<int?> warmupRating,
      Value<int?> confidenceRating,
      Value<int?> greatSavesRating,
      Value<String?> comments,
      Value<DateTime> createdAt,
    });
typedef $$MatchesTableUpdateCompanionBuilder =
    MatchesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int> goalkeeperId,
      Value<DateTime> date,
      Value<String> opponent,
      Value<String?> score,
      Value<String?> gameTime,
      Value<String?> personalTasks,
      Value<int> gameDuration,
      Value<int> goalsConceded,
      Value<int> saves,
      Value<double?> savePercentage,
      Value<int?> moodRating,
      Value<int?> warmupRating,
      Value<int?> confidenceRating,
      Value<int?> greatSavesRating,
      Value<String?> comments,
      Value<DateTime> createdAt,
    });

final class $$MatchesTableReferences
    extends BaseReferences<_$AppDatabase, $MatchesTable, Matche> {
  $$MatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GoalkeepersTable _goalkeeperIdTable(_$AppDatabase db) =>
      db.goalkeepers.createAlias(
        $_aliasNameGenerator(db.matches.goalkeeperId, db.goalkeepers.id),
      );

  $$GoalkeepersTableProcessedTableManager get goalkeeperId {
    final $_column = $_itemColumn<int>('goalkeeper_id')!;

    final manager = $$GoalkeepersTableTableManager(
      $_db,
      $_db.goalkeepers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalkeeperIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GoalsTable, List<Goal>> _goalsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.goals,
    aliasName: $_aliasNameGenerator(db.matches.id, db.goals.matchId),
  );

  $$GoalsTableProcessedTableManager get goalsRefs {
    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.matchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MatchesTableFilterComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opponent => $composableBuilder(
    column: $table.opponent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameTime => $composableBuilder(
    column: $table.gameTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalTasks => $composableBuilder(
    column: $table.personalTasks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gameDuration => $composableBuilder(
    column: $table.gameDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalsConceded => $composableBuilder(
    column: $table.goalsConceded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saves => $composableBuilder(
    column: $table.saves,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get savePercentage => $composableBuilder(
    column: $table.savePercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodRating => $composableBuilder(
    column: $table.moodRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warmupRating => $composableBuilder(
    column: $table.warmupRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confidenceRating => $composableBuilder(
    column: $table.confidenceRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get greatSavesRating => $composableBuilder(
    column: $table.greatSavesRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalkeepersTableFilterComposer get goalkeeperId {
    final $$GoalkeepersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalkeeperId,
      referencedTable: $db.goalkeepers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalkeepersTableFilterComposer(
            $db: $db,
            $table: $db.goalkeepers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> goalsRefs(
    Expression<bool> Function($$GoalsTableFilterComposer f) f,
  ) {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.matchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opponent => $composableBuilder(
    column: $table.opponent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameTime => $composableBuilder(
    column: $table.gameTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalTasks => $composableBuilder(
    column: $table.personalTasks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gameDuration => $composableBuilder(
    column: $table.gameDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalsConceded => $composableBuilder(
    column: $table.goalsConceded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saves => $composableBuilder(
    column: $table.saves,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get savePercentage => $composableBuilder(
    column: $table.savePercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodRating => $composableBuilder(
    column: $table.moodRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warmupRating => $composableBuilder(
    column: $table.warmupRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confidenceRating => $composableBuilder(
    column: $table.confidenceRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get greatSavesRating => $composableBuilder(
    column: $table.greatSavesRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalkeepersTableOrderingComposer get goalkeeperId {
    final $$GoalkeepersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalkeeperId,
      referencedTable: $db.goalkeepers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalkeepersTableOrderingComposer(
            $db: $db,
            $table: $db.goalkeepers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get opponent =>
      $composableBuilder(column: $table.opponent, builder: (column) => column);

  GeneratedColumn<String> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get gameTime =>
      $composableBuilder(column: $table.gameTime, builder: (column) => column);

  GeneratedColumn<String> get personalTasks => $composableBuilder(
    column: $table.personalTasks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gameDuration => $composableBuilder(
    column: $table.gameDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get goalsConceded => $composableBuilder(
    column: $table.goalsConceded,
    builder: (column) => column,
  );

  GeneratedColumn<int> get saves =>
      $composableBuilder(column: $table.saves, builder: (column) => column);

  GeneratedColumn<double> get savePercentage => $composableBuilder(
    column: $table.savePercentage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get moodRating => $composableBuilder(
    column: $table.moodRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get warmupRating => $composableBuilder(
    column: $table.warmupRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get confidenceRating => $composableBuilder(
    column: $table.confidenceRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get greatSavesRating => $composableBuilder(
    column: $table.greatSavesRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GoalkeepersTableAnnotationComposer get goalkeeperId {
    final $$GoalkeepersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalkeeperId,
      referencedTable: $db.goalkeepers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalkeepersTableAnnotationComposer(
            $db: $db,
            $table: $db.goalkeepers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> goalsRefs<T extends Object>(
    Expression<T> Function($$GoalsTableAnnotationComposer a) f,
  ) {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.matchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchesTable,
          Matche,
          $$MatchesTableFilterComposer,
          $$MatchesTableOrderingComposer,
          $$MatchesTableAnnotationComposer,
          $$MatchesTableCreateCompanionBuilder,
          $$MatchesTableUpdateCompanionBuilder,
          (Matche, $$MatchesTableReferences),
          Matche,
          PrefetchHooks Function({bool goalkeeperId, bool goalsRefs})
        > {
  $$MatchesTableTableManager(_$AppDatabase db, $MatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> goalkeeperId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> opponent = const Value.absent(),
                Value<String?> score = const Value.absent(),
                Value<String?> gameTime = const Value.absent(),
                Value<String?> personalTasks = const Value.absent(),
                Value<int> gameDuration = const Value.absent(),
                Value<int> goalsConceded = const Value.absent(),
                Value<int> saves = const Value.absent(),
                Value<double?> savePercentage = const Value.absent(),
                Value<int?> moodRating = const Value.absent(),
                Value<int?> warmupRating = const Value.absent(),
                Value<int?> confidenceRating = const Value.absent(),
                Value<int?> greatSavesRating = const Value.absent(),
                Value<String?> comments = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MatchesCompanion(
                id: id,
                uuid: uuid,
                goalkeeperId: goalkeeperId,
                date: date,
                opponent: opponent,
                score: score,
                gameTime: gameTime,
                personalTasks: personalTasks,
                gameDuration: gameDuration,
                goalsConceded: goalsConceded,
                saves: saves,
                savePercentage: savePercentage,
                moodRating: moodRating,
                warmupRating: warmupRating,
                confidenceRating: confidenceRating,
                greatSavesRating: greatSavesRating,
                comments: comments,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int goalkeeperId,
                required DateTime date,
                required String opponent,
                Value<String?> score = const Value.absent(),
                Value<String?> gameTime = const Value.absent(),
                Value<String?> personalTasks = const Value.absent(),
                Value<int> gameDuration = const Value.absent(),
                Value<int> goalsConceded = const Value.absent(),
                Value<int> saves = const Value.absent(),
                Value<double?> savePercentage = const Value.absent(),
                Value<int?> moodRating = const Value.absent(),
                Value<int?> warmupRating = const Value.absent(),
                Value<int?> confidenceRating = const Value.absent(),
                Value<int?> greatSavesRating = const Value.absent(),
                Value<String?> comments = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MatchesCompanion.insert(
                id: id,
                uuid: uuid,
                goalkeeperId: goalkeeperId,
                date: date,
                opponent: opponent,
                score: score,
                gameTime: gameTime,
                personalTasks: personalTasks,
                gameDuration: gameDuration,
                goalsConceded: goalsConceded,
                saves: saves,
                savePercentage: savePercentage,
                moodRating: moodRating,
                warmupRating: warmupRating,
                confidenceRating: confidenceRating,
                greatSavesRating: greatSavesRating,
                comments: comments,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalkeeperId = false, goalsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (goalsRefs) db.goals],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalkeeperId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalkeeperId,
                                referencedTable: $$MatchesTableReferences
                                    ._goalkeeperIdTable(db),
                                referencedColumn: $$MatchesTableReferences
                                    ._goalkeeperIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (goalsRefs)
                    await $_getPrefetchedData<Matche, $MatchesTable, Goal>(
                      currentTable: table,
                      referencedTable: $$MatchesTableReferences._goalsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$MatchesTableReferences(db, table, p0).goalsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.matchId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchesTable,
      Matche,
      $$MatchesTableFilterComposer,
      $$MatchesTableOrderingComposer,
      $$MatchesTableAnnotationComposer,
      $$MatchesTableCreateCompanionBuilder,
      $$MatchesTableUpdateCompanionBuilder,
      (Matche, $$MatchesTableReferences),
      Matche,
      PrefetchHooks Function({bool goalkeeperId, bool goalsRefs})
    >;
typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      Value<int> id,
      required int matchId,
      required int goalTypeId,
      Value<double?> toZoneX,
      Value<double?> toZoneY,
      Value<double?> fromZoneX,
      Value<double?> fromZoneY,
      Value<String?> zone,
      Value<String?> fromZone,
      Value<DateTime> createdAt,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<int> id,
      Value<int> matchId,
      Value<int> goalTypeId,
      Value<double?> toZoneX,
      Value<double?> toZoneY,
      Value<double?> fromZoneX,
      Value<double?> fromZoneY,
      Value<String?> zone,
      Value<String?> fromZone,
      Value<DateTime> createdAt,
    });

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MatchesTable _matchIdTable(_$AppDatabase db) => db.matches
      .createAlias($_aliasNameGenerator(db.goals.matchId, db.matches.id));

  $$MatchesTableProcessedTableManager get matchId {
    final $_column = $_itemColumn<int>('match_id')!;

    final manager = $$MatchesTableTableManager(
      $_db,
      $_db.matches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_matchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalTypeId => $composableBuilder(
    column: $table.goalTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toZoneX => $composableBuilder(
    column: $table.toZoneX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toZoneY => $composableBuilder(
    column: $table.toZoneY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fromZoneX => $composableBuilder(
    column: $table.fromZoneX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fromZoneY => $composableBuilder(
    column: $table.fromZoneY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromZone => $composableBuilder(
    column: $table.fromZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MatchesTableFilterComposer get matchId {
    final $$MatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchId,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableFilterComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalTypeId => $composableBuilder(
    column: $table.goalTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toZoneX => $composableBuilder(
    column: $table.toZoneX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toZoneY => $composableBuilder(
    column: $table.toZoneY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fromZoneX => $composableBuilder(
    column: $table.fromZoneX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fromZoneY => $composableBuilder(
    column: $table.fromZoneY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromZone => $composableBuilder(
    column: $table.fromZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MatchesTableOrderingComposer get matchId {
    final $$MatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchId,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableOrderingComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get goalTypeId => $composableBuilder(
    column: $table.goalTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get toZoneX =>
      $composableBuilder(column: $table.toZoneX, builder: (column) => column);

  GeneratedColumn<double> get toZoneY =>
      $composableBuilder(column: $table.toZoneY, builder: (column) => column);

  GeneratedColumn<double> get fromZoneX =>
      $composableBuilder(column: $table.fromZoneX, builder: (column) => column);

  GeneratedColumn<double> get fromZoneY =>
      $composableBuilder(column: $table.fromZoneY, builder: (column) => column);

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<String> get fromZone =>
      $composableBuilder(column: $table.fromZone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MatchesTableAnnotationComposer get matchId {
    final $$MatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchId,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, $$GoalsTableReferences),
          Goal,
          PrefetchHooks Function({bool matchId})
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> matchId = const Value.absent(),
                Value<int> goalTypeId = const Value.absent(),
                Value<double?> toZoneX = const Value.absent(),
                Value<double?> toZoneY = const Value.absent(),
                Value<double?> fromZoneX = const Value.absent(),
                Value<double?> fromZoneY = const Value.absent(),
                Value<String?> zone = const Value.absent(),
                Value<String?> fromZone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                matchId: matchId,
                goalTypeId: goalTypeId,
                toZoneX: toZoneX,
                toZoneY: toZoneY,
                fromZoneX: fromZoneX,
                fromZoneY: fromZoneY,
                zone: zone,
                fromZone: fromZone,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int matchId,
                required int goalTypeId,
                Value<double?> toZoneX = const Value.absent(),
                Value<double?> toZoneY = const Value.absent(),
                Value<double?> fromZoneX = const Value.absent(),
                Value<double?> fromZoneY = const Value.absent(),
                Value<String?> zone = const Value.absent(),
                Value<String?> fromZone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                matchId: matchId,
                goalTypeId: goalTypeId,
                toZoneX: toZoneX,
                toZoneY: toZoneY,
                fromZoneX: fromZoneX,
                fromZoneY: fromZoneY,
                zone: zone,
                fromZone: fromZone,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GoalsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({matchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (matchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.matchId,
                                referencedTable: $$GoalsTableReferences
                                    ._matchIdTable(db),
                                referencedColumn: $$GoalsTableReferences
                                    ._matchIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, $$GoalsTableReferences),
      Goal,
      PrefetchHooks Function({bool matchId})
    >;
typedef $$DailyTasksTableCreateCompanionBuilder =
    DailyTasksCompanion Function({
      Value<int> id,
      required int goalkeeperId,
      required String title,
      Value<String?> description,
      Value<String> recurrenceType,
      Value<bool> isEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$DailyTasksTableUpdateCompanionBuilder =
    DailyTasksCompanion Function({
      Value<int> id,
      Value<int> goalkeeperId,
      Value<String> title,
      Value<String?> description,
      Value<String> recurrenceType,
      Value<bool> isEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$DailyTasksTableReferences
    extends BaseReferences<_$AppDatabase, $DailyTasksTable, DailyTask> {
  $$DailyTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GoalkeepersTable _goalkeeperIdTable(_$AppDatabase db) =>
      db.goalkeepers.createAlias(
        $_aliasNameGenerator(db.dailyTasks.goalkeeperId, db.goalkeepers.id),
      );

  $$GoalkeepersTableProcessedTableManager get goalkeeperId {
    final $_column = $_itemColumn<int>('goalkeeper_id')!;

    final manager = $$GoalkeepersTableTableManager(
      $_db,
      $_db.goalkeepers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalkeeperIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $DailyTaskCompletionsTable,
    List<DailyTaskCompletion>
  >
  _dailyTaskCompletionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dailyTaskCompletions,
        aliasName: $_aliasNameGenerator(
          db.dailyTasks.id,
          db.dailyTaskCompletions.taskId,
        ),
      );

  $$DailyTaskCompletionsTableProcessedTableManager
  get dailyTaskCompletionsRefs {
    final manager = $$DailyTaskCompletionsTableTableManager(
      $_db,
      $_db.dailyTaskCompletions,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyTaskCompletionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyTasksTableFilterComposer
    extends Composer<_$AppDatabase, $DailyTasksTable> {
  $$DailyTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceType => $composableBuilder(
    column: $table.recurrenceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalkeepersTableFilterComposer get goalkeeperId {
    final $$GoalkeepersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalkeeperId,
      referencedTable: $db.goalkeepers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalkeepersTableFilterComposer(
            $db: $db,
            $table: $db.goalkeepers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> dailyTaskCompletionsRefs(
    Expression<bool> Function($$DailyTaskCompletionsTableFilterComposer f) f,
  ) {
    final $$DailyTaskCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyTaskCompletions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyTaskCompletionsTableFilterComposer(
            $db: $db,
            $table: $db.dailyTaskCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyTasksTable> {
  $$DailyTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceType => $composableBuilder(
    column: $table.recurrenceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalkeepersTableOrderingComposer get goalkeeperId {
    final $$GoalkeepersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalkeeperId,
      referencedTable: $db.goalkeepers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalkeepersTableOrderingComposer(
            $db: $db,
            $table: $db.goalkeepers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyTasksTable> {
  $$DailyTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceType => $composableBuilder(
    column: $table.recurrenceType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$GoalkeepersTableAnnotationComposer get goalkeeperId {
    final $$GoalkeepersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalkeeperId,
      referencedTable: $db.goalkeepers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalkeepersTableAnnotationComposer(
            $db: $db,
            $table: $db.goalkeepers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> dailyTaskCompletionsRefs<T extends Object>(
    Expression<T> Function($$DailyTaskCompletionsTableAnnotationComposer a) f,
  ) {
    final $$DailyTaskCompletionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dailyTaskCompletions,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyTaskCompletionsTableAnnotationComposer(
                $db: $db,
                $table: $db.dailyTaskCompletions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DailyTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyTasksTable,
          DailyTask,
          $$DailyTasksTableFilterComposer,
          $$DailyTasksTableOrderingComposer,
          $$DailyTasksTableAnnotationComposer,
          $$DailyTasksTableCreateCompanionBuilder,
          $$DailyTasksTableUpdateCompanionBuilder,
          (DailyTask, $$DailyTasksTableReferences),
          DailyTask,
          PrefetchHooks Function({
            bool goalkeeperId,
            bool dailyTaskCompletionsRefs,
          })
        > {
  $$DailyTasksTableTableManager(_$AppDatabase db, $DailyTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalkeeperId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> recurrenceType = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => DailyTasksCompanion(
                id: id,
                goalkeeperId: goalkeeperId,
                title: title,
                description: description,
                recurrenceType: recurrenceType,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int goalkeeperId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> recurrenceType = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => DailyTasksCompanion.insert(
                id: id,
                goalkeeperId: goalkeeperId,
                title: title,
                description: description,
                recurrenceType: recurrenceType,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({goalkeeperId = false, dailyTaskCompletionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dailyTaskCompletionsRefs) db.dailyTaskCompletions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (goalkeeperId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.goalkeeperId,
                                    referencedTable: $$DailyTasksTableReferences
                                        ._goalkeeperIdTable(db),
                                    referencedColumn:
                                        $$DailyTasksTableReferences
                                            ._goalkeeperIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dailyTaskCompletionsRefs)
                        await $_getPrefetchedData<
                          DailyTask,
                          $DailyTasksTable,
                          DailyTaskCompletion
                        >(
                          currentTable: table,
                          referencedTable: $$DailyTasksTableReferences
                              ._dailyTaskCompletionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DailyTasksTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyTaskCompletionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DailyTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyTasksTable,
      DailyTask,
      $$DailyTasksTableFilterComposer,
      $$DailyTasksTableOrderingComposer,
      $$DailyTasksTableAnnotationComposer,
      $$DailyTasksTableCreateCompanionBuilder,
      $$DailyTasksTableUpdateCompanionBuilder,
      (DailyTask, $$DailyTasksTableReferences),
      DailyTask,
      PrefetchHooks Function({bool goalkeeperId, bool dailyTaskCompletionsRefs})
    >;
typedef $$DailyTaskCompletionsTableCreateCompanionBuilder =
    DailyTaskCompletionsCompanion Function({
      required int taskId,
      required DateTime occurrenceDate,
      Value<DateTime> completedAt,
      Value<int> rowid,
    });
typedef $$DailyTaskCompletionsTableUpdateCompanionBuilder =
    DailyTaskCompletionsCompanion Function({
      Value<int> taskId,
      Value<DateTime> occurrenceDate,
      Value<DateTime> completedAt,
      Value<int> rowid,
    });

final class $$DailyTaskCompletionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DailyTaskCompletionsTable,
          DailyTaskCompletion
        > {
  $$DailyTaskCompletionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DailyTasksTable _taskIdTable(_$AppDatabase db) =>
      db.dailyTasks.createAlias(
        $_aliasNameGenerator(db.dailyTaskCompletions.taskId, db.dailyTasks.id),
      );

  $$DailyTasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$DailyTasksTableTableManager(
      $_db,
      $_db.dailyTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyTaskCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyTaskCompletionsTable> {
  $$DailyTaskCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyTasksTableFilterComposer get taskId {
    final $$DailyTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.dailyTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyTasksTableFilterComposer(
            $db: $db,
            $table: $db.dailyTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyTaskCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyTaskCompletionsTable> {
  $$DailyTaskCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyTasksTableOrderingComposer get taskId {
    final $$DailyTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.dailyTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyTasksTableOrderingComposer(
            $db: $db,
            $table: $db.dailyTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyTaskCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyTaskCompletionsTable> {
  $$DailyTaskCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$DailyTasksTableAnnotationComposer get taskId {
    final $$DailyTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.dailyTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyTaskCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyTaskCompletionsTable,
          DailyTaskCompletion,
          $$DailyTaskCompletionsTableFilterComposer,
          $$DailyTaskCompletionsTableOrderingComposer,
          $$DailyTaskCompletionsTableAnnotationComposer,
          $$DailyTaskCompletionsTableCreateCompanionBuilder,
          $$DailyTaskCompletionsTableUpdateCompanionBuilder,
          (DailyTaskCompletion, $$DailyTaskCompletionsTableReferences),
          DailyTaskCompletion,
          PrefetchHooks Function({bool taskId})
        > {
  $$DailyTaskCompletionsTableTableManager(
    _$AppDatabase db,
    $DailyTaskCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyTaskCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyTaskCompletionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyTaskCompletionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> taskId = const Value.absent(),
                Value<DateTime> occurrenceDate = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyTaskCompletionsCompanion(
                taskId: taskId,
                occurrenceDate: occurrenceDate,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int taskId,
                required DateTime occurrenceDate,
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyTaskCompletionsCompanion.insert(
                taskId: taskId,
                occurrenceDate: occurrenceDate,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyTaskCompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$DailyTaskCompletionsTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$DailyTaskCompletionsTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyTaskCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyTaskCompletionsTable,
      DailyTaskCompletion,
      $$DailyTaskCompletionsTableFilterComposer,
      $$DailyTaskCompletionsTableOrderingComposer,
      $$DailyTaskCompletionsTableAnnotationComposer,
      $$DailyTaskCompletionsTableCreateCompanionBuilder,
      $$DailyTaskCompletionsTableUpdateCompanionBuilder,
      (DailyTaskCompletion, $$DailyTaskCompletionsTableReferences),
      DailyTaskCompletion,
      PrefetchHooks Function({bool taskId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GoalkeepersTableTableManager get goalkeepers =>
      $$GoalkeepersTableTableManager(_db, _db.goalkeepers);
  $$MatchesTableTableManager get matches =>
      $$MatchesTableTableManager(_db, _db.matches);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$DailyTasksTableTableManager get dailyTasks =>
      $$DailyTasksTableTableManager(_db, _db.dailyTasks);
  $$DailyTaskCompletionsTableTableManager get dailyTaskCompletions =>
      $$DailyTaskCompletionsTableTableManager(_db, _db.dailyTaskCompletions);
}
