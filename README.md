# tf_form  
  
### TechFusion's form builder and validator

Copyright (c) 2022 TechFusion Ltd (https://www.techfusion.dev)
  
## Usage  
### Create a `TFForm` with a GlobalKey
First, create a `TFForm`. The `TFForm` widget acts as a container for grouping and validating multiple form fields.

When creating the form, provide a `GlobalKey`. This uniquely identifies the `TFForm`, and allows validation of the form in a later step.

```dart  
    final _formKey = GlobalKey<TFFormState>();

    @override
    Widget build(BuildContext context) {
        // Build a Form widget using the _formKey created above.
        return TFForm(
        key: _formKey,
        child: Column(
                children: <Widget>[
                // Add TFTextField and ElevatedButton here.
                ],
            ),
        );
    }
```  
  
### Add a `TFTextField` with validation types and controller
`TFTextField` maintains the current state of the form field, so that updates
and validation errors are visually reflected in the UI.

A `TFForm` ancestor is required. The `TFForm` simply makes it easier to
validate multiple fields at once.

```dart  
    TFForm(
        key: _personalFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TFTextField(
                label: "Nickname",
                hintText: "Enter a nickname",
                controller: nicknameController,
                validationTypes: const [
                  TFValidationType.required,
                ],
              ),
              const SizedBox(height: 15),
              TFTextField(
                label: "Email",
                hintText: "ben@somewhere.com",
                controller: emailController,
                validationTypes: const [
                  TFValidationType.required,
                  TFValidationType.emailAddress,
                ],
              ),
              const SizedBox(height: 15),
              TFDateField(
                label: "Birthday",
                controller: birthdayController,
              ),
              const SizedBox(height: 15),
              TFDropdownField(
                label: "City",
                items: const [
                  "Hà Nội",
                  "Hồ Chí Minh",
                  "Đà Nẵng",
                  "Lào Cai",
                ],
                controller: cityController,
              ),
              const SizedBox(height: 15),
              TFTextField(
                label: "Phone",
                hintText: "Enter a phone",
                controller: phoneController,
                validationTypes: const [
                  TFValidationType.required,
                  TFValidationType.phone,
                ],
              ),
              const SizedBox(height: 20),
              TFCheckboxGroup(
                title: "Which social network do you usually use ?",
                items: [
                  TFCheckboxItem(title: "Facebook"),
                  TFCheckboxItem(title: "Zalo"),
                  TFCheckboxItem(title: "Twitter"),
                  TFCheckboxItem(title: "Linkedin"),
                  TFCheckboxItem(title: "Telegram"),
                ],
                onChanged: (checkedItemIndexes) {},
              ),
              const SizedBox(height: 20),
              TFRadioGroup<String>(
                title: "Gender",
                items: [
                  TFRadioItem<String>(title: "Male", value: "male"),
                  TFRadioItem<String>(title: "Female", value: "female"),
                  TFRadioItem<String>(title: "Other", value: "other"),
                ],
                onChanged: (selectedItem) {},
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _personalFormKey.currentState!.validate();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
 ```
 
### 3. Create a button to validate and submit the form

```dart
    ElevatedButton(
        onPressed: () {
            _formKey.currentState!.validate();
        },
        child: const Text('Submit'),
    ),

```