# tf_form  
  
TechFusion form builder and validator
  
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
    TFTextField(
        label: "Nickname",
        controller: nicknameController,
        types: const [
            TFTextFieldType.required,
        ],
    ),
    TFTextField(
        label: "Email",
        controller: emailController,
        types: const [
        TFTextFieldType.required,
            TFTextFieldType.emailAddress,
        ],
    ),
    TFTextField(
        label: "Phone",
        controller: phoneController,
        types: const [
        TFTextFieldType.required,
            TFTextFieldType.phone,
        ],
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