import 'package:billify/Util/app_colors.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

extension WidgetExt on Widget {
  Widget shimmer(
    double height, {
    double borderRadius = 10,
    bool enabled = true,
    double width = double.infinity,
    BoxShape shape = BoxShape.rectangle,
    Color? shimmerColor = borderLineColor,
    int shimmerDuration = 1000,
  }) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: shimmerDuration),
        child: enabled
            ? Builder(builder: (context) {
                bool isDark = context.isDark;
                Color c1 = isDark
                    ? context.colorScheme.primary.withOpacity(0.2)
                    : Colors.grey[300]!;
                Color c2 = isDark ? Colors.grey[500]! : Colors.grey[200]!;
                return SkeletonAnimation(
                  shimmerColor: shimmerColor ?? c1,
                  borderRadius: BorderRadius.circular(borderRadius),
                  shimmerDuration: 1000,
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      shape: shape,
                      color: c2,
                      borderRadius: shape == BoxShape.rectangle
                          ? BorderRadius.circular(borderRadius)
                          : null,
                    ),
                    // child: this,
                  ),
                );
              })
            : this);
  }

  Widget shimmerText({
    double height = 18,
    double borderRadius = 5,
    bool enabled = true,
    double width = double.infinity,
    BoxShape shape = BoxShape.rectangle,
    AlignmentGeometry? alignment,
    Color? shimmerColor,
  }) {
    if (alignment == null) {
      return shimmer(height,
          borderRadius: borderRadius,
          enabled: enabled,
          width: width,
          shape: shape,
          shimmerColor: shimmerColor);
    }
    return Container(
      height: height,
      width: width,
      alignment: alignment,
      child: shimmer(height,
          borderRadius: borderRadius,
          enabled: enabled,
          width: width,
          shape: shape,
          shimmerColor: shimmerColor),
    );
  }

  Widget shimmerFull({
    bool enabled = true,
  }) {
    if (enabled == false) return this;
    return SkeletonAnimation(
      shimmerColor: Colors.grey[300]!,
      borderRadius: BorderRadius.circular(10),
      shimmerDuration: 1000,
      child: this,
    );
  }

  Widget safe({
    Key? key,
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
    EdgeInsets minimum = EdgeInsets.zero,
    bool maintainBottomViewPadding = false,
  }) {
    return SafeArea(
      key: key,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: this,
    );
  }

  Widget fit({BoxFit fit = BoxFit.contain}) {
    return FittedBox(
      fit: fit,
      child: this,
    );
  }
}
