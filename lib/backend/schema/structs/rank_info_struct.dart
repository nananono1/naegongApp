// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class RankInfoStruct extends FFFirebaseStruct {
  RankInfoStruct({
    int? seatNoRank,
    String? rankUserName,
    String? schoolNameRank,
    int? pointInDuration,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _seatNoRank = seatNoRank,
        _rankUserName = rankUserName,
        _schoolNameRank = schoolNameRank,
        _pointInDuration = pointInDuration,
        super(firestoreUtilData);

  // "seatNoRank" field.
  int? _seatNoRank;
  int get seatNoRank => _seatNoRank ?? 0;
  set seatNoRank(int? val) => _seatNoRank = val;

  void incrementSeatNoRank(int amount) => seatNoRank = seatNoRank + amount;

  bool hasSeatNoRank() => _seatNoRank != null;

  // "RankUserName" field.
  String? _rankUserName;
  String get rankUserName => _rankUserName ?? '';
  set rankUserName(String? val) => _rankUserName = val;

  bool hasRankUserName() => _rankUserName != null;

  // "schoolNameRank" field.
  String? _schoolNameRank;
  String get schoolNameRank => _schoolNameRank ?? '';
  set schoolNameRank(String? val) => _schoolNameRank = val;

  bool hasSchoolNameRank() => _schoolNameRank != null;

  // "pointInDuration" field.
  int? _pointInDuration;
  int get pointInDuration => _pointInDuration ?? 0;
  set pointInDuration(int? val) => _pointInDuration = val;

  void incrementPointInDuration(int amount) =>
      pointInDuration = pointInDuration + amount;

  bool hasPointInDuration() => _pointInDuration != null;

  static RankInfoStruct fromMap(Map<String, dynamic> data) => RankInfoStruct(
        seatNoRank: castToType<int>(data['seatNoRank']),
        rankUserName: data['RankUserName'] as String?,
        schoolNameRank: data['schoolNameRank'] as String?,
        pointInDuration: castToType<int>(data['pointInDuration']),
      );

  static RankInfoStruct? maybeFromMap(dynamic data) =>
      data is Map ? RankInfoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'seatNoRank': _seatNoRank,
        'RankUserName': _rankUserName,
        'schoolNameRank': _schoolNameRank,
        'pointInDuration': _pointInDuration,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'seatNoRank': serializeParam(
          _seatNoRank,
          ParamType.int,
        ),
        'RankUserName': serializeParam(
          _rankUserName,
          ParamType.String,
        ),
        'schoolNameRank': serializeParam(
          _schoolNameRank,
          ParamType.String,
        ),
        'pointInDuration': serializeParam(
          _pointInDuration,
          ParamType.int,
        ),
      }.withoutNulls;

  static RankInfoStruct fromSerializableMap(Map<String, dynamic> data) =>
      RankInfoStruct(
        seatNoRank: deserializeParam(
          data['seatNoRank'],
          ParamType.int,
          false,
        ),
        rankUserName: deserializeParam(
          data['RankUserName'],
          ParamType.String,
          false,
        ),
        schoolNameRank: deserializeParam(
          data['schoolNameRank'],
          ParamType.String,
          false,
        ),
        pointInDuration: deserializeParam(
          data['pointInDuration'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'RankInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RankInfoStruct &&
        seatNoRank == other.seatNoRank &&
        rankUserName == other.rankUserName &&
        schoolNameRank == other.schoolNameRank &&
        pointInDuration == other.pointInDuration;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([seatNoRank, rankUserName, schoolNameRank, pointInDuration]);
}

RankInfoStruct createRankInfoStruct({
  int? seatNoRank,
  String? rankUserName,
  String? schoolNameRank,
  int? pointInDuration,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RankInfoStruct(
      seatNoRank: seatNoRank,
      rankUserName: rankUserName,
      schoolNameRank: schoolNameRank,
      pointInDuration: pointInDuration,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RankInfoStruct? updateRankInfoStruct(
  RankInfoStruct? rankInfo, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    rankInfo
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRankInfoStructData(
  Map<String, dynamic> firestoreData,
  RankInfoStruct? rankInfo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (rankInfo == null) {
    return;
  }
  if (rankInfo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && rankInfo.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final rankInfoData = getRankInfoFirestoreData(rankInfo, forFieldValue);
  final nestedData = rankInfoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = rankInfo.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRankInfoFirestoreData(
  RankInfoStruct? rankInfo, [
  bool forFieldValue = false,
]) {
  if (rankInfo == null) {
    return {};
  }
  final firestoreData = mapToFirestore(rankInfo.toMap());

  // Add any Firestore field values
  rankInfo.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRankInfoListFirestoreData(
  List<RankInfoStruct>? rankInfos,
) =>
    rankInfos?.map((e) => getRankInfoFirestoreData(e, true)).toList() ?? [];
