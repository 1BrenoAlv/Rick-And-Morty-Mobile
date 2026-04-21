import 'package:flutter/material.dart';

/// Cores do app baseadas no CSS da versão web do Rick and Morty Explorer.
///
/// --bg-color: #F0EBD8;
/// --bg-aside: #1D2D44;
/// --bg-main: #cfd5df33;
/// --primary-color: #0D1321;
/// --color-border: #0d132115;
/// --radius-card: 10px;
class AppColors {
  AppColors._();

  /// Cor de fundo principal (#F0EBD8)
  static const Color bgColor = Color(0xFFF0EBD8);

  /// Cor de fundo do aside / drawer (#1D2D44)
  static const Color bgAside = Color(0xFF1D2D44);

  /// Cor de fundo do conteúdo principal (#CFD5DF com 20% de opacidade)
  static const Color bgMain = Color(0x33CFD5DF);

  /// Cor primária / textos (#0D1321)
  static const Color primaryColor = Color(0xFF0D1321);

  /// Cor de borda (#0D1321 com ~8% de opacidade)
  static const Color colorBorder = Color(0x150D1321);

  /// Radius padrão dos cards (10px)
  static const double radiusCard = 10.0;

  /// BorderRadius pronto para uso nos cards
  static final BorderRadius borderRadiusCard = BorderRadius.circular(radiusCard);
}
