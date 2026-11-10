import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaitTimerBadge extends StatefulWidget {
  final DateTime entryTime;
  final bool compact;
  final bool isCompleted;
  final bool enablePulsing;

  const WaitTimerBadge({
    super.key,
    required this.entryTime,
    this.compact = false,
    this.isCompleted = false,
    this.enablePulsing = true,
  });

  @override
  State<WaitTimerBadge> createState() => _WaitTimerBadgeState();
}

class _WaitTimerBadgeState extends State<WaitTimerBadge>
    with SingleTickerProviderStateMixin {
  late Timer _ticker;
  late int _minutes;
  AnimationController? _pulseController;

  @override
  void initState() {
    super.initState();
    _updateMinutes();
    _setupAnimation();
    if (!widget.isCompleted) {
      _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
        if (mounted) {
          _updateMinutes();
        }
      });
    }
  }

  void _updateMinutes() {
    setState(() {
      final now = DateTime.now();
      final diff = now.difference(widget.entryTime.toLocal()).inMinutes;
      _minutes = diff < 0 ? 0 : diff;
    });
    _setupAnimation();
  }

  void _setupAnimation() {
    if (widget.enablePulsing && _minutes >= 45 && !widget.isCompleted) {
      _pulseController ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      )..repeat(reverse: true);
    } else {
      _pulseController?.stop();
      _pulseController?.dispose();
      _pulseController = null;
    }
  }

  @override
  void dispose() {
    if (!widget.isCompleted) {
      _ticker.cancel();
    }
    _pulseController?.dispose();
    super.dispose();
  }

  Color get _badgeColor {
    if (widget.isCompleted) return AppTheme.textMuted;
    if (_minutes >= 45) return AppTheme.slaOverdue;
    if (_minutes >= 30) return AppTheme.slaWarning;
    return AppTheme.slaNormal;
  }

  String get _label {
    if (widget.isCompleted) {
      return '${_minutes}m (Done)';
    }
    if (_minutes >= 45) {
      return widget.compact ? '${_minutes}m ⚠️' : 'OVERDUE: ${_minutes}m';
    }
    return '${_minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final color = _badgeColor;

    Widget badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? 6 : 10,
        vertical: widget.compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            _label,
            style: TextStyle(
              fontSize: widget.compact ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );

    if (_pulseController != null) {
      return AnimatedBuilder(
        animation: _pulseController!,
        builder: (context, child) {
          final scale = 1.0 + (_pulseController!.value * 0.05);
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: badge,
      );
    }

    return badge;
  }
}
