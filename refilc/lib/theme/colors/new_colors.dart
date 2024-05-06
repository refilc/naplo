import 'package:flutter/material.dart';

class NewColors extends ThemeExtension<NewColors> {
  const NewColors({
    required this.accent,
    required this.primary,
    required this.secondary,
    required this.teritary,
    required this.icon,
    required this.darkenBg,
    required this.btnSecStrk,
    required this.background,
    required this.card,
    required this.btnSec,
  });

  final Color? accent;
  final Color? primary;
  final Color? secondary;
  final Color? teritary;
  final Color? icon;
  final Color? darkenBg;
  final Color? btnSecStrk;
  final Color? background;
  final Color? card;
  final Color? btnSec;

  @override
  NewColors copyWith({
    Color? accent,
    Color? primary,
    Color? secondary,
    Color? teritary,
    Color? icon,
    Color? darkenBg,
    Color? btnSecStrk,
    Color? background,
    Color? card,
    Color? btnSec,
  }) {
    return NewColors(
      accent: accent ?? this.accent,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      teritary: teritary ?? this.teritary,
      icon: icon ?? this.icon,
      darkenBg: darkenBg ?? this.darkenBg,
      btnSecStrk: btnSecStrk ?? this.btnSecStrk,
      background: background ?? this.background,
      card: card ?? this.card,
      btnSec: btnSec ?? this.btnSec,
    );
  }

  @override
  NewColors lerp(NewColors? other, double t) {
    if (other is! NewColors) {
      return this;
    }
    return NewColors(
      accent: Color.lerp(accent, other.accent, t),
      primary: Color.lerp(primary, other.primary, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      teritary: Color.lerp(teritary, other.teritary, t),
      icon: Color.lerp(icon, other.icon, t),
      darkenBg: Color.lerp(darkenBg, other.darkenBg, t),
      btnSecStrk: Color.lerp(btnSecStrk, other.btnSecStrk, t),
      background: Color.lerp(background, other.background, t),
      card: Color.lerp(card, other.card, t),
      btnSec: Color.lerp(btnSec, other.btnSec, t),
    );
  }
}
