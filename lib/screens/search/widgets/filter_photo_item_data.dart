import 'package:flutter/material.dart';

class FilterPhotoItemData<T> {
  final T value;
  final String text;
  final IconData icon;

  const FilterPhotoItemData({
    @required this.value,
    this.text,
    this.icon,
  });
}

class FilterPhotoItem<T> extends StatelessWidget {
  final String label;
  final T value;
  final void Function(T) onChange;
  final List<FilterPhotoItemData<T>> items;
  final bool useDropdown;

  FilterPhotoItem({
    @required this.label,
    @required this.value,
    @required this.onChange,
    @required this.items,
    this.useDropdown = false,
  });

  void _handleToggleButtonsChanged(int index) {
    onChange(items[index].value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (useDropdown)
          DropdownButtonFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10)),
            isExpanded: true,
            value: value,
            onChanged: onChange,
            items: items
                .map((e) =>
                    DropdownMenuItem(child: Text(e.text), value: e.value))
                .toList(),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) => ToggleButtons(
              selectedBorderColor: Colors.black,
              constraints: BoxConstraints.expand(
                width: (constraints.maxWidth - 1 - items.length) / items.length,
              ),
              children: items
                  .map(
                    (e) => Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: e.icon != null
                          ? Icon(e.icon)
                          : Text(
                              e.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                    ),
                  )
                  .toList(),
              onPressed: _handleToggleButtonsChanged,
              isSelected: items.map((e) => e.value == value).toList(),
            ),
          ),
      ],
    );
  }
}
