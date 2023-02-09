// Copyright 2020 Godwin Asuquo. All rights reserved.
//
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:editable/widgets/table_body.dart';
import 'package:editable/widgets/table_header.dart';
import 'package:flutter/material.dart';

class Editable extends StatefulWidget {
  /// Builds an editable table using predefined row and column counts
  /// Or using a row and header data set provided
  ///
  /// if no data is provided for [row] and [column],
  /// [rowCount] and [columnCount] properties must be set
  /// this will generate an empty table
  ///
  /// it is useful for rendering data from an API or to create a spreadsheet-like
  /// data table
  ///
  /// example:
  ///
  /// ```dart
  ///  Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: <Widget>[
  ///           Expanded(
  ///           flex: 1,
  ///           child: EdiTable(
  ///               showCreateButton: true,
  ///               tdStyle: TextStyle(fontSize: 20),
  ///               showSaveIcon: false,
  ///               borderColor: Colors.lightBlue,
  ///               columnCount: 4,
  ///               rowCount: 8
  ///              ),
  ///           ).
  ///         ]
  ///       ),
  ///   );
  /// }
  /// ```
  const Editable(
      {Key? key,
      this.columns = const [],
      this.rows = const [],
      this.columnRatio = 0.20,
      this.onSubmitted,
      this.onRowSaved,
      this.columnCount = 0,
      this.rowCount = 0,
      this.borderColor = Colors.grey,
      this.tdPaddingLeft = 8.0,
      this.tdPaddingTop = 8.0,
      this.tdPaddingRight = 8.0,
      this.tdPaddingBottom = 12.0,
      this.thPaddingLeft = 8.0,
      this.thPaddingTop = 0.0,
      this.thPaddingRight = 8.0,
      this.thPaddingBottom = 0.0,
      this.trHeight = 50.0,
      this.borderWidth = 0.5,
      this.thWeight = FontWeight.w600,
      this.thSize = 18,
      this.showRemoveIcon = false,
      this.removeIcon = Icons.delete,
      this.removeIconColor = Colors.red,
      this.removeIconSize = 18,
      this.tdAlignment = TextAlign.start,
      this.tdStyle,
      this.onRowRemoved,
      this.tdEditableMaxLines = 1,
      this.thAlignment = TextAlign.start,
      this.thStyle,
      this.thVertAlignment = CrossAxisAlignment.center,
      this.createButtonAlign = CrossAxisAlignment.start,
      this.createButtonIcon,
      this.createButtonColor,
      this.createButtonShape,
      this.onRowAdded,
      this.createButtonLabel,
      this.stripeColor1 = Colors.white,
      this.stripeColor2 = Colors.black12,
      this.zebraStripe = false,
      this.focusedBorder})
      : super(key: key);

  /// A data set to create headers
  ///
  /// Can be null if blank columns are needed, else:
  /// Must be array of objects
  /// with the following keys: [title], [widthFactor] and [key]
  ///
  /// example:
  /// ```dart
  /// List cols = [
  ///   {"title":'Name', 'widthFactor': 0.1, 'key':'name', 'editable': false},
  ///   {"title":'Date', 'widthFactor': 0.2, 'key':'date'},
  ///   {"title":'Month', 'widthFactor': 0.1, 'key':'month', 'editable': false},
  ///   {"title":'Status', 'widthFactor': 0.1, 'key':'status'},
  /// ];
  /// ```
  /// [title] is the column heading
  ///
  /// [widthFactor] a custom size ratio of each column width, if not provided, defaults to  [columnRatio = 0.20]
  /// ```dart
  /// 'widthFactor': 0.1 //gives 10% of screen size to the column
  /// 'widthFactor': 0.2 //gives 20% of screen size to the column
  /// ```
  ///
  /// [key] an identifier preferably a short string
  /// [editable] a boolean, if the column should be editable or not, [true] by default.
  final List columns;

  /// A data set to create rows
  ///
  /// Can be null if empty rows are needed. else,
  /// Must be array of objects
  /// with keys matching [key] provided in the column array
  ///
  /// example:
  /// ```dart
  ///List rows = [
  ///          {"name": 'James Joe', "date":'23/09/2020',"month":'June',"status":'completed'},
  ///          {"name": 'Daniel Paul', "date":'12/4/2020',"month":'March',"status":'new'},
  ///        ];
  /// ```
  /// each objects DO NOT have to be positioned in same order as its column

  final List rows;

  /// Interger value of number of rows to be generated:
  ///
  /// Optional if row data is provided
  final int rowCount;

