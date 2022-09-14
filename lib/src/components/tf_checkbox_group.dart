part of 'tf_form.dart';

/// [TFCheckboxGroup] widget allows user to select multiple items.
/// The checkbox is displayed before the item name,
/// which you can check/uncheck to make/remove the selection.
class TFCheckboxGroup<T> extends StatefulWidget {
  final String title;
  final List<TFOptionItem<T>> items;
  final List<T>? initialValues;
  final void Function(List<T>) onChanged;
  final List<TFValidationType> validationTypes;
  final TextEditingController? relatedController;
  final TFGroupStyle? style;

  TFCheckboxGroup({
    Key? key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.initialValues,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController,  
    this.style,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.requiredIfHas) &&
        relatedController == null) {
      throw ArgumentError(
          "requiredIfHas type and relatedController should both be set.");
    }
  }

  @override
  State<TFCheckboxGroup<T>> createState() => _TFCheckboxGroupState();
}

class _TFCheckboxGroupState<T> extends State<TFCheckboxGroup<T>> {
  List<T> _selectedValues = <T>[];
  bool _isValid = true;

  List<TFValidationType> get validationTypes => widget.validationTypes;

  void _setValid(bool val) {
    setState(() {
      _isValid = val;
    });
  }

  void _onItemChanged(T value, bool isSelected) {
    final selectedValues = List.of(_selectedValues);
    if (isSelected) {
      selectedValues.add(value);
    } else {
      selectedValues.remove(value);
    }
    setState(() {
      _selectedValues = selectedValues;
    });
    widget.onChanged(selectedValues);

    // for autoValidate
    if ((TFForm.of(context)?.widget.autoValidate ?? false) &&
        validationTypes.isNotEmpty) {
      final isValid = _validate();
      _setValid(isValid);
    }
  }

  bool _validate() {
    if (validationTypes.contains(TFValidationType.required)) {
      if (_selectedValues.isEmpty) {
        return false;
      }
    } else if (validationTypes.contains(TFValidationType.requiredIfHas)) {
      final relatedVal = widget.relatedController!.text;
      if (relatedVal.isNotEmpty && _selectedValues.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      setState(() {
        _selectedValues = widget.initialValues!;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (validationTypes.isNotEmpty) {
        TFForm.of(context)?._registerCheckboxGroup(this);
      }
    });
  }

  @override
  void deactivate() {
    if (validationTypes.isNotEmpty) {
      TFForm.of(context)?._unregisterCheckboxGroup(this);
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: _tffStyle.titleStyle,
        ),
        const SizedBox(height: 8),
        ...List.generate(widget.items.length, (index) {
          return _buildCheckboxTile(widget.items[index]);
        }),
        TFErrorText(
          error: "Please select at least one option",
          visible: !_isValid,
        ),
      ],
    );
  }

  Widget _buildCheckboxTile(TFOptionItem<T> item) {
    return CheckboxListTile(
      title: Text(
        item.title,
        style: _itemTitleStyle.copyWith(
          color: _isValid ? null : _tffStyle.errorColor,
        ),
      ),
      value: _selectedValues.contains(item.value),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: _tffStyle.activeColor,
      contentPadding: EdgeInsets.zero,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      side: BorderSide(
        width: 1.5,
        color: _isValid
            ? _unselectedColor
            : _tffStyle.errorColor,
      ),
      onChanged: (bool? isSelected) {
        _onItemChanged(item.value, isSelected ?? false);
      },
    );
  }

  get _itemTitleStyle => widget.style?.itemTitleStyle ?? _tffStyle.groupStyle.itemTitleStyle;
  get _unselectedColor => widget.style?.unselectedColor ?? _tffStyle.groupStyle.unselectedColor;
}
