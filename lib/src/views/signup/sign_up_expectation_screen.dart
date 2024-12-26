
import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/features/widgets/custom_dropdown_button_field.dart';
import 'package:bureau_couple/getx/features/widgets/custom_height_picker.dart';
import 'package:bureau_couple/getx/features/widgets/custom_textfield_widget.dart';
import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/getx/utils/sizeboxes.dart';
import 'package:bureau_couple/getx/utils/styles.dart';
import 'package:bureau_couple/src/constants/assets.dart';
import 'package:bureau_couple/src/constants/fonts.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/widgets/dropdown_buttons.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
class SignUpScreenExpectationScreen extends StatefulWidget {

  const SignUpScreenExpectationScreen({super.key,});

  @override
  State<SignUpScreenExpectationScreen> createState() => _SignUpScreenExpectationScreenState();
  static final GlobalKey<FormState> _formKey8 = GlobalKey<FormState>();
  bool validate() {
    return _formKey8.currentState?.validate() ?? false;
  }
}

class _SignUpScreenExpectationScreenState extends State<SignUpScreenExpectationScreen> {

  final minHeightController = TextEditingController();
  final aboutController = TextEditingController();
  final maxHeightController = TextEditingController();
  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();

  @override
  void initState() {
    fields();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getProfessionList();
      Get.find<AuthController>().getPositionHeldList();
      Get.find<AuthController>().getCommunityList();
      Get.find<AuthController>().getSmokingList();
      Get.find<AuthController>().getDrinkingList();
      fields();
      // Get.find<AuthController>().clearStateDistrict();

      // Get.find<AuthController>().getMotherTongueList();

    });

  }


  void fields() {
    minAgeController.text = Get.find<AuthController>().partnerMinAge ?? '';
    maxAgeController.text = Get.find<AuthController>().partnerMaxAge ?? '';
    minHeightController.text = Get.find<AuthController>().partnerMinHeight ?? '';
    maxHeightController.text = Get.find<AuthController>().partnerMaxHeight ?? '';
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
          return authControl.partProfessionList == null || authControl.partProfessionList!.isEmpty ||
              authControl.partPositionHeldList == null || authControl.partPositionHeldList!.isEmpty ||
              authControl.smokingList == null || authControl.smokingList!.isEmpty ||
              authControl.drikingList == null || authControl.drikingList!.isEmpty ?
          const Center(child: CircularProgressIndicator()) :
          SingleChildScrollView(
            child: Form(key: SignUpScreenExpectationScreen._formKey8,
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
                          icPartnerRegister,
                        ),
                      ),
                    ),
                    sizedBox20(),
                    // sizedBox12(),
                    Center(
                      child: Text("All Done Now Let's Add Partner Preference",
                        textAlign: TextAlign.center,
                        style: kManrope14Medium626262.copyWith(color: Colors.black),
                      ),
                    ),
                    sizedBox20(),
                    Text(
                      'General Requirement',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    CustomTextField(
                      maxLines: 3,
                      showTitle: true,
                      controller: aboutController,
                      capitalization: TextCapitalization.words,
                      hintText: '',
                      onChanged: (value) {
                        authControl.setAboutPartner(aboutController.text);
                      },
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'General Requirement';
                        }
                        // Regular expression to allow only letters and spaces
                        final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
                        if (!nameRegExp.hasMatch(value)) {
                          return 'Please enter a valid General Requirement without special characters';
                        }
                        return null;
                      },
                    ),
                    sizedBox12(),
                    Text(
                      'State',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    CustomDropdownButtonFormField<String>(
                      isMultiSelect: true,
                      value: authControl.selectedState,
                      items: authControl.states,
                      hintText: "Select State/UT",
                      onChanged: ( value) {
                        if (value != null) {
                          authControl.setStatePartner(value,true);
                          print(authControl.statePartner);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == 'Select State/UT') {
                          return 'Please Select State';
                        }
                        return null;
                      },
                    ),
                    sizedBox12(),
                    Text(
                      'Religion',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    CustomDropdownButtonFormField<String>(
                        isMultiSelect: true,
                      value: authControl.partReligionList!.firstWhere((religion) => religion.id == authControl.partnerReligion).name,// Assuming you have a selectedPosition variable
                      items: authControl.partReligionList!.map((position) => position.name!).toList(),
                      hintText: "Select Religion",
                      onChanged: (value) {
                          // debugPrint("value====>"+value.toString());
                        if (value != null) {
                          List<int?>? selected = [];
                          value.forEach((value){
                            var selectedValue = authControl.partReligionList!.firstWhere((position) => value == position.name);
                            selected.add(selectedValue.id);
                          });
                          authControl.setReligionMainIndexs(selected, true);
                          print(authControl.religionMainIndexs);
                        }
                      },
                      // itemLabelBuilder: (String item) => item,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Religion';
                        }
                        return null;
                      },
                    ),


                    // CustomStyledDropdownButton(
                    //   items: authControl.partReligionList!.map((religion) => religion.name!).toList(),
                    //   onChanged: (value) {
                    //     var selectedReligion = authControl.partReligionList!.firstWhere((religion) => religion.name == value);
                    //     authControl.setPartnerReligion(selectedReligion.id!);
                    //     print(authControl.partnerReligion);
                    //   },
                    //   title: "Select Religion",
                    //   selectedValue: authControl.partReligionList!.firstWhere((religion) => religion.id == authControl.partnerReligion ).name,
                    // ),

                    sizedBox20(),
                    Text(
                      'Mother Tongue',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    CustomDropdownButtonFormField<String>(
                      isMultiSelect: true,
                      value: authControl.partMotherTongueList!.firstWhere((religion) => religion.id == authControl.partnerMotherTongue).name,// Assuming you have a selectedPosition variable
                      items: authControl.partMotherTongueList!.map((position) => position.name!).toList(),
                      hintText: "Select Mother Tongue",
                      onChanged: (value) {
                        if (value != null) {
                          List<int?>? selected = [];
                          debugPrint("value====>"+value.toString());
                          value.forEach((value){
                            var selectedValue = authControl.partMotherTongueList!.firstWhere((position) => position.name == value);
                            selected.add(selectedValue.id);
                          });
                          authControl.setMotherTongueIndexs(selected,true);
                          print(authControl.motherTongueIndexs);
                          // var selected = authControl.partMotherTongueList!.firstWhere((position) => position.name == value);
                          // authControl.setPartnerMotherTongue(selected.id!);
                          // print( authControl.partnerMotherTongue);
                        }
                      },
                      // itemLabelBuilder: (String item) => item,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Mother Tongue';
                        }
                        return null;
                      },
                    ),

                    // CustomStyledDropdownButton(
                    //   items: authControl.partMotherTongueList!.map((religion) => religion.name!).toList(),
                    //   onChanged: (value) {
                    //     var selected = authControl.partMotherTongueList!.firstWhere((religion) => religion.name == value);
                    //     authControl.setPartnerMotherTongue(selected.id!);
                    //     print( authControl.partnerMotherTongue);
                    //   },
                    //   title: "Mother Tongue",
                    //   selectedValue: authControl.partMotherTongueList!.firstWhere((religion) => religion.id == authControl.partnerMotherTongue ).name,
                    // ),
                    sizedBox20(),
                    Text(
                      'Community',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    // authControl.casteList == null || authControl.casteList!.isEmpty ||
                    //     authControl.religionList == null ||  authControl.religionList!.isEmpty ||
                    //     authControl.isLoading
                    //     ?
                    // Container(
                    //     height: 55,
                    //     width: Get.size.width,
                    //     padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize10),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(width: 0.5,color: Colors.black.withOpacity(0.50)),
                    //       color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radius5),
                    //     ),
                    //     child: const Center(child: Align(alignment: Alignment.centerLeft,
                    //         child: Text("Community")))) :
                    // CustomDropdownButtonFormField<String>(
                    //   isMultiSelect: true,
                    //   value: authControl.casteList!.firstWhere((religion) => religion.id == authControl.casteMainIndex).name,// Assuming you have a selectedPosition variable
                    //   items: authControl.casteList!.map((position) => position.name!).toList(),
                    //   hintText: "Select Community",
                    //   onChanged: (value) {
                    //     // if (value != null) {
                    //     //   var selected = authControl.partCommunityList!.firstWhere((position) => position.name == value);
                    //     //   authControl.setPartnerCommunity(selected.id!);
                    //     //   print( authControl.partnerCommunity);
                    //     // }
                    //   },
                    //   // itemLabelBuilder: (String item) => item,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please Select Community';
                    //     }
                    //     return null;
                    //   },
                    // ),


                    CustomDropdownButtonFormField<String>(
                      isMultiSelect: true,
                      value: authControl.partCommunityList!.firstWhere((religion) => religion.id == authControl.partnerCommunity).name,// Assuming you have a selectedPosition variable
                      items: authControl.partCommunityList!.map((position) => position.name!).toList(),
                      hintText: "Select Community",
                      onChanged: (value) {
                        if (value != null) {
                          debugPrint("value====>"+value.toString());
                          List<int?>? selected = [];
                          value.forEach((value){
                            var selectedValue = authControl.partCommunityList!.firstWhere((position) => position.name == value);
                            selected.add(selectedValue.id);

                            // print( authControl.partnerCommunity);
                          });
                          authControl.setPartnerCommunitys(selected);

                        }
                      },
                      // itemLabelBuilder: (String item) => item,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Community';
                        }
                        return null;
                      },
                    ),

                    sizedBox20(),
                    Text(
                      'Diet',
                      style: kManrope25Black.copyWith(fontSize: Dimensions.fontSize18),
                    ),
                    sizedBox12(),
                    CustomDropdownButtonFormField<String>(
                      value: authControl.partnerDiet ,
                      items: authControl.dietList,
                      hintText: "Select Diet Type",
                      onChanged: (value) {
                        authControl.setPartnerDiet(value!);
                        print(authControl.partnerDiet);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == 'Select Diet Type') {
                          return 'Please Select Your Diet Type';
                        }
                        return null;
                      },
                    ),
                    // CustomStyledDropdownButton(
                    //   items: authControl.partCommunityList!.map((religion) => religion.name!).toList(),
                    //   onChanged: (value) {
                    //     var selected = authControl.partCommunityList!.firstWhere((religion) => religion.name == value);
                    //     authControl.setPartnerCommunity(selected.id!);
                    //     print(authControl.partnerCommunity);
                    //   },
                    //   title: "Community",
                    //   selectedValue: authControl.partCommunityList!.firstWhere((religion) => religion.id == authControl.partnerCommunity  ).name,
                    // ),
                    sizedBox20(),
                    Text(
                      'Profession ',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    CustomDropdownButtonFormField<String>(
                      isMultiSelect: true,
                      value: authControl.partProfessionList!.firstWhere((religion) => religion.id == authControl.partnerProfession).name,// Assuming you have a selectedPosition variable
                      items: authControl.partProfessionList!.map((position) => position.name!).toList(),
                      hintText: "Select Profession",
                      onChanged: (value) {
                        if (value != null) {
                          debugPrint("value====>"+value.toString());

                          List<int?> select = [];

                          value.forEach((value){
                            var selectedValue = authControl.partProfessionList!.firstWhere((position) => position.name == value);
                            select.add(selectedValue.id);
                          });

                          authControl.setPartnerProfessions(select);
                          // var selected = authControl.partProfessionList!.firstWhere((position) => position.name == value);
                          // authControl.setPartnerProfession(selected.id!);
                          // print( authControl.partnerProfession);
                        }
                      },
                      // itemLabelBuilder: (String item) => item,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Profession';
                        }
                        return null;
                      },
                    ),

                    // CustomStyledDropdownButton(
                    //   items: authControl.partProfessionList!.map((religion) => religion.name!).toList(),
                    //   onChanged: (value) {
                    //     var selected = authControl.partProfessionList!.firstWhere((religion) => religion.name == value);
                    //     authControl.setPartnerProfession(selected.id!);
                    //     print(authControl.partnerProfession );
                    //   },
                    //   title: "Community",
                    //   selectedValue: authControl.partProfessionList!.firstWhere((religion) => religion.id == authControl.partnerProfession   ).name,
                    // ),
                    sizedBox20(),
                    Text(
                      'Position',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    CustomDropdownButtonFormField<String>(
                      isMultiSelect: true,
                      value: authControl.partPositionHeldList!.firstWhere((religion) => religion.id == authControl.partnerPosition).name,// Assuming you have a selectedPosition variable
                      items: authControl.partPositionHeldList!.map((position) => position.name!).toList(),
                      hintText: "Select Position",
                      onChanged: (value) {
                        debugPrint("value====>"+value.toString());
                        if (value != null) {
                          List<int?> select = [];
                          value.forEach((value){
                            var selectedValue = authControl.partPositionHeldList!.firstWhere((position) => position.name == value);
                            select.add(selectedValue.id);
                          });
                          authControl.setPartnerPositions(select);
                          print(authControl.partnerPosition);
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
                    //   items: authControl.partPositionHeldList!.map((religion) => religion.name!).toList(),
                    //   onChanged: (value) {
                    //     var selected = authControl.partPositionHeldList!.firstWhere((religion) => religion.name == value);
                    //     authControl.setPartnerPosition(selected.id!);
                    //     print(authControl.partnerPosition);
                    //   },
                    //   title: "Community",
                    //   selectedValue: authControl.partPositionHeldList!.firstWhere((religion) => religion.id == authControl.partnerPosition    ).name,
                    // ),
                    sizedBox20(),
                    Text(
                      'Age Bracket',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Column(
                          children: [
                            // Text("Min Age", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                            Text('${authControl.startValue.value.round().toString()} yrs',
                              style:satoshiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).primaryColor),),
                          ],
                        ),
                        Column(
                          children: [
                            // Text("Max Age", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                            Text('${authControl.endValue.value.round().toString()} yrs',
                              style:satoshiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).primaryColor),),
                          ],
                        ),
                      ],),
                      RangeSlider(
                        min: 20.0,
                        max: 60.0,
                        divisions: 75,
                        labels: RangeLabels(
                          authControl.startValue.value.round().toString(),
                          authControl.endValue.value.round().toString(),
                        ),
                        values: RangeValues(
                          authControl.startValue.value,
                          authControl.endValue.value,
                        ),
                        onChanged: (values) {
                          authControl.setAgeValue(values);
                        },
                      ),
                    ],
                  ),
                ),


                    sizedBox20(),
                    Text(
                      'Height Bracket',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  // Text("Min Height", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                                  Text('${authControl.startHeightValue.value.round().toString()} ft',
                                    style:satoshiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).primaryColor),),
                                ],
                              ),
                              Column(
                                children: [
                                  // Text("Max Height", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                                  Text('${authControl.endHeightValue.value.round().toString()} ft',
                                    style:satoshiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).primaryColor),),
                                ],
                              ),
                            ],),
                          Container(
                            width: double.infinity,
                            child: Obx(() => RangeSlider(
                              min: 4.0, // Minimum value
                              max: 7.0, // Maximum value
                              divisions: 76, // Number of divisions for finer granularity
                              labels: RangeLabels(
                                authControl.startHeightValue.value.toStringAsFixed(1), // Format to 1 decimal place
                                authControl.endHeightValue.value.toStringAsFixed(1), // Format to 1 decimal place
                              ),
                              values: RangeValues(
                                authControl.startHeightValue.value,
                                authControl.endHeightValue.value,
                              ),
                              onChanged: (values) {
                                authControl.setHeightValue(values); // Update the values when slider changes
                                print('Updated range values: ${values.start.toStringAsFixed(1)} - ${values.end.toStringAsFixed(1)}');
                              },
                            )),
                          ),


                        ],
                      ),
                    ),
                    sizedBox20(),
                    Text(
                      'Smoking & Drinking Habit',
                      style: kManrope25Black.copyWith(fontSize: 16),
                    ),
                    sizedBox12(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Smoking", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                              const SizedBox(height: 5),
                              CustomStyledDropdownButton(
                                items: authControl.smokingList!.map((religion) => religion.name!).toList(),
                                onChanged: (value) {
                                  var selected = authControl.smokingList!.firstWhere((religion) => religion.name == value);
                                  authControl.setSmokingIndex(selected.id!,true);
                                  print(authControl.smokingIndex  );
                                },
                                title: "Community",
                                selectedValue: authControl.smokingList!.firstWhere((religion) => religion.id == authControl.smokingIndex    ).name,
                              ),
                            ],
                          ),
                        ),
                        sizedBoxW15(),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Drinking", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                              const SizedBox(height: 5),
                              CustomStyledDropdownButton(
                                items: authControl.drikingList!.map((religion) => religion.name!).toList(),
                                onChanged: (value) {
                                  var selected = authControl.drikingList!.firstWhere((religion) => religion.name == value);
                                  authControl.setDrikingIndex(selected.id!,true);
                                  print(authControl.drikingIndex  );
                                },
                                title: "Community",
                                selectedValue: authControl.drikingList!.firstWhere((religion) => religion.id == authControl.drikingIndex    ).name,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),


                  ],
                )
            ),
          );
        }),
      ),
    );
  }
}