  /// Interger value of number of columns to be generated:
  ///
  /// Optional if column data is provided
  final int columnCount;

  /// aspect ration of each column,
  /// sets the ratio of the screen width occupied by each column
  /// it is set in fraction between 0 to 1.0
  /// 0.8 indicates 80 percent width per column
  final double columnRatio;

  /// Color of table border
  final Color borderColor;

  /// width of table borders
  final double borderWidth;

  /// Table data cell padding left
  final double tdPaddingLeft;

  /// Table data cell padding top
  final double tdPaddingTop;

  /// Table data cell padding right
  final double tdPaddingRight;

  /// Table data cell padding bottom
  final double tdPaddingBottom;

  /// Aligns the table data
  final TextAlign tdAlignment;

  /// Style the table data
  final TextStyle? tdStyle;

  /// Max lines allowed in editable text, default: 1 (longer data will not wrap and be hidden), setting to 100 will allow wrapping and not increase row size
  final int tdEditableMaxLines;

  /// Table header cell padding left
  final double thPaddingLeft;

  /// Table header cell padding top
  final double thPaddingTop;

  /// Table header cell padding right
  final double thPaddingRight;

  /// Table header cell padding bottom
  final double thPaddingBottom;

  /// Aligns the table header
  final TextAlign thAlignment;

  /// Style the table header - use for more control of header style, using this OVERRIDES the thWeight and thSize parameters and those will be ignored.
  final TextStyle? thStyle;

  /// Table headers fontweight (use thStyle for more control of header style)
  final FontWeight thWeight;

  /// Table header label vertical alignment
  final CrossAxisAlignment thVertAlignment;

  /// Table headers fontSize  (use thStyle for more control of header style)
  final double thSize;

  /// On Remove Row index will be returned
  final Function(int index)? onRowRemoved;

  /// Table Row Height
  /// cannot be less than 40.0
  final double trHeight;

  /// Toogles the save button,
  /// if [true] displays an icon to save rows,
  /// adds an addition column to the right
  final bool showRemoveIcon;

  /// Icon for to save row data
  /// example:
  ///
  /// ```dart
  /// saveIcon : Icons.add
  /// ````
  final IconData removeIcon;

  /// Color for the save Icon
  final Color removeIconColor;

  /// Size for the saveIcon
  final double removeIconSize;

  /// Aligns the button for adding new rows
  final CrossAxisAlignment createButtonAlign;

  /// Icon displayed in the create new row button
  final Icon? createButtonIcon;

  /// Color for the create new row button
  final Color? createButtonColor;

  /// border shape of the create new row button
  ///
  /// ```dart
  /// createButtonShape: RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.circular(8)
  /// )
  /// ```
  final BoxShape? createButtonShape;

  /// Label for the create new row button
  final Widget? createButtonLabel;

  /// The first row alternate color, if stripe is set to true
  final Color stripeColor1;

  /// The Second row alternate color, if stripe is set to true
  final Color stripeColor2;

  /// enable zebra-striping, set to false by default
  /// if enabled, you can style the colors [stripeColor1] and [stripeColor2]
  final bool zebraStripe;

  final InputBorder? focusedBorder;

  ///[onSubmitted] callback is triggered when the enter button is pressed on a table data cell
  /// it returns a value of the cell data
  final ValueChanged<String>? onSubmitted;

  /// [onRowSaved] callback is triggered when a [saveButton] is pressed.
  /// returns only values if row is edited, otherwise returns a string ['no edit']
  final ValueChanged<dynamic>? onRowSaved;
  final ValueChanged<dynamic>? onRowAdded;

  @override
  EditableState createState() => EditableState();
}

class EditableState extends State<Editable> {
  late List rows;
  late List columns;
  late int rowCount;
  late int columnCount;

  @override
  void didChangeDependencies() {
    rows = widget.rows;
    columns = widget.columns;
    rowCount = widget.rowCount;
    columnCount = widget.columnCount;
    super.didChangeDependencies();
  }

  final ScrollController _scrollController = ScrollController();

