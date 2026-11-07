import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Sort'**
  String get appTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A COZY COLOR SORTING GAME'**
  String get homeSubtitle;

  /// No description provided for @homeLevelPill.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String homeLevelPill(int level);

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @continueGame.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueGame;

  /// No description provided for @gameModes.
  ///
  /// In en, this message translates to:
  /// **'Game Modes'**
  String get gameModes;

  /// No description provided for @customization.
  ///
  /// In en, this message translates to:
  /// **'Customization'**
  String get customization;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get howToPlay;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @gameModesTitle.
  ///
  /// In en, this message translates to:
  /// **'GAME MODES'**
  String get gameModesTitle;

  /// No description provided for @selectLevel.
  ///
  /// In en, this message translates to:
  /// **'Select Level'**
  String get selectLevel;

  /// No description provided for @randomPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Random Puzzle'**
  String get randomPuzzle;

  /// No description provided for @multiplayer.
  ///
  /// In en, this message translates to:
  /// **'Multiplayer'**
  String get multiplayer;

  /// No description provided for @tubeCapacity.
  ///
  /// In en, this message translates to:
  /// **'TUBE CAPACITY'**
  String get tubeCapacity;

  /// No description provided for @playPuzzle.
  ///
  /// In en, this message translates to:
  /// **'PLAY PUZZLE'**
  String get playPuzzle;

  /// No description provided for @selectProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'SELECT PROFILE'**
  String get selectProfileTitle;

  /// No description provided for @createNewProfile.
  ///
  /// In en, this message translates to:
  /// **'+ CREATE NEW PROFILE'**
  String get createNewProfile;

  /// No description provided for @createProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'CREATE PROFILE'**
  String get createProfileTitle;

  /// No description provided for @enterProfileName.
  ///
  /// In en, this message translates to:
  /// **'Enter profile name'**
  String get enterProfileName;

  /// No description provided for @selectAvatarEmoji.
  ///
  /// In en, this message translates to:
  /// **'SELECT AVATAR EMOJI'**
  String get selectAvatarEmoji;

  /// No description provided for @createUpper.
  ///
  /// In en, this message translates to:
  /// **'CREATE'**
  String get createUpper;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get editProfileTitle;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @levelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get levelsTitle;

  /// No description provided for @howToPlayTitle.
  ///
  /// In en, this message translates to:
  /// **'HOW TO PLAY'**
  String get howToPlayTitle;

  /// No description provided for @howToPlayStep.
  ///
  /// In en, this message translates to:
  /// **'STEP {stepNumber}'**
  String howToPlayStep(int stepNumber);

  /// No description provided for @howToPlayStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Select a Tube'**
  String get howToPlayStep1Title;

  /// No description provided for @howToPlayStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap any tube to select it. The tube will float up and glow to show it is selected.'**
  String get howToPlayStep1Desc;

  /// No description provided for @howToPlayStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Pour into Matching Color'**
  String get howToPlayStep2Title;

  /// No description provided for @howToPlayStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap another tube to pour. Water can only be poured onto the same color or into an empty tube.'**
  String get howToPlayStep2Desc;

  /// No description provided for @howToPlayStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Sort All Colors'**
  String get howToPlayStep3Title;

  /// No description provided for @howToPlayStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Organize all water segments so each tube contains only one single color.'**
  String get howToPlayStep3Desc;

  /// No description provided for @howToPlayStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Elder & Child Friendly'**
  String get howToPlayStep4Title;

  /// No description provided for @howToPlayStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the distinct symbols inside each water block to match colors easily without eye strain.'**
  String get howToPlayStep4Desc;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got It!'**
  String get gotIt;

  /// No description provided for @multiplayerTitle.
  ///
  /// In en, this message translates to:
  /// **'MULTIPLAYER'**
  String get multiplayerTitle;

  /// No description provided for @createRoom.
  ///
  /// In en, this message translates to:
  /// **'CREATE ROOM'**
  String get createRoom;

  /// No description provided for @diffEasy.
  ///
  /// In en, this message translates to:
  /// **'EASY'**
  String get diffEasy;

  /// No description provided for @diffMedium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get diffMedium;

  /// No description provided for @diffHard.
  ///
  /// In en, this message translates to:
  /// **'HARD'**
  String get diffHard;

  /// No description provided for @diffExpert.
  ///
  /// In en, this message translates to:
  /// **'EXPERT'**
  String get diffExpert;

  /// No description provided for @diffExtreme.
  ///
  /// In en, this message translates to:
  /// **'EXTREME'**
  String get diffExtreme;

  /// No description provided for @roomCode.
  ///
  /// In en, this message translates to:
  /// **'ROOM CODE'**
  String get roomCode;

  /// No description provided for @roomCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Room code copied to clipboard'**
  String get roomCodeCopied;

  /// No description provided for @playThisPuzzle.
  ///
  /// In en, this message translates to:
  /// **'PLAY THIS PUZZLE'**
  String get playThisPuzzle;

  /// No description provided for @joinRoom.
  ///
  /// In en, this message translates to:
  /// **'JOIN ROOM'**
  String get joinRoom;

  /// No description provided for @enterCodeHint.
  ///
  /// In en, this message translates to:
  /// **'ENTER CODE (E.G. {code})'**
  String enterCodeHint(String code);

  /// No description provided for @joinPuzzle.
  ///
  /// In en, this message translates to:
  /// **'JOIN PUZZLE'**
  String get joinPuzzle;

  /// No description provided for @invalidRoomCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid room code. Please check and try again.'**
  String get invalidRoomCode;

  /// No description provided for @levelSolvable.
  ///
  /// In en, this message translates to:
  /// **'Level is solvable'**
  String get levelSolvable;

  /// No description provided for @levelNotSolvable.
  ///
  /// In en, this message translates to:
  /// **'Level is not solvable'**
  String get levelNotSolvable;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'RANDOM'**
  String get random;

  /// No description provided for @levelTitle.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {levelNumber}'**
  String levelTitle(int levelNumber);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @moves.
  ///
  /// In en, this message translates to:
  /// **'MOVES'**
  String get moves;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'CHECK'**
  String get check;

  /// No description provided for @hint.
  ///
  /// In en, this message translates to:
  /// **'HINT'**
  String get hint;

  /// No description provided for @noSolutionPossible.
  ///
  /// In en, this message translates to:
  /// **'No solution possible from current state. Try undoing some moves!'**
  String get noSolutionPossible;

  /// No description provided for @levelComplete.
  ///
  /// In en, this message translates to:
  /// **'LEVEL COMPLETE!'**
  String get levelComplete;

  /// No description provided for @levelCompleteRandomDesc.
  ///
  /// In en, this message translates to:
  /// **'You sorted this {difficulty} puzzle in {moveCount} moves.'**
  String levelCompleteRandomDesc(String difficulty, int moveCount);

  /// No description provided for @levelCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'You sorted Level {levelNumber} in {moveCount} moves.'**
  String levelCompleteDesc(int levelNumber, int moveCount);

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nextLevel;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @buyMeACoffeeWithEmoji.
  ///
  /// In en, this message translates to:
  /// **'Buy Me a Coffee ☕'**
  String get buyMeACoffeeWithEmoji;

  /// No description provided for @timesUp.
  ///
  /// In en, this message translates to:
  /// **'TIME\'S UP!'**
  String get timesUp;

  /// No description provided for @timesUpDesc.
  ///
  /// In en, this message translates to:
  /// **'You ran out of time to sort the water colors.'**
  String get timesUpDesc;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @restartLevel.
  ///
  /// In en, this message translates to:
  /// **'RESTART LEVEL?'**
  String get restartLevel;

  /// No description provided for @restartLevelDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restart the current level? Your current progress will be lost.'**
  String get restartLevelDesc;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelUpper.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancelUpper;

  /// No description provided for @backupExportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup exported successfully.'**
  String get backupExportedSuccess;

  /// No description provided for @backupExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export backup.'**
  String get backupExportFailed;

  /// No description provided for @backupImportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup imported successfully.'**
  String get backupImportedSuccess;

  /// No description provided for @backupImportInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file format.'**
  String get backupImportInvalid;

  /// No description provided for @backupImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to import backup.'**
  String get backupImportFailed;

  /// No description provided for @resetProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'RESET PROGRESS?'**
  String get resetProgressTitle;

  /// No description provided for @resetProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'This will erase all completed levels, stars, and saved state for this profile. This action cannot be undone.'**
  String get resetProgressDesc;

  /// No description provided for @resetUpper.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get resetUpper;

  /// No description provided for @progressResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Progress has been reset.'**
  String get progressResetSuccess;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @sectionGameplayRules.
  ///
  /// In en, this message translates to:
  /// **'GAMEPLAY & RULES'**
  String get sectionGameplayRules;

  /// No description provided for @settingTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'GAMEPLAY TIMER'**
  String get settingTimerTitle;

  /// No description provided for @settingTimerDesc.
  ///
  /// In en, this message translates to:
  /// **'Add countdown timer to levels for an extra challenge, or keep it off to play relaxed.'**
  String get settingTimerDesc;

  /// No description provided for @settingHintHelperTitle.
  ///
  /// In en, this message translates to:
  /// **'HINT HELPER'**
  String get settingHintHelperTitle;

  /// No description provided for @settingHintHelperDesc.
  ///
  /// In en, this message translates to:
  /// **'Show a hint button during gameplay to highlight the next optimal move.'**
  String get settingHintHelperDesc;

  /// No description provided for @settingCheckButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'CHECK BUTTON'**
  String get settingCheckButtonTitle;

  /// No description provided for @settingCheckButtonDesc.
  ///
  /// In en, this message translates to:
  /// **'Replace the hint button with a check button that tells if the level is solvable via tooltip without giving hints.'**
  String get settingCheckButtonDesc;

  /// No description provided for @settingSuperHardTitle.
  ///
  /// In en, this message translates to:
  /// **'SUPER HARD DIFFICULTY'**
  String get settingSuperHardTitle;

  /// No description provided for @settingSuperHardDesc.
  ///
  /// In en, this message translates to:
  /// **'Only reveal the topmost color; all hidden liquid segments beneath are pure white.'**
  String get settingSuperHardDesc;

  /// No description provided for @settingDecrementMovesTitle.
  ///
  /// In en, this message translates to:
  /// **'DECREMENT MOVES ON UNDO'**
  String get settingDecrementMovesTitle;

  /// No description provided for @settingDecrementMovesDesc.
  ///
  /// In en, this message translates to:
  /// **'Decrease the move counter when undoing a move.'**
  String get settingDecrementMovesDesc;

  /// No description provided for @sectionAudioAnimations.
  ///
  /// In en, this message translates to:
  /// **'AUDIO & ANIMATIONS'**
  String get sectionAudioAnimations;

  /// No description provided for @settingSoundEffectsTitle.
  ///
  /// In en, this message translates to:
  /// **'SOUND EFFECTS'**
  String get settingSoundEffectsTitle;

  /// No description provided for @settingSoundEffectsDesc.
  ///
  /// In en, this message translates to:
  /// **'Liquid pouring sounds, tube completion chimes, and victory fanfare.'**
  String get settingSoundEffectsDesc;

  /// No description provided for @settingTurnOffAnimationsTitle.
  ///
  /// In en, this message translates to:
  /// **'TURN OFF ANIMATIONS'**
  String get settingTurnOffAnimationsTitle;

  /// No description provided for @settingTurnOffAnimationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Instant gameplay mode. Disables pouring physics, ripples, waves, and all sound effects.'**
  String get settingTurnOffAnimationsDesc;

  /// No description provided for @sectionBackupRestore.
  ///
  /// In en, this message translates to:
  /// **'BACKUP & RESTORE'**
  String get sectionBackupRestore;

  /// No description provided for @actionExportBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'EXPORT BACKUP'**
  String get actionExportBackupTitle;

  /// No description provided for @actionExportBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Save your progress'**
  String get actionExportBackupDesc;

  /// No description provided for @actionImportBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'IMPORT BACKUP'**
  String get actionImportBackupTitle;

  /// No description provided for @actionImportBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Restore your progress'**
  String get actionImportBackupDesc;

  /// No description provided for @sectionSupportAbout.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT & ABOUT'**
  String get sectionSupportAbout;

  /// No description provided for @actionReportBugsTitle.
  ///
  /// In en, this message translates to:
  /// **'REPORT BUGS / SUGGESTIONS'**
  String get actionReportBugsTitle;

  /// No description provided for @actionReportBugsDesc.
  ///
  /// In en, this message translates to:
  /// **'Open GitHub to submit bug reports or propose new features.'**
  String get actionReportBugsDesc;

  /// No description provided for @actionBuyCoffeeTitle.
  ///
  /// In en, this message translates to:
  /// **'BUY ME A COFFEE'**
  String get actionBuyCoffeeTitle;

  /// No description provided for @actionBuyCoffeeDesc.
  ///
  /// In en, this message translates to:
  /// **'Support independent development and future game updates.'**
  String get actionBuyCoffeeDesc;

  /// No description provided for @actionResetAllProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'RESET ALL PROGRESS'**
  String get actionResetAllProgressTitle;

  /// No description provided for @actionResetAllProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear all solved level records, stars, and saved states.'**
  String get actionResetAllProgressDesc;

  /// No description provided for @themeMidnight.
  ///
  /// In en, this message translates to:
  /// **'MIDNIGHT'**
  String get themeMidnight;

  /// No description provided for @themeCyberpunk.
  ///
  /// In en, this message translates to:
  /// **'CYBERPUNK'**
  String get themeCyberpunk;

  /// No description provided for @themeForest.
  ///
  /// In en, this message translates to:
  /// **'FOREST'**
  String get themeForest;

  /// No description provided for @themeSpace.
  ///
  /// In en, this message translates to:
  /// **'SPACE'**
  String get themeSpace;

  /// No description provided for @themeRetro.
  ///
  /// In en, this message translates to:
  /// **'RETRO'**
  String get themeRetro;

  /// No description provided for @themeSunset.
  ///
  /// In en, this message translates to:
  /// **'SUNSET'**
  String get themeSunset;

  /// No description provided for @themeNeon.
  ///
  /// In en, this message translates to:
  /// **'NEON'**
  String get themeNeon;

  /// No description provided for @themeOcean.
  ///
  /// In en, this message translates to:
  /// **'OCEAN'**
  String get themeOcean;

  /// No description provided for @themeVolcano.
  ///
  /// In en, this message translates to:
  /// **'VOLCANO'**
  String get themeVolcano;

  /// No description provided for @themeAurora.
  ///
  /// In en, this message translates to:
  /// **'AURORA'**
  String get themeAurora;

  /// No description provided for @themeLavender.
  ///
  /// In en, this message translates to:
  /// **'LAVENDER'**
  String get themeLavender;

  /// No description provided for @themeDesert.
  ///
  /// In en, this message translates to:
  /// **'DESERT'**
  String get themeDesert;

  /// No description provided for @themeGlitch.
  ///
  /// In en, this message translates to:
  /// **'GLITCH'**
  String get themeGlitch;

  /// No description provided for @themeSakura.
  ///
  /// In en, this message translates to:
  /// **'SAKURA'**
  String get themeSakura;

  /// No description provided for @themeMonochrome.
  ///
  /// In en, this message translates to:
  /// **'MONOCHROME'**
  String get themeMonochrome;

  /// No description provided for @themeAquamarine.
  ///
  /// In en, this message translates to:
  /// **'AQUAMARINE'**
  String get themeAquamarine;

  /// No description provided for @themeSolar.
  ///
  /// In en, this message translates to:
  /// **'SOLAR'**
  String get themeSolar;

  /// No description provided for @customizationTitle.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMIZATION'**
  String get customizationTitle;

  /// No description provided for @themePalettesTitle.
  ///
  /// In en, this message translates to:
  /// **'THEME PALETTES'**
  String get themePalettesTitle;

  /// No description provided for @customizeLiquidColorsTitle.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMIZE LIQUID COLORS'**
  String get customizeLiquidColorsTitle;

  /// No description provided for @jsonUpper.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get jsonUpper;

  /// No description provided for @liquidColorsResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Liquid colors reset to default.'**
  String get liquidColorsResetSuccess;

  /// No description provided for @resetAllUpper.
  ///
  /// In en, this message translates to:
  /// **'RESET ALL'**
  String get resetAllUpper;

  /// No description provided for @visualsTitle.
  ///
  /// In en, this message translates to:
  /// **'VISUALS'**
  String get visualsTitle;

  /// No description provided for @frostSolvedTubesTitle.
  ///
  /// In en, this message translates to:
  /// **'FROST SOLVED TUBES'**
  String get frostSolvedTubesTitle;

  /// No description provided for @frostSolvedTubesDesc.
  ///
  /// In en, this message translates to:
  /// **'Apply an icy glass frosting effect to completed tubes to easily focus on active ones.'**
  String get frostSolvedTubesDesc;

  /// No description provided for @tubeThicknessTitle.
  ///
  /// In en, this message translates to:
  /// **'TUBE THICKNESS'**
  String get tubeThicknessTitle;

  /// No description provided for @tubeThicknessDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose how wide or thin test tubes look on screen.'**
  String get tubeThicknessDesc;

  /// No description provided for @tubeThicknessSlim.
  ///
  /// In en, this message translates to:
  /// **'SLIM'**
  String get tubeThicknessSlim;

  /// No description provided for @tubeThicknessMedium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get tubeThicknessMedium;

  /// No description provided for @tubeThicknessWide.
  ///
  /// In en, this message translates to:
  /// **'WIDE'**
  String get tubeThicknessWide;

  /// No description provided for @tubeThicknessAdaptive.
  ///
  /// In en, this message translates to:
  /// **'ADAPTIVE'**
  String get tubeThicknessAdaptive;

  /// No description provided for @customBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM BACKGROUND IMAGE'**
  String get customBackgroundTitle;

  /// No description provided for @customBackgroundDesc.
  ///
  /// In en, this message translates to:
  /// **'Set custom image from your deviice for gameplay background.'**
  String get customBackgroundDesc;

  /// No description provided for @customBackgroundSetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Custom background image set successfully.'**
  String get customBackgroundSetSuccess;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'CHANGE IMAGE'**
  String get changeImage;

  /// No description provided for @setBackgroundImage.
  ///
  /// In en, this message translates to:
  /// **'SET BACKGROUND IMAGE'**
  String get setBackgroundImage;

  /// No description provided for @customBackgroundRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Custom background image removed.'**
  String get customBackgroundRemovedSuccess;

  /// No description provided for @customizeColorTitle.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMIZE COLOR'**
  String get customizeColorTitle;

  /// No description provided for @hexNumber.
  ///
  /// In en, this message translates to:
  /// **'HEX #'**
  String get hexNumber;

  /// No description provided for @iconColorTitle.
  ///
  /// In en, this message translates to:
  /// **'ICON COLOR'**
  String get iconColorTitle;

  /// No description provided for @whiteUpper.
  ///
  /// In en, this message translates to:
  /// **'WHITE'**
  String get whiteUpper;

  /// No description provided for @blackUpper.
  ///
  /// In en, this message translates to:
  /// **'BLACK'**
  String get blackUpper;

  /// No description provided for @hslAdjustmentTitle.
  ///
  /// In en, this message translates to:
  /// **'HSL ADJUSTMENT'**
  String get hslAdjustmentTitle;

  /// No description provided for @palettePresetsTitle.
  ///
  /// In en, this message translates to:
  /// **'PALETTE PRESETS'**
  String get palettePresetsTitle;

  /// No description provided for @defaultUpper.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get defaultUpper;

  /// No description provided for @applyUpper.
  ///
  /// In en, this message translates to:
  /// **'APPLY'**
  String get applyUpper;

  /// No description provided for @themeJsonTitle.
  ///
  /// In en, this message translates to:
  /// **'THEME JSON'**
  String get themeJsonTitle;

  /// No description provided for @themeJsonCopiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Theme JSON copied to clipboard.'**
  String get themeJsonCopiedSuccess;

  /// No description provided for @themeJsonDesc.
  ///
  /// In en, this message translates to:
  /// **'Copy, paste or edit 16 liquid colors formatted as a JSON array of hex codes.'**
  String get themeJsonDesc;

  /// No description provided for @jsonMustBe16Hex.
  ///
  /// In en, this message translates to:
  /// **'JSON must be a list of 16 hex colors.'**
  String get jsonMustBe16Hex;

  /// No description provided for @jsonItemMustBeHex.
  ///
  /// In en, this message translates to:
  /// **'Every color item must be a hex string.'**
  String get jsonItemMustBeHex;

  /// No description provided for @themeAppliedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Theme applied successfully.'**
  String get themeAppliedSuccess;

  /// No description provided for @invalidJsonSyntax.
  ///
  /// In en, this message translates to:
  /// **'Invalid JSON syntax.'**
  String get invalidJsonSyntax;

  /// No description provided for @mustContainExactColors.
  ///
  /// In en, this message translates to:
  /// **'Must contain exactly {count} colors (found {found}).'**
  String mustContainExactColors(int count, int found);

  /// No description provided for @invalidHexColor.
  ///
  /// In en, this message translates to:
  /// **'Invalid hex color: {item}'**
  String invalidHexColor(String item);

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get sectionLanguage;

  /// No description provided for @settingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get settingLanguageTitle;

  /// No description provided for @settingLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred app language or match system.'**
  String get settingLanguageDesc;

  /// No description provided for @localeSystem.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM'**
  String get localeSystem;

  /// No description provided for @localeSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow device language'**
  String get localeSystemDesc;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE LANGUAGE'**
  String get chooseLanguageTitle;

  /// No description provided for @localeEn.
  ///
  /// In en, this message translates to:
  /// **'ENGLISH'**
  String get localeEn;

  /// No description provided for @localeDe.
  ///
  /// In en, this message translates to:
  /// **'DEUTSCH'**
  String get localeDe;

  /// No description provided for @followTwitter.
  ///
  /// In en, this message translates to:
  /// **'FOLLOW ME ON TWITTER'**
  String get followTwitter;

  /// No description provided for @followMastodon.
  ///
  /// In en, this message translates to:
  /// **'FOLLOW ME ON MASTODON'**
  String get followMastodon;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
