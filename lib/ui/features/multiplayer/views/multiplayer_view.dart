import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watersort/l10n/app_localizations.dart';
import 'package:watersort/ui/core/theme/app_colors.dart';
import 'package:watersort/ui/core/widgets/tangible_button.dart';
import 'package:watersort/ui/features/game/views/game_view.dart';

class MultiplayerView extends StatefulWidget {
  const MultiplayerView({super.key});

  @override
  State<MultiplayerView> createState() => _MultiplayerViewState();
}

class _MultiplayerViewState extends State<MultiplayerView> {
  static const _difficulties = [
    {'value': 'Easy', 'cap': 4},
    {'value': 'Medium', 'cap': 4},
    {'value': 'Hard', 'cap': 5},
    {'value': 'Super Hard', 'cap': 5},
    {'value': 'Super Duper Hard', 'cap': 6},
  ];

  String _selectedDifficulty = 'Easy';
  late int _seed;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _regenerateSeed();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _regenerateSeed() {
    setState(() {
      _seed = 100000 + Random().nextInt(900000);
    });
  }

  String _encodeRoom(String diff, int seed) {
    final idx = _difficulties.indexWhere((d) => d['value'] == diff);
    final safeIdx = idx == -1 ? 0 : idx;
    return '$safeIdx-$seed';
  }

  (String, int)? _decodeRoom(String raw) {
    final clean = raw.trim();
    final parts = clean.split('-');
    if (parts.length == 2) {
      final idx = int.tryParse(parts[0]);
      final s = int.tryParse(parts[1]);
      if (idx != null && s != null && idx >= 0 && idx < _difficulties.length) {
        return (_difficulties[idx]['value'] as String, s);
      }
    }
    final numericOnly = int.tryParse(clean);
    if (numericOnly != null) {
      return (_selectedDifficulty, numericOnly);
    }
    return null;
  }

  int _getCap(String diff) {
    final item = _difficulties.firstWhere(
      (d) => d['value'] == diff,
      orElse: () => _difficulties.first,
    );
    return item['cap'] as int;
  }

  void _launchGame(String diff, int seed) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameView(
          levelNumber: 0,
          isRandom: true,
          randomDifficulty: diff,
          randomCapacity: _getCap(diff),
          randomSeed: seed,
        ),
      ),
    );
  }

  String _difficultyLabel(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 'Easy':
        return l10n.diffEasy;
      case 'Medium':
        return l10n.diffMedium;
      case 'Hard':
        return l10n.diffHard;
      case 'Super Hard':
        return l10n.diffExpert;
      case 'Super Duper Hard':
        return l10n.diffExtreme;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final code = _encodeRoom(_selectedDifficulty, _seed);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C22),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF222222),
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.multiplayerTitle,
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.headingWhite,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.createRoom,
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 18,
                        color: AppColors.accent,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _difficulties.map((diff) {
                        final diffValue = diff['value'] as String;
                        final isSelected = _selectedDifficulty == diffValue;
                        return ChoiceChip(
                          label: Text(
                            _difficultyLabel(context, diffValue),
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 14,
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.accent,
                          backgroundColor: const Color(0xFF1C1C22),
                          side: BorderSide(
                            color: isSelected ? AppColors.accent : const Color(0xFF333333),
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedDifficulty = diffValue;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF18181E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF222222)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.roomCode,
                                  style: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontSize: 12,
                                    color: AppColors.subtext,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SelectableText(
                                  code,
                                  style: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontSize: 26,
                                    color: AppColors.headingWhite,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                            onPressed: _regenerateSeed,
                          ),
                          IconButton(
                            icon: Icon(Icons.copy_rounded, color: AppColors.accent),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: code));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.roomCodeCopied),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    TangibleButton(
                      text: l10n.playThisPuzzle,
                      onPressed: () => _launchGame(_selectedDifficulty, _seed),
                    ),
                    const SizedBox(height: 28),
                    Divider(color: const Color(0xFF262626)),
                    const SizedBox(height: 20),
                    Text(
                      l10n.joinRoom,
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 18,
                        color: AppColors.accent,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _codeController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.enterCodeHint(code),
                        hintStyle: TextStyle(
                          fontFamily: 'BebasNeue',
                          color: AppColors.subtext.withOpacity(0.5),
                          fontSize: 15,
                          letterSpacing: 1.0,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF18181E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF222222)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF222222)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.accent),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.paste_rounded, color: Colors.white70),
                          onPressed: () async {
                            final data = await Clipboard.getData(Clipboard.kTextPlain);
                            if (data?.text != null) {
                              _codeController.text = data!.text!.trim();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TangibleButton(
                      text: l10n.joinPuzzle,
                      isSecondary: true,
                      onPressed: () {
                        final decoded = _decodeRoom(_codeController.text);
                        if (decoded == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.invalidRoomCode),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        _launchGame(decoded.$1, decoded.$2);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
