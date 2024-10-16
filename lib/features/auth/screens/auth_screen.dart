import 'package:ecommerce_app/common/custom_button.dart';
import 'package:ecommerce_app/common/custom_textfield.dart';
import 'package:ecommerce_app/common/custom_tost.dart';
import 'package:ecommerce_app/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../../constants/global_variables.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _businessSectorController =
      TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  String? _selectedUserType;
  bool _isAgreedToTerms = false; 

  final List<String> _userTypes = ['Buyer', 'Seller'];

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _businessSectorController.dispose();
    _gstNumberController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      phoneNumber: _phoneNumberController.text,
      businessSector: _businessSectorController.text,
      gstNumber: _gstNumberController.text,
      userType: _selectedUserType,
      emailController: _emailController,
      passwordController: _passwordController,
      nameController: _nameController,
      phoneNumberController: _phoneNumberController,
      businessSectorController: _businessSectorController,
      gstNumberController: _gstNumberController,
    );
    setState(() {
      _isAgreedToTerms = false;
    });
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      emailController: _emailController,
      passwordController: _passwordController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ListTile(
                        tileColor: _auth == Auth.signup
                            ? Colors.transparent
                            : Colors.transparent,
                        title: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Radio(
                          activeColor: GlobalVariables.secondaryColor,
                          value: Auth.signup,
                          groupValue: _auth,
                          onChanged: (Auth? val) {
                            setState(() {
                              _auth = val!;
                            });
                          },
                        ),
                      ),
                      if (_auth == Auth.signup)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.transparent,
                          child: Form(
                            key: _signUpFormKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _nameController,
                                  hintText: 'Name',
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  controller: _phoneNumberController,
                                  hintText: 'Phone Number',
                                ),
                                const SizedBox(height: 10),
                                // User Type Dropdown
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintText: 'Select User Type',
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black38,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ),
                                  value: _selectedUserType,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedUserType = newValue;
                                    });
                                  },
                                  items: _userTypes
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 10),
                                // Conditionally show these fields
                                if (_selectedUserType == 'Seller') ...[
                                  CustomTextField(
                                    controller: _gstNumberController,
                                    hintText: 'GST Number',
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    controller: _businessSectorController,
                                    hintText: 'Business Sector',
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isAgreedToTerms,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isAgreedToTerms = value!;
                                        });
                                      },
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'I agree to the terms and conditions',
                                      ),
                                    ),
                                  ],
                                ),
                                CustomButton(
                                  text: 'Sign Up',
                                  onTap: () {
                                    if (_signUpFormKey.currentState!
                                            .validate() &&
                                        _isAgreedToTerms) {
                                      signUpUser();
                                    } else if (!_isAgreedToTerms) {
                                      CommonToast.showToast(
                                        context: context,
                                        message:
                                            'You must agree to the terms and conditions.',
                                        autoCloseDuration:
                                            const Duration(seconds: 5),
                                        primaryColor: Colors.red,
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ListTile(
                        tileColor: _auth == Auth.signin
                            ? Colors.transparent
                            : Colors.transparent,
                        title: const Text(
                          'Sign-In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Radio(
                          activeColor: GlobalVariables.secondaryColor,
                          value: Auth.signin,
                          groupValue: _auth,
                          onChanged: (Auth? val) {
                            setState(() {
                              _auth = val!;
                            });
                          },
                        ),
                      ),
                      if (_auth == Auth.signin)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.transparent,
                          child: Form(
                            key: _signInFormKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                ),
                                const SizedBox(height: 10),
                                CustomButton(
                                  text: 'Sign In',
                                  onTap: () {
                                    if (_signInFormKey.currentState!
                                        .validate()) {
                                      signInUser();
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
