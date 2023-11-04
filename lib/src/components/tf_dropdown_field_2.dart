part of 'tf_form.dart';

/// [TFDropdownField2] widget allows the user to pick a value from a dropdown list
class TFDropdownField2<T extends TFDropdonwnItem> extends StatefulWidget {
  TFDropdownField2({
    Key? key,
    this.title,
    this.hintText,
    required this.items,
    this.selectedItem,
    this.onChanged,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController,
    this.style,
    this.enabled = true,
    this.showError = true,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.requiredIfHas) && relatedController == null) {
      throw ArgumentError("requiredIfHas type and relatedController should both be set.");
    }
  }

  final String? title;
  final String? hintText;
  final List<T> items;
  final T? selectedItem;
  final Function(T selectedItem)? onChanged;
  final List<TFValidationType> validationTypes;
  final TextEditingController? relatedController;
  final TFFieldStyle? style;
  final bool enabled;
  final bool showError;

  @override
  State<TFDropdownField2<T>> createState() => _TFDropdownFieldState2<T>();
}

class _TFDropdownFieldState2<T extends TFDropdonwnItem> extends State<TFDropdownField2<T>> {
  final LayerLink _dropdownLink = LayerLink();
  final TextEditingController _titleController = TextEditingController();
  OverlayEntry? _dropdownOverlay;

  void _showDropdown() {
    _dropdownOverlay = _buildDropListOverlay();
    Overlay.of(context).insert(_dropdownOverlay!);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  void _toggleDropdown() {
    if (_dropdownOverlay == null) {
      _showDropdown();
    } else {
      _hideDropdown();
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.selectedItem?.displayTitle ?? "";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dropdownOverlay?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _dropdownLink,
      child: TFTextField(
        title: widget.title,
        hintText: widget.hintText,
        controller: _titleController,
        validationTypes: widget.validationTypes,
        relatedController: widget.relatedController,
        readOnly: true,
        style: widget.style,
        enabled: widget.enabled,
        showError: widget.showError,
        suffix: GestureDetector(
          onTap: _toggleDropdown,
          child: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
        ),
        onTap: _toggleDropdown,
        onFocusChanged: (hasFocus) {
          if (!hasFocus) _hideDropdown();
        },
      ),
    );
  }

  OverlayEntry _buildDropListOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final topOffset = offset.dy + size.height + 5;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _hideDropdown(),
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: size.width,
                child: CompositedTransformFollower(
                  link: _dropdownLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 5.0),
                  child: Material(
                    elevation: 2,
                    color: _tffStyle.fieldStyle.backgroundColor,
                    child: Column(
                      children: List.generate(widget.items.length, (index) {
                        final item = widget.items[index];
                        final isSelected = widget.selectedItem?.id == item.id;
                        return ListTile(
                          title: Text(item.displayTitle),
                          selected: isSelected,
                          selectedColor: Theme.of(context).colorScheme.onPrimary,
                          selectedTileColor: Theme.of(context).colorScheme.primary,
                          trailing: isSelected ? const Icon(Icons.check, size: 18) : null,
                          onTap: () {
                            _titleController.text = item.displayTitle;
                            widget.onChanged?.call(item);
                            _hideDropdown();
                          },
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
