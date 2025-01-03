import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/features/widgets/custom_textfield_widget.dart';
import 'package:bureau_couple/src/constants/assets.dart';
import 'package:bureau_couple/src/constants/textstyles.dart';
import 'package:bureau_couple/src/utils/widgets/common_widgets.dart';
import 'package:bureau_couple/src/utils/widgets/dropdown_buttons.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../../apis/signup_api/kyc_details_api.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';

import '../../constants/sizedboxe.dart';
import '../../constants/textfield.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../utils/widgets/buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'kyc_wait_screen.dart';

class AddKycDetailsScreen extends StatefulWidget {
  const AddKycDetailsScreen({super.key});

  @override
  State<AddKycDetailsScreen> createState() => _AddKycDetailsScreenState();
}

class _AddKycDetailsScreenState extends State<AddKycDetailsScreen> {
  final _documentNoController = TextEditingController();
  final designationController = TextEditingController();
  final identityProof = TextEditingController();
  final joiningDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController authControl = Get.find();

  late DateTime _selectedDate;
  bool loading = false;

  @override
  void initState() {
    _selectedDate = DateTime.now();
    super.initState();
  }

  File pickedImage = File("");
  final ImagePicker _imgPicker = ImagePicker();


  String? validateDocument(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Document number cannot be empty';
    }
   // debugPrint('Document type: ${authControl.document}');
    switch (authControl.document) {
      case 'PAN Card':
      // PAN Card validation: should be 10 characters and alphanumeric
        final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
        if (!panRegex.hasMatch(value)) {
          return 'Enter a valid PAN number (e.g., ABCDE1234F)';
        }
        break;

      case 'Aadhar Card':
      // Aadhar validation: should be 12 digits
        if (value.length != 12 || int.tryParse(value) == null) {
          return 'Enter a valid Aadhar number (12 digits)';
        }
        break;

      case 'Driving License':
      // Driving License validation: should match specific patterns
        final dlRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[0-9A-Z]{1,15}$');
        if (!dlRegex.hasMatch(value)) {
          return 'Enter a valid Driving License number';
        }
        break;

      case 'Passport':
      // Passport validation: should be 8 characters (1 letter + 7 digits)
        final passportRegex = RegExp(r'^[A-Z][0-9]{7}$');
        if (!passportRegex.hasMatch(value)) {
          return 'Enter a valid Passport number (e.g., A1234567)';
        }
        break;

      case 'Govt Authorized Card':
      // Govt Authorized ID: Allow alphanumeric with minimum 5 characters
        if (value.length < 5) {
          return 'Enter a valid Govt Authorized ID (min 5 characters)';
        }
        break;

      default:
        return 'Please select a document type';
    }
    return null;
  }
  int getMaxLengthForDocumentType(String? documentType) {
    switch (documentType) {
      case 'Pan Card':
        return 10; // Fixed 10 characters for PAN Card
      case 'Aadhar Card':
        return 12; // Fixed 12 digits for Aadhar Card
      case 'Driving License':
        return 16; // Approx max length for DL as per Indian DL standards
      case 'Passport':
        return 8; // Fixed 8 characters for Passport
      case 'Govt Authorized Card':
        return 20; // Example max length for Govt ID (can be modified)
      default:
        return 50; // Fallback to a reasonable default length
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child:  GetBuilder<AuthController>(builder: (authControl) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(onPressed: () {
                onBackPressed(context);
              }, icon: const Icon(Icons.close,color: Colors.white,))
              // Padding(
              //   padding: const EdgeInsets.only(right: 16.0),
              //   child: backButton(context: context, image: icCross, onTap: (){
              //     onBackPressed(context);
              //   }),
              // )
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child:
              loading ?
              loadingButton(context: context) :
              button(context: context,
                  onTap: () {
                if(pickedImage.path.isNotEmpty ) {
                  if(_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                      // ToastUtil.showToast("Registered Successfully");
                      //       Navigator.push(context, MaterialPageRoute(builder: (builder) =>
                      //       const KycWaitScreen()));

                    kycDetailsApi(
                      designation: _documentNoController.text,
                      identityProof:authControl.document.toString(),
                      // joiningDate: joiningDateController.text,
                      photo: pickedImage.path,
                    ).then((value) {
                      setState(() {
                      });
                      if (value['status'] == true) {
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (builder) =>
                        const KycWaitScreen()));

                        // ToastUtil.showToast("Login Successful");

                        ToastUtil.showToast("Registered Successfully");

                      } else {
                        setState(() {
                          loading = false;
                        });


                        List<dynamic> errors = value['message']['error'];
                        String errorMessage = errors.isNotEmpty ? errors[0] : "An unknown error occurred.";
                        Fluttertoast.showToast(msg: errorMessage);
                      }
                    });

                  }
                } else{
                  Fluttertoast.showToast(msg: "Please add document image");
                }



              }, title: "Submit"),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child:
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBox30(),
                          Center(
                            child: Container(
                              height: 104,
                              width: 104,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                icEmailRegister,
                              ),
                            ),
                          ),
                          sizedBox20(),

                          Center(
                            child: Text(
                              'Please Add Your Document For Verification. \n You Will be Notified When Your Profile Is Approved.',
                              textAlign: TextAlign.center,
                              style: kManrope14Medium626262.copyWith(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 23,),
                          Center(
                              child: GestureDetector(
                                onTap:  () async {
                                  XFile? v = await _imgPicker.pickImage(
                                      source: ImageSource.gallery);
                                  if (v != null) {
                                    setState(
                                          () {
                                        pickedImage = File(v.path);
                                      },
                                    );
                                  }

                                },
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 200,
                                          width: 300,
                                          padding:const EdgeInsets.all(24),
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            // color: Colors.redAccent,
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: pickedImage.path.isEmpty
                                              ? Image.asset(
                                            icIdentity,
                                            fit: BoxFit.cover,
                                          )  : Image.file(
                                            pickedImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                            top: 50,bottom: 50,right: 50,left: 50,
                                            child: Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context).highlightColor
                                                ),
                                                child: const Icon(Icons.camera_alt_outlined,size: 40,color: Colors.white,)))
                                      ],
                                    ),

                                  ],
                                ),
                              )

                          ),
                          // Text("Designation",
                          //   style: kManrope14Medium626262,),
                          // sizedBox6(),
                          // textBox(
                          //   context: context,
                          //   label: '',
                          //   controller: designationController,
                          //   hint: '',
                          //   length: 20,
                          //   onChanged: (value) {
                          //
                          //
                          //   },
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter your designation';
                          //     }
                          //     return null;
                          //   },
                          // ),

                          sizedBox20(),
                          Text(
                            'Select Verification Document Type ',
                            style: kManrope25Black.copyWith(fontSize: 16),
                          ),
                          sizedBox12(),
                          CustomStyledDropdownButton(
                            title: "Select Verification Document",
                            items: authControl.documentList,
                            selectedValue: authControl.document,
                            onChanged: (value) {
                              authControl.setDocument(value ?? authControl.documentList.first);
                              print('cadre =========== >${authControl.document}');
                            },
                          ),
                          sizedBox20(),
                          Text(
                            'Add Document Number ',
                            style: kManrope25Black.copyWith(fontSize: 16),
                          ),
                          sizedBox12(),
                          CustomTextField(
                            inputType: authControl.document == 'Aadhar Card' ? TextInputType.number : TextInputType.text,
                            maximumInput: getMaxLengthForDocumentType(authControl.document),
                            controller: _documentNoController,
                            capitalization: TextCapitalization.words,
                            hintText: 'Document Number',
                            onChanged: (value) {
                              authControl.setDocumentNo(_documentNoController.text);
                              print(authControl.documentNo);
                            },
                            validation: validateDocument,
                          ),

                          // const SizedBox(height: 20,),
                          // Text("Identity Proof Document Name",
                          //   style: kManrope14Medium626262,),
                          // sizedBox6(),
                          // CustomTextField(
                          //   controller: identityProof,
                          //   maxLines: 3,
                          //   hintText: 'Document Descrption',
                          //   validation: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter your Document Discription';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // textBox(
                          //   context: context,
                          //   label: '',
                          //   controller: identityProof,
                          //   hint: '',
                          //   length: 20,
                          //   onChanged: (value) {},
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter your first name';
                          //     }
                          //     return null;
                          //   },
                          // ),

                        ],
                      ),
                    ],
                  ),
                ),





            ),
          ),
        );
      })


    );
  }
  Future<void> _showDatePickerBottomSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: ScrollDatePicker(
            selectedDate: _selectedDate,
            locale: Locale('en'),
            onDateTimeChanged: (DateTime value) {
              setState(() {
                _selectedDate = value;
                final DateFormat formatter = DateFormat('yyyy/MM/dd');
                String formattedDate = formatter.format(_selectedDate);
                joiningDateController.text = formattedDate;
                print(formattedDate);
                print(_selectedDate);

              });
            },
          ),
        );
      },
    );
  }
  onBackPressed(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.exit_to_app_sharp, color: primaryColor),
              SizedBox(width: 10),
              Text('Close Application?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            content: const Text('Are you sure you want to exit the Application?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No', style: TextStyle(fontSize: 15, color: primaryColor)),
                onPressed: () {
                  Navigator.of(context).pop(false); //Will not exit the App
                },
              ),
              TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 15, color: primaryColor),
                ),
                onPressed: () {
                  exit(0);
                },
              )
            ],
          );
        });
  }

}


