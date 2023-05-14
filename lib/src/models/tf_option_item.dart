/// TFOptionItem object is used for [TFRadioGroup, TFCheckboxGroup, TFDropdownField]
class TFOptionItem<T> {
  TFOptionItem({
    required this.title,
    required this.value,
  });
  
  final String title;
  final T value;
}
