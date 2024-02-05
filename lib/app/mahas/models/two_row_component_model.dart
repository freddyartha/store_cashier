import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';

class TwoRowComponentModel {
  String? title;
  String? data;
  bool? isTitle;

  TwoRowComponentModel.init({
    required this.title,
    this.data,
    this.isTitle = false,
  });
}

class CustomTwoRowComponentModel {
  String? title;
  String? data;
  InputTextController? textController;

  CustomTwoRowComponentModel({
    required this.title,
    this.data,
    this.textController,
  });
}
