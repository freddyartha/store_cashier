import 'package:flutter/material.dart';

class ListGridComponent extends StatelessWidget {
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int itemCount;
  final int itemCountPerRow;
  final Widget Function(int index) itemBuilder;

  const ListGridComponent({
    super.key,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    required this.itemCount,
    required this.itemCountPerRow,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    int numRows = (itemCount + itemCountPerRow - 1) ~/ itemCountPerRow;
    int numCols = itemCountPerRow;

    // Create a 2D array to hold the widgets
    // and provide a default Container()
    List<List<Widget>> items2d = List.generate(
      numRows,
      (row) => List.generate(numCols, (col) => Container()),
    );

    // Inserting the input widget
    // from itemBuilder into the 2D array
    for (int i = 0; i < itemCount; i++) {
      int row = i ~/ itemCountPerRow;
      int col = i % itemCountPerRow;
      items2d[row][col] = itemBuilder(i);
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: numRows,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: mainAxisSpacing),
      itemBuilder: (context, index) {
        double leftSpacing = (index == 0) ? 0 : crossAxisSpacing / 2;
        double rightSpacing =
            (index == (itemCountPerRow - 1)) ? 0 : crossAxisSpacing / 2;

        return Row(
          children: items2d[index]
              .asMap()
              .map((index, item) {
                return MapEntry(
                  index,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: leftSpacing,
                        right: rightSpacing,
                      ),
                      child: item,
                    ),
                  ),
                );
              })
              .values
              .toList(),
        );
      },
    );
  }
}
