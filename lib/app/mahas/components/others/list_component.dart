import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';
import '../../mahas_colors.dart';
import '../inputs/input_text_component.dart';
import 'empty_component.dart';
import 'shimmer_component.dart';

class ListComponentController<T> {
  final Function()? addOnTap;
  final bool allowSearch;
  final bool isWithAddTap;
  late Function(VoidCallback fn) setState;
  Query<T> query;

  ListComponentController({
    required this.query,
    this.allowSearch = true,
    this.addOnTap,
    this.isWithAddTap = true,
  });

  void init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
  }
}

class ListComponent<T> extends StatefulWidget {
  final ListComponentController<T> controller;
  final Widget Function(QueryDocumentSnapshot<T>) itemBuilder;
  final bool emptyIsCard;
  final bool isCustomLoadingWidget;
  final Widget customLoadingWidget;
  final InputTextComponent? searchTextComponent;

  const ListComponent({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.emptyIsCard = false,
    this.isCustomLoadingWidget = false,
    this.customLoadingWidget = const ShimmerComponent(),
    this.searchTextComponent,
  });

  @override
  State<ListComponent<T>> createState() => _ListComponentState<T>();
}

class _ListComponentState<T> extends State<ListComponent<T>> {
  @override
  void initState() {
    widget.controller.init((fn) {
      if (mounted) {
        setState(fn);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MahasWidget.backgroundWidget(),
        Column(
          children: [
            Visibility(
              visible: widget.controller.allowSearch,
              child: MahasWidget.uniformCardWidget(
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 25,
                      color: MahasColors.greyFontColor,
                    ),
                    Expanded(
                      child: Center(child: widget.searchTextComponent),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FirestoreListView<T>(
                query: widget.controller.query,
                emptyBuilder: (context) => const EmptyComponent(),
                loadingBuilder: (context) => const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: ShimmerComponent(),
                ),
                errorBuilder: (context, error, stackTrace) => EmptyComponent(
                  isGeneralError: true,
                  message: error.toString(),
                ),
                itemBuilder: (context, doc) {
                  return widget.itemBuilder(doc);
                },
              ),
            ),
          ],
        ),
        Visibility(
          visible: widget.controller.isWithAddTap,
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: widget.controller.addOnTap,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: MahasColors.light,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: MahasColors.primary,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
