// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SpotAdminInfoStruct extends FFFirebaseStruct {
  SpotAdminInfoStruct({
    String? spot,
    String? fcm,
    DocumentReference? references,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _spot = spot,
        _fcm = fcm,
        _references = references,
        super(firestoreUtilData);

  // "spot" field.
  String? _spot;
  String get spot => _spot ?? '';
  set spot(String? val) => _spot = val;

  bool hasSpot() => _spot != null;

  // "fcm" field.
  String? _fcm;
  String get fcm => _fcm ?? '';
  set fcm(String? val) => _fcm = val;

  bool hasFcm() => _fcm != null;

  // "references" field.
  DocumentReference? _references;
  DocumentReference? get references => _references;
  set references(DocumentReference? val) => _references = val;

  bool hasReferences() => _references != null;

  static SpotAdminInfoStruct fromMap(Map<String, dynamic> data) =>
      SpotAdminInfoStruct(
        spot: data['spot'] as String?,
        fcm: data['fcm'] as String?,
        references: data['references'] as DocumentReference?,
      );

  static SpotAdminInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? SpotAdminInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'spot': _spot,
        'fcm': _fcm,
        'references': _references,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'spot': serializeParam(
          _spot,
          ParamType.String,
        ),
        'fcm': serializeParam(
          _fcm,
          ParamType.String,
        ),
        'references': serializeParam(
          _references,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static SpotAdminInfoStruct fromSerializableMap(Map<String, dynamic> data) =>
      SpotAdminInfoStruct(
        spot: deserializeParam(
          data['spot'],
          ParamType.String,
          false,
        ),
        fcm: deserializeParam(
          data['fcm'],
          ParamType.String,
          false,
        ),
        references: deserializeParam(
          data['references'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
      );

  @override
  String toString() => 'SpotAdminInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SpotAdminInfoStruct &&
        spot == other.spot &&
        fcm == other.fcm &&
        references == other.references;
  }

  @override
  int get hashCode => const ListEquality().hash([spot, fcm, references]);
}

SpotAdminInfoStruct createSpotAdminInfoStruct({
  String? spot,
  String? fcm,
  DocumentReference? references,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SpotAdminInfoStruct(
      spot: spot,
      fcm: fcm,
      references: references,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SpotAdminInfoStruct? updateSpotAdminInfoStruct(
  SpotAdminInfoStruct? spotAdminInfo, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    spotAdminInfo
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSpotAdminInfoStructData(
  Map<String, dynamic> firestoreData,
  SpotAdminInfoStruct? spotAdminInfo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (spotAdminInfo == null) {
    return;
  }
  if (spotAdminInfo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && spotAdminInfo.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final spotAdminInfoData =
      getSpotAdminInfoFirestoreData(spotAdminInfo, forFieldValue);
  final nestedData =
      spotAdminInfoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = spotAdminInfo.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSpotAdminInfoFirestoreData(
  SpotAdminInfoStruct? spotAdminInfo, [
  bool forFieldValue = false,
]) {
  if (spotAdminInfo == null) {
    return {};
  }
  final firestoreData = mapToFirestore(spotAdminInfo.toMap());

  // Add any Firestore field values
  spotAdminInfo.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSpotAdminInfoListFirestoreData(
  List<SpotAdminInfoStruct>? spotAdminInfos,
) =>
    spotAdminInfos
        ?.map((e) => getSpotAdminInfoFirestoreData(e, true))
        .toList() ??
    [];
