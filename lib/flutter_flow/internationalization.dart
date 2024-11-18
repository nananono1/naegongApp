import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['ko', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? koText = '',
    String? enText = '',
  }) =>
      [koText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    '1a7lrdwb': {
      'ko': ' 학생 - ',
      'en': 'student -',
    },
    'a51pmt39': {
      'ko': ' 번 좌석(',
      'en': 'Seat number(',
    },
    '0kqws3hh': {
      'ko': ')',
      'en': ')',
    },
    'oozt6r9f': {
      'ko': 'Delete',
      'en': 'Delete',
    },
    'jolze01o': {
      'ko': '-',
      'en': '-',
    },
    'lqsd42zw': {
      'ko': '\n',
      'en': '',
    },
    'jw6d5xt7': {
      'ko': ' 포인트 ',
      'en': 'point',
    },
    '01pjgd4g': {
      'ko': '-',
      'en': '-',
    },
    'rc3590hh': {
      'ko': '\n',
      'en': '',
    },
    '4ptq001w': {
      'ko': ' 포인트 ',
      'en': 'point',
    },
    'x723tryd': {
      'ko': '내공에듀센터',
      'en': 'Naegong Education Center',
    },
    's252ggsd': {
      'ko': 'Platform Navigation',
      'en': 'Platform Navigation',
    },
    'tduf5mac': {
      'ko': '메인메뉴',
      'en': 'Main Menu',
    },
    '7nkumn1c': {
      'ko': '플래너확인',
      'en': 'Check planner',
    },
    'wvirljok': {
      'ko': '시간표 관리',
      'en': 'Schedule Management',
    },
    '9je02ug5': {
      'ko': '공부시간분석',
      'en': 'Study time analysis',
    },
    '84jqczir': {
      'ko': 'Settings',
      'en': 'Settings',
    },
    'dzlqrywj': {
      'ko': '개인설정',
      'en': 'Personal Settings',
    },
    'hye9vdir': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // auth_WelcomeScreen
  {
    'r2ua082y': {
      'ko': '내공관리형스터디카페',
      'en': 'Study cafe with internal energy management',
    },
    '7x29s7qo': {
      'ko': '내안의 공부 감각',
      'en': 'The sense of study within me',
    },
    '4cqtdzwg': {
      'ko': 'Awesome Recipes',
      'en': 'Awesome Recipes',
    },
    '0r3afhpc': {
      'ko': 'I have some great food options here!! Yum yum!!',
      'en': 'I have some great food options here!! Yum yum!!',
    },
    'psh28zm4': {
      'ko': 'Personalized recipe discovery',
      'en': 'Personalized recipe discovery',
    },
    '7u7w5uiq': {
      'ko': 'I have some great food options here!! Yum yum!!',
      'en': 'I have some great food options here!! Yum yum!!',
    },
    'bnjg4ufq': {
      'ko': 'Login',
      'en': 'Login',
    },
    'ea5wkc6s': {
      'ko': 'Create an Account',
      'en': 'Create an Account',
    },
    'wjl334q3': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // auth_Create
  {
    'vwwz8e8n': {
      'ko': '회원가입',
      'en': 'join the membership',
    },
    'qey1ca7r': {
      'ko': '이메일',
      'en': 'email',
    },
    'y8ccjtbq': {
      'ko': '비밀번호',
      'en': 'password',
    },
    '6ocyk9tw': {
      'ko': '2차 비밀번호(6자리)',
      'en': 'Secondary password (6 digits)',
    },
    '8sb4kwhq': {
      'ko': '학생명',
      'en': 'Student name',
    },
    's179xcqi': {
      'ko': '학생',
      'en': 'student',
    },
    'bc0rgaqo': {
      'ko': '재수',
      'en': 'Good luck',
    },
    'yolq9242': {
      'ko': '공시',
      'en': 'Public notice',
    },
    'zomnxy9g': {
      'ko': '일반',
      'en': 'common',
    },
    '68p1h5zx': {
      'ko': '신분',
      'en': 'station in life',
    },
    'hu049jfk': {
      'ko': 'Search for an item...',
      'en': 'Search for an item...',
    },
    'nhut6xey': {
      'ko': '학교명(00고등학교)',
      'en': 'School name (00 High School)',
    },
    'nw2l1al6': {
      'ko': '학생',
      'en': 'student',
    },
    'fcub2cim': {
      'ko': '재수',
      'en': 'Good luck',
    },
    'ahbyrhjr': {
      'ko': '공시',
      'en': 'Public notice',
    },
    'jbjpa020': {
      'ko': '일반',
      'en': 'common',
    },
    'qsuxqay6': {
      'ko': '센터명',
      'en': 'Center name',
    },
    '0y0qbxmp': {
      'ko': 'Search for an item...',
      'en': 'Search for an item...',
    },
    't8krrw6p': {
      'ko': 'Create Account',
      'en': 'Create Account',
    },
    'n1x87mxb': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // auth_Login
  {
    'wwt0hnq0': {
      'ko': 'Get to my account',
      'en': 'Get to my account',
    },
    'u2yaiocv': {
      'ko': 'Access your wonderful things by logging in below.',
      'en': 'Access your wonderful things by logging in below.',
    },
    '1avlqts8': {
      'ko': 'Email Address',
      'en': 'Email Address',
    },
    'emin4cgb': {
      'ko': 'Password',
      'en': 'Password',
    },
    'gzutj348': {
      'ko': 'Forgot Password?',
      'en': 'Forgot Password?',
    },
    'faosfaxw': {
      'ko': 'Login',
      'en': 'Login',
    },
    'mqw4h0pm': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // auth_ForgotPassword
  {
    'jt9ln5h4': {
      'ko': 'Forgot Password',
      'en': 'Forgot Password',
    },
    's4fd6liv': {
      'ko': 'We will send you a reset link.',
      'en': 'We will send you a reset link.',
    },
    'l1zskwdh': {
      'ko': 'Email Address',
      'en': 'Email Address',
    },
    'ukox13i6': {
      'ko': 'Send Link',
      'en': 'Send Link',
    },
    'v3vd3a6a': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // timerPage
  {
    'yn9qzu7p': {
      'ko': '현재공부기록',
      'en': 'Current study record',
    },
    'pbdmrcnn': {
      'ko': '시작시각',
      'en': 'Start time',
    },
    'h3garjdt': {
      'ko': '종료시각',
      'en': 'End time',
    },
    'usbfyh6i': {
      'ko': '공부시간',
      'en': 'Study time',
    },
    'fp16p9bf': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // backup
  {
    'yucs135q': {
      'ko': 'Page Title',
      'en': 'Page Title',
    },
    'cjz5nhl0': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // userPage
  {
    'v6h92yl4': {
      'ko': '좌석 만료일 : ',
      'en': 'Seat Expiration Date:',
    },
    'lgn3ge75': {
      'ko': 'David.j@gmail.com',
      'en': 'David.j@gmail.com',
    },
    'pnv7vi02': {
      'ko': '포인트 관리',
      'en': 'Point Management',
    },
    '87hijuag': {
      'ko': '대표 과목 설정',
      'en': 'Setting representative subjects',
    },
    '57os1gab': {
      'ko': 'Help Center',
      'en': 'Help Center',
    },
    'y0svwee2': {
      'ko': 'Settings',
      'en': 'Settings',
    },
    '9e51q603': {
      'ko': '알림설정',
      'en': 'Notification settings',
    },
    'xsx3jlfr': {
      'ko': '잠금설정',
      'en': 'Lock settings',
    },
    'wgfti7v9': {
      'ko': '개인정보처리방침(Privacy Policy)',
      'en': 'Privacy Policy',
    },
    'd3r0jmd3': {
      'ko': '이용약관(Terms of Service)',
      'en': 'Terms of Service',
    },
    '7e88zrrv': {
      'ko': 'Log out of account',
      'en': 'Log out of account',
    },
    'u4wo1z0p': {
      'ko': '내공에듀센터',
      'en': 'Naegong Education Center',
    },
    'drkv8ol0': {
      'ko': 'Platform Navigation',
      'en': 'Platform Navigation',
    },
    'n9z48dp1': {
      'ko': '메인메뉴',
      'en': 'Main Menu',
    },
    'i3jx9amg': {
      'ko': '플래너확인',
      'en': 'Check planner',
    },
    'lbgp0ie3': {
      'ko': '시간표 관리',
      'en': 'Schedule Management',
    },
    'ohm3agld': {
      'ko': '공부시간분석',
      'en': 'Study time analysis',
    },
    'dflh7b2r': {
      'ko': 'Settings',
      'en': 'Settings',
    },
    '8u40etk8': {
      'ko': '개인설정',
      'en': 'Personal Settings',
    },
    'z2ilxzkd': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // Settings1Notifications
  {
    '6s11dqjv': {
      'ko': 'Settings Page',
      'en': 'Settings Page',
    },
    '8zzszftr': {
      'ko':
          'Choose what notifcations you want to recieve below and we will update the settings.',
      'en':
          'Choose what notifications you want to recieve below and we will update the settings.',
    },
    'o3p16zui': {
      'ko': 'Push Notifications',
      'en': 'Push Notifications',
    },
    'g67aklao': {
      'ko':
          'Receive Push notifications from our application on a semi regular basis.',
      'en':
          'Receive Push notifications from our application on a semi regular basis.',
    },
    'lo96ey9k': {
      'ko': 'Email Notifications',
      'en': 'Email Notifications',
    },
    'xnvktf2s': {
      'ko':
          'Receive email notifications from our marketing team about new features.',
      'en':
          'Receive email notifications from our marketing team about new features.',
    },
    'vgcm1uoc': {
      'ko': 'Location Services',
      'en': 'Location Services',
    },
    'wswdulbv': {
      'ko':
          'Allow us to track your location, this helps keep track of spending and keeps you safe.',
      'en':
          'Allow us to track your location, this helps keep track of spending and keeps you safe.',
    },
    'wltnhq1t': {
      'ko': 'Change Changes',
      'en': 'Change Changes',
    },
    'sf7fr1gp': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // analyticsPage
  {
    'pk4vbqp0': {
      'ko': 'Home',
      'en': '',
    },
  },
  // adminSeatConfigure
  {
    'ag9ll4hs': {
      'ko': '내공관리자',
      'en': '',
    },
    's44swigz': {
      'ko': 'Platform Navigation',
      'en': '',
    },
    'q79pxdz1': {
      'ko': '플래너확인',
      'en': '',
    },
    'zxv0talx': {
      'ko': '시간표 관리',
      'en': '',
    },
    'clqqshru': {
      'ko': 'Projects',
      'en': '',
    },
    '0panmh7u': {
      'ko': 'Settings',
      'en': '',
    },
    'vhx2suyi': {
      'ko': '좌석배정',
      'en': '',
    },
    '5vdirxp5': {
      'ko': '좌석변경',
      'en': '',
    },
    '3i4ft0rt': {
      'ko': '포인트 관리',
      'en': '',
    },
    'hnykkumr': {
      'ko': '좌석배정',
      'en': '',
    },
    'bkrs2gwz': {
      'ko': '학생들의 좌석을 배정해주세요',
      'en': '',
    },
    'w79t7x85': {
      'ko': 'Option 1',
      'en': '',
    },
    'h077cm7c': {
      'ko': 'Option 2',
      'en': '',
    },
    'vielfpih': {
      'ko': 'Option 3',
      'en': '',
    },
    '9jf97nc8': {
      'ko': 'Select...',
      'en': '',
    },
    '73tn7mkv': {
      'ko': 'Search...',
      'en': '',
    },
    'lub0npsf': {
      'ko': '이름',
      'en': '',
    },
    'oe5ssdb2': {
      'ko': '학교',
      'en': '',
    },
    'd7cfzvz3': {
      'ko': '등록일',
      'en': '',
    },
    'pfv9g4wj': {
      'ko': '지점',
      'en': '',
    },
    'heoadc6x': {
      'ko': '좌석배정',
      'en': '',
    },
    'mm12nq0w': {
      'ko': 'Home',
      'en': '',
    },
  },
  // adminplannerPage
  {
    'mzvael5o': {
      'ko': '내공관리자',
      'en': '',
    },
    '5rzxoa40': {
      'ko': 'Platform Navigation',
      'en': '',
    },
    'wk76jdxg': {
      'ko': '플래너확인',
      'en': '',
    },
    'i7j21km5': {
      'ko': '시간표 관리',
      'en': '',
    },
    'uenbupyn': {
      'ko': 'Projects',
      'en': '',
    },
    '09p3zibs': {
      'ko': 'Settings',
      'en': '',
    },
    'qfsml14d': {
      'ko': '좌석배정',
      'en': '',
    },
    'z863rf48': {
      'ko': '좌석변경',
      'en': '',
    },
    'kiezxc4g': {
      'ko': '포인트 관리',
      'en': '',
    },
    '1hseyro0': {
      'ko': '플래너 확인',
      'en': '',
    },
    '5sazzl33': {
      'ko': '제출된 플래너를 승인 및 저장하세요',
      'en': '',
    },
    'mpvjtct5': {
      'ko': 'Option 1',
      'en': '',
    },
    'l713i9hq': {
      'ko': 'Option 2',
      'en': '',
    },
    'alvdjsza': {
      'ko': 'Option 3',
      'en': '',
    },
    '6cvp4sp5': {
      'ko': 'Select...',
      'en': '',
    },
    'q1ha6inv': {
      'ko': 'Search...',
      'en': '',
    },
    'aekdiqw1': {
      'ko': '이름',
      'en': '',
    },
    'mtcviyw8': {
      'ko': '좌석번호',
      'en': '',
    },
    '4h0jy67h': {
      'ko': '지점',
      'en': '',
    },
    'i6u1bcvo': {
      'ko': '날짜',
      'en': '',
    },
    '0kx4a6xu': {
      'ko': '확인여부',
      'en': '',
    },
    '19y03ooa': {
      'ko': 'Home',
      'en': '',
    },
  },
  // adminSeatChange
  {
    'yxg4z0bq': {
      'ko': '내공관리자',
      'en': '',
    },
    'fdfmw9o1': {
      'ko': 'Platform Navigation',
      'en': '',
    },
    'k8dx31tp': {
      'ko': '플래너확인',
      'en': '',
    },
    'uu8tvgio': {
      'ko': '시간표 관리',
      'en': '',
    },
    'p8an595x': {
      'ko': 'Projects',
      'en': '',
    },
    'ejauuwss': {
      'ko': 'Settings',
      'en': '',
    },
    'x5xmx2bl': {
      'ko': '좌석배정',
      'en': '',
    },
    'tsrf5m0q': {
      'ko': '좌석변경',
      'en': '',
    },
    'nuanz0qd': {
      'ko': '포인트 관리',
      'en': '',
    },
    'nc4hnwd2': {
      'ko': '좌석변경',
      'en': '',
    },
    'pf122zv1': {
      'ko': '학생들의 좌석을 배정해주세요',
      'en': '',
    },
    'g6ltl5ki': {
      'ko': 'Option 1',
      'en': '',
    },
    'llsri1hg': {
      'ko': 'Option 2',
      'en': '',
    },
    'ph7e9caj': {
      'ko': 'Option 3',
      'en': '',
    },
    '3alkahlo': {
      'ko': 'Select...',
      'en': '',
    },
    'oqhn20d7': {
      'ko': 'Search...',
      'en': '',
    },
    '07h1ppri': {
      'ko': '좌석번호',
      'en': '',
    },
    'e33ty6so': {
      'ko': '학생명',
      'en': '',
    },
    '0o42zkcd': {
      'ko': '지점',
      'en': '',
    },
    '117fq338': {
      'ko': '좌석수정 / 삭제',
      'en': '',
    },
    'yx070d1u': {
      'ko': 'Home',
      'en': '',
    },
  },
  // adminPointConfigurePage
  {
    'b7gl8bg8': {
      'ko': '내공관리자',
      'en': '',
    },
    'l932eufl': {
      'ko': 'Platform Navigation',
      'en': '',
    },
    '3b03trlw': {
      'ko': '플래너확인',
      'en': '',
    },
    'u6nvgb5v': {
      'ko': '시간표 관리',
      'en': '',
    },
    'liexrbj7': {
      'ko': 'Projects',
      'en': '',
    },
    '6eg6ugzu': {
      'ko': 'Settings',
      'en': '',
    },
    'h0975xl1': {
      'ko': '좌석배정',
      'en': '',
    },
    'k7ogoguj': {
      'ko': '좌석변경',
      'en': '',
    },
    'rrbdik3g': {
      'ko': '포인트 관리',
      'en': '',
    },
    'tl0vm0y8': {
      'ko': '포인트 관리',
      'en': '',
    },
    'fu50h7df': {
      'ko': '지점 및 좌석을 입력 후 검색해주세요',
      'en': '',
    },
    'ousujg1a': {
      'ko': 'Option 1',
      'en': '',
    },
    'f8hyslll': {
      'ko': 'Option 2',
      'en': '',
    },
    'a79jvvez': {
      'ko': 'Option 3',
      'en': '',
    },
    'jff0atkx': {
      'ko': '지점선택',
      'en': '',
    },
    'tpvht1pe': {
      'ko': 'Search...',
      'en': '',
    },
    'fqp5p5of': {
      'ko': '좌석번호 :',
      'en': '',
    },
    'smpn7pt2': {
      'ko': '',
      'en': '',
    },
    'uydav5rf': {
      'ko': '좌석번호',
      'en': '',
    },
    'xonku1zk': {
      'ko': '학생명',
      'en': '',
    },
    '8so0jhca': {
      'ko': '현재 점수',
      'en': '',
    },
    'fi1brrzh': {
      'ko': '포인트 부여/차감',
      'en': '',
    },
    '5nwa05uf': {
      'ko': '기록조회',
      'en': '',
    },
    '28rf7q7f': {
      'ko': 'Home',
      'en': '',
    },
  },
  // studentAnalytics
  {
    'frucqgf2': {
      'ko': 'TextField',
      'en': '',
    },
    'b24ell2a': {
      'ko': 'Page Title',
      'en': '',
    },
    '4anifbmv': {
      'ko': 'Home',
      'en': '',
    },
  },
  // setBestColorPage
  {
    'q96uyd25': {
      'ko': 'TextField',
      'en': '',
    },
    'p546677a': {
      'ko': 'colorpicker',
      'en': '',
    },
    '32rx88xv': {
      'ko': 'save',
      'en': '',
    },
    'u8zbcxg0': {
      'ko': 'Page Title',
      'en': '',
    },
    'ioxwd1ek': {
      'ko': 'Home',
      'en': '',
    },
  },
  // pageeee
  {
    '5qnipkbt': {
      'ko': '내공에듀센터',
      'en': '',
    },
    '4t3g5d59': {
      'ko': 'Platform Navigation',
      'en': '',
    },
    'xo08j24a': {
      'ko': '메인메뉴',
      'en': '',
    },
    '1dl3o6ls': {
      'ko': '플래너확인',
      'en': '',
    },
    'wcgnbbjx': {
      'ko': '시간표 관리',
      'en': '',
    },
    'xkumutni': {
      'ko': '공부시간분석',
      'en': '',
    },
    'pmetb3iw': {
      'ko': 'Settings',
      'en': '',
    },
    'zgmkf3a2': {
      'ko': '개인설정',
      'en': '',
    },
    '7mbntnn0': {
      'ko': '수면시간 : ',
      'en': '',
    },
    'tngtwzm4': {
      'ko': '기상시간 : ',
      'en': '',
    },
    '074bs2m3': {
      'ko': '목표공부시간 : ',
      'en': '',
    },
    't4167kpj': {
      'ko': '현재공부시간 : ',
      'en': '',
    },
    'dpz3fo5y': {
      'ko': '오늘의 한마디 :',
      'en': '',
    },
    'nvya9jrv': {
      'ko': '',
      'en': '',
    },
    '02xp35km': {
      'ko': '오늘의 다짐, 고민거리, 건의사항등\n하고싶은 말을 자유롭게 적어주세요!',
      'en': '',
    },
    'rnhw2tjz': {
      'ko': 'TO DO LIST',
      'en': '',
    },
    'v23o1msf': {
      'ko': 'STUDY PLAN',
      'en': '',
    },
    '0l4ewjpy': {
      'ko': 'SUB',
      'en': '',
    },
    'p8qs7y62': {
      'ko': 'TimeTable',
      'en': '',
    },
    '7lv7ybg6': {
      'ko': '5',
      'en': '',
    },
    '09esbp58': {
      'ko': '6',
      'en': '',
    },
    'wvut6nhm': {
      'ko': '7',
      'en': '',
    },
    '1kc8ga7d': {
      'ko': '8',
      'en': '',
    },
    'qaj4uocp': {
      'ko': '9',
      'en': '',
    },
    'm437mwys': {
      'ko': '10',
      'en': '',
    },
    'i0f3j9x7': {
      'ko': '11',
      'en': '',
    },
    '9oxtcuoz': {
      'ko': '12',
      'en': '',
    },
    'b0udfzo8': {
      'ko': '13',
      'en': '',
    },
    'bvsoktuz': {
      'ko': '14',
      'en': '',
    },
    'vbanbl5d': {
      'ko': '15',
      'en': '',
    },
    'fjrw3dgd': {
      'ko': '16',
      'en': '',
    },
    'y5z9alkb': {
      'ko': '17',
      'en': '',
    },
    '056dfs2h': {
      'ko': '18',
      'en': '',
    },
    '6yjwdhib': {
      'ko': '19',
      'en': '',
    },
    'r76pvops': {
      'ko': '20',
      'en': '',
    },
    'v8go3tpw': {
      'ko': '21',
      'en': '',
    },
    'esm3izmk': {
      'ko': '22',
      'en': '',
    },
    'ygmi6gxp': {
      'ko': '23',
      'en': '',
    },
    'ioc3p4ch': {
      'ko': 'Good Things',
      'en': '',
    },
    'vhvd54o9': {
      'ko': 'Improvement',
      'en': '',
    },
    'k7zyg131': {
      'ko': 'Home',
      'en': '',
    },
  },
  // timerPageCopy
  {
    'yt33k1f0': {
      'ko': '현재공부기록',
      'en': '',
    },
    'lpuq8g1r': {
      'ko': '시작시각',
      'en': '',
    },
    '3jai5q52': {
      'ko': '종료시각',
      'en': '',
    },
    'vwl9tp2a': {
      'ko': '공부시간',
      'en': '',
    },
    's94vrpb6': {
      'ko': 'Home',
      'en': '',
    },
  },
  // alertAdmin
  {
    'eemnr00o': {
      'ko': 'Home',
      'en': 'Home',
    },
  },
  // plannerTimeOptionBottomSheet
  {
    's9m9beip': {
      'ko': '플래너 시간 설정',
      'en': 'Set planner time',
    },
    'rxfqhb3x': {
      'ko': '플래너에 표시될 처음, 끝시간을 설정해주세요.',
      'en':
          'Please set the start and end times to be displayed in the planner.',
    },
    'glqj09e6': {
      'ko': '5시',
      'en': '5 o\'clock',
    },
    'cq40boxg': {
      'ko': '6시',
      'en': '6 o\'clock',
    },
    'vvilbti8': {
      'ko': '7시',
      'en': '7 o\'clock',
    },
    'h0tk2u8o': {
      'ko': '8시',
      'en': '8 o\'clock',
    },
    'pwn5d05j': {
      'ko': '9시',
      'en': '9 o\'clock',
    },
    'am7spdjm': {
      'ko': '시작시간',
      'en': 'Start time',
    },
    '7lc1o9sf': {
      'ko': 'Search for an item...',
      'en': 'Search for an item...',
    },
    'kst3f7l8': {
      'ko': '22시',
      'en': '22 o\'clock',
    },
    'e2kz08j1': {
      'ko': '23시',
      'en': '23:00',
    },
    'yay7nnrs': {
      'ko': '24시',
      'en': '24 hours',
    },
    '0rurf4it': {
      'ko': '1시',
      'en': '1 o\'clock',
    },
    'eiaypmrl': {
      'ko': '2시',
      'en': '2 o\'clock',
    },
    'h9qx3nas': {
      'ko': '3시',
      'en': '3 o\'clock',
    },
    'asfllf2w': {
      'ko': '4시',
      'en': '4 o\'clock',
    },
    'cvgy3jfo': {
      'ko': '마무리 시간',
      'en': 'Finishing time',
    },
    'sut9nk19': {
      'ko': 'Search for an item...',
      'en': 'Search for an item...',
    },
    '357vyekx': {
      'ko': '저장',
      'en': 'save',
    },
    'q33o7zko': {
      'ko': '취소',
      'en': 'cancellation',
    },
  },
  // plannerInutSetCopy
  {
    'nunwdjyb': {
      'ko': '과목명',
      'en': 'Subject name',
    },
    '25jkvgza': {
      'ko': '과목명',
      'en': 'Subject name',
    },
    'v790npf4': {
      'ko': '공부내용',
      'en': 'Study content',
    },
    'ov2uggdg': {
      'ko': '공부내용',
      'en': 'Study content',
    },
    'cwvdtt9w': {
      'ko': '색깔',
      'en': 'color',
    },
    '3hyncctv': {
      'ko': 'color picker',
      'en': 'color picker',
    },
    'd12my60n': {
      'ko': '저장',
      'en': 'save',
    },
    '5vws355k': {
      'ko': '취소',
      'en': 'cancellation',
    },
  },
  // plannerFix
  {
    'up45ec53': {
      'ko': '과목명',
      'en': 'Subject name',
    },
    'q2tjvhi4': {
      'ko': '과목명',
      'en': 'Subject name',
    },
    'x5yh4xzy': {
      'ko': '공부내용',
      'en': 'Study content',
    },
    'da8eqjfq': {
      'ko': '공부내용',
      'en': 'Study content',
    },
    'ztjfro6d': {
      'ko': '색깔',
      'en': 'color',
    },
    'dzzmm8xb': {
      'ko': 'color picker',
      'en': 'color picker',
    },
    'umecke63': {
      'ko': '저장',
      'en': 'save',
    },
    '3asauka4': {
      'ko': '취소',
      'en': 'cancellation',
    },
    '4ctzpxg8': {
      'ko': '공부기록 삭제',
      'en': 'Delete study records',
    },
  },
  // adminSeatConfigureBottomSheet
  {
    'e8eazmlc': {
      'ko': '좌석부여',
      'en': '',
    },
    'hhb1tz02': {
      'ko': ' 학생의 좌석을 배정해 주세요',
      'en': '',
    },
    'dhg6ftgx': {
      'ko': 'Hello World',
      'en': '',
    },
    'xk9gs9q0': {
      'ko': '',
      'en': '',
    },
    'inwekhik': {
      'ko': '좌석번호를 입력해 주세요',
      'en': '',
    },
    '35o0qft7': {
      'ko': '확인',
      'en': '',
    },
    '1nsja3sc': {
      'ko': '취소',
      'en': '',
    },
  },
  // WidgetToCaptureComponent
  {
    'zhzhwl98': {
      'ko': '오늘의 공부시간 - ',
      'en': '',
    },
    '5knv4f3e': {
      'ko': 'TO DO LIST',
      'en': '',
    },
    'gmu2qx8p': {
      'ko': 'STUDY PLAN',
      'en': '',
    },
    'ncuy8y73': {
      'ko': 'SUB',
      'en': '',
    },
    '2p6jll3r': {
      'ko': 'TimeTable',
      'en': '',
    },
    'v2gz65tv': {
      'ko': '5',
      'en': '',
    },
    'apjrt7ai': {
      'ko': 'Hello World',
      'en': '',
    },
    'yu1kjzt0': {
      'ko': '선생님확인란',
      'en': '',
    },
    'xikhfxso': {
      'ko': '',
      'en': '',
    },
    'lp6eqjvq': {
      'ko': '관리자한마디',
      'en': '',
    },
  },
  // adminSeatChangeBottomSheet
  {
    'kv8ypx2a': {
      'ko': '좌석변경',
      'en': '',
    },
    '4h4jw3ii': {
      'ko': ' 학생의 좌석을 배정해 주세요',
      'en': '',
    },
    '7xcxtgzn': {
      'ko': 'Hello World',
      'en': '',
    },
    '7xykt552': {
      'ko': '',
      'en': '',
    },
    '9kgip50v': {
      'ko': '좌석번호를 입력해 주세요',
      'en': '',
    },
    '2ap6o9v5': {
      'ko': '확인',
      'en': '',
    },
    'uw6135mz': {
      'ko': '취소',
      'en': '',
    },
  },
  // privacyPolicy
  {
    'rowr13zz': {
      'ko': '개인정보처리방침',
      'en': '',
    },
    'pfbdgc0y': {
      'ko': 'Hello World',
      'en': '',
    },
  },
  // termsOfServices
  {
    'p3ljbmes': {
      'ko': '이용약관',
      'en': '',
    },
    'r3heb4zg': {
      'ko': 'Hello World',
      'en': '',
    },
  },
  // Dashboard01RecentActivity
  {
    'bocnrsjg': {
      'ko': 'Recent Activity',
      'en': '',
    },
    '1ax3lusv': {
      'ko': 'Below is an overview of tasks & activity completed.',
      'en': '',
    },
    'uxqxoz8g': {
      'ko': 'Tasks',
      'en': '',
    },
    '4b9eukw5': {
      'ko': 'Completed',
      'en': '',
    },
  },
  // restInfoFix
  {
    'dye7w2x7': {
      'ko': '휴식설정',
      'en': '',
    },
    '80ocwh31': {
      'ko': '과목명',
      'en': '',
    },
    '12likolm': {
      'ko': '공부내용',
      'en': '',
    },
    'r7r9fzz6': {
      'ko': '공부내용',
      'en': '',
    },
    'bf1v3r85': {
      'ko': '저장',
      'en': '',
    },
    'gyvos7p2': {
      'ko': '취소',
      'en': '',
    },
    'i7a8cx90': {
      'ko': '공부기록 삭제',
      'en': '',
    },
  },
  // callWhileStudy
  {
    'qsypsdya': {
      'ko': '화장실 / 휴게실',
      'en': '',
    },
    '4a7igcag': {
      'ko': '질문',
      'en': '',
    },
    'ihae1x8g': {
      'ko': '기타',
      'en': '',
    },
  },
  // dailySet
  {
    '3yuhipyj': {
      'ko': '수면시각 :',
      'en': '',
    },
    'a19musvf': {
      'ko': '기상시각 :',
      'en': '',
    },
    'i15ls5bv': {
      'ko': '목표공부시간 :  ',
      'en': '',
    },
    '1tuae7uc': {
      'ko': '0',
      'en': '',
    },
    'fyd2fkhw': {
      'ko': '시간   ',
      'en': '',
    },
    'l3gw79rv': {
      'ko': '0',
      'en': '',
    },
    '1membqpw': {
      'ko': '분',
      'en': '',
    },
    '8n5xkeci': {
      'ko': '저장',
      'en': '',
    },
    'mxtbl1bm': {
      'ko': '취소',
      'en': '',
    },
  },
  // temporaryLock
  {
    '37db1j6j': {
      'ko': 'Insert PIN',
      'en': '',
    },
    '1imgg2qw': {
      'ko': '7',
      'en': '',
    },
    'xbuxgy0w': {
      'ko': '8',
      'en': '',
    },
    'vtt3s5xg': {
      'ko': '9',
      'en': '',
    },
    'pwp35wds': {
      'ko': '4',
      'en': '',
    },
    'lylvn4g0': {
      'ko': '5',
      'en': '',
    },
    'ggjj2azl': {
      'ko': '6',
      'en': '',
    },
    'h6dkx1b5': {
      'ko': '1',
      'en': '',
    },
    'oy46b296': {
      'ko': '2',
      'en': '',
    },
    'ym54vorg': {
      'ko': '3',
      'en': '',
    },
    'j0pnremt': {
      'ko': 'C',
      'en': '',
    },
    '752yiia7': {
      'ko': '0',
      'en': '',
    },
  },
  // secondPinConfirm
  {
    'xqcjvivv': {
      'ko': '현재 2차 비밀번호를 입력해 주세요.',
      'en': '',
    },
    '6cdy96xb': {
      'ko': '7',
      'en': '',
    },
    'dd3sf1kv': {
      'ko': '8',
      'en': '',
    },
    'nss7y5c4': {
      'ko': '9',
      'en': '',
    },
    'f1g79k6i': {
      'ko': '4',
      'en': '',
    },
    'nafdttfw': {
      'ko': '5',
      'en': '',
    },
    'dea3pguq': {
      'ko': '6',
      'en': '',
    },
    'ubpi7h2c': {
      'ko': '1',
      'en': '',
    },
    '43lz3twn': {
      'ko': '2',
      'en': '',
    },
    '5hghs8cs': {
      'ko': '3',
      'en': '',
    },
    't7dlgw99': {
      'ko': 'C',
      'en': '',
    },
    '5zyx490l': {
      'ko': '0',
      'en': '',
    },
  },
  // helpCenter
  {
    'dfae1x7t': {
      'ko': 'Help Center',
      'en': '',
    },
    '58bl331r': {
      'ko':
          '앱 사용과 관련된 불편사항 및 건의사항은 각 지점 담당 선생님 혹은 parkjh3530@gmail.com으로 문의 바랍니다',
      'en': '',
    },
  },
  // pointadjustcompo
  {
    'w2kxdlkg': {
      'ko': '학생',
      'en': '',
    },
    'e5tetwvx': {
      'ko': '현재 포인트',
      'en': '',
    },
    'we1z7hfe': {
      'ko': ':',
      'en': '',
    },
    'k70nw7t7': {
      'ko': ':',
      'en': '',
    },
    'o5mao20v': {
      'ko': '현재 포인트',
      'en': '',
    },
    'u3bpglis': {
      'ko': '',
      'en': '',
    },
    'm9ualjbx': {
      'ko': 'TextField',
      'en': '',
    },
    '9pw6q11m': {
      'ko': '사유',
      'en': '',
    },
    '0iwqopm4': {
      'ko': ':',
      'en': '',
    },
    '1zk33kfz': {
      'ko': '현재 포인트',
      'en': '',
    },
    'elmowda7': {
      'ko': '',
      'en': '',
    },
    'cmgih2uz': {
      'ko': 'TextField',
      'en': '',
    },
    '70vl07vr': {
      'ko': '확인',
      'en': '',
    },
    '2nsyho0d': {
      'ko': '취소',
      'en': '',
    },
  },
  // test11
  {
    '5r844jkp': {
      'ko': '수면시간 : ',
      'en': '',
    },
    'aw3o0rf9': {
      'ko': '기상시간 : ',
      'en': '',
    },
    '7dx33ngy': {
      'ko': '목표공부시간 : ',
      'en': '',
    },
    '5v9wil78': {
      'ko': '현재공부시간 : ',
      'en': '',
    },
    'roztzh13': {
      'ko': '오늘의 한마디 :',
      'en': '',
    },
    'uheamk68': {
      'ko': '',
      'en': '',
    },
    'i2he2l3f': {
      'ko': '오늘의 다짐, 고민거리, 건의사항등\n하고싶은 말을 자유롭게 적어주세요!',
      'en': '',
    },
    'fdfri5xu': {
      'ko': 'TO DO LIST',
      'en': '',
    },
    'u0e77cll': {
      'ko': 'STUDY PLAN',
      'en': '',
    },
    'axn0nvw7': {
      'ko': 'SUB',
      'en': '',
    },
    '7qz27fko': {
      'ko': 'TimeTable',
      'en': '',
    },
    '5ztpeni7': {
      'ko': '5',
      'en': '',
    },
    '29c0v8j1': {
      'ko': '6',
      'en': '',
    },
    '3miqgwki': {
      'ko': '7',
      'en': '',
    },
    'np7lk07u': {
      'ko': '8',
      'en': '',
    },
    'mijzuzgu': {
      'ko': '9',
      'en': '',
    },
    'h4dduz9o': {
      'ko': '10',
      'en': '',
    },
    '6eti23xq': {
      'ko': '11',
      'en': '',
    },
    'wvcx6ymq': {
      'ko': '12',
      'en': '',
    },
    'u0zebo96': {
      'ko': '13',
      'en': '',
    },
    'x2xypj0r': {
      'ko': '14',
      'en': '',
    },
    '8ompatdx': {
      'ko': '15',
      'en': '',
    },
    '6v22bofn': {
      'ko': '16',
      'en': '',
    },
    'a9e9ksdk': {
      'ko': '17',
      'en': '',
    },
    'f1d49ztv': {
      'ko': '18',
      'en': '',
    },
    'pn7uynt6': {
      'ko': '19',
      'en': '',
    },
    '28yfiqj6': {
      'ko': '20',
      'en': '',
    },
    'gl30r3l5': {
      'ko': '21',
      'en': '',
    },
    'vr31i4lj': {
      'ko': '22',
      'en': '',
    },
    '1gl7t18o': {
      'ko': '23',
      'en': '',
    },
    '897mgbwa': {
      'ko': 'Good Things',
      'en': '',
    },
    '2q0e29ub': {
      'ko': 'Improvement',
      'en': '',
    },
  },
  // Miscellaneous
  {
    'rxmgapcs': {
      'ko': 'Title',
      'en': 'Title',
    },
    'hg46it45': {
      'ko': 'Subtitle goes here...',
      'en': 'Subtitle goes here...',
    },
    'rt5yta4w': {
      'ko': 'are you sure to provide location data?',
      'en': '',
    },
    'tjdw9w18': {
      'ko': '위치정보 수집을 허가하시겠습니까?',
      'en': '',
    },
    'elwxahj2': {
      'ko': '12',
      'en': '',
    },
    '146sgepy': {
      'ko': 'are you sure to ensure contact?',
      'en': '',
    },
    '1ql6h09k': {
      'ko': '',
      'en': '',
    },
    '4r57gxe5': {
      'ko': '',
      'en': '',
    },
    'ujva6nmx': {
      'ko': '',
      'en': '',
    },
    'jro8lyw3': {
      'ko': '',
      'en': '',
    },
    'juraff75': {
      'ko': '',
      'en': '',
    },
    '4idz97xr': {
      'ko': '',
      'en': '',
    },
    'ei6u64un': {
      'ko': '',
      'en': '',
    },
    'q1857cwl': {
      'ko': '',
      'en': '',
    },
    'icdxdaob': {
      'ko': '',
      'en': '',
    },
    'gbgkqvb8': {
      'ko': '',
      'en': '',
    },
    'bep3pb0y': {
      'ko': '',
      'en': '',
    },
    'lazwtlrf': {
      'ko': '',
      'en': '',
    },
    '6x337yz5': {
      'ko': '',
      'en': '',
    },
    'xnmgci54': {
      'ko': '',
      'en': '',
    },
    '5sftm42r': {
      'ko': '',
      'en': '',
    },
    '1brhi96g': {
      'ko': '',
      'en': '',
    },
    't5k127n5': {
      'ko': '',
      'en': '',
    },
    'n6kf0pup': {
      'ko': '',
      'en': '',
    },
    'baui5q41': {
      'ko': '',
      'en': '',
    },
    'c31gdtjl': {
      'ko': '',
      'en': '',
    },
    '8yhiplwt': {
      'ko': '',
      'en': '',
    },
    'ixy8x8ft': {
      'ko': '',
      'en': '',
    },
    'wfagqe05': {
      'ko': '',
      'en': '',
    },
    'fv47hm3t': {
      'ko': '',
      'en': '',
    },
    '85ovme0y': {
      'ko': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
