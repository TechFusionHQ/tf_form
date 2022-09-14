/// TFOptionItem object is used for [TFRadioGroup, TFCheckboxGroup, TFDropdownField]
class TFOptionItem<T> {
  final String title;
  final T value;

  TFOptionItem({
    required this.title,
    required this.value,
  });
}

