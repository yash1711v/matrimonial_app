
import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/features/widgets/custom_dropdown_button_field.dart';
import 'package:bureau_couple/getx/features/widgets/custom_textfield_widget.dart';
import 'package:bureau_couple/getx/utils/sizeboxes.dart';
import 'package:bureau_couple/src/constants/assets.dart';
import 'package:bureau_couple/src/constants/fonts.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/widgets/dropdown_buttons.dart';

class SignUpScreenProfessionScreen extends StatefulWidget {

  const SignUpScreenProfessionScreen({super.key,});

  @override
  State<SignUpScreenProfessionScreen> createState() => _SignUpScreenProfessionScreenState();
  static final GlobalKey<FormState> _formKey7 = GlobalKey<FormState>();
  bool validate() {
    return _formKey7.currentState?.validate() ?? false;
  }
}

class _SignUpScreenProfessionScreenState extends State<SignUpScreenProfessionScreen> {

  final highestDegreeController = TextEditingController();
  final fieldOfStudyController = TextEditingController();
  final instituteController = TextEditingController();
  final startDateController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void initState() {
    fields();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getProfessionList();
      Get.find<AuthController>().getPositionHeldList();
      // Get.find<AuthController>().clearStateDistrict();

      // Get.find<AuthController>().getMotherTongueList();

    });
  }


  void fields() {
    highestDegreeController.text = Get.find<AuthController>().highestDegree ?? '' ;
    fieldOfStudyController.text = Get.find<AuthController>().fieldOfStudy ?? '' ;
    instituteController.text = Get.find<AuthController>().institute ?? '' ;

  }




  String? cadarValue;
  String cadarFilter = '';







  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: GetBuilder<AuthController>(builder: (authControl) {
          // startDateController.text =  authControl.from == null ? "" : authControl.from.toString();
          // endDateController.text =  authControl.to == null ? "" : authControl.to.toString();
          // startBatchYearController.text =  authControl.batchFromString;
          // endBatchController.text = authControl.batchToString;
          return authControl.professionList == null || authControl.professionList!.isEmpty ||
              authControl.positionHeldList == null || authControl.positionHeldList!.isEmpty ?
          const Center(child: CircularProgressIndicator()) :
          SingleChildScrollView(
            child: Form(key: SignUpScreenProfessionScreen._formKey7,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBox20(),
                    Center(
                      child: Container(
                        height: 104,
                        width: 104,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          icProfessionRegister,
                        ),
                      ),
                    ),  sizedBox20(),
                    Center(
                      child: Text("Now Let's Add Professional Details",
                        textAlign: TextAlign.center,
                        style: kManrope14Medium626262.copyWith(color: Colors.black),
                      ),
                    ),
                    sizedBox20(),

                    Text(
                      'Profession',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    CustomDropdownButtonFormField<String>(
                      value: authControl.professionList!.firstWhere((religion) => religion.id == authControl.professionIndex).name,// Assuming you have a selectedPosition variable
                      items: authControl.professionList!.map((position) => position.name!).toList(),
                      hintText: "Select Position",
                      onChanged: (value) {
                        if (value != null) {
                          var selected = authControl.professionList!.firstWhere((position) => position.name == value);
                          authControl.setProfessionIndexValue(selected.id, true);
                          print(authControl.professionIndexValue);
                        }
                      },
                      // itemLabelBuilder: (String item) => item,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Position';
                        }
                        return null;
                      },
                    ),
                    sizedBox20(),
                    Text(
                      'Position',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    CustomDropdownButtonFormField<String>(
                      value: authControl.positionHeldList!.firstWhere((religion) => religion.id == authControl.positionHeldIndex).name,// Assuming you have a selectedPosition variable
                      items: authControl.positionHeldList!.map((position) => position.name!).toList(),
                      hintText: "Select Position",
                      onChanged: (value) {
                        if (value != null) {
                          var selected = authControl.positionHeldList!.firstWhere((position) => position.name == value);
                          authControl.setPositionIndex(selected.id, true);
                          print(authControl.positionHeldIndex);
                        }
                      },
                      // itemLabelBuilder: (String item) => item,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Position';
                        }
                        return null;
                      },
                    ),

                    // CustomStyledDropdownButton(
                    //   items: authControl.positionHeldList!.map((religion) => religion.name!).toList(),
                    //   onChanged: (value) {
                    //     var selected = authControl.positionHeldList!.firstWhere((religion) => religion.name == value);
                    //     authControl.setPositionIndex(selected.id, true);
                    //     print(authControl.positionHeldIndex);
                    //   },
                    //   title: "Profession",
                    //   selectedValue: authControl.positionHeldList!.firstWhere((religion) => religion.id == authControl.positionHeldIndex).name,
                    // ),
                    sizedBox20(),
                    Text(
                      'Annual Income',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    CustomDropdownButtonFormField<String>(
                      value:  authControl.annualIncome,// Assuming you have a selectedPosition variable
                      items: authControl.annualIncomeList,
                      hintText: "Select Annual Income",
                      onChanged: (value) {
                        if (value != null) {
                          authControl.setAnnualIncome(value);
                          print(authControl.annualIncome);
                        }
                      },
                      // itemLabelBuilder: (String item) => item,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Annual Income';
                        }
                        return null;
                      },
                    ),




                    // CustomStyledDropdownButton(
                    //   title: "Select Annual Income",
                    //   items: authControl.annualIncomeList,
                    //   selectedValue: authControl.annualIncome ?? authControl.annualIncomeList.first,
                    //   onChanged: (value) {
                    //     authControl.setAnnualIncome(value ?? authControl.annualIncomeList.first);
                    //     print(authControl.annualIncome);
                    //   },
                    // ),

                    sizedBox12(),
                  ],
                )

















              ///##################################################################




              /*  Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Professional Info',
                    style: kManrope25Black,),
                  const  SizedBox(height: 30,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Profession",
                      textAlign: TextAlign.left,
                      style: styleSatoshiBold(size: 16, color: Colors.black),),
                  ),
                  const SizedBox(height: 5,),
                  Wrap(
                    spacing: 8.0,
                    children: authControl.professionList!.map((religion) {
                      return ChoiceChip(
                        selectedColor: color4B164C.withOpacity(0.80),
                        backgroundColor: Colors.white,
                        label: Text(
                          religion.name!,
                          style: TextStyle(
                            color: authControl.professionIndex == religion.id
                                ? Colors.white
                                : Colors.black.withOpacity(0.80),
                          ),
                        ),
                        selected: authControl.professionIndex == religion.id,
                        onSelected: (selected) {
                          if (selected) {
                            authControl.setProfessionIndex(religion.id, true);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Position",
                      textAlign: TextAlign.left,
                      style: styleSatoshiBold(size: 16, color: Colors.black),),
                  ),
                  const SizedBox(height: 5,),
                  Wrap(
                    spacing: 8.0,
                    children: authControl.positionHeldList!.map((religion) {
                      return ChoiceChip(
                        selectedColor: color4B164C.withOpacity(0.80),
                        backgroundColor: Colors.white,
                        label: Text(
                          religion.name!,
                          style: TextStyle(
                            color: authControl.positionHeldIndex == religion.id
                                ? Colors.white
                                : Colors.black.withOpacity(0.80),
                          ),
                        ),
                        selected: authControl.positionHeldIndex == religion.id,
                        onSelected: (selected) {
                          if (selected) {
                            authControl.setPositionIndex(religion.id, true);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                  Text("Cadres", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                  const SizedBox(height: 5),
                  const SizedBox(height: 5),
                  TypeAheadFormField<String>(
                    textFieldConfiguration:  TextFieldConfiguration(
                      controller: cadreController,
                      decoration: authDecoration(
                          context, "Select Cadre"
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      return authControl.indianStatesAndUTs.where((state) => state.toLowerCase().contains(pattern.toLowerCase())).toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion), ); },
                    onSuggestionSelected: (String? suggestion) {
                      if (suggestion != null) {
                        authControl.setIndianStates(suggestion);
                        cadreController.text = suggestion;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Select State';
                      }
                      return null;
                    },
                    onSaved: (value) => authControl.setIndianStates(value!),
                  ),
                  // SizedBox(
                  //   width: 1.sw,
                  //   child: CustomStyledDropdownButton(
                  //     items: const  [
                  //       "Cadres",
                  //
                  //     ],
                  //     selectedValue: cadarValue,
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please enter Cadres';
                  //       }
                  //       return null;
                  //     },
                  //     onChanged: (String? value) {
                  //       // setState(() {
                  //       //   cadarValue = value;
                  //       //   cadarFilter = cadarValue ?? '';
                  //       //   SharedPrefs().setMotherTongue(cadarFilter);
                  //       //
                  //       // });
                  //       // print(userTypeFilter);
                  //       // print('Check ======> Usetype${userTypeFilter}');
                  //     },
                  //     title: 'Cadres',
                  //   ),
                  // ),
                  const SizedBox(height: 20,),
                Text("Batch Year", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your Starting Year';
                            }
                            return null;
                          },
                          onTap: () {authControl.showStartingYearPickerDialog();},
                          onChanged: (value) {
                            authControl.setBatchStartYear(startBatchYearController.text);
                          },
                          readOnly:  true,
                          hintText:"Starting year",
                          controller: startBatchYearController,
                        ),
                      ),
                      // sizedBoxW10(),
                      // Expanded(
                      //   child: CustomTextField(hintText:"Ending year",
                      //     validation: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please Enter your Ending Year';
                      //       }
                      //       return null;
                      //     },
                      //     onChanged: (value) {
                      //     authControl.setBatchStartYear(endBatchController.text);
                      //     },
                      //     onTap: () {
                      //     authControl.showEndingYearPickerDialog();
                      //     },
                      //     readOnly: true,
                      //     controller: endBatchController,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Posting State", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                      const SizedBox(height: 5),
                      TypeAheadFormField<String>(
                        textFieldConfiguration:  TextFieldConfiguration(
                          controller: stateController,
                          decoration: authDecoration(
                              context, "Select Posting State"
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return authControl.posStates.where((state) => state.toLowerCase().contains(pattern.toLowerCase())).toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (String? suggestion) {
                          if (suggestion != null) {
                            authControl.setPosState(suggestion);
                            stateController.text = suggestion;
                            authControl.setPosstate(stateController.text);
                            print(authControl.posState);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select Posting State';
                          }
                          return null;
                        },
                        onSaved: (value) => authControl.setPosState(value!),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20,),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Posting District", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                      const SizedBox(height: 5),
                      TypeAheadFormField<String>(
                        textFieldConfiguration:  TextFieldConfiguration(

                          controller: districtController,
                          decoration: const InputDecoration(
                            // labelText: 'Select Posting District',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return authControl.posDistricts.where((state) => state.toLowerCase().contains(pattern.toLowerCase())).toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (String? suggestion) {
                          if (suggestion != null) {
                            // authControl.setDistrict(suggestion);
                            districtController.text = suggestion;
                            authControl.setPosDist(suggestion);
                            print(authControl.posDistrict);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select Posting District';
                          }
                          return null;
                        },
                        onSaved: (value) => authControl.setPosDistrict(value!),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20,),
                  Text("Date of Posting", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                  const SizedBox(height: 5), //
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          showTitle: false,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your Starting Date';
                            }
                            return null;
                          },
                          onTap: () { Get.find<AuthController>().showDatePicker(context); },
                          onChanged: (value) {
                            authControl.setPostingStartDate(authControl.from.toString());

                          },
                          readOnly:  true,
                          hintText:"Posting Start date",
                          controller: startDateController,
                        ),
                      ),
                      // sizedBoxW10(),
                      // Expanded(
                      //   child: CustomTextField(
                      //     showTitle: true, validation: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please Enter your Ending Date';
                      //        }
                      //       return null;
                      //     },
                      //     onChanged: (value) {
                      //       authControl.setPostingEndDate(endDateController.text);
                      //     },
                      //     hintText:"Ending date",
                      //     controller: endDateController,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Text('Education Info', style: kManrope25Black,),
                  const SizedBox(height: 20,),
                  Text("Highest Degree", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                  const SizedBox(height: 5), //
                  CustomTextField(hintText: "Highest Degree",
                  controller: highestDegreeController,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Highest Degree';
                      }
                      return null;
                    },
                    onChanged: (value) {
                    authControl.setHighestDegree(highestDegreeController.text);
                    },
                  showTitle: false,),
                  const SizedBox(height: 20,),
                  Text("Field of Study", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                  const SizedBox(height: 5), //
                  CustomTextField(hintText: "Field of Study",
                    controller: fieldOfStudyController,
                    validation: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Please Enter your Field of Study';
                    }
                      return null;
                    },
                    onChanged: (value) {
                      authControl.setFieldOfStudy(fieldOfStudyController.text);
                    },
                    showTitle: false,),
                  const SizedBox(height: 20,),
                  Text("University / Institute", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                  const SizedBox(height: 5), //
                  CustomTextField(hintText: "University / Institute",
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your University / Institute';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      authControl.setInstitute(instituteController.text);
                    },
                    controller: instituteController,
                    showTitle: false,),
                  const SizedBox(height: 20,),
                ],
              ),*/
            ),
          );
        }),
      ),
    );
  }
}

