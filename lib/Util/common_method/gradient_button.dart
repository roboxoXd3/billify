// ignore_for_file: must_be_immutable

import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';

class GradientElevatedButton extends StatelessWidget {
  final Widget child;
  final Widget? icon;
  Gradient? gradient;
  final VoidCallback? onPressed;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final Color? bgColor;

  GradientElevatedButton({
    super.key,
    required this.child,
    this.icon,
    this.gradient,
    required this.onPressed,
    this.borderRadius = 8.0,
    this.elevation = 2.0,
    this.bgColor,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    final shadowColor = Theme.of(context).colorScheme.primary.withOpacity(0.15);

    Color c1 =
        context.isDark ? const Color(0xFF243B7F) : const Color.fromARGB(255, 227, 174, 2);

    Color c2 =
        context.isDark ?   const Color(0xFF3182DF):const Color(0xFFFFED12);

    gradient ??= LinearGradient(
      colors: [c1, c2],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    double blurRadius = 5 * elevation;
    double spreadRadius = 0.1;
    return Container(
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(borderRadius),
        color: onPressed == null ? bgColor : bgColor,
        boxShadow: onPressed == null
            ? null
            : [
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(elevation, elevation),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(-elevation, -elevation),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(-elevation, elevation),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(elevation, -elevation),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
        child: Ink(
          decoration: BoxDecoration(
            color: onPressed == null ? Colors.grey : bgColor,
            gradient: bgColor != null
                ? null
                : onPressed == null
                    ? null
                    : gradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: AnimatedScale(
            scale: onPressed == null ? 1.0 : 1.02,
            duration: const Duration(milliseconds: 150),
            child: Container(
              alignment: Alignment.center,
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!.paddingRight(8),
                  Flexible(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilledElevatedButton extends StatelessWidget {
  final Widget child;
  final Widget? icon;
  Gradient? gradient;
  final VoidCallback? onPressed;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;
  final bool shrink;

  FilledElevatedButton(
      {super.key,
      required this.child,
      this.icon,
      this.gradient,
      required this.onPressed,
      this.borderRadius = 8.0,
      this.elevation = 2.0,
      this.bgColor,
      this.shrink = true,
      this.padding});

  @override
  Widget build(BuildContext context) {
    final shadowColor = Theme.of(context).colorScheme.primary.withOpacity(0.15);

    Color c1 = context.isDark
        ? context.colorScheme.primary
        : context.colorScheme.primaryFixedDim;
    Color c2 = context.isDark
        ? context.colorScheme.primaryFixedDim
        : context.colorScheme.primary;
    gradient ??= LinearGradient(
      colors: [c1, c2],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    double blurRadius = 5 * elevation;
    double spreadRadius = 0.1;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: onPressed == null
            ? null
            : [
                /// shadow in all direction according to elevation value

                BoxShadow(
                  color: shadowColor,
                  offset: Offset(elevation, elevation),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),

                BoxShadow(
                  color: shadowColor,
                  offset: Offset(-elevation, -elevation),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),

                BoxShadow(
                  color: shadowColor,
                  offset: Offset(-elevation, elevation),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),

                BoxShadow(
                  color: shadowColor,
                  offset: Offset(elevation, -elevation),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          side: BorderSide(
            color: onPressed == null
                ? Colors.transparent
                : context.isDark
                    ? context.colorScheme.primary
                    : context.colorScheme.primaryFixedDim,
          ),
          foregroundColor: context.isDark
              ? context.colorScheme.primary
              : context.colorScheme.primaryFixedDim,
          backgroundColor:
              onPressed == null ? null : bgColor ?? context.colorScheme.surface,
        ),
        child: AnimatedScale(
          scale: onPressed == null && shrink ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon!.paddingRight(8),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
