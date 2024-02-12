import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_cashier/app/mahas/components/mahas_themes.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';

import '../../mahas_colors.dart';

class ShimmerComponent extends StatelessWidget {
  final int count;
  final double marginBottom;
  final double marginTop;
  final double marginLeft;
  final double marginRight;
  final bool isCardList;

  const ShimmerComponent({
    super.key,
    this.count = 8,
    this.marginBottom = 0,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginTop = 0,
    this.isCardList = true,
  });

  @override
  Widget build(BuildContext context) {
    var shimmers = <Widget>[];

    for (var i = 1; i <= count; i++) {
      shimmers.add(
        isCardList
            ? MahasWidget.uniformCardWidget(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: const SizedBox(
                  height: 60,
                  width: double.infinity,
                ),
              )
            : Container(
                margin: EdgeInsets.only(
                  right: marginRight,
                  left: marginLeft,
                  top: marginTop,
                  bottom: i == count ? marginBottom : 5,
                ),
                width: double.infinity,
                height: 25,
                decoration: BoxDecoration(
                  color: MahasColors.light,
                  borderRadius:
                      BorderRadius.circular(MahasThemes.borderRadius / 2),
                ),
              ),
      );
    }
    return Shimmer.fromColors(
      baseColor: MahasColors.dark.withOpacity(.1),
      highlightColor: MahasColors.dark.withOpacity(.05),
      child: SingleChildScrollView(
        child: Column(
          children: shimmers,
        ),
      ),
    );
  }
}
