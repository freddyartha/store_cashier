import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/mahas_themes.dart';
import 'package:store_cashier/app/mahas/components/others/two_row_component.dart';
import 'package:store_cashier/app/mahas/models/two_row_component_model.dart';

import 'components/texts/text_component.dart';
import 'mahas_colors.dart';
import 'mahas_font_size.dart';

class MahasWidget {
  static PreferredSizeWidget mahasAppBar({
    required String title,
    Color background = MahasColors.main,
    IconData backIcon = Icons.arrow_back_ios,
    Color appBarItemColor = MahasColors.light,
    double elevation = MahasThemes.cardelevation,
    Function()? onBackTap,
    bool isLeading = true,
    TextAlign titleAlign = TextAlign.center,
    List<Widget>? actionBtn,
  }) {
    return AppBar(
      elevation: elevation,
      title: TextComponent(
        value: title,
        fontSize: MahasFontSize.actionBartitle,
        fontColor: appBarItemColor,
        fontWeight: FontWeight.w500,
        textAlign: titleAlign,
      ),
      backgroundColor: background,
      leading: isLeading == true
          ? IconButton(
              onPressed: onBackTap ??
                  () {
                    Get.back();
                  },
              icon: Icon(backIcon),
            )
          : null,
      iconTheme: IconThemeData(
        color: appBarItemColor,
      ),
      actions: actionBtn,
    );
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Widget hideWidget() {
    return Visibility(visible: false, child: Container());
  }

  static Widget backgroundWidget() {
    return ClipPath(
      clipper: BackgroundClipper(),
      child: Container(
        color: MahasColors.primary,
      ),
    );
  }

  static Widget loadingWidget({Widget? customWidget}) {
    return customWidget != null
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: true,
            child: customWidget)
        : Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: MahasColors.primary,
                ),
              ),
            ],
          );
  }

  static Widget pageUnderConstructionWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/page_under_construction.png",
              width: Get.width * 0.7,
            ),
            const TextComponent(
              value: "Halaman ini sedang dalam pengembangan!",
              fontSize: MahasFontSize.h4,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              margin: EdgeInsets.only(top: 10),
            ),
          ],
        ),
      ),
    );
  }

  static Widget searchInstructionWidget({
    String? message,
    bool isCard = false,
    Color textColor = MahasColors.dark,
  }) {
    return isCard
        ? Card(
            margin: const EdgeInsets.all(10),
            elevation: MahasThemes.cardelevation,
            shape: MahasThemes.cardBorderShape,
            color: MahasColors.light,
            child: SizedBox(
              width: Get.width,
              child: InstructionWidget(message: message),
            ),
          )
        : InstructionWidget(message: message, textColor: textColor);
  }

  static Widget safeAreaWidget(
      {bool connectionStatus = true, Widget? child, Color? color}) {
    return Container(
      color: color ?? MahasColors.backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          color: connectionStatus
              ? MahasColors.primary
              : MahasColors.backgroundColor,
          child: SafeArea(
            child: child ?? hideWidget(),
          ),
        ),
      ),
    );
  }

  static Widget uniformCardWidget({
    required Widget child,
    EdgeInsetsGeometry margin = const EdgeInsets.all(10),
    EdgeInsetsGeometry padding = const EdgeInsets.all(10),
    Color color = MahasColors.light,
  }) {
    return Card(
      margin: margin,
      elevation: MahasThemes.cardelevation,
      shape: MahasThemes.cardBorderShape,
      color: color,
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }

  static Widget dividerTitleWidget(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 15,
          thickness: 1,
          color: MahasColors.grey,
        ),
        TextComponent(
          value: title,
          margin: const EdgeInsets.only(
            bottom: 5,
          ),
          fontWeight: FontWeight.w500,
          fontSize: MahasFontSize.h5,
        ),
      ],
    );
  }

  static Widget listTwoRowWidget({
    required List<TwoRowComponentModel> values,
    double titleWidth = 20,
    bool isInPixel = true,
    bool isWithColon = false,
    TextAlign textAlign = TextAlign.justify,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: values.length,
      itemBuilder: (context, index) {
        bool isTitle =
            values[index].isTitle != null && values[index].isTitle == true;
        return TwoRowComponent(
          isInPixel: isInPixel,
          title: values[index].title,
          data: values[index].data,
          titleFontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
          dataFontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
          titleWidth: titleWidth,
          colonMargin: 5,
          isWithColon: isWithColon,
          titleMuted: true,
          dataAlign: textAlign,
          padding: EdgeInsets.only(top: isTitle ? 10 : 2),
        );
      },
    );
  }

  static Widget listCustomTwoRowWidget({
    required List<CustomTwoRowComponentModel> values,
    bool editable = false,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: values.length,
      itemBuilder: (context, index) {
        return TwoRowComponent(
          title: values[index].title,
          isWithColon: true,
          colonMargin: 5,
          titleMuted: true,
          padding: const EdgeInsets.only(top: 2),
          isCustomDataWidget: editable,
          titleWidth: 0.3,
          data: values[index].data,
          dataCustomWidget: InputTextComponent(
            isBorderRectangle: true,
            editable: editable,
            controller: values[index].textController,
          ),
        );
      },
    );
  }

  static Widget customLoadingWidget({double? width}) {
    return Container(
      height: 15,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: MahasColors.light,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  ui.Path getClip(ui.Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.35);
    path.lineTo(size.width, size.height * 0.65);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<ui.Path> oldClipper) => false;
}

class InstructionWidget extends StatelessWidget {
  const InstructionWidget({
    super.key,
    this.message,
    this.textColor = MahasColors.dark,
  });

  final String? message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/search_illustration.png",
            width: Get.width * 0.6,
          ),
          TextComponent(
            value: message ?? "Klik Tombol di Atas untuk Mencari Data",
            fontSize: MahasFontSize.h6,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            margin: const EdgeInsets.only(top: 30),
            fontColor: textColor,
          ),
        ],
      ),
    );
  }
}
