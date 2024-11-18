import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = const FlutterSecureStorage();
    await _safeInitAsync(() async {
      _insideDBStudent =
          (await secureStorage.getStringList('ff_insideDBStudent'))
                  ?.map((x) {
                    try {
                      return PageStateSchemaStruct.fromSerializableMap(
                          jsonDecode(x));
                    } catch (e) {
                      print("Can't decode persisted data type. Error: $e.");
                      return null;
                    }
                  })
                  .withoutNulls
                  .toList() ??
              _insideDBStudent;
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_pageStateSchemaVariable') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_pageStateSchemaVariable') ??
                  '{}';
          _pageStateSchemaVariable = PageStateSchemaStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_changeChecker') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_changeChecker') ?? '{}';
          _changeChecker = PageStateSchemaStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      _plannerDateSelected =
          await secureStorage.read(key: 'ff_plannerDateSelected') != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  (await secureStorage.getInt('ff_plannerDateSelected'))!)
              : _plannerDateSelected;
    });
    await _safeInitAsync(() async {
      _PlannerStartTime = await secureStorage.getInt('ff_PlannerStartTime') ??
          _PlannerStartTime;
    });
    await _safeInitAsync(() async {
      _PlannerEndTime =
          await secureStorage.getInt('ff_PlannerEndTime') ?? _PlannerEndTime;
    });
    await _safeInitAsync(() async {
      _maxNumberOfPlan =
          await secureStorage.getInt('ff_maxNumberOfPlan') ?? _maxNumberOfPlan;
    });
    await _safeInitAsync(() async {
      _rapidClickAvoidCount =
          await secureStorage.getInt('ff_rapidClickAvoidCount') ??
              _rapidClickAvoidCount;
    });
    await _safeInitAsync(() async {
      _dDayAppState = (await secureStorage.getStringList('ff_dDayAppState'))
              ?.map((x) {
                try {
                  return DDaySchemaStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _dDayAppState;
    });
    await _safeInitAsync(() async {
      _dateselectSafety =
          await secureStorage.read(key: 'ff_dateselectSafety') != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  (await secureStorage.getInt('ff_dateselectSafety'))!)
              : _dateselectSafety;
    });
    await _safeInitAsync(() async {
      _fixSubjectColorAppState =
          (await secureStorage.getStringList('ff_fixSubjectColorAppState'))
                  ?.map((x) {
                    try {
                      return FixSubjectColorStruct.fromSerializableMap(
                          jsonDecode(x));
                    } catch (e) {
                      print("Can't decode persisted data type. Error: $e.");
                      return null;
                    }
                  })
                  .withoutNulls
                  .toList() ??
              _fixSubjectColorAppState;
    });
    await _safeInitAsync(() async {
      _weeklyTimeTableChoice =
          (await secureStorage.getStringList('ff_weeklyTimeTableChoice'))
                  ?.map((x) {
                    try {
                      return WeeklyTimeTableStruct.fromSerializableMap(
                          jsonDecode(x));
                    } catch (e) {
                      print("Can't decode persisted data type. Error: $e.");
                      return null;
                    }
                  })
                  .withoutNulls
                  .toList() ??
              _weeklyTimeTableChoice;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  List<PageStateSchemaStruct> _insideDBStudent = [];
  List<PageStateSchemaStruct> get insideDBStudent => _insideDBStudent;
  set insideDBStudent(List<PageStateSchemaStruct> value) {
    _insideDBStudent = value;
    secureStorage.setStringList(
        'ff_insideDBStudent', value.map((x) => x.serialize()).toList());
  }

  void deleteInsideDBStudent() {
    secureStorage.delete(key: 'ff_insideDBStudent');
  }

  void addToInsideDBStudent(PageStateSchemaStruct value) {
    insideDBStudent.add(value);
    secureStorage.setStringList('ff_insideDBStudent',
        _insideDBStudent.map((x) => x.serialize()).toList());
  }

  void removeFromInsideDBStudent(PageStateSchemaStruct value) {
    insideDBStudent.remove(value);
    secureStorage.setStringList('ff_insideDBStudent',
        _insideDBStudent.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromInsideDBStudent(int index) {
    insideDBStudent.removeAt(index);
    secureStorage.setStringList('ff_insideDBStudent',
        _insideDBStudent.map((x) => x.serialize()).toList());
  }

  void updateInsideDBStudentAtIndex(
    int index,
    PageStateSchemaStruct Function(PageStateSchemaStruct) updateFn,
  ) {
    insideDBStudent[index] = updateFn(_insideDBStudent[index]);
    secureStorage.setStringList('ff_insideDBStudent',
        _insideDBStudent.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInInsideDBStudent(int index, PageStateSchemaStruct value) {
    insideDBStudent.insert(index, value);
    secureStorage.setStringList('ff_insideDBStudent',
        _insideDBStudent.map((x) => x.serialize()).toList());
  }

  PageStateSchemaStruct _pageStateSchemaVariable = PageStateSchemaStruct();
  PageStateSchemaStruct get pageStateSchemaVariable => _pageStateSchemaVariable;
  set pageStateSchemaVariable(PageStateSchemaStruct value) {
    _pageStateSchemaVariable = value;
    secureStorage.setString('ff_pageStateSchemaVariable', value.serialize());
  }

  void deletePageStateSchemaVariable() {
    secureStorage.delete(key: 'ff_pageStateSchemaVariable');
  }

  void updatePageStateSchemaVariableStruct(
      Function(PageStateSchemaStruct) updateFn) {
    updateFn(_pageStateSchemaVariable);
    secureStorage.setString(
        'ff_pageStateSchemaVariable', _pageStateSchemaVariable.serialize());
  }

  PageStateSchemaStruct _changeChecker = PageStateSchemaStruct();
  PageStateSchemaStruct get changeChecker => _changeChecker;
  set changeChecker(PageStateSchemaStruct value) {
    _changeChecker = value;
    secureStorage.setString('ff_changeChecker', value.serialize());
  }

  void deleteChangeChecker() {
    secureStorage.delete(key: 'ff_changeChecker');
  }

  void updateChangeCheckerStruct(Function(PageStateSchemaStruct) updateFn) {
    updateFn(_changeChecker);
    secureStorage.setString('ff_changeChecker', _changeChecker.serialize());
  }

  DateTime? _plannerDateSelected;
  DateTime? get plannerDateSelected => _plannerDateSelected;
  set plannerDateSelected(DateTime? value) {
    _plannerDateSelected = value;
    value != null
        ? secureStorage.setInt(
            'ff_plannerDateSelected', value.millisecondsSinceEpoch)
        : secureStorage.remove('ff_plannerDateSelected');
  }

  void deletePlannerDateSelected() {
    secureStorage.delete(key: 'ff_plannerDateSelected');
  }

  int _PlannerStartTime = 9;
  int get PlannerStartTime => _PlannerStartTime;
  set PlannerStartTime(int value) {
    _PlannerStartTime = value;
    secureStorage.setInt('ff_PlannerStartTime', value);
  }

  void deletePlannerStartTime() {
    secureStorage.delete(key: 'ff_PlannerStartTime');
  }

  int _PlannerEndTime = 22;
  int get PlannerEndTime => _PlannerEndTime;
  set PlannerEndTime(int value) {
    _PlannerEndTime = value;
    secureStorage.setInt('ff_PlannerEndTime', value);
  }

  void deletePlannerEndTime() {
    secureStorage.delete(key: 'ff_PlannerEndTime');
  }

  bool _timeIsGoing = false;
  bool get timeIsGoing => _timeIsGoing;
  set timeIsGoing(bool value) {
    _timeIsGoing = value;
  }

  DateTime? _TimeNow;
  DateTime? get TimeNow => _TimeNow;
  set TimeNow(DateTime? value) {
    _TimeNow = value;
  }

  int _maxNumberOfPlan = 10;
  int get maxNumberOfPlan => _maxNumberOfPlan;
  set maxNumberOfPlan(int value) {
    _maxNumberOfPlan = value;
    secureStorage.setInt('ff_maxNumberOfPlan', value);
  }

  void deleteMaxNumberOfPlan() {
    secureStorage.delete(key: 'ff_maxNumberOfPlan');
  }

  int _rapidClickAvoidCount = 0;
  int get rapidClickAvoidCount => _rapidClickAvoidCount;
  set rapidClickAvoidCount(int value) {
    _rapidClickAvoidCount = value;
    secureStorage.setInt('ff_rapidClickAvoidCount', value);
  }

  void deleteRapidClickAvoidCount() {
    secureStorage.delete(key: 'ff_rapidClickAvoidCount');
  }

  List<DDaySchemaStruct> _dDayAppState = [
    DDaySchemaStruct.fromSerializableMap(jsonDecode(
        '{\"dDay\":\"1762981200000\",\"isImportant\":\"false\",\"ddayInfo\":\"2026학년도 수능\"}'))
  ];
  List<DDaySchemaStruct> get dDayAppState => _dDayAppState;
  set dDayAppState(List<DDaySchemaStruct> value) {
    _dDayAppState = value;
    secureStorage.setStringList(
        'ff_dDayAppState', value.map((x) => x.serialize()).toList());
  }

  void deleteDDayAppState() {
    secureStorage.delete(key: 'ff_dDayAppState');
  }

  void addToDDayAppState(DDaySchemaStruct value) {
    dDayAppState.add(value);
    secureStorage.setStringList(
        'ff_dDayAppState', _dDayAppState.map((x) => x.serialize()).toList());
  }

  void removeFromDDayAppState(DDaySchemaStruct value) {
    dDayAppState.remove(value);
    secureStorage.setStringList(
        'ff_dDayAppState', _dDayAppState.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromDDayAppState(int index) {
    dDayAppState.removeAt(index);
    secureStorage.setStringList(
        'ff_dDayAppState', _dDayAppState.map((x) => x.serialize()).toList());
  }

  void updateDDayAppStateAtIndex(
    int index,
    DDaySchemaStruct Function(DDaySchemaStruct) updateFn,
  ) {
    dDayAppState[index] = updateFn(_dDayAppState[index]);
    secureStorage.setStringList(
        'ff_dDayAppState', _dDayAppState.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInDDayAppState(int index, DDaySchemaStruct value) {
    dDayAppState.insert(index, value);
    secureStorage.setStringList(
        'ff_dDayAppState', _dDayAppState.map((x) => x.serialize()).toList());
  }

  int _currentIndexIDParameter = 0;
  int get currentIndexIDParameter => _currentIndexIDParameter;
  set currentIndexIDParameter(int value) {
    _currentIndexIDParameter = value;
  }

  DateTime? _dateselectSafety;
  DateTime? get dateselectSafety => _dateselectSafety;
  set dateselectSafety(DateTime? value) {
    _dateselectSafety = value;
    value != null
        ? secureStorage.setInt(
            'ff_dateselectSafety', value.millisecondsSinceEpoch)
        : secureStorage.remove('ff_dateselectSafety');
  }

  void deleteDateselectSafety() {
    secureStorage.delete(key: 'ff_dateselectSafety');
  }

  int _seatNoSelected = 0;
  int get seatNoSelected => _seatNoSelected;
  set seatNoSelected(int value) {
    _seatNoSelected = value;
  }

  DocumentReference? _loadedDataID;
  DocumentReference? get loadedDataID => _loadedDataID;
  set loadedDataID(DocumentReference? value) {
    _loadedDataID = value;
  }

  String _teachersNote = '';
  String get teachersNote => _teachersNote;
  set teachersNote(String value) {
    _teachersNote = value;
  }

  String _adminUserName = '';
  String get adminUserName => _adminUserName;
  set adminUserName(String value) {
    _adminUserName = value;
  }

  List<String> _spotInfoAppstate = [];
  List<String> get spotInfoAppstate => _spotInfoAppstate;
  set spotInfoAppstate(List<String> value) {
    _spotInfoAppstate = value;
  }

  void addToSpotInfoAppstate(String value) {
    spotInfoAppstate.add(value);
  }

  void removeFromSpotInfoAppstate(String value) {
    spotInfoAppstate.remove(value);
  }

  void removeAtIndexFromSpotInfoAppstate(int index) {
    spotInfoAppstate.removeAt(index);
  }

  void updateSpotInfoAppstateAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    spotInfoAppstate[index] = updateFn(_spotInfoAppstate[index]);
  }

  void insertAtIndexInSpotInfoAppstate(int index, String value) {
    spotInfoAppstate.insert(index, value);
  }

  List<FixSubjectColorStruct> _fixSubjectColorAppState = [];
  List<FixSubjectColorStruct> get fixSubjectColorAppState =>
      _fixSubjectColorAppState;
  set fixSubjectColorAppState(List<FixSubjectColorStruct> value) {
    _fixSubjectColorAppState = value;
    secureStorage.setStringList(
        'ff_fixSubjectColorAppState', value.map((x) => x.serialize()).toList());
  }

  void deleteFixSubjectColorAppState() {
    secureStorage.delete(key: 'ff_fixSubjectColorAppState');
  }

  void addToFixSubjectColorAppState(FixSubjectColorStruct value) {
    fixSubjectColorAppState.add(value);
    secureStorage.setStringList('ff_fixSubjectColorAppState',
        _fixSubjectColorAppState.map((x) => x.serialize()).toList());
  }

  void removeFromFixSubjectColorAppState(FixSubjectColorStruct value) {
    fixSubjectColorAppState.remove(value);
    secureStorage.setStringList('ff_fixSubjectColorAppState',
        _fixSubjectColorAppState.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromFixSubjectColorAppState(int index) {
    fixSubjectColorAppState.removeAt(index);
    secureStorage.setStringList('ff_fixSubjectColorAppState',
        _fixSubjectColorAppState.map((x) => x.serialize()).toList());
  }

  void updateFixSubjectColorAppStateAtIndex(
    int index,
    FixSubjectColorStruct Function(FixSubjectColorStruct) updateFn,
  ) {
    fixSubjectColorAppState[index] = updateFn(_fixSubjectColorAppState[index]);
    secureStorage.setStringList('ff_fixSubjectColorAppState',
        _fixSubjectColorAppState.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInFixSubjectColorAppState(
      int index, FixSubjectColorStruct value) {
    fixSubjectColorAppState.insert(index, value);
    secureStorage.setStringList('ff_fixSubjectColorAppState',
        _fixSubjectColorAppState.map((x) => x.serialize()).toList());
  }

  List<DailyInfoEachStruct> _dailyInfoList = [
    DailyInfoEachStruct.fromSerializableMap(jsonDecode(
        '{\"starttime\":\"1729627975812\",\"endtime\":\"1729627975812\",\"colorPicked\":\"#0000\",\"subject\":\"Hello World\",\"details\":\"Hello World\",\"restinfo\":\"Hello World\"}'))
  ];
  List<DailyInfoEachStruct> get dailyInfoList => _dailyInfoList;
  set dailyInfoList(List<DailyInfoEachStruct> value) {
    _dailyInfoList = value;
  }

  void addToDailyInfoList(DailyInfoEachStruct value) {
    dailyInfoList.add(value);
  }

  void removeFromDailyInfoList(DailyInfoEachStruct value) {
    dailyInfoList.remove(value);
  }

  void removeAtIndexFromDailyInfoList(int index) {
    dailyInfoList.removeAt(index);
  }

  void updateDailyInfoListAtIndex(
    int index,
    DailyInfoEachStruct Function(DailyInfoEachStruct) updateFn,
  ) {
    dailyInfoList[index] = updateFn(_dailyInfoList[index]);
  }

  void insertAtIndexInDailyInfoList(int index, DailyInfoEachStruct value) {
    dailyInfoList.insert(index, value);
  }

  List<WeeklyTimeTableStruct> _weeklyTimeTableChoice = [];
  List<WeeklyTimeTableStruct> get weeklyTimeTableChoice =>
      _weeklyTimeTableChoice;
  set weeklyTimeTableChoice(List<WeeklyTimeTableStruct> value) {
    _weeklyTimeTableChoice = value;
    secureStorage.setStringList(
        'ff_weeklyTimeTableChoice', value.map((x) => x.serialize()).toList());
  }

  void deleteWeeklyTimeTableChoice() {
    secureStorage.delete(key: 'ff_weeklyTimeTableChoice');
  }

  void addToWeeklyTimeTableChoice(WeeklyTimeTableStruct value) {
    weeklyTimeTableChoice.add(value);
    secureStorage.setStringList('ff_weeklyTimeTableChoice',
        _weeklyTimeTableChoice.map((x) => x.serialize()).toList());
  }

  void removeFromWeeklyTimeTableChoice(WeeklyTimeTableStruct value) {
    weeklyTimeTableChoice.remove(value);
    secureStorage.setStringList('ff_weeklyTimeTableChoice',
        _weeklyTimeTableChoice.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromWeeklyTimeTableChoice(int index) {
    weeklyTimeTableChoice.removeAt(index);
    secureStorage.setStringList('ff_weeklyTimeTableChoice',
        _weeklyTimeTableChoice.map((x) => x.serialize()).toList());
  }

  void updateWeeklyTimeTableChoiceAtIndex(
    int index,
    WeeklyTimeTableStruct Function(WeeklyTimeTableStruct) updateFn,
  ) {
    weeklyTimeTableChoice[index] = updateFn(_weeklyTimeTableChoice[index]);
    secureStorage.setStringList('ff_weeklyTimeTableChoice',
        _weeklyTimeTableChoice.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInWeeklyTimeTableChoice(
      int index, WeeklyTimeTableStruct value) {
    weeklyTimeTableChoice.insert(index, value);
    secureStorage.setStringList('ff_weeklyTimeTableChoice',
        _weeklyTimeTableChoice.map((x) => x.serialize()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return const CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: const ListToCsvConverter().convert([value]));
}
