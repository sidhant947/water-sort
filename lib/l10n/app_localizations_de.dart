// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Water Sort';

  @override
  String get homeSubtitle => 'EIN GEMÜTLICHES FARBSORTIER-SPIEL';

  @override
  String homeLevelPill(int level) {
    return 'Level $level';
  }

  @override
  String get startGame => 'Spiel starten';

  @override
  String get continueGame => 'Fortsetzen';

  @override
  String get gameModes => 'Spielmodi';

  @override
  String get customization => 'Anpassung';

  @override
  String get howToPlay => 'Spielanleitung';

  @override
  String get settings => 'Einstellungen';

  @override
  String get gameModesTitle => 'SPIELMODI';

  @override
  String get selectLevel => 'Level auswählen';

  @override
  String get randomPuzzle => 'Zufälliges Rätsel';

  @override
  String get multiplayer => 'Mehrspieler';

  @override
  String get tubeCapacity => 'RÖHRCHEN-KAPAZITÄT';

  @override
  String get playPuzzle => 'RÄTSEL SPIELEN';

  @override
  String get selectProfileTitle => 'PROFIL AUSWÄHLEN';

  @override
  String get createNewProfile => '+ NEUES PROFIL ERSTELLEN';

  @override
  String get createProfileTitle => 'PROFIL ERSTELLEN';

  @override
  String get enterProfileName => 'Profilnamen eingeben';

  @override
  String get selectAvatarEmoji => 'AVATAR-EMOJI AUSWÄHLEN';

  @override
  String get createUpper => 'ERSTELLEN';

  @override
  String get editProfileTitle => 'PROFIL BEARBEITEN';

  @override
  String get saveChanges => 'ÄNDERUNGEN SPEICHERN';

  @override
  String get levelsTitle => 'Level';

  @override
  String get howToPlayTitle => 'SPIELANLEITUNG';

  @override
  String howToPlayStep(int stepNumber) {
    return 'SCHRITT $stepNumber';
  }

  @override
  String get howToPlayStep1Title => 'Wähle ein Röhrchen';

  @override
  String get howToPlayStep1Desc =>
      'Tippe auf ein Röhrchen, um es auszuwählen. Es schwebt nach oben und leuchtet auf.';

  @override
  String get howToPlayStep2Title => 'In passende Farbe gießen';

  @override
  String get howToPlayStep2Desc =>
      'Tippe auf ein anderes Röhrchen zum Umfüllen. Wasser kann nur auf dieselbe Farbe oder in ein leeres Röhrchen gegossen werden.';

  @override
  String get howToPlayStep3Title => 'Sortiere alle Farben';

  @override
  String get howToPlayStep3Desc =>
      'Ordne alle Wassersegmente so an, dass jedes Röhrchen nur eine einzige Farbe enthält.';

  @override
  String get howToPlayStep4Title => 'Senioren- & kinderfreundlich';

  @override
  String get howToPlayStep4Desc =>
      'Nutze die eindeutigen Symbole in den Wasserblöcken, um Farben ohne Anstrengung für die Augen zu unterscheiden.';

  @override
  String get gotIt => 'Verstanden!';

  @override
  String get multiplayerTitle => 'MEHRSPIELER';

  @override
  String get createRoom => 'RAUM ERSTELLEN';

  @override
  String get diffEasy => 'EINFACH';

  @override
  String get diffMedium => 'MITTEL';

  @override
  String get diffHard => 'SCHWER';

  @override
  String get diffExpert => 'EXPERTE';

  @override
  String get diffExtreme => 'EXTREM';

  @override
  String get roomCode => 'RAUM-CODE';

  @override
  String get roomCodeCopied => 'Raum-Code in die Zwischenablage kopiert';

  @override
  String get playThisPuzzle => 'DIESES RÄTSEL SPIELEN';

  @override
  String get joinRoom => 'RAUM BEITRETEN';

  @override
  String enterCodeHint(String code) {
    return 'CODE EINGEBEN (Z. B. $code)';
  }

  @override
  String get joinPuzzle => 'RÄTSEL BEITRETEN';

  @override
  String get invalidRoomCode =>
      'Ungültiger Raum-Code. Bitte überprüfen und erneut versuchen.';

  @override
  String get levelSolvable => 'Level ist lösbar';

  @override
  String get levelNotSolvable => 'Level ist nicht lösbar';

  @override
  String get random => 'ZUFALL';

  @override
  String levelTitle(int levelNumber) {
    return 'LEVEL $levelNumber';
  }

  @override
  String get retry => 'Wiederholen';

  @override
  String get undo => 'RÜCKGÄNGIG';

  @override
  String get moves => 'ZÜGE';

  @override
  String get check => 'PRÜFEN';

  @override
  String get hint => 'HINWEIS';

  @override
  String get noSolutionPossible =>
      'Aus dem aktuellen Zustand ist keine Lösung möglich. Versuche, einige Züge rückgängig zu machen!';

  @override
  String get levelComplete => 'LEVEL ABGESCHLOSSEN!';

  @override
  String levelCompleteRandomDesc(String difficulty, int moveCount) {
    return 'Du hast dieses $difficulty-Rätsel in $moveCount Zügen gelöst.';
  }

  @override
  String levelCompleteDesc(int levelNumber, int moveCount) {
    return 'Du hast Level $levelNumber in $moveCount Zügen gelöst.';
  }

  @override
  String get playAgain => 'Nochmals spielen';

  @override
  String get nextLevel => 'Nächstes Level';

  @override
  String get home => 'Hauptmenü';

  @override
  String get buyMeACoffeeWithEmoji => 'Gib mir einen Kaffee aus ☕';

  @override
  String get timesUp => 'DIE ZEIT IST UM!';

  @override
  String get timesUpDesc =>
      'Dir ist die Zeit zum Sortieren der Wasserfarben ausgegangen.';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get restartLevel => 'LEVEL NEU STARTEN?';

  @override
  String get restartLevelDesc =>
      'Bist du sicher, dass du das aktuelle Level neu starten möchtest? Dein aktueller Fortschritt geht verloren.';

  @override
  String get restart => 'Neustart';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cancelUpper => 'ABBRECHEN';

  @override
  String get backupExportedSuccess => 'Backup erfolgreich exportiert.';

  @override
  String get backupExportFailed => 'Export des Backups fehlgeschlagen.';

  @override
  String get backupImportedSuccess => 'Backup erfolgreich importiert.';

  @override
  String get backupImportInvalid => 'Ungültiges Backup-Dateiformat.';

  @override
  String get backupImportFailed => 'Import des Backups fehlgeschlagen.';

  @override
  String get resetProgressTitle => 'FORTSCHRITT ZURÜCKSETZEN?';

  @override
  String get resetProgressDesc =>
      'Dadurch werden alle abgeschlossenen Level, Sterne und gespeicherten Zustände für dieses Profil gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get resetUpper => 'ZURÜCKSETZEN';

  @override
  String get progressResetSuccess => 'Fortschritt wurde zurückgesetzt.';

  @override
  String get settingsTitle => 'EINSTELLUNGEN';

  @override
  String get sectionGameplayRules => 'SPIELEINSTELLUNGEN';

  @override
  String get settingTimerTitle => 'GAMEPLAY-TIMER';

  @override
  String get settingTimerDesc =>
      'Füge Levels einen Countdown-Timer für eine zusätzliche Herausforderung hinzu oder lasse ihn ausgeschaltet, um entspannt zu spielen.';

  @override
  String get settingHintHelperTitle => 'HINWEIS-HELFER';

  @override
  String get settingHintHelperDesc =>
      'Zeige während des Spiels eine Hinweis-Schaltfläche an, um den nächsten optimalen Zug hervorzuheben.';

  @override
  String get settingCheckButtonTitle => 'PRÜFEN-SCHALTFLÄCHE';

  @override
  String get settingCheckButtonDesc =>
      'Ersetze die Hinweis-Schaltfläche durch eine Prüfen-Schaltfläche, die per Tooltip anzeigt, ob das Level lösbar ist, ohne direkte Hinweise zu geben.';

  @override
  String get settingSuperHardTitle => 'SUPER-SCHWERER SCHWIERIGKEITSGRAD';

  @override
  String get settingSuperHardDesc =>
      'Zeige nur die oberste Farbe an. Alle darunter verborgenen Flüssigkeitssegmente sind rein weiß.';

  @override
  String get settingDecrementMovesTitle => 'ZÜGE BEI RÜCKGÄNGIG VERRINGERN';

  @override
  String get settingDecrementMovesDesc =>
      'Verringere den Zugzähler, wenn ein Zug rückgängig gemacht wird.';

  @override
  String get sectionAudioAnimations => 'AUDIO & ANIMATIONEN';

  @override
  String get settingSoundEffectsTitle => 'SOUNDEFFEKTE';

  @override
  String get settingSoundEffectsDesc =>
      'Geräusche beim Umfüllen von Flüssigkeiten, Töne beim Fertigstellen von Röhrchen und Siegesfanfaren.';

  @override
  String get settingTurnOffAnimationsTitle => 'ANIMATIONEN AUSSCHALTEN';

  @override
  String get settingTurnOffAnimationsDesc =>
      'Sofortiges Gameplay. Deaktiviert Gießphysik, Wellen, Effekte und alle Soundeffekte.';

  @override
  String get sectionBackupRestore => 'SICHERUNG & WIEDERHERSTELLUNG';

  @override
  String get actionExportBackupTitle => 'BACKUP EXPORTIEREN';

  @override
  String get actionExportBackupDesc => 'Sichere deinen Fortschritt';

  @override
  String get actionImportBackupTitle => 'BACKUP IMPORTIEREN';

  @override
  String get actionImportBackupDesc => 'Stelle deinen Fortschritt wieder her';

  @override
  String get sectionSupportAbout => 'SUPPORT & INFO';

  @override
  String get actionReportBugsTitle => 'FEHLER MELDEN / VORSCHLÄGE';

  @override
  String get actionReportBugsDesc =>
      'Öffne GitHub, um Fehlerberichte einzureichen oder neue Funktionen vorzuschlagen.';

  @override
  String get actionBuyCoffeeTitle => 'GIB MIR EINEN KAFFEE AUS';

  @override
  String get actionBuyCoffeeDesc =>
      'Unterstütze die unabhängige Entwicklung und zukünftige Spiel-Updates.';

  @override
  String get actionResetAllProgressTitle => 'GESAMTEN FORTSCHRITT ZURÜCKSETZEN';

  @override
  String get actionResetAllProgressDesc =>
      'Lösche alle gelösten Level-Einträge, Sterne und gespeicherten Zustände.';

  @override
  String get themeMidnight => 'MITTERNACHT';

  @override
  String get themeCyberpunk => 'CYBERPUNK';

  @override
  String get themeForest => 'WALD';

  @override
  String get themeSpace => 'WELTRAUM';

  @override
  String get themeRetro => 'RETRO';

  @override
  String get themeSunset => 'SONNENUNTERGANG';

  @override
  String get themeNeon => 'NEON';

  @override
  String get themeOcean => 'OZEAN';

  @override
  String get themeVolcano => 'VULKAN';

  @override
  String get themeAurora => 'AURORA';

  @override
  String get themeLavender => 'LAVENDEL';

  @override
  String get themeDesert => 'WÜSTE';

  @override
  String get themeGlitch => 'GLITCH';

  @override
  String get themeSakura => 'SAKURA';

  @override
  String get themeMonochrome => 'MONOCHROM';

  @override
  String get themeAquamarine => 'AQUAMARIN';

  @override
  String get themeSolar => 'SOLAR';

  @override
  String get customizationTitle => 'ANPASSUNG';

  @override
  String get themePalettesTitle => 'THEMEN-PALETTEN';

  @override
  String get customizeLiquidColorsTitle => 'FLÜSSIGKEITSFARBEN ANPASSEN';

  @override
  String get jsonUpper => 'JSON';

  @override
  String get liquidColorsResetSuccess =>
      'Flüssigkeitsfarben auf Standard zurückgesetzt.';

  @override
  String get resetAllUpper => 'ALLES ZURÜCKSETZEN';

  @override
  String get visualsTitle => 'OPTIK';

  @override
  String get frostSolvedTubesTitle => 'GELÖSTE RÖHRCHEN GEFRIEREN';

  @override
  String get frostSolvedTubesDesc =>
      'Wende einen Mattglas-Effekt auf fertiggestellte Röhrchen an, um dich leicht auf die aktiven zu konzentrieren.';

  @override
  String get tubeThicknessTitle => 'RÖHRCHEN-DICKE';

  @override
  String get tubeThicknessDesc =>
      'Wähle, wie breit oder dünn die Röhrchen auf dem Bildschirm erscheinen.';

  @override
  String get tubeThicknessSlim => 'SCHMAL';

  @override
  String get tubeThicknessMedium => 'MITTEL';

  @override
  String get tubeThicknessWide => 'BREIT';

  @override
  String get tubeThicknessAdaptive => 'ANPASSEN';

  @override
  String get customBackgroundTitle => 'BENUTZERDEFINIERTES HINTERGRUNDBILD';

  @override
  String get customBackgroundDesc =>
      'Wähle ein eigenes Bild von deinem Gerät als Spielhintergrund.';

  @override
  String get customBackgroundSetSuccess =>
      'Benutzerdefiniertes Hintergrundbild erfolgreich festgelegt.';

  @override
  String get changeImage => 'BILD ÄNDERN';

  @override
  String get setBackgroundImage => 'HINTERGRUNDBILD FESTLEGEN';

  @override
  String get customBackgroundRemovedSuccess =>
      'Benutzerdefiniertes Hintergrundbild entfernt.';

  @override
  String get customizeColorTitle => 'FARBE ANPASSEN';

  @override
  String get hexNumber => 'HEX #';

  @override
  String get iconColorTitle => 'ICON-FARBE';

  @override
  String get whiteUpper => 'WEISS';

  @override
  String get blackUpper => 'SCHWARZ';

  @override
  String get hslAdjustmentTitle => 'HSL-ANPASSUNG';

  @override
  String get palettePresetsTitle => 'PALETTEN-VOREINSTELLUNGEN';

  @override
  String get defaultUpper => 'STANDARD';

  @override
  String get applyUpper => 'ANWENDEN';

  @override
  String get themeJsonTitle => 'THEMEN-JSON';

  @override
  String get themeJsonCopiedSuccess =>
      'Themen-JSON in die Zwischenablage kopiert.';

  @override
  String get themeJsonDesc =>
      'Kopiere, füge ein oder bearbeite 16 Flüssigkeitsfarben im Format eines JSON-Arrays aus Hex-Codes.';

  @override
  String get jsonMustBe16Hex => 'JSON muss eine Liste von 16 Hex-Farben sein.';

  @override
  String get jsonItemMustBeHex =>
      'Jedes Farbelement muss eine Hex-Zeichenkette sein.';

  @override
  String get themeAppliedSuccess => 'Design erfolgreich angewendet.';

  @override
  String get invalidJsonSyntax => 'Ungültige JSON-Syntax.';

  @override
  String mustContainExactColors(int count, int found) {
    return 'Muss genau $count Farben enthalten ($found gefunden).';
  }

  @override
  String invalidHexColor(String item) {
    return 'Ungültige Hex-Farbe: $item';
  }

  @override
  String get sectionLanguage => 'SPRACHE';

  @override
  String get settingLanguageTitle => 'SPRACHE';

  @override
  String get settingLanguageDesc =>
      'Wähle deine bevorzugte App-Sprache oder folge dem System.';

  @override
  String get localeSystem => 'SYSTEM';

  @override
  String get localeSystemDesc => 'Gerätesprache verwenden';

  @override
  String get chooseLanguageTitle => 'SPRACHE WÄHLEN';

  @override
  String get localeEn => 'ENGLISH';

  @override
  String get localeDe => 'DEUTSCH';

  @override
  String get followTwitter => 'FOLGE MIR AUF TWITTER';

  @override
  String get followMastodon => 'FOLGE MIR AUF MASTODON';
}
