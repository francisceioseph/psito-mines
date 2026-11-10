import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Psito Mines'**
  String get appTitle;

  /// No description provided for @youWon.
  ///
  /// In en, this message translates to:
  /// **'You found them all!'**
  String get youWon;

  /// No description provided for @caught.
  ///
  /// In en, this message translates to:
  /// **'A cat caught you!'**
  String get caught;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @winSummary.
  ///
  /// In en, this message translates to:
  /// **'Every cat found in {time}'**
  String winSummary(String time);

  /// No description provided for @statCats.
  ///
  /// In en, this message translates to:
  /// **'Cats'**
  String get statCats;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @difficultyDetail.
  ///
  /// In en, this message translates to:
  /// **'{name}: {width} × {height}, {cats} cats'**
  String difficultyDetail(String name, int width, int height, int cats);

  /// No description provided for @howToPlayBody.
  ///
  /// In en, this message translates to:
  /// **'Some cats are hiding under the leaves. Lift every leaf that has no cat under it.\n\nA click lifts a leaf, and the first one is always safe. A number tells how many cats are in the eight leaves around it.\n\nThe right button, or holding the click, puts a feather on a leaf you suspect, and a leaf with a feather cannot be lifted by accident.\n\nA click on a number lifts the leaves around it when the feathers there add up to that number. If a feather is in the wrong place, the cat gets out.\n\nCtrl+N starts a new game.'**
  String get howToPlayBody;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Find the cats hiding under the leaves, with cockatiels. No ads, no telemetry and no account.'**
  String get aboutBody;

  /// No description provided for @aboutLegal.
  ///
  /// In en, this message translates to:
  /// **'Code under the Apache 2.0 license. Art under CC0.'**
  String get aboutLegal;

  /// No description provided for @cellLeaf.
  ///
  /// In en, this message translates to:
  /// **'Leaf, row {row}, column {column}'**
  String cellLeaf(int row, int column);

  /// No description provided for @cellFeather.
  ///
  /// In en, this message translates to:
  /// **'Leaf with a feather, row {row}, column {column}'**
  String cellFeather(int row, int column);

  /// No description provided for @cellCat.
  ///
  /// In en, this message translates to:
  /// **'Cat, row {row}, column {column}'**
  String cellCat(int row, int column);

  /// No description provided for @cellOpen.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No cats nearby} =1{1 cat nearby} other{{count} cats nearby}}, row {row}, column {column}'**
  String cellOpen(int count, int row, int column);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
