import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "birthday" field.
  DateTime? _birthday;
  DateTime? get birthday => _birthday;
  bool hasBirthday() => _birthday != null;

  // "school" field.
  String? _school;
  String get school => _school ?? '';
  bool hasSchool() => _school != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "IsAdmin" field.
  bool? _isAdmin;
  bool get isAdmin => _isAdmin ?? false;
  bool hasIsAdmin() => _isAdmin != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "forWhat" field.
  String? _forWhat;
  String get forWhat => _forWhat ?? '';
  bool hasForWhat() => _forWhat != null;

  // "seatNo" field.
  int? _seatNo;
  int get seatNo => _seatNo ?? 0;
  bool hasSeatNo() => _seatNo != null;

  // "seatRequest" field.
  bool? _seatRequest;
  bool get seatRequest => _seatRequest ?? false;
  bool hasSeatRequest() => _seatRequest != null;

  // "totalPoint" field.
  int? _totalPoint;
  int get totalPoint => _totalPoint ?? 0;
  bool hasTotalPoint() => _totalPoint != null;

  // "pointListEach" field.
  List<PointInputStruct>? _pointListEach;
  List<PointInputStruct> get pointListEach => _pointListEach ?? const [];
  bool hasPointListEach() => _pointListEach != null;

  // "weeklyPointEach" field.
  int? _weeklyPointEach;
  int get weeklyPointEach => _weeklyPointEach ?? 0;
  bool hasWeeklyPointEach() => _weeklyPointEach != null;

  // "monthlyPointEach" field.
  int? _monthlyPointEach;
  int get monthlyPointEach => _monthlyPointEach ?? 0;
  bool hasMonthlyPointEach() => _monthlyPointEach != null;

  // "spot" field.
  String? _spot;
  String get spot => _spot ?? '';
  bool hasSpot() => _spot != null;

  // "fixSubjectColorList" field.
  List<FixSubjectColorStruct>? _fixSubjectColorList;
  List<FixSubjectColorStruct> get fixSubjectColorList =>
      _fixSubjectColorList ?? const [];
  bool hasFixSubjectColorList() => _fixSubjectColorList != null;

  // "userClaims" field.
  String? _userClaims;
  String get userClaims => _userClaims ?? '';
  bool hasUserClaims() => _userClaims != null;

  // "secondPin" field.
  int? _secondPin;
  int get secondPin => _secondPin ?? 0;
  bool hasSecondPin() => _secondPin != null;

  // "rankOpen" field.
  bool? _rankOpen;
  bool get rankOpen => _rankOpen ?? false;
  bool hasRankOpen() => _rankOpen != null;

  // "studyDBbackup" field.
  List<PageStateSchemaStruct>? _studyDBbackup;
  List<PageStateSchemaStruct> get studyDBbackup => _studyDBbackup ?? const [];
  bool hasStudyDBbackup() => _studyDBbackup != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _birthday = snapshotData['birthday'] as DateTime?;
    _school = snapshotData['school'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _isAdmin = snapshotData['IsAdmin'] as bool?;
    _uid = snapshotData['uid'] as String?;
    _forWhat = snapshotData['forWhat'] as String?;
    _seatNo = castToType<int>(snapshotData['seatNo']);
    _seatRequest = snapshotData['seatRequest'] as bool?;
    _totalPoint = castToType<int>(snapshotData['totalPoint']);
    _pointListEach = getStructList(
      snapshotData['pointListEach'],
      PointInputStruct.fromMap,
    );
    _weeklyPointEach = castToType<int>(snapshotData['weeklyPointEach']);
    _monthlyPointEach = castToType<int>(snapshotData['monthlyPointEach']);
    _spot = snapshotData['spot'] as String?;
    _fixSubjectColorList = getStructList(
      snapshotData['fixSubjectColorList'],
      FixSubjectColorStruct.fromMap,
    );
    _userClaims = snapshotData['userClaims'] as String?;
    _secondPin = castToType<int>(snapshotData['secondPin']);
    _rankOpen = snapshotData['rankOpen'] as bool?;
    _studyDBbackup = getStructList(
      snapshotData['studyDBbackup'],
      PageStateSchemaStruct.fromMap,
    );
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  DateTime? createdTime,
  String? phoneNumber,
  DateTime? birthday,
  String? school,
  String? photoUrl,
  bool? isAdmin,
  String? uid,
  String? forWhat,
  int? seatNo,
  bool? seatRequest,
  int? totalPoint,
  int? weeklyPointEach,
  int? monthlyPointEach,
  String? spot,
  String? userClaims,
  int? secondPin,
  bool? rankOpen,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'birthday': birthday,
      'school': school,
      'photo_url': photoUrl,
      'IsAdmin': isAdmin,
      'uid': uid,
      'forWhat': forWhat,
      'seatNo': seatNo,
      'seatRequest': seatRequest,
      'totalPoint': totalPoint,
      'weeklyPointEach': weeklyPointEach,
      'monthlyPointEach': monthlyPointEach,
      'spot': spot,
      'userClaims': userClaims,
      'secondPin': secondPin,
      'rankOpen': rankOpen,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.birthday == e2?.birthday &&
        e1?.school == e2?.school &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.isAdmin == e2?.isAdmin &&
        e1?.uid == e2?.uid &&
        e1?.forWhat == e2?.forWhat &&
        e1?.seatNo == e2?.seatNo &&
        e1?.seatRequest == e2?.seatRequest &&
        e1?.totalPoint == e2?.totalPoint &&
        listEquality.equals(e1?.pointListEach, e2?.pointListEach) &&
        e1?.weeklyPointEach == e2?.weeklyPointEach &&
        e1?.monthlyPointEach == e2?.monthlyPointEach &&
        e1?.spot == e2?.spot &&
        listEquality.equals(e1?.fixSubjectColorList, e2?.fixSubjectColorList) &&
        e1?.userClaims == e2?.userClaims &&
        e1?.secondPin == e2?.secondPin &&
        e1?.rankOpen == e2?.rankOpen &&
        listEquality.equals(e1?.studyDBbackup, e2?.studyDBbackup);
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.createdTime,
        e?.phoneNumber,
        e?.birthday,
        e?.school,
        e?.photoUrl,
        e?.isAdmin,
        e?.uid,
        e?.forWhat,
        e?.seatNo,
        e?.seatRequest,
        e?.totalPoint,
        e?.pointListEach,
        e?.weeklyPointEach,
        e?.monthlyPointEach,
        e?.spot,
        e?.fixSubjectColorList,
        e?.userClaims,
        e?.secondPin,
        e?.rankOpen,
        e?.studyDBbackup
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
