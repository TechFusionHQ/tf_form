## 0.0.1

### Released

* Initial release

## 0.0.2

### Changed

* Validation type arguments

## 0.0.3

### Added

* Action bar for numeric keyboard type in iOS

### Fixed

* Update condition for auto validation

## 0.0.5

### Breaking changes

* Replaced `TFDropdownField` property: `items`(`List<String>`) 👉 `items`(`List<TFOptionItem<T>>`)
* Replaced `TFCheckboxGroup` property: `items`(`List<TFCheckboxItem>`) 👉 `items`(`List<TFOptionItem<T>>`)
* Replaced `TFRadioGroup` property: `items`(`List<TFRadioItem>`) 👉 `items`(`List<TFOptionItem<T>>`)
* Renamed `TFDropdownField` property: `initialItem` 👉 `initialValue`)
* Renamed `TFRadioGroup` property: `groupValue` 👉 `initialValue`)
* Added `TFCheckboxGroup` property: `initialValues` (`List<T>`)

## 0.0.6
* Minor UI changes