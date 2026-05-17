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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GoalkeepersTable goalkeepers = $GoalkeepersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [goalkeepers];
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
          (
            Goalkeeper,
            BaseReferences<_$AppDatabase, $GoalkeepersTable, Goalkeeper>,
          ),
          Goalkeeper,
          PrefetchHooks Function()
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        Goalkeeper,
        BaseReferences<_$AppDatabase, $GoalkeepersTable, Goalkeeper>,
      ),
      Goalkeeper,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GoalkeepersTableTableManager get goalkeepers =>
      $$GoalkeepersTableTableManager(_db, _db.goalkeepers);
}
