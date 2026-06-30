import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

/// Typewriter animation that reveals [text] character by character,
/// followed by a blinking cursor that fades out once typing is done.
class TypewriterText extends StatefulWidget {
  final String text;

  /// Delay between each character reveal.
  final Duration charDelay;

  /// How long to keep the cursor blinking after typing completes.
  final Duration cursorLingerDuration;

  const TypewriterText({
    super.key,
    required this.text,
    this.charDelay = const Duration(milliseconds: 110),
    this.cursorLingerDuration = const Duration(milliseconds: 900),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with TickerProviderStateMixin {
  String _displayed = '';
  bool _showCursor = true;
  bool _typingDone = false;

  Timer? _charTimer;
  late AnimationController _cursorBlink;
  late AnimationController _cursorFade;

  @override
  void initState() {
    super.initState();

    // ── Cursor blink ──────────────────────────────────────────────────────────
    _cursorBlink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    // ── Cursor fade-out after typing ──────────────────────────────────────────
    _cursorFade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );

    _startTyping();
  }

  void _startTyping() {
    int index = 0;
    _charTimer = Timer.periodic(widget.charDelay, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (index < widget.text.length) {
        setState(() => _displayed = widget.text.substring(0, index + 1));
        index++;
      } else {
        timer.cancel();
        _onTypingComplete();
      }
    });
  }

  void _onTypingComplete() async {
    _typingDone = true;
    // Let cursor blink a little after typing
    await Future.delayed(widget.cursorLingerDuration);
    if (!mounted) return;
    // Fade cursor out
    await _cursorFade.animateTo(0);
    if (!mounted) return;
    setState(() => _showCursor = false);
  }

  @override
  void dispose() {
    _charTimer?.cancel();
    _cursorBlink.dispose();
    _cursorFade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // The typed text
        Text(
          _displayed,
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 48,
            fontWeight: FontWeight.w400,
            color: AppColors.onBackground,
            letterSpacing: 2,
          ),
        ),

        // Blinking cursor
        if (_showCursor)
          AnimatedBuilder(
            animation: _typingDone ? _cursorFade : _cursorBlink,
            builder: (context, child) {
              final opacity =
                  _typingDone ? _cursorFade.value : _cursorBlink.value;
              return Opacity(
                opacity: opacity,
                child: Container(
                  width: 3,
                  height: 50,
                  margin: const EdgeInsets.only(left: 3, bottom: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
