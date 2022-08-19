# TFForm

A Flutter package for creating a form container to group multiple common form widgets together and validate them automatically.

Copyright (c) 2022 TechFusion Ltd (<https://www.techfusion.dev>)

## TL;DR
![image](https://user-images.githubusercontent.com/735555/185453640-49ebf733-a288-4aa0-b9c6-7d574fb964a1.png)

Video example: https://cloud.techfusion.dev/9EIzr4pOMZ40aedOr9X8

## Installing

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  tf_form: ^0.0.5
```

In your library add the following import:

```dart
import 'package:tf_form/tf_form.dart';
```

## Widgets

### TFForm

The `TFForm` widget acts as a container for grouping and validating multiple form widgets provided by package. It requires a `GlobalKey` to allow validation of the form in a later step. Also, you can configure error messages or style the form by passing arguments to the constructor.

```dart  
    final _formKey = GlobalKey<TFFormState>();

    @override
    Widget build(BuildContext context) {
        // Build a TFForm widget using the _formKey created above.
        return TFForm(
        key: _formKey,
        child: Column(
                children: <Widget>[
                    // Add form widgets and ElevatedButton here.
                ],
            ),
        );
    }
```  

### TFTextField

 A text field is the most popular form widget. It lets the user enter text, either with hardware keyboard or with an onscreen keyboard.

```dart
    TFTextField(
        title: "Nickname",
        hintText: "Enter a nickname",
        controller: nicknameController,
        validationTypes: const [
            TFValidationType.required,
        ],
    ),
```

### TFDropdownField

A dropdown field allows the user to pick a value from a dropdown list

```dart
    TFDropdownField(
        title: "Role",
        items: [
          TFOptionItem<String>(title: "Member", value: "member"),
          TFOptionItem<String>(title: "Administrator", value: "admin"),
          TFOptionItem<String>(title: "Manager", value: "manager")
        ],
        controller: roleController,
        initialValue: "member",
        validationTypes: const [
          TFValidationType.required,
        ],
      ),
```

### TFDateField

A date field allows the user to pick a DateTime.=

```dart
    TFDateField(
        title: "Birthday",
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        controller: birthdayController,
        validationTypes: const [
            TFValidationType.required,
        ],
    ),
```

### TFRadioGroup

A radio group allows user to select one option from multiple selections

```dart
    TFCheckboxGroup<String>(
        title: "Which social network do you usually use ?",
        initialValues: const ["fb", "telegram"],
        items: [
          TFOptionItem<String>(title: "Facebook", value: "fb"),
          TFOptionItem<String>(title: "Twitter", value: "twitter"),
          TFOptionItem<String>(title: "Linkedin", value: "linkedin"),
          TFOptionItem<String>(title: "Telegram", value: "telegram"),
        ],
        onChanged: (List<String> values) {
          print("$values");
        },
        validationTypes: const [
          TFValidationType.required,
        ],
      ),
```

### TFCheckboxGroup

A checkbox group allows user to select multiple items

```dart
    TFRadioGroup<String>(
        title: "Gender",
        initialValue: "male",
        items: [
          TFOptionItem<String>(title: "Male", value: "male"),
          TFOptionItem<String>(title: "Female", value: "female"),
          TFOptionItem<String>(title: "Other", value: "other"),
        ],
        onChanged: (selectedItem) {
          print("$selectedItem");
        },
        validationTypes: const [
          TFValidationType.requiredIfHas,
        ],
        relatedController: nicknameController,
      ),
```

## Basic Usage

- First, create a `TFForm`

- Add one of the above form widgets as children of `TFForm`. The `TFForm` simply makes it easier to validate all at once.

- Finally, create a button to validate the form.

```dart
    ElevatedButton(
        onPressed: () {
            _formKey.currentState!.validate();
        },
        child: const Text('Submit'),
    ),

```