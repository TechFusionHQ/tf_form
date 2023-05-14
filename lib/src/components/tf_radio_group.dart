part of 'tf_form.dart';

/// [TFRadioGroup] widget allows user to select one option from multiple selections.
class TFRadioGroup<T> extends StatefulWidget {
  TFRadioGroup({
    Key? key,
    this.title,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController,
    this.style,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.requiredIfHas) && relatedController == null) {
      throw ArgumentError("requiredIfHas type and relatedController should both be set.");
    }
  }

  final String? title;
  final List<TFOptionItem<T>> items;
  final T? initialValue;
  final Function(T?) onChanged;
  final List<TFValidationType> validationTypes;
  final TextEditingController? relatedController;
  final TFGroupStyle? style;

  @override
  State<TFRadioGroup<T>> createState() => _TFRadioGroupState<T>();
}

class _TFRadioGroupState<T> extends State<TFRadioGroup<T>> {
  T? _groupValue;
  bool _isValid = true;

  List<TFValidationType> get _validationTypes => widget.validationTypes;
  TextStyle get _titleStyle => widget.style?.titleStyle ?? _tffStyle.titleStyle;
  TextStyle get _itemTitleStyle => widget.style?.itemTitleStyle ?? _tffStyle.groupStyle.itemTitleStyle;
  Color get _unselectedColor => widget.style?.unselectedColor ?? _tffStyle.groupStyle.unselectedColor;

  void _setValid(bool val) {
    setState(() {
      _isValid = val;
    });
  }

  void _onItemChanged(T? val) {
    widget.onChanged(val);
    setState(() {
      _groupValue = val;
    });

    // for autoValidate
    if ((TFForm.of(context)?.widget.autoValidate ?? false) && _validationTypes.isNotEmpty) {
      final isValid = _validate();
      _setValid(isValid);
    }
  }

  bool _validate() {
    if (_validationTypes.contains(TFValidationType.required)) {
      if (_groupValue == null) {
        return false;
      }
    } else if (_validationTypes.contains(TFValidationType.requiredIfHas)) {
      final relatedVal = widget.relatedController!.text;
      if (relatedVal.isNotEmpty && _groupValue == null) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_validationTypes.isNotEmpty) {
        TFForm.of(context)?._registerRadioGroup(this);
      }
    });
    _groupValue = widget.initialValue;
  }

  @override
  void deactivate() {
    if (_validationTypes.isNotEmpty) {
      TFForm.of(context)?._unregisterRadioGroup(this);
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: _isValid ? _unselectedColor : Theme.of(context).colorScheme.error,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: _titleStyle,
            ),
            const SizedBox(height: 10),
          ],
          ...List.generate(widget.items.length, (index) {
            return _buildRadioTile(widget.items[index], index);
          }),
          TFErrorText(
            error: "Please select one option",
            visible: !_isValid,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile(TFOptionItem<T> item, int index) {
    return ListTile(
      title: Text(
        item.title,
        style: _itemTitleStyle.copyWith(
          color: _isValid ? null : Theme.of(context).colorScheme.error,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      leading: Radio<T>(
        value: item.value,
        groupValue: _groupValue,
        onChanged: _onItemChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
