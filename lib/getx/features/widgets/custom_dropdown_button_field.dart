import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/getx/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatefulWidget {
  final List<T>? selectedValues; // For multi-select
  final T? value; // For single-select
  final List<T> items; // Dropdown items
  final String hintText;
  final bool? isMultiSelect; // Nullable bool
  final ValueChanged<dynamic>? onChanged; // Callback for value(s) change
  final FormFieldValidator<dynamic>? validator;

  const CustomDropdownButtonFormField({
    Key? key,
    this.selectedValues,
    this.value,
    required this.items,
    required this.hintText,
    this.isMultiSelect, // Nullable variable
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomDropdownButtonFormField<T>> createState() =>
      _CustomDropdownButtonFormFieldState<T>();
}

class _CustomDropdownButtonFormFieldState<T>
    extends State<CustomDropdownButtonFormField<T>> {
  final List<T> _selectedItems = [];
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.isMultiSelect == true) {
      _selectedItems.addAll(widget.selectedValues ?? []);
    } else {
      _selectedItem = widget.value;
    }
  }

  void _onItemCheckedChange(T item, bool isChecked) {

     setState(() {
       if (isChecked) {
         _selectedItems.add(item);
       } else {
         _selectedItems.remove(item);
       }
       if (widget.onChanged != null) {
         widget.onChanged!(_selectedItems);
       }
     });
  }

  void _onSingleItemSelect(T item) {
    setState(() {
      _selectedItem = item;
      if (widget.onChanged != null) {
        widget.onChanged!(_selectedItem);
      }
    });
    Navigator.of(context).pop(); // Close the dialog
  }

  Future<void> _showSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            widget.isMultiSelect == true
                ? "Select Multiple Items"
                : "Select Item",
            style: satoshiRegular,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context,  setState) {
              return  SingleChildScrollView(
                child: ListBody(
                  children: widget.items.map((T item) {
                    final isChecked = _selectedItems.contains(item);
                    return widget.isMultiSelect == true
                        ? CheckboxListTile(
                      value: isChecked,
                      title: Text(item.toString()),
                      onChanged: (bool? checked) {
                        setState (()=>_onItemCheckedChange(item, checked ?? false));
                        // Navigator.of(context).pop();
                      },
                    )
                        : ListTile(
                      title: Text(item.toString()),
                      onTap: () => _onSingleItemSelect(item),
                    );
                  }).toList(),
                ),
              );
            },

          ),
          actions: [
            if (widget.isMultiSelect == true)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSelectionDialog,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius5),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 0.3,
              color: Theme.of(context).primaryColorDark.withOpacity(0.80),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius5),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: Theme.of(context).primaryColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius5),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 0.3,
              color: Theme.of(context).primaryColorDark.withOpacity(0.80),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.isMultiSelect == true
                    ? _selectedItems.isNotEmpty
                    ? _selectedItems.join(" | ") // Join multi-selected values
                    : widget.hintText
                    : _selectedItem != null
                    ? _selectedItem.toString()
                    : widget.hintText,
                style: satoshiRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: widget.isMultiSelect == true
                      ? (_selectedItems.isNotEmpty
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : Theme.of(context).hintColor)
                      : (_selectedItem != null
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : Theme.of(context).hintColor),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}