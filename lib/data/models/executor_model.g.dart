// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'executor_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetExecutorModelCollection on Isar {
  IsarCollection<ExecutorModel> get executorModels => this.collection();
}

const ExecutorModelSchema = CollectionSchema(
  name: r'ExecutorModel',
  id: 4482499512813631730,
  properties: {
    r'bin': PropertySchema(
      id: 0,
      name: r'bin',
      type: IsarType.string,
    ),
    r'countOrders': PropertySchema(
      id: 1,
      name: r'countOrders',
      type: IsarType.long,
    ),
    r'fullAddress': PropertySchema(
      id: 2,
      name: r'fullAddress',
      type: IsarType.string,
    ),
    r'lat': PropertySchema(
      id: 3,
      name: r'lat',
      type: IsarType.double,
    ),
    r'lon': PropertySchema(
      id: 4,
      name: r'lon',
      type: IsarType.double,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'photo': PropertySchema(
      id: 6,
      name: r'photo',
      type: IsarType.string,
    ),
    r'rating': PropertySchema(
      id: 7,
      name: r'rating',
      type: IsarType.string,
    )
  },
  estimateSize: _executorModelEstimateSize,
  serialize: _executorModelSerialize,
  deserialize: _executorModelDeserialize,
  deserializeProp: _executorModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _executorModelGetId,
  getLinks: _executorModelGetLinks,
  attach: _executorModelAttach,
  version: '3.0.5',
);

int _executorModelEstimateSize(
  ExecutorModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bin;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fullAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.photo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rating;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _executorModelSerialize(
  ExecutorModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bin);
  writer.writeLong(offsets[1], object.countOrders);
  writer.writeString(offsets[2], object.fullAddress);
  writer.writeDouble(offsets[3], object.lat);
  writer.writeDouble(offsets[4], object.lon);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.photo);
  writer.writeString(offsets[7], object.rating);
}

ExecutorModel _executorModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExecutorModel(
    bin: reader.readStringOrNull(offsets[0]),
    countOrders: reader.readLongOrNull(offsets[1]),
    fullAddress: reader.readStringOrNull(offsets[2]),
    id: id,
    lat: reader.readDoubleOrNull(offsets[3]),
    lon: reader.readDoubleOrNull(offsets[4]),
    name: reader.readString(offsets[5]),
    photo: reader.readStringOrNull(offsets[6]),
    rating: reader.readStringOrNull(offsets[7]),
  );
  return object;
}

P _executorModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _executorModelGetId(ExecutorModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _executorModelGetLinks(ExecutorModel object) {
  return [];
}

void _executorModelAttach(
    IsarCollection<dynamic> col, Id id, ExecutorModel object) {}

extension ExecutorModelQueryWhereSort
    on QueryBuilder<ExecutorModel, ExecutorModel, QWhere> {
  QueryBuilder<ExecutorModel, ExecutorModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExecutorModelQueryWhere
    on QueryBuilder<ExecutorModel, ExecutorModel, QWhereClause> {
  QueryBuilder<ExecutorModel, ExecutorModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExecutorModelQueryFilter
    on QueryBuilder<ExecutorModel, ExecutorModel, QFilterCondition> {
  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      binIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bin',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      binIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bin',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> binEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      binGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> binLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> binBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      binStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> binEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> binContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> binMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      binIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bin',
        value: '',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      binIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bin',
        value: '',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      countOrdersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'countOrders',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      countOrdersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'countOrders',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      countOrdersEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countOrders',
        value: value,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      countOrdersGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'countOrders',
        value: value,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      countOrdersLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'countOrders',
        value: value,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      countOrdersBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'countOrders',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fullAddress',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fullAddress',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      fullAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      latIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lat',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      latIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lat',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> latEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      latGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> latLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> latBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      lonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lon',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      lonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lon',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> lonEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      lonGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> lonLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> lonBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photo',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photo',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photo',
        value: '',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      photoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photo',
        value: '',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rating',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rating',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rating',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: '',
      ));
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterFilterCondition>
      ratingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rating',
        value: '',
      ));
    });
  }
}

extension ExecutorModelQueryObject
    on QueryBuilder<ExecutorModel, ExecutorModel, QFilterCondition> {}

extension ExecutorModelQueryLinks
    on QueryBuilder<ExecutorModel, ExecutorModel, QFilterCondition> {}

extension ExecutorModelQuerySortBy
    on QueryBuilder<ExecutorModel, ExecutorModel, QSortBy> {
  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByBin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bin', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByBinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bin', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByCountOrders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countOrders', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy>
      sortByCountOrdersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countOrders', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByFullAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullAddress', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy>
      sortByFullAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullAddress', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lon', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByLonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lon', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByPhoto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photo', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByPhotoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photo', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }
}

extension ExecutorModelQuerySortThenBy
    on QueryBuilder<ExecutorModel, ExecutorModel, QSortThenBy> {
  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByBin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bin', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByBinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bin', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByCountOrders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countOrders', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy>
      thenByCountOrdersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countOrders', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByFullAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullAddress', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy>
      thenByFullAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullAddress', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lon', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByLonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lon', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByPhoto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photo', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByPhotoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photo', Sort.desc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }
}

extension ExecutorModelQueryWhereDistinct
    on QueryBuilder<ExecutorModel, ExecutorModel, QDistinct> {
  QueryBuilder<ExecutorModel, ExecutorModel, QDistinct> distinctByBin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QDistinct>
      distinctByCountOrders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countOrders');
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QDistinct> distinctByFullAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullAddress', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QDistinct> distinctByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lat');
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QDistinct> distinctByLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lon');
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QDistinct> distinctByPhoto(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExecutorModel, ExecutorModel, QDistinct> distinctByRating(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating', caseSensitive: caseSensitive);
    });
  }
}

extension ExecutorModelQueryProperty
    on QueryBuilder<ExecutorModel, ExecutorModel, QQueryProperty> {
  QueryBuilder<ExecutorModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExecutorModel, String?, QQueryOperations> binProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bin');
    });
  }

  QueryBuilder<ExecutorModel, int?, QQueryOperations> countOrdersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countOrders');
    });
  }

  QueryBuilder<ExecutorModel, String?, QQueryOperations> fullAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullAddress');
    });
  }

  QueryBuilder<ExecutorModel, double?, QQueryOperations> latProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lat');
    });
  }

  QueryBuilder<ExecutorModel, double?, QQueryOperations> lonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lon');
    });
  }

  QueryBuilder<ExecutorModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ExecutorModel, String?, QQueryOperations> photoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photo');
    });
  }

  QueryBuilder<ExecutorModel, String?, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }
}
