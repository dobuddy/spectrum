/// Provides [MaterialColor]-related functionality.
library spectrum;

import '../common.dart';
import 'shading.dart';

/// The quantity of valid shade map `keys` for a `Map<int, Color> palette`
/// that would generate a [MaterialAccentColor].
const kShadeCountMaterialAccent = 5;

/// The quantity of valid shade map `keys` for a `Map<int, Color> palette`
/// that would generate a [MaterialColor].
const kShadeCountMaterialColor = 10;

/// The range of valid shade map `keys` for a `Map<int, Color> palette`
/// that would generate a [MaterialAccentColor].
const kShadeKeysMaterialAccent = [50, 100, 200, 400, 700];

/// The range of valid shade map `keys` for a `Map<int, Color> palette`
/// that would generate a [MaterialColor].
const kShadeKeysMaterialColor = [
  50,
  100,
  200,
  300,
  400,
  500,
  600,
  700,
  800,
  900,
];

/// Accepts a `Color` and returns a [MaterialColor] whose primary is the
/// provided `color` and whose `swatch` is generated by [mapSwatchByShade].
MaterialColor materialColorFrom(Color color, Blend mode, double? factor) =>
    mode == Blend.range
        ? MaterialColor(
            color.value,
            mapSwatchByShade(
              color,
              min: factor != null ? -(factor ~/ 2) : -100,
              max: factor != null ? factor ~/ 2 : 100,
            ))
        : mode == Blend.shade
            ? MaterialColor(color.value,
                mapSwatchByAlphaBlend(color, strength: factor ?? 1.0))
            : MaterialColor(color.value,
                mapSwatchByOpacity(color, add: factor?.truncate() ?? 0));

/// Accepts [Color] `primary` and returns a `Map<int, Color>`
/// with the appropriate keys to form a `ColorSwatch<int>._swatch`,
/// which can fulfill the [new MaterialColor] `swatch` property.
///
/// - `050`: `primary.withWhite(step)`
/// - `100`: `primary.withWhite(step)`
/// - ...
/// - `800`: `primary.withWhite(step)`
/// - `900`: `primary.withWhite(step)`
///
/// Where `step` is determined by finding the range between [min] and [max]
/// and dividing by `10`, considering a `MaterialColor` has ten shades.
///
/// Value for key `500`: passed `primary`
///
/// Default [min] is `-75` and default max is `75`.
///
/// If `min` and `max` are not polar opposites, the value mapped to shade 500
/// will not match the input provided [primary] color.
Map<int, Color> mapSwatchByShade(
  Color primary, {
  int min = -100,
  int max = 100,
}) {
  final range = max - min;
  // ten shades in a MaterialColor
  final step = range / kShadeCountMaterialColor;
  final shades = List<int>.generate(
      kShadeCountMaterialColor, (int index) => (max - index * step).truncate());

  var i = 0;
  return <int, Color>{
    for (var shade in kShadeKeysMaterialColor)
      shade: primary.withWhite(shades[i++])
  };
}

/// Accepts [Color] `primary` and returns a `Map<int, Color>`
/// with the appropriate keys to form a `ColorSwatch<int>._swatch`,
/// which can fulfill the [new MaterialColor] `swatch` property.
///
/// - `050`: `Color.alphaBlend(primary.withOpacity(0.25), Colors.white)`,
/// - `100`: `Color.alphaBlend(primary.withOpacity(0.45), Colors.white)`,
/// - ...
/// - `800`: `Color.alphaBlend(primary.withOpacity(0.4), Colors.black)`,
/// - `900`: `Color.alphaBlend(primary.withOpacity(0.25), Colors.black)`
///
/// The value mapped to shade 500 will always be the input provided
/// [primary] color.
Map<int, Color> mapSwatchByAlphaBlend(Color primary, {double strength = 1.0}) {
  return {
    50: Color.alphaBlend(
        primary.withOpacity((0.25 * strength).clamp(0, 1)), Colors.white),
    100: Color.alphaBlend(
        primary.withOpacity((0.45 * strength).clamp(0, 1)), Colors.white),
    200: Color.alphaBlend(
        primary.withOpacity((0.65 * strength).clamp(0, 1)), Colors.white),
    300: Color.alphaBlend(
        primary.withOpacity((0.8 * strength).clamp(0, 1)), Colors.white),
    400: Color.alphaBlend(
        primary.withOpacity((0.9 * strength).clamp(0, 1)), Colors.white),
    500: primary,
    600: Color.alphaBlend(
        primary.withOpacity((0.75 * strength).clamp(0, 1)), Colors.black),
    700: Color.alphaBlend(
        primary.withOpacity((0.55 * strength).clamp(0, 1)), Colors.black),
    800: Color.alphaBlend(
        primary.withOpacity((0.4 * strength).clamp(0, 1)), Colors.black),
    900: Color.alphaBlend(
        primary.withOpacity((0.25 * strength).clamp(0, 1)), Colors.black),
  };
}

/// Accepts [Color] `primary` and returns a `Map<int, Color>`
/// with the appropriate keys to form a `ColorSwatch<int>._swatch`,
/// which can fulfill the [new MaterialColor] `swatch` property.
///
/// - `050`: `primary.withOpacity(0.1)`
/// - `100`: `primary.withOpacity(0.2)`
/// - ...
/// - `800`: `primary.withOpacity(0.9)`
/// - `900`: `primary.withOpacity(1.0)`
///
/// The value mapped to shade 500 will not be the input provided
/// [primary] color. It will be [primary] with an opacity of `0.6`.
///
/// All the above is true with the default [add] `== 1`. The `add` is
/// the amount to provide as `primary.withWhite(add)` on top of ramping the
/// opacity with each progressive shade.
Map<int, Color> mapSwatchByOpacity(Color primary, {int add = 0}) {
  return {
    50: primary.withWhite(add).withOpacity(0.1),
    100: primary.withWhite(add).withOpacity(0.2),
    200: primary.withWhite(add).withOpacity(0.3),
    300: primary.withWhite(add).withOpacity(0.4),
    400: primary.withWhite(add).withOpacity(0.5),
    500: primary.withWhite(add).withOpacity(0.6),
    600: primary.withWhite(add).withOpacity(0.7),
    700: primary.withWhite(add).withOpacity(0.8),
    800: primary.withWhite(add).withOpacity(0.9),
    900: primary.withWhite(add).withOpacity(1.0),
  };
}
