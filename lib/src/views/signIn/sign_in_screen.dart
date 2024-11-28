import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/features/widgets/custom_button%20_widget.dart';
import 'package:bureau_couple/getx/features/widgets/custom_textfield_widget.dart';
import 'package:bureau_couple/getx/repository/api/api_client.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../apis/login/login_api.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../constants/shared_prefs.dart';
import '../../constants/sizedboxe.dart';
import '../../constants/textfield.dart';
import '../../models/LoginResponse.dart';
import '../../utils/widgets/buttons.dart';
import '../../utils/widgets/common_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../home/home_dashboard.dart';
import '../signup/forgot_password.dart';
import '../signup/forgot_password_Screen.dart';
import '../signup/signup_dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final mobileController = TextEditingController();
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    // _loadSavedLoginDetails();
  }

  bool loading = false;
  bool saveLoginDetails = false;

  _loadSavedLoginDetails() async {
    final loginDetails = await SharedPreferencesHelper.getLoginDetails();
    mobileController.text = loginDetails['username'] ?? '';
    otpController.text = loginDetails['password'] ?? '';
  }

  _onLoginButtonPressed() async {
    // Perform login logic

    // Save login details if checkbox is selected
    if (saveLoginDetails) {
      SharedPreferencesHelper.saveLoginDetails(
        mobileController.text,
        otpController.text,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(

      builder: (GetxController controller) {
        return   Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          bottomNavigationBar: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0,left: 16,right: 16),
              child: loading ? const Center(child: CircularProgressIndicator()) :
              CustomButtonWidget(
                  fontColor: Theme.of(context).cardColor,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {



                    if (mobileController.text.isNotEmpty && Get.find<AuthController>().varificationId.isEmpty) {
                      // TextInput.finishAutofillContext();
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        Get.find<AuthController>().loginApi(
                          number: mobileController.text,
                        ).then((value){
                          if(value.isEmpty){
                            setState(() {
                              loading = false;
                            });
                            Fluttertoast.showToast(msg: "please check your account");
                          } else {
                            setState(() {
                              loading = false;
                            });

                          }
                        });

                      }
                    }
                    else if(mobileController.text.isNotEmpty && Get.find<AuthController>().varificationId.isNotEmpty && otpController.text.isNotEmpty) {
                      setState(() {
                        loading = true;
                      });
                      Get.find<AuthController>().verifyOtp(
                        number: mobileController.text, otp: otpController.text, varificationId: Get.find<AuthController>().varificationId, context: context,
                      ).then((value){
                        if(Get.find<AuthController>().varificationDone){
                          setState(() {
                            loading = false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => SignUpOnboardScreen()));
                          // Fluttertoast.showToast(msg: "otp verified");
                          // Navigator.push(context, MaterialPageRoute(builder: (builder) => HomeDashboardScreen(response: response)));
                        } else {
                          setState(() {
                            loading = false;
                          });
                          // Navigator.push(context, MaterialPageRoute(builder: (builder) => SignUpOnboardScreen()));
                        }
                      });
                    }
                    else {
                      setState(() {
                        loading = false;
                      });
                      ToastUtil.showToast(
                          "Please Enter Number");
                    }

                  },
                  isBold: false,
                  buttonText: Get.find<AuthController>().varificationId.isNotEmpty?"Verify Otp":'Sign In'),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      authBackground,
                    ),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 80, left: 44, right: 44, bottom: 60),
                      child: Image.asset(
                        icLogo,
                      ),
                    ),
                    AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              showTitle: true,
                              inputType: TextInputType.number,
                              maximumInput: 10,
                              readOnly: Get.find<AuthController>().varificationId.isNotEmpty,
                              controller: mobileController,
                              hintText: 'Mobile Number',
                              fillColor: Colors.transparent,
                              hintColor: Colors.black.withOpacity(0.70),
                            ),
                            sizedBox16(),
                            Visibility(
                              visible: Get.find<AuthController>().varificationId.isNotEmpty,
                              child: CustomTextField(
                                showTitle: true,
                                isPassword: true,
                                maximumInput: 6,
                                controller: otpController,
                                hintText: 'Enter Otp',
                                fillColor: Colors.transparent,
                                hintColor: Colors.black.withOpacity(0.70),
                              ),
                            ),
                            // Text("Username",
                            //   style: kManrope14Medium626262.copyWith(color: Colors.black),),
                            // sizedBox6(),
                            // textBox(
                            //     string:  [AutofillHints.username],
                            //     context: context,
                            //     label: '',
                            //     controller: mobileController,
                            //     hint: 'Password',
                            //     length: null,
                            //     validator: (value) {
                            //       return null;
                            //     }, onChanged: (value) {
                            //
                            // }
                            //
                            // ),
                            // sizedBox20(),
                            // Text("Password",
                            //   style: kManrope14Medium626262.copyWith(color: Colors.black),),
                            // sizedBox6(),
                            // textBoxSuffixIcon(
                            //     suffixOnTap: () {
                            //       setState(() {
                            //         _passwordVisible = !_passwordVisible;
                            //       });
                            //     },
                            //     string:  [AutofillHints.password],
                            //     context: context,
                            //     label: '',
                            //     controller: otpController,
                            //     hint: 'Password',
                            //     length: null,
                            //     suffixIcon: _passwordVisible
                            //         ? const Icon(Icons.visibility)
                            //         : const Icon(Icons.visibility_off),
                            //     validator: (value) {
                            //       return ;
                            //     }, bool: _passwordVisible, onChanged: (String ) {  }),
                            const SizedBox(
                              height: 21,
                            ),


                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),

          ///    Old Login /// ######################################################
          // body: SingleChildScrollView(
          //   child: Form(
          //     key: _formKey,
          //     child: Column(
          //       children: [
          //         Stack(
          //           children: [
          //             Image.asset(icSignInBG),
          //             Container(
          //               child: Stack(
          //                 children: [
          //                   Image.asset(icSignInLinearBG),
          //                   Padding(
          //                     padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         backButton(context: context, image: icArrowLeft, onTap: () {
          //                           Navigator.pop(context);
          //                         }),
          //                         const SizedBox(height:80 ,),
          //                         Image.asset(icLogo,
          //                           width: 72,
          //                           height: 59,),
          //                         sizedBox10(),
          //                         Text(
          //                           "Sign In",
          //                           style: kManrope34BoldBlack,
          //                           textAlign: TextAlign.center,),
          //                         Text(
          //                           "Log in to continue your journey of\nyour love and connetion",
          //                           style: kManrope16MediumBlack,
          //                           textAlign: TextAlign.center,),
          //                         sizedBox20(),
          //                         AutofillGroup(
          //                           child: Column(
          //                             crossAxisAlignment: CrossAxisAlignment.start,
          //                             children: [
          //                               Text("Email / Username",
          //                                 style: kManrope14Medium626262,),
          //                               sizedBox6(),
          //                               textBox(
          //                                   string:  [AutofillHints.username],
          //                                   context: context,
          //                                   label: '',
          //                                   controller: mobileController,
          //                                   hint: '',
          //                                   length: null,
          //                                   validator: (value) {
          //                                     return null;
          //                                   }, onChanged: (value) {
          //
          //                               }
          //
          //                               ),
          //                               sizedBox20(),
          //                               Text("Password",
          //                                 style: kManrope14Medium626262,),
          //                               sizedBox6(),
          //                               textBoxSuffixIcon(
          //                                   suffixOnTap: () {
          //                                     setState(() {
          //                                       _passwordVisible = !_passwordVisible;
          //                                     });
          //                                   },
          //                                   string:  [AutofillHints.password],
          //                                   context: context,
          //                                   label: '',
          //                                   controller: otpController,
          //                                   hint: '',
          //                                   length: null,
          //                                   suffixIcon: _passwordVisible
          //                                       ? const Icon(Icons.visibility)
          //                                       : const Icon(Icons.visibility_off),
          //                                   validator: (value) {
          //                                     return ;
          //                                   }, bool: _passwordVisible, onChanged: (String ) {  }),
          //                               const SizedBox(height: 21,),
          //                               Align(
          //                                 alignment: Alignment.centerRight,
          //                                 child: GestureDetector(
          //                                   onTap: () {
          //                                     showModalBottomSheet(
          //                                       context: context,
          //                                       isScrollControlled: true,
          //                                       builder: (BuildContext context) {
          //                                         return ForgotPassEmailSheet();
          //                                       },
          //                                     );
          //                                     // Navigator.push(context, MaterialPageRoute(builder: (builder) => ForgotPasswordScreen()));
          //                                   },
          //                                   child: Text("Forgot Password",
          //                                     textAlign: TextAlign.right,
          //                                     style: kManrope16Regular4271ec,),
          //                                 ),
          //                               ),
          //
          //                               sizedBoxHeight32(),
          //                               loading ?
          //                               loadingButton(context: context) :
          //                               button(
          //                                   onTap: () {
          //                                     if(mobileController.text.isNotEmpty ||
          //                                         otpController.text.isNotEmpty) {
          //                                       TextInput.finishAutofillContext();
          //                                       if(_formKey.currentState!.validate()) {
          //                                         setState(() {
          //                                           loading = true;
          //                                         });
          //                                         loginApi(
          //                                           password: otpController.text,
          //                                           userName: mobileController.text,
          //                                         ).then((value) {
          //                                           response = value;
          //
          //                                           if (
          //                                               response?.status == 'success' /*value['status'] == 'success'*/) {
          //                                             setState(() {
          //                                               loading = false;
          //                                             });
          //                                             print("cehc");
          //                                             print(response);
          //                                             SharedPrefs().setLoginToken(response!.data!.accessToken.toString());
          //                                             SharedPrefs().setUserName(response!.data!.user!.username.toString());
          //                                             SharedPrefs().setName(response!.data!.user!.firstname.toString());
          //                                             SharedPrefs().setEmail((response!.data!.user!.email.toString()));
          //                                             SharedPrefs().setPhone(response!.data!.user!.mobile.toString());
          //                                             SharedPrefs().setProfileId(response!.data!.user!.profileId as int);
          //                                             SharedPrefs().setLoginTrue();
          //                                             SharedPrefs().setProfilePhoto(response!.data!.user!.image.toString());
          //                                             SharedPrefs().setLoginGender(response!.data!.user!.gender.toString());
          //                                             SharedPrefs().setLoginEmail(mobileController.text);
          //                                             SharedPrefs().setLoginPassword(otpController.text);
          //                                             Navigator.push(context, MaterialPageRoute(builder: (builder) =>
          //                                              HomeDashboardScreen(response: response!,)));
          //                                             ToastUtil.showToast("Login Successful");
          //
          //                                           } else {
          //                                             setState(() {
          //                                               loading = false;
          //                                             });
          //                                             print("fkfm");
          //                                             Fluttertoast.showToast(msg: "please check your account");
          //
          //                                           }
          //                                         });
          //                                       }
          //                                     } else {
          //                                       setState(() {
          //                                         loading = false;
          //                                       });
          //                                       ToastUtil.showToast("Please Enter Username and password");
          //
          //                                     }
          //                                   },
          //                                   context: context, title: 'Sign In'),
          //
          //                               sizedBoxHeight32(),
          //                               Align(
          //                                 alignment: Alignment.center,
          //                                 child: GestureDetector(
          //                                   behavior: HitTestBehavior.translucent,
          //                                   onTap: () {
          //                                     Navigator.push(context, MaterialPageRoute(
          //                                         builder: (builder) =>
          //                                         const SignInOptionScreen()));
          //                                   },
          //                                   child: Text("Sign Up Now",
          //                                     textAlign: TextAlign.center,
          //                                     style:kManrope18Bold101010 ,),
          //                                 ),
          //                               )
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ],
          //         )
          //
          //       ],
          //     ),
          //   ),
          // ),
        );
      },

    );
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }
}
