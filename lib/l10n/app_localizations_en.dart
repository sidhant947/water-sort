// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Water Sort';

  @override
  String get homeSubtitle => 'A COZY COLOR SORTING GAME';

  @override
  String homeLevelPill(int level) {
    return 'Level $level';
  }

  @override
  String get startGame => 'Start Game';

  @override
  String get continueGame => 'Continue';

  @override
  String get gameModes => 'Game Modes';

  @override
  String get customization => 'Customization';

  @override
  String get howToPlay => 'How to Play';

  @override
  String get settings => 'Settings';

  @override
  String get gameModesTitle => 'GAME MODES';

  @override
  String get selectLevel => 'Select Level';

  @override
  String get randomPuzzle => 'Random Puzzle';

  @override
  String get multiplayer => 'Multiplayer';

  @override
  String get tubeCapacity => 'TUBE CAPACITY';

  @override
  String get playPuzzle => 'PLAY PUZZLE';

  @override
  String get selectProfileTitle => 'SELECT PROFILE';

  @override
  String get createNewProfile => '+ CREATE NEW PROFILE';

  @override
  String get createProfileTitle => 'CREATE PROFILE';

  @override
  String get enterProfileName => 'Enter profile name';

  @override
  String get selectAvatarEmoji => 'SELECT AVATAR EMOJI';

  @override
  String get createUpper => 'CREATE';

  @override
  String get editProfileTitle => 'EDIT PROFILE';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get levelsTitle => 'Levels';

  @override
  String get howToPlayTitle => 'HOW TO PLAY';

  @override
  String howToPlayStep(int stepNumber) {
    return 'STEP $stepNumber';
  }

  @override
  String get howToPlayStep1Title => 'Select a Tube';

  @override
  String get howToPlayStep1Desc =>
      'Tap any tube to select it. The tube will float up and glow to show it is selected.';

  @override
  String get howToPlayStep2Title => 'Pour into Matching Color';

  @override
  String get howToPlayStep2Desc =>
      'Tap another tube to pour. Water can only be poured onto the same color or into an empty tube.';

  @override
  String get howToPlayStep3Title => 'Sort All Colors';

  @override
  String get howToPlayStep3Desc =>
      'Organize all water segments so each tube contains only one single color.';

  @override
  String get howToPlayStep4Title => 'Elder & Child Friendly';

  @override
  String get howToPlayStep4Desc =>
      'Use the distinct symbols inside each water block to match colors easily without eye strain.';

  @override
  String get gotIt => 'Got It!';

  @override
  String get multiplayerTitle => 'MULTIPLAYER';

  @override
  String get createRoom => 'CREATE ROOM';

  @override
  String get diffEasy => 'EASY';

  @override
  String get diffMedium => 'MEDIUM';

  @override
  String get diffHard => 'HARD';

  @override
  String get diffExpert => 'EXPERT';

  @override
  String get diffExtreme => 'EXTREME';

  @override
  String get roomCode => 'ROOM CODE';

  @override
  String get roomCodeCopied => 'Room code copied to clipboard';

  @override
  String get playThisPuzzle => 'PLAY THIS PUZZLE';

  @override
  String get joinRoom => 'JOIN ROOM';

  @override
  String enterCodeHint(String code) {
    return 'ENTER CODE (E.G. $code)';
  }

  @override
  String get joinPuzzle => 'JOIN PUZZLE';

  @override
  String get invalidRoomCode =>
      'Invalid room code. Please check and try again.';

  @override
  String get levelSolvable => 'Level is solvable';

  @override
  String get levelNotSolvable => 'Level is not solvable';

  @override
  String get random => 'RANDOM';

  @override
  String levelTitle(int levelNumber) {
    return 'LEVEL $levelNumber';
  }

  @override
  String get retry => 'Retry';

  @override
  String get undo => 'UNDO';

  @override
  String get moves => 'MOVES';

  @override
  String get check => 'CHECK';

  @override
  String get hint => 'HINT';

  @override
  String get noSolutionPossible =>
      'No solution possible from current state. Try undoing some moves!';

  @override
  String get levelComplete => 'LEVEL COMPLETE!';

  @override
  String levelCompleteRandomDesc(String difficulty, int moveCount) {
    return 'You sorted this $difficulty puzzle in $moveCount moves.';
  }

  @override
  String levelCompleteDesc(int levelNumber, int moveCount) {
    return 'You sorted Level $levelNumber in $moveCount moves.';
  }

  @override
  String get playAgain => 'Play Again';

  @override
  String get nextLevel => 'Next Level';

  @override
  String get home => 'Home';

  @override
  String get buyMeACoffeeWithEmoji => 'Buy Me a Coffee ☕';

  @override
  String get timesUp => 'TIME\'S UP!';

  @override
  String get timesUpDesc => 'You ran out of time to sort the water colors.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get restartLevel => 'RESTART LEVEL?';

  @override
  String get restartLevelDesc =>
      'Are you sure you want to restart the current level? Your current progress will be lost.';

  @override
  String get restart => 'Restart';

  @override
  String get cancel => 'Cancel';

  @override
  String get cancelUpper => 'CANCEL';

  @override
  String get backupExportedSuccess => 'Backup exported successfully.';

  @override
  String get backupExportFailed => 'Failed to export backup.';

  @override
  String get backupImportedSuccess => 'Backup imported successfully.';

  @override
  String get backupImportInvalid => 'Invalid backup file format.';

  @override
  String get backupImportFailed => 'Failed to import backup.';

  @override
  String get resetProgressTitle => 'RESET PROGRESS?';

  @override
  String get resetProgressDesc =>
      'This will erase all completed levels, stars, and saved state for this profile. This action cannot be undone.';

  @override
  String get resetUpper => 'RESET';

  @override
  String get progressResetSuccess => 'Progress has been reset.';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get sectionGameplayRules => 'GAMEPLAY & RULES';

  @override
  String get settingTimerTitle => 'GAMEPLAY TIMER';

  @override
  String get settingTimerDesc =>
      'Add countdown timer to levels for an extra challenge, or keep it off to play relaxed.';

  @override
  String get settingHintHelperTitle => 'HINT HELPER';

  @override
  String get settingHintHelperDesc =>
      'Show a hint button during gameplay to highlight the next optimal move.';

  @override
  String get settingCheckButtonTitle => 'CHECK BUTTON';

  @override
  String get settingCheckButtonDesc =>
      'Replace the hint button with a check button that tells if the level is solvable via tooltip without giving hints.';

  @override
  String get settingSuperHardTitle => 'SUPER HARD DIFFICULTY';

  @override
  String get settingSuperHardDesc =>
      'Only reveal the topmost color; all hidden liquid segments beneath are pure white.';

  @override
  String get settingDecrementMovesTitle => 'DECREMENT MOVES ON UNDO';

  @override
  String get settingDecrementMovesDesc =>
      'Decrease the move counter when undoing a move.';

  @override
  String get sectionAudioAnimations => 'AUDIO & ANIMATIONS';

  @override
  String get settingSoundEffectsTitle => 'SOUND EFFECTS';

  @override
  String get settingSoundEffectsDesc =>
      'Liquid pouring sounds, tube completion chimes, and victory fanfare.';

  @override
  String get settingTurnOffAnimationsTitle => 'TURN OFF ANIMATIONS';

  @override
  String get settingTurnOffAnimationsDesc =>
      'Instant gameplay mode. Disables pouring physics, ripples, waves, and all sound effects.';

  @override
  String get sectionBackupRestore => 'BACKUP & RESTORE';

  @override
  String get actionExportBackupTitle => 'EXPORT BACKUP';

  @override
  String get actionExportBackupDesc => 'Save your progress';

  @override
  String get actionImportBackupTitle => 'IMPORT BACKUP';

  @override
  String get actionImportBackupDesc => 'Restore your progress';

  @override
  String get sectionSupportAbout => 'SUPPORT & ABOUT';

  @override
  String get actionReportBugsTitle => 'REPORT BUGS / SUGGESTIONS';

  @override
  String get actionReportBugsDesc =>
      'Open GitHub to submit bug reports or propose new features.';

  @override
  String get actionBuyCoffeeTitle => 'BUY ME A COFFEE';

  @override
  String get actionBuyCoffeeDesc =>
      'Support independent development and future game updates.';

  @override
  String get actionResetAllProgressTitle => 'RESET ALL PROGRESS';

  @override
  String get actionResetAllProgressDesc =>
      'Clear all solved level records, stars, and saved states.';

  @override
  String get themeMidnight => 'MIDNIGHT';

  @override
  String get themeCyberpunk => 'CYBERPUNK';

  @override
  String get themeForest => 'FOREST';

  @override
  String get themeSpace => 'SPACE';

  @override
  String get themeRetro => 'RETRO';

  @override
  String get themeSunset => 'SUNSET';

  @override
  String get themeNeon => 'NEON';

  @override
  String get themeOcean => 'OCEAN';

  @override
  String get themeVolcano => 'VOLCANO';

  @override
  String get themeAurora => 'AURORA';

  @override
  String get themeLavender => 'LAVENDER';

  @override
  String get themeDesert => 'DESERT';

  @override
  String get themeGlitch => 'GLITCH';

  @override
  String get themeSakura => 'SAKURA';

  @override
  String get themeMonochrome => 'MONOCHROME';

  @override
  String get themeAquamarine => 'AQUAMARINE';

  @override
  String get themeSolar => 'SOLAR';

  @override
  String get customizationTitle => 'CUSTOMIZATION';

  @override
  String get themePalettesTitle => 'THEME PALETTES';

  @override
  String get customizeLiquidColorsTitle => 'CUSTOMIZE LIQUID COLORS';

  @override
  String get jsonUpper => 'JSON';

  @override
  String get liquidColorsResetSuccess => 'Liquid colors reset to default.';

  @override
  String get resetAllUpper => 'RESET ALL';

  @override
  String get visualsTitle => 'VISUALS';

  @override
  String get frostSolvedTubesTitle => 'FROST SOLVED TUBES';

  @override
  String get frostSolvedTubesDesc =>
      'Apply an icy glass frosting effect to completed tubes to easily focus on active ones.';

  @override
  String get tubeThicknessTitle => 'TUBE THICKNESS';

  @override
  String get tubeThicknessDesc =>
      'Choose how wide or thin test tubes look on screen.';

  @override
  String get tubeThicknessSlim => 'SLIM';

  @override
  String get tubeThicknessMedium => 'MEDIUM';

  @override
  String get tubeThicknessWide => 'WIDE';

  @override
  String get tubeThicknessAdaptive => 'ADAPTIVE';

  @override
  String get customBackgroundTitle => 'CUSTOM BACKGROUND IMAGE';

  @override
  String get customBackgroundDesc =>
      'Set custom image from your deviice for gameplay background.';

  @override
  String get customBackgroundSetSuccess =>
      'Custom background image set successfully.';

  @override
  String get changeImage => 'CHANGE IMAGE';

  @override
  String get setBackgroundImage => 'SET BACKGROUND IMAGE';

  @override
  String get customBackgroundRemovedSuccess =>
      'Custom background image removed.';

  @override
  String get customizeColorTitle => 'CUSTOMIZE COLOR';

  @override
  String get hexNumber => 'HEX #';

  @override
  String get iconColorTitle => 'ICON COLOR';

  @override
  String get whiteUpper => 'WHITE';

  @override
  String get blackUpper => 'BLACK';

  @override
  String get hslAdjustmentTitle => 'HSL ADJUSTMENT';

  @override
  String get palettePresetsTitle => 'PALETTE PRESETS';

  @override
  String get defaultUpper => 'DEFAULT';

  @override
  String get applyUpper => 'APPLY';

  @override
  String get themeJsonTitle => 'THEME JSON';

  @override
  String get themeJsonCopiedSuccess => 'Theme JSON copied to clipboard.';

  @override
  String get themeJsonDesc =>
      'Copy, paste or edit 16 liquid colors formatted as a JSON array of hex codes.';

  @override
  String get jsonMustBe16Hex => 'JSON must be a list of 16 hex colors.';

  @override
  String get jsonItemMustBeHex => 'Every color item must be a hex string.';

  @override
  String get themeAppliedSuccess => 'Theme applied successfully.';

  @override
  String get invalidJsonSyntax => 'Invalid JSON syntax.';

  @override
  String mustContainExactColors(int count, int found) {
    return 'Must contain exactly $count colors (found $found).';
  }

  @override
  String invalidHexColor(String item) {
    return 'Invalid hex color: $item';
  }

  @override
  String get sectionLanguage => 'LANGUAGE';

  @override
  String get settingLanguageTitle => 'LANGUAGE';

  @override
  String get settingLanguageDesc =>
      'Choose your preferred app language or match system.';

  @override
  String get localeSystem => 'SYSTEM';

  @override
  String get localeSystemDesc => 'Follow device language';

  @override
  String get chooseLanguageTitle => 'CHOOSE LANGUAGE';

  @override
  String get localeEn => 'ENGLISH';

  @override
  String get localeDe => 'DEUTSCH';

  @override
  String get followTwitter => 'FOLLOW ME ON TWITTER';

  @override
  String get followMastodon => 'FOLLOW ME ON MASTODON';
}
