import 'package:flutter/material.dart';
import 'package:tf_form/tf_form.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(backgroundColor: Colors.white),
      home: const DemoFormPage(),
    );
  }
}

class DemoFormPage extends StatefulWidget {
  const DemoFormPage({super.key});

  @override
  DemoFormPageState createState() {
    return DemoFormPageState();
  }
}

class DemoFormPageState extends State<DemoFormPage> {
  final _personalFormKey = GlobalKey<TFFormState>();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final _addressesFormKey = GlobalKey<TFFormState>();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final addressTypeController = TextEditingController();

  final _securityFormKey = GlobalKey<TFFormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Personal Info"),
              Tab(text: "Addresses"),
              Tab(text: "Security"),
            ],
          ),
          title: const Text('Form Validation Demo'),
        ),
        body: TabBarView(
          children: [
            _buildPersonalInfoTab(),
            _buildAddressesTab(),
            _buildPSecurityTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return TFForm(
      key: _personalFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TFTextField(
              label: "Nickname",
              controller: nicknameController,
              types: const [
                TFTextFieldType.required,
              ],
            ),
            const SizedBox(height: 10),
            TFTextField(
              label: "Email",
              controller: emailController,
              types: const [
                TFTextFieldType.required,
                TFTextFieldType.emailAddress,
              ],
            ),
            const SizedBox(height: 10),
            TFTextField(
              label: "Name",
              controller: nameController,
              types: const [],
            ),
            const SizedBox(height: 10),
            TFTextField(
              label: "Phone",
              controller: phoneController,
              types: const [
                TFTextFieldType.required,
                TFTextFieldType.phone,
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _personalFormKey.currentState!.validate();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesTab() {
    return TFForm(
      key: _addressesFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TFTextField(
              label: "Type",
              controller: addressTypeController,
              types: const [],
            ),
            const SizedBox(height: 10),
            TFTextField(
              label: "Address 1",
              controller: address1Controller,
              types: const [
                TFTextFieldType.required,
              ],
            ),
            const SizedBox(height: 10),
            TFTextField(
              label: "Address 2",
              controller: address2Controller,
              types: const [],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _addressesFormKey.currentState!.validate();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPSecurityTab() {
    return TFForm(
      key: _securityFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TFTextField(
              label: "New password",
              controller: passwordController,
              types: const [
                TFTextFieldType.required,
                TFTextFieldType.password,
              ],
            ),
            const SizedBox(height: 10),
            TFTextField(
              label: "Confirm",
              controller: confirmPasswordController,
              passwordController: passwordController,
              types: const [
                TFTextFieldType.required,
                TFTextFieldType.confirmPassword,
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _securityFormKey.currentState!.validate();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