  ///Get all edited rows
  List get editedRows => _editedRows;
  createRow() {
    Map<String, dynamic> item = {};
    for (var element in columns) {
      if (element['key'] == 'key') {
        item[element['key']] = 'key_name${rows.length + 1}';
      }
    }
    rows.add(item);
    if (widget.onRowAdded != null) {
      widget.onRowAdded!(item);
    }
    final nextPageTrigger = _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels < nextPageTrigger) {
      _scrollController.animateTo(rows.length * 100,
          curve: Curves.bounceIn, duration: const Duration(milliseconds: 200));
    }
    setState(() {});
    return rows;
  }

  removeRow(int index) {
    rows.removeAt(index);
    setState(() {});
    if (widget.onRowRemoved != null) {
      widget.onRowRemoved!(index);
    }
  }

  /// Temporarily holds all edited rows
  final List _editedRows = [];

  @override
  Widget build(BuildContext context) {
    /// initial Setup of columns and row, sets count of column and row
    rowCount = rows.isEmpty ? widget.rowCount : rows.length;
    columnCount = columns.isEmpty ? columnCount : columns.length;
    columns = columns;
    rows = rows;

    /// Builds saveIcon widget
    Widget removeIcon(index) {
      return Visibility(
        visible: widget.showRemoveIcon,
        child: IconButton(
          padding: EdgeInsets.only(right: widget.tdPaddingRight, top: 22),
          hoverColor: Colors.transparent,
          icon: Icon(
            widget.removeIcon,
            color: widget.removeIconColor,
            size: widget.removeIconSize,
          ),
          onPressed: () {
            removeRow(index);
          },
        ),
      );
    }

    /// Generates table columns
    List<Widget> tableHeaders() {
      return List<Widget>.generate(columnCount + 1, (index) {
        return index == 0
            ? const SizedBox(
                width: 40,
              )
            : THeader(
                widthRatio: columns[index - 1]['widthFactor'] != null
                    ? columns[index - 1]['widthFactor'].toDouble()
                    : widget.columnRatio,
                thAlignment: widget.thAlignment,
                thStyle: widget.thStyle,
                thPaddingLeft: widget.thPaddingLeft,
                thPaddingTop: widget.thPaddingTop,
                thPaddingBottom: widget.thPaddingBottom,
                thPaddingRight: widget.thPaddingRight,
                headers: columns,
                thWeight: widget.thWeight,
                thSize: widget.thSize,
                index: index - 1);
      });
    }

    /// Generates table rows
    Widget tableRows() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            controller: _scrollController,
            itemCount: rowCount,
            itemBuilder: (_, index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(columnCount + 1, (rowIndex) {
                  List<String> ckeys = [];
                  List<double> cwidths = [];
                  List<bool> ceditable = <bool>[];
                  for (Map e in columns) {
                    ckeys.add(e['key']);
                    cwidths.add(e['widthFactor'] ?? widget.columnRatio);
                    ceditable.add(e['editable'] ?? true);
                  }
                  Map list = rows[index];
                  return rowIndex == 0
                      ? removeIcon(index)
                      : RowBuilder(
                          key: UniqueKey(),
                          index: index,
                          col: ckeys[rowIndex - 1],
                          trHeight: widget.trHeight,
                          borderColor: widget.borderColor,
                          borderWidth: widget.borderWidth,
                          cellData: list[ckeys[rowIndex - 1]] ?? '',
                          tdPaddingLeft: widget.tdPaddingLeft,
                          tdPaddingTop: widget.tdPaddingTop,
                          tdPaddingBottom: widget.tdPaddingBottom,
                          tdPaddingRight: widget.tdPaddingRight,
                          tdAlignment: widget.tdAlignment,
                          tdStyle: widget.tdStyle,
                          tdEditableMaxLines: widget.tdEditableMaxLines,
                          onSubmitted: widget.onSubmitted,
                          widthRatio: cwidths[rowIndex - 1].toDouble(),
                          isEditable: ceditable[rowIndex - 1],
                          zebraStripe: widget.zebraStripe,
                          focusedBorder: widget.focusedBorder,
                          stripeColor1: widget.stripeColor1,
                          stripeColor2: widget.stripeColor2,
                          onChanged: (value) {
                            ///checks if row has been edited previously
                            var result = editedRows.indexWhere((element) {
                              return element['row'] != index ? false : true;
                            });

                            ///adds a new edited data to a temporary holder
                            if (result != -1) {
                              editedRows[result][ckeys[rowIndex - 1]] = value;
                              widget.onRowSaved!(editedRows[result]);
                            } else {
                              var temp = {};
                              temp['row'] = index;
                              temp[ckeys[rowIndex - 1]] = value;
                              editedRows.add(temp);
                            }
                          },
                        );
                }),
              );
            }),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: widget.createButtonAlign,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: widget.thPaddingBottom),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: widget.borderColor, width: widget.borderWidth),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: widget.thVertAlignment,
                  mainAxisSize: MainAxisSize.min,
                  children: tableHeaders(),
                ),
              ),
              Expanded(
                child: tableRows(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
