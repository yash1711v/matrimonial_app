import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/controllers/profile_controller.dart';
import 'package:bureau_couple/getx/data/response/profile_model.dart';
import 'package:bureau_couple/getx/features/widgets/custom_dropdown_button_field.dart';
import 'package:bureau_couple/getx/features/widgets/custom_textfield_widget.dart';
import 'package:bureau_couple/getx/features/widgets/custom_toast.dart';
import 'package:bureau_couple/getx/features/widgets/custom_typeahead_field.dart';
import 'package:bureau_couple/getx/features/widgets/edit_details_textfield.dart';
import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/getx/utils/styles.dart';
import 'package:bureau_couple/src/constants/colors.dart';
import 'package:bureau_couple/src/constants/fonts.dart';
import 'package:bureau_couple/src/constants/sizedboxe.dart';
import 'package:bureau_couple/src/models/profie_model.dart';
import 'package:bureau_couple/src/utils/widgets/buttons.dart';
import 'package:bureau_couple/src/views/home/profile/edit_preferred_matches.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../apis/profile_apis/career_info_api.dart';
import '../../../apis/profile_apis/get_profile_api.dart';
import '../../../constants/assets.dart';
import '../../../constants/string.dart';
import '../../../constants/textstyles.dart';
import '../../../utils/widgets/common_widgets.dart';
import '../../../utils/widgets/customAppbar.dart';
import '../../../utils/widgets/loader.dart';
import '../../../utils/widgets/name_edit_dialog.dart';
import '../../../utils/widgets/textfield_decoration.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class EditCareerInfoScreen extends StatefulWidget {
  final CareerInfo? career;

  const EditCareerInfoScreen({super.key, this.career});

  @override
  State<EditCareerInfoScreen> createState() => _EditCareerInfoScreenState();
}

class _EditCareerInfoScreenState extends State<EditCareerInfoScreen> {
  final companyController = TextEditingController();
  final startingYearController = TextEditingController();
  final endingYearController = TextEditingController();
  final designationController = TextEditingController();
  bool loading = false;
  bool isLoading = false;
  List<Map<String,Map<String, TextEditingController>>> fieldControllers = [];

  List<String> fieldNames = []; // Initial constant fields
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    careerInfo();
    Get.find<AuthController>().getProfessionList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getPositionHeldList();
    });
    super.initState();
  }

  List<CareerInfo> career = [];


  void showAddFieldDialog() {
    TextEditingController positionControllerDialog = TextEditingController();
    TextEditingController highestDegree = TextEditingController();
    TextEditingController fieldOfStudy = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Field"),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                TextField(
                  readOnly: true,
                  controller: positionControllerDialog,
                  onTap: (){
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                'Position',
                                style: kManrope25Black.copyWith(
                                    fontSize: 16),
                              ),
                              sizedBox12(),
                              CustomDropdownButtonFormField<String>(
                                value: Get.find<AuthController>().positionHeldList!
                                    .firstWhere((religion) =>
                                religion.id ==
                                    Get.find<AuthController>().positionHeldIndex)
                                    .name,
                                // Assuming you have a selectedPosition variable
                                items: Get.find<AuthController>().positionHeldList!
                                    .map((position) => position.name!)
                                    .toList(),
                                hintText: "Select Position",
                                onChanged: (value) {
                                  if (value != null) {
                                    var selected = Get.find<AuthController>().positionHeldList!
                                        .firstWhere((position) =>
                                    position.name == value);
                                    Get.find<AuthController>().setPositionIndex(
                                        selected.id, true);
                                    positionControllerDialog.text =
                                        selected.name.toString();
                                    print(
                                        Get.find<AuthController>().positionHeldIndex);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  decoration: const InputDecoration(hintText: "Position"),
                ),
                // SizedBox(height: 10),
                TextField(
                  controller: highestDegree,
                  readOnly: true,
                  decoration: const InputDecoration(hintText: "select state of posting"),
                  onTap: () {
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                'State of Posting',
                                style: kManrope25Black.copyWith(
                                    fontSize: 16),
                              ),
                              sizedBox12(),
                              CustomDropdownButtonFormField<String>(
                                value: Get.find<AuthController>().posselectedState,
                                items: Get.find<AuthController>().posstates,
                                hintText: "Select Posting State",
                                onChanged: (value) {
                                  Get.find<AuthController>().possetState(value ??
                                      Get.find<AuthController>().posstates.first);
                                  print(
                                      'cadre =========== >${Get.find<AuthController>().posselectedState}');
                                  highestDegree.text = Get.find<AuthController>()
                                      .posselectedState
                                      .toString();
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value ==
                                          'Please Posting State') {
                                    return 'Please Posting State';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // TextField(
                //   controller: highestDegree,
                //   decoration: const InputDecoration(hintText: "State of Posting"),
                // ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {

                Navigator.of(context).pop();

                List<String> position = [Get.find<AuthController>().positionHeldIndex.toString()];
                List<String> stateOfPosting = [highestDegree
                    .text];


                Get.find<ProfileController>().editCareerInfoApi(
                    null,
                    position,
                    stateOfPosting,
                    districtController.text,
                    fromController.text,
                    endController.text).then((value){
                      debugPrint("Value: $value");
                      setState(() {
                        fieldControllers.add({
                          "newFields ${fieldControllers.length+1}": {
                            "Position": positionControllerDialog,
                            "State of Posting": highestDegree,
                            "id": TextEditingController(text: value.toString()),
                          }
                        });
                      });


                });

              },
            ),
          ],
        );
      },
    );
  }


  careerInfo() {
    isLoading = true;
    var resp = getProfileApi();
    resp.then((value) {
      career.clear();
      if (value['status'] == true) {
        setState(() {
          // profile = ProfileModel.fromJson(value);
          for (var v in value['data']['user']['career_info']) {
            career.add(CareerInfo.fromJson(v));
          }
          fields();
          // print(career.length);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  final positionController = TextEditingController();
  final positionIdController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final fromController = TextEditingController();
  final endController = TextEditingController();
     int id = 0;
  // final positionController = TextEditingController();

  void fields() {
    positionController.text =
        Get.find<AuthController>().positionHeldList!
            .firstWhere((element) => element.id == career[0].position)
            .name!;
    stateController.text = career[0].statePosting.toString() ?? '';
    districtController.text = career[0].districtPosting.toString() ?? '';
    fromController.text = career[0].from ?? '';
    id = career[0].id ?? 0;


    var selected = [];
    for(int i = 0; i< career.length; i++) {
    (Get.find<AuthController>().positionHeldList ?? [])
        .forEach((element){
      if(element.id == career[i].position && i>0){
        selected.add(element.name);
      }
    });}
    for(int i = 0; i< career.length; i++) {
      if(i > 0){
        fieldControllers.add({
          "newFields $i": {
            "Position": TextEditingController(text: selected[i-1]),
            "State of Posting": TextEditingController(text: career[i].statePosting.toString()),
            "id": TextEditingController(text: career[i].id.toString()),
          }
        });
      }
    }
    // endController.text = career[0].end.toString() ?? '';
  }

  List<String> selectedItems = [];
  String selectedItemId = '';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authControl) {
      return GetBuilder<ProfileController>(builder: (profileControl) {

        return Scaffold(
          appBar: CustomAppBar(
            title: "Career Info",
            menuWidget: IconButton(
                onPressed: () {
                  debugPrint("Menu pressed");
                  showAddFieldDialog();
                },
                icon: const Icon(Icons.add)),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: /*profileControl.isLoading ?
                 loadingButton(context: context) :*/
                  button(
                      context: context,
                      onTap: () {
                        if (authControl.positionHeldIndex == 0) {
                          showCustomSnackBar("Please Select Position");
                        } else {

                          //
                          // List<String> position = [authControl.positionHeldIndex.toString()];
                          // List<String> stateOfPosting = [stateController
                          //     .text];
                          //
                          // fieldControllers.forEach((element) {
                          //   position.add(element["newFields ${fieldControllers.indexOf(element)+1}"]!["Position"]!.text);
                          //   stateOfPosting.add(element["newFields ${fieldControllers.indexOf(element)+1}"]!["State of Posting"]!.text);
                          // });
                          //
                          // profileControl.editCareerInfoApi(
                          //     career[0].id.toString(),
                          //     position,
                          //     stateOfPosting,
                          //     districtController.text,
                          //     fromController.text,
                          //     endController.text);
                          // print(positionController.text);
                          // print(fromController.text);
                          // print(endController.text);
                          // print(stateController.text);
                          // print(districtController.text);
                          // print(authControl.professionIndex.toString());
                          // Navigator.pop(context);
                          Get.back();
                        }
                      },
                      title: "Save"),
            ),
          ),
          body: isLoading
              ? const Loading()
              : CustomRefreshIndicator(
                  onRefresh: () {
                    setState(() {
                      isLoading = true;
                    });
                    return careerInfo();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Column(
                        children: [
                          // if (career.isEmpty || career == null) Center(
                          //     child: GestureDetector(
                          //       onTap: () {
                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return StatefulBuilder(
                          //                 builder: (BuildContext context, StateSetter setState) {
                          //                   return EditDialogWidget(
                          //                       addTextField: Column(
                          //                         crossAxisAlignment: CrossAxisAlignment.start,
                          //                         children: [
                          //                           Text("Career Info",
                          //                             style: styleSatoshiBold(size: 18, color: Colors.black),),
                          //                           sizedBox16(),
                          //                           Row(
                          //                             children: [
                          //                               Expanded(
                          //                                 child: buildTextFormField(context,
                          //                                     hint: 'company', controller: companyController),
                          //                               ),
                          //                               const SizedBox(width: 6,),
                          //                               Expanded(
                          //                                 child: buildTextFormField(context,
                          //                                     hint: 'designation',
                          //                                     controller: designationController),
                          //                               ),
                          //                             ],
                          //                           ),
                          //                           sizedBox16(),
                          //                           Row(
                          //                             children: [
                          //                               Expanded(
                          //                                 child: buildTextFormField(context,
                          //                                     hint: 'start',
                          //                                     controller: startingYearController,
                          //                                     keyboard: TextInputType.number),
                          //                               ),
                          //                               const SizedBox(
                          //                                 width: 6,
                          //                               ),
                          //                               Expanded(
                          //                                 child: buildTextFormField(context,
                          //                                     hint: 'end No',
                          //                                     controller: endingYearController,
                          //                                     keyboard: TextInputType.number),
                          //                               ),
                          //                             ],
                          //                           ),
                          //                           sizedBox10(),
                          //                           sizedBox16(),
                          //                           loading
                          //                               ? loadingElevatedButton(
                          //                               context: context, color: primaryColor)
                          //                               : elevatedButton(
                          //                               color: primaryColor,
                          //                               context: context,
                          //                               onTap: () {
                          //                                 setState(() {
                          //                                   loading = true;
                          //                                 });
                          //
                          //                                 careerInfoAddApi(
                          //                                   // id: career[0].id.toString(),
                          //                                     company: companyController.text,
                          //                                     designation: designationController.text,
                          //                                     startYear: startingYearController.text,
                          //                                     endYear: endingYearController.text)
                          //                                     .then((value) {
                          //                                   if (value['status'] == true) {
                          //                                     Navigator.pop(context);
                          //                                     setState(() {
                          //                                       loading = false;
                          //                                       careerInfo();
                          //                                     });
                          //                                     companyController.clear();
                          //                                     designationController.clear();
                          //                                     startingYearController.clear();
                          //                                     endingYearController.clear();
                          //                                     ToastUtil.showToast("Updated Successfully");
                          //                                   } else {
                          //                                     setState(() {
                          //                                       loading = false;
                          //                                     });
                          //                                     Get.back();
                          //
                          //                                     List<dynamic> errors =
                          //                                     value['message']['error'];
                          //                                     String errorMessage = errors.isNotEmpty
                          //                                         ? errors[0]
                          //                                         : "An unknown error occurred.";
                          //                                     Fluttertoast.showToast(msg: errorMessage);
                          //                                   }
                          //                                 });
                          //                               },
                          //                               title: "Save")
                          //                         ],
                          //                       ));
                          //                 });
                          //           },
                          //         );
                          //
                          //
                          //       },
                          //       child: const Padding(
                          //         padding: EdgeInsets.only(top: 50.0),
                          //         child: DottedPlaceHolder(text: "Add Career Info"),
                          //       ),
                          //     )) else
                         Padding(
                           padding: const EdgeInsets.only(bottom: 8.0),
                           child: Container(
                             width: double.infinity,
                             decoration: BoxDecoration(
                                 color: Theme.of(context).cardColor,
                                 borderRadius: BorderRadius.circular(12),
                                 boxShadow: [
                                   BoxShadow(
                                     color: Colors.grey.withOpacity(0.5),
                                     spreadRadius: 1,
                                     blurRadius: 5,
                                     offset: const Offset(
                                         0, 3), // changes position of shadow
                                   ),
                                 ]),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
                               child: Column(
                                 children: [
                                   EditDetailsTextField(
                                     title: 'Position',
                                     controller: positionController,
                                     readOnly: true,
                                     onTap: () {
                                       Get.bottomSheet(
                                         SingleChildScrollView(
                                           child: Container(
                                             color: Theme.of(context).cardColor,
                                             padding: const EdgeInsets.all(
                                                 Dimensions.paddingSizeDefault),
                                             child: Column(
                                               children: [
                                                 Text(
                                                   'Position',
                                                   style: kManrope25Black.copyWith(
                                                       fontSize: 16),
                                                 ),
                                                 sizedBox12(),
                                                 CustomDropdownButtonFormField<String>(
                                                   value: authControl.positionHeldList!
                                                       .firstWhere((religion) =>
                                                   religion.id ==
                                                       authControl.positionHeldIndex)
                                                       .name,
                                                   // Assuming you have a selectedPosition variable
                                                   items: authControl.positionHeldList!
                                                       .map((position) => position.name!)
                                                       .toList(),
                                                   hintText: "Select Position",
                                                   onChanged: (value) {
                                                     if (value != null) {
                                                       var selected = authControl
                                                           .positionHeldList!
                                                           .firstWhere((position) =>
                                                       position.name == value);
                                                       authControl.setPositionIndex(
                                                           selected.id, true);
                                                       positionController.text =
                                                           selected.name.toString();
                                                       print(
                                                           authControl.professionIndex);

                                                     profileControl.editCareerInfoApi(
                                                         career[0].id.toString(),
                                                         [authControl.positionHeldIndex.toString()],
                                                         [stateController.text],
                                                         districtController.text,
                                                         fromController.text,
                                                       endController.text
                                                       );

                                                     }
                                                   },
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),
                                       );
                                     },
                                   ),
                                   sizedBox6(),
                                   EditDetailsTextField(
                                     title: 'State of Posting',
                                     controller: stateController,
                                     readOnly: true,
                                     onTap: () {
                                       Get.bottomSheet(
                                         SingleChildScrollView(
                                           child: Container(
                                             color: Theme.of(context).cardColor,
                                             padding: const EdgeInsets.all(
                                                 Dimensions.paddingSizeDefault),
                                             child: Column(
                                               children: [
                                                 Text(
                                                   'State of Posting',
                                                   style: kManrope25Black.copyWith(
                                                       fontSize: 16),
                                                 ),
                                                 sizedBox12(),
                                                 CustomDropdownButtonFormField<String>(
                                                   value: authControl.posselectedState,
                                                   items: authControl.posstates,
                                                   hintText: "Select Posting State",
                                                   onChanged: (value) {
                                                     authControl.possetState(value ??
                                                         authControl.posstates.first);
                                                     print(
                                                         'cadre =========== >${authControl.posselectedState}');
                                                     stateController.text = authControl
                                                         .posselectedState
                                                         .toString();
                                                     profileControl.editCareerInfoApi(
                                                         career[0].id.toString(),
                                                         [authControl.positionHeldIndex.toString()],
                                                         [stateController.text],
                                                         districtController.text,
                                                         fromController.text,
                                                         endController.text
                                                     );
                                                   },
                                                   validator: (value) {
                                                     if (value == null ||
                                                         value.isEmpty ||
                                                         value ==
                                                             'Please Posting State') {
                                                       return 'Please Posting State';
                                                     }
                                                     return null;
                                                   },
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),
                                       );
                                     },
                                   ),
                                   sizedBox6(),
                                 ],
                               ),
                             ),
                           ),
                         ),

                          sizedBox16(),
                          for(int i = 0; i < fieldControllers.length; i++)
                            Visibility(
                              // visible: i>0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(
                                              0, 3), // changes position of shadow
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
                                    child: Column(
                                      children: [
                                        EditDetailsTextField(
                                          title: "Position",
                                          controller: fieldControllers[i]["newFields ${i+1}"]!["Position"]! ?? TextEditingController(),
                                          readOnly: true,
                                          onTap: (){
                                            Get.bottomSheet(
                                            SingleChildScrollView(
                                              child: Container(
                                                color: Theme.of(context).cardColor,
                                                padding: const EdgeInsets.all(
                                                    Dimensions.paddingSizeDefault),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Position',
                                                      style: kManrope25Black.copyWith(
                                                          fontSize: 16),
                                                    ),
                                                    sizedBox12(),
                                                    CustomDropdownButtonFormField<String>(
                                                      value: Get.find<AuthController>().positionHeldList!
                                                          .firstWhere((religion) =>
                                                      religion.id ==
                                                          Get.find<AuthController>().positionHeldIndex)
                                                          .name,
                                                      // Assuming you have a selectedPosition variable
                                                      items: Get.find<AuthController>().positionHeldList!
                                                          .map((position) => position.name!)
                                                          .toList(),
                                                      hintText: "Select Position",
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          var selected = Get.find<AuthController>().positionHeldList!
                                                              .firstWhere((position) =>
                                                          position.name == value);
                                                          Get.find<AuthController>().setProfessionIndex(
                                                              selected.id, true);
                                                         setState(() {
                                                           fieldControllers[i]["newFields ${i+1}"]!["Position"]!.text =
                                                               selected.name.toString();
                                                         });
                                                          print(
                                                              Get.find<AuthController>().positionHeldIndex);

                                                          profileControl.editCareerInfoApi(
                                                              fieldControllers[i]["newFields ${i+1}"]!["id"]!.text,
                                                              [selected.id.toString()],
                                                              [fieldControllers[i]["newFields ${i+1}"]!["State of Posting"]!.text],
                                                              districtController.text,
                                                              fromController.text,
                                                              endController.text
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                          },
                                        ),
                                        sizedBox6(),
                                        EditDetailsTextField(
                                          title: "State of Posting",
                                          controller: fieldControllers[i]["newFields ${i+1}"]!["State of Posting"]! ?? TextEditingController(),
                                          readOnly: true,
                                          onTap: (){
                                            Get.bottomSheet(
                                              SingleChildScrollView(
                                                child: Container(
                                                  color: Theme.of(context).cardColor,
                                                  padding: const EdgeInsets.all(
                                                      Dimensions.paddingSizeDefault),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'State of Posting',
                                                        style: kManrope25Black.copyWith(
                                                            fontSize: 16),
                                                      ),
                                                      sizedBox12(),
                                                      CustomDropdownButtonFormField<String>(
                                                        value: authControl.posselectedState,
                                                        items: authControl.posstates,
                                                        hintText: "Select Posting State",
                                                        onChanged: (value) {
                                                          authControl.possetState(value ??
                                                              authControl.posstates.first);

                                                          fieldControllers[i]["newFields ${i+1}"]!["State of Posting"]!.text = authControl
                                                              .posselectedState
                                                              .toString();
                                                          print(
                                                              'Va;lue ${fieldControllers[i]["newFields ${i+1}"]!["State of Posting"]!.text}');
                                                          print(
                                                              'Va;lue ${fieldControllers[i]["newFields ${i+1}"]!["Position"]!.text}');
                                                          var selected = Get.find<AuthController>().positionHeldList!
                                                              .firstWhere((position) =>
                                                          position.name == fieldControllers[i]["newFields ${i+1}"]!["Position"]!.text);

                                                          profileControl.editCareerInfoApi(
                                                              fieldControllers[i]["newFields ${i+1}"]!["id"]!.text,
                                                              [selected.id.toString()],
                                                              [fieldControllers[i]["newFields ${i+1}"]!["State of Posting"]!.text],
                                                              districtController.text,
                                                              fromController.text,
                                                              endController.text
                                                          );
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty ||
                                                              value ==
                                                                  'Please Posting State') {
                                                            return 'Please Posting State';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        sizedBox6(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          /*                ListView.builder(
                       physics: const NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       itemCount: career.length,
                       itemBuilder: (_, i) {
                         return GestureDetector(
                           behavior: HitTestBehavior.translucent,
                           onLongPress: () {
                             setState(() {
                               selectedItemId = career[i]
                                   .id
                                   .toString(); // Set the ID of the selected item
                             });
                           },
                           child: Column(
                             children: [
                               buildListRow(
                                 title: 'Position',
                                 data1: StringUtils.capitalize(positionController.text), tap: () {
                                 Get.bottomSheet(
                                   SingleChildScrollView(
                                     child: Container(color: Theme.of(context).cardColor,
                                       padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                       child: Column(
                                         children: [
                                           Text(
                                             'Profession',
                                             style: kManrope25Black.copyWith(fontSize: 16),
                                           ),
                                           sizedBox12(),
                                           CustomDropdownButtonFormField<String>(
                                             value: authControl.professionList!.firstWhere((religion) => religion.id == authControl.professionIndex).name,// Assuming you have a selectedPosition variable
                                             items: authControl.professionList!.map((position) => position.name!).toList(),
                                             hintText: "Select Position",
                                             onChanged: (String? value) {
                                               if (value != null) {
                                                 var selected = authControl.professionList!.firstWhere((position) => position.name == value);
                                                 authControl.setProfessionIndex(selected.id, true);
                                                 positionController.text = selected.name.toString();
                                                 print(authControl.professionIndex);
                                               }
                                             },

                                           ),
                                         ],
                                       ),),
                                   ),
                                 );
                               },
                                 widget: const Icon(
                             Icons.edit,
                             size: 12,
                           ),
                               ),
                               // const Divider(),
                               // sizedBox10(),
                               // buildListRow(
                               //   title: 'Posting Year',
                               //   data1: StringUtils.capitalize('${fromController.text}'), tap: () {
                               //   Get.bottomSheet(
                               //     SingleChildScrollView(
                               //       child: Container(color: Colors.white,
                               //         padding: const EdgeInsets.all(16),
                               //         child: Column(
                               //           children: [
                               //             Align(
                               //               alignment: Alignment.centerLeft,
                               //               child: Text("Date of Posting",
                               //                 textAlign: TextAlign.left,
                               //                 style: styleSatoshiBold(size: 16, color: Colors.black),),
                               //             ),
                               //             const SizedBox(height: 5), //
                               //             Row(
                               //               children: [
                               //                 Expanded(
                               //                   child: CustomTextField(
                               //                     showTitle: true,
                               //                     validation: (value) {
                               //                       if (value == null || value.isEmpty) {
                               //                         return 'Please Enter your Starting Date';
                               //                       }
                               //                       return null;
                               //                     },
                               //                     onTap: () {
                               //                       Get.find<AuthController>().showDatePicker(context);
                               //                       fromController.text = authControl.from!;
                               //                       endController.text =  authControl.to!;
                               //                       // authControl.update();
                               //
                               //                     },
                               //                     onChanged: (value) {
                               //                       print(' ===== > Print $value');
                               //
                               //                       // authControl.setPostingStartDate(authControl.from.toString());
                               //
                               //                     },
                               //                     readOnly:  true,
                               //                     hintText:"Starting date",
                               //                     controller: fromController,
                               //                   ),
                               //                 ),
                               //                 const SizedBox(width: 10,),
                               //                 Expanded(
                               //                   child: CustomTextField(
                               //                     showTitle: true, validation: (value) {
                               //                     if (value == null || value.isEmpty) {
                               //                       return 'Please Enter your Ending Date';
                               //                     }
                               //                     return null;
                               //                   },
                               //                     onChanged: (value) {
                               //                       authControl.setPostingEndDate(endController.text);
                               //                     },
                               //                     hintText:"Ending date",
                               //                     controller: endController,
                               //                   ),
                               //                 ),
                               //               ],
                               //             ),
                               //           ],
                               //         ),
                               //       ),
                               //     ),
                               //     backgroundColor: Colors.transparent,
                               //     isScrollControlled: true,);
                               //
                               //   print(stateController.text);
                               //   print(districtController.text);
                               // },
                               // ),
                               sizedBox10(),
                               const Divider(),
                               sizedBox10(),
                               // Align(alignment: Alignment.centerRight,
                               //     child: InkWell(
                               //       onTap: () {
                               //         Get.bottomSheet(
                               //           SelectStateAndDistrict( onStatePop: (val) {
                               //             stateController.text = val;
                               //             print('=========?${stateController.text}');
                               //             Get.find<AuthController>().update();
                               //           }, onDistrictPop: (val) {
                               //             districtController.text = val;
                               //             Get.find<AuthController>().update();
                               //           },),
                               //           backgroundColor: Colors.transparent,
                               //           isScrollControlled: true,);
                               //       },
                               //       child: Container(
                               //         padding: const EdgeInsets.only(top: 10,bottom: 10,left: 16),
                               //         child: Text('Edit',
                               //           style: kManrope16Medium.copyWith(color: Colors.red),),
                               //       ),
                               //     )
                               // ),
                               buildListRow(
                                 title: 'State Of Posting',
                                 data1: stateController.text, tap: () {
                                 Get.bottomSheet(
                                   SingleChildScrollView(
                                     child: Container(color: Theme.of(context).cardColor,
                                       padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                       child: Column(
                                         children: [
                                           Text(
                                             'State of Posting',
                                             style: kManrope25Black.copyWith(fontSize: 16),
                                           ),
                                           sizedBox12(),
                                           CustomDropdownButtonFormField<String>(
                                             value:  authControl.posselectedState,
                                             items: authControl.posstates,
                                             hintText: "Select Posting State",
                                             onChanged: (value) {
                                               authControl.possetState(value ?? authControl.posstates.first);
                                               print('cadre =========== >${authControl.posselectedState}');
                                               stateController.text = authControl.posselectedState.toString();
                                             },
                                             validator: (value) {
                                               if (value == null || value.isEmpty || value == 'Please Posting State') {
                                                 return 'Please Posting State';
                                               }
                                               return null;
                                             },
                                           ),
                                         ],
                                       ),),
                                   ),
                                 );
                                }, widget: const Icon(
                                 Icons.edit,
                                 size: 12,),),
                               sizedBox6(),
                               const Divider(),
                               sizedBox10(),
                               // buildListRow(
                               //   title: 'District Of Posting',
                               //   data1: districtController.text, tap: () {
                               //   // Get.bottomSheet(
                               //   //   SelectStateAndDistrict( onStatePop: (String ) {
                               //   //     stateController.text = String;
                               //   //   }, onDistrictPop: (String ) {
                               //   //     districtController.text = String;
                               //   //   },),
                               //   //   backgroundColor: Colors.transparent,
                               //   //   isScrollControlled: true,);
                               // },
                               // ),
                             ],
                           ),
                         );
                       }),*/
                        ],
                      ),
                    ),
                  ),
                ),
        );
      });
    });
  }

  GestureDetector buildListRow({
    required String title,
    required String data1,
    required Widget widget,
    required Function() tap,
  }) {
    return GestureDetector(
      onTap: tap,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  '${title}  ',
                ),
                widget,
              ],
            ),
          ),
          Expanded(
            // flex: 3,
            child: SizedBox(
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data1,
                    maxLines: 4,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row buildDataAddRow({
    required String title,
    required String data1,
    required String data2,
    required bool isControllerTextEmpty,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
          ),
        ),
        isControllerTextEmpty
            ? Expanded(
                // flex: 3,
                child: SizedBox(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        data1,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data2,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: backButton(
            context: context,
            image: icArrowLeft,
            onTap: () {
              Navigator.pop(context);
            }),
      ),
      title: Text(
        "Career Info",
        style: styleSatoshiBold(size: 18, color: Colors.black),
      ),
      actions: [
        selectedItemId.isNotEmpty
            ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  careerInfoDeleteApi(id: selectedItemId).then((value) {
                    setState(() {});
                    if (value['status'] == true) {
                      setState(() {
                        loading = false;
                        isLoading ? const Loading() : careerInfo();
                      });

                      // isLoading ? Loading() :careerInfo();
                      // Navigator.push(context, MaterialPageRoute(builder: (builder) =>
                      // const KycWaitScreen()));

                      // ToastUtil.showToast("Login Successful");

                      ToastUtil.showToast("Deleted Successfully");
                      print('done');
                    } else {
                      setState(() {
                        loading = false;
                      });

                      List<dynamic> errors = value['message']['error'];
                      String errorMessage = errors.isNotEmpty
                          ? errors[0]
                          : "An unknown error occurred.";
                      Fluttertoast.showToast(msg: errorMessage);
                    }
                  });
                },
                child: const Icon(Icons.delete))
            : const SizedBox(),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return EditDialogWidget(
                      addTextField: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Career info",
                        style: styleSatoshiBold(size: 18, color: Colors.black),
                      ),
                      sizedBox16(),
                      Row(
                        children: [
                          Expanded(
                            child: buildTextFormField(context,
                                hint: 'company', controller: companyController),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: buildTextFormField(context,
                                hint: 'designation',
                                controller: designationController),
                          ),
                        ],
                      ),
                      sizedBox16(),
                      Row(
                        children: [
                          Expanded(
                            child: buildTextFormField(context,
                                hint: 'start',
                                controller: startingYearController),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: buildTextFormField(context,
                                hint: 'end No',
                                controller: endingYearController,
                                keyboard: TextInputType.number),
                          ),
                        ],
                      ),
                      sizedBox10(),
                      sizedBox16(),
                      loading
                          ? loadingElevatedButton(
                              context: context, color: primaryColor)
                          : elevatedButton(
                              color: primaryColor,
                              context: context,
                              onTap: () {
                                print(positionController);
                                print(fromController);
                                print(endController);
                                print(stateController);
                                print(districtController);
                                // setState(() {
                                //   loading = true;
                                // });
                                // careerInfoAddApi(
                                //         // id: career[0].id.toString(),
                                //         company: companyController.text,
                                //         designation: designationController.text,
                                //         startYear: startingYearController.text,
                                //         endYear: endingYearController.text)
                                //     .then((value) {
                                //   if (value['status'] == true) {
                                //     setState(() {
                                //       loading = false;
                                //     });
                                //
                                //
                                //     ToastUtil.showToast("Updated Successfully");
                                //     print('done');
                                //   } else {
                                //     setState(() {
                                //       loading = false;
                                //     });
                                //
                                //     List<dynamic> errors =
                                //         value['message']['error'];
                                //     String errorMessage = errors.isNotEmpty
                                //         ? errors[0]
                                //         : "An unknown error occurred.";
                                //     Fluttertoast.showToast(msg: errorMessage);
                                //   }
                                // });
                              },
                              title: "Save")
                    ],
                  ));
                });
              },
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }

  TextFormField buildTextFormField(
    BuildContext context, {
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboard,
  }) {
    return TextFormField(
      keyboardType: keyboard ?? TextInputType.name,

      inputFormatters: [
        LengthLimitingTextInputFormatter(40),
      ],
      onChanged: (v) {
        setState(() {});
      },
      onEditingComplete: () {
        Navigator.pop(context); // Close the dialog
      },
      controller: controller,
      decoration: AppTFDecoration(hint: hint).decoration(),
      //keyboardType: TextInputType.phone,
    );
  }
}

// class PositionBottomSheet extends StatelessWidget {
//   const PositionBottomSheet({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return
//
//       Container(
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text("Position",
//               textAlign: TextAlign.left,
//               style: styleSatoshiBold(size: 16, color: Colors.black),),
//           ),
//           const SizedBox(height: 5,),
//           Wrap(
//             spacing: 8.0,
//             children: authControl.positionHeldList!.map((religion) {
//               return ChoiceChip(
//                 selectedColor: color4B164C.withOpacity(0.80),
//                 backgroundColor: Colors.white,
//                 label: Text(
//                   religion.name!,
//                   style: TextStyle(
//                     color: authControl.positionHeldIndex == religion.id
//                         ? Colors.white
//                         : Colors.black.withOpacity(0.80),
//                   ),
//                 ),
//                 selected: authControl.positionHeldIndex == religion.id,
//                 onSelected: (selected) {
//                   if (selected) {
//                     authControl.setPositionIndex(religion.id, true);
//                   }
//                 },
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SelectStateAndDistrict extends StatefulWidget {
  final Function(String) onStatePop;
  final Function(String) onDistrictPop;

  SelectStateAndDistrict(
      {super.key, required this.onStatePop, required this.onDistrictPop});

  @override
  State<SelectStateAndDistrict> createState() => _SelectStateAndDistrictState();
}

class _SelectStateAndDistrictState extends State<SelectStateAndDistrict> {
  @override
  Widget build(BuildContext context) {
    final stateController = TextEditingController();
    final districtController = TextEditingController();

    return GetBuilder<AuthController>(builder: (authControl) {
      return SingleChildScrollView(
        child: Container(
          height: Get.size.height * 0.7,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              sizedBox20(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select State And District Of Posting",
                  textAlign: TextAlign.left,
                  style: styleSatoshiBold(size: 16, color: Colors.black),
                ),
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select State",
                      style: satoshiRegular.copyWith(
                        fontSize: Dimensions.fontSize12,
                      )),
                  const SizedBox(height: 5),
                  // TypeAheadFormField<String>(
                  //   textFieldConfiguration:  TextFieldConfiguration(
                  //     controller: stateController,
                  //     decoration: authDecoration(
                  //         context, "Select State"
                  //     ),
                  //   ),
                  //   suggestionsCallback: (pattern) async {
                  //     return authControl.states.where((state) => state.toLowerCase().contains(pattern.toLowerCase())).toList();
                  //   },
                  //   itemBuilder: (context, suggestion) {
                  //     return ListTile(
                  //       title: Text(suggestion),
                  //     );
                  //   },
                  //   onSuggestionSelected: (String? suggestion) {
                  //     if (suggestion != null) {
                  //       authControl.setState(suggestion);
                  //       stateController.text = suggestion;
                  //       widget.onStatePop(stateController.text);
                  //       // authControl.setstate(stateController.text);
                  //     }
                  //   },
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please Select State';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) => authControl.setState(value!),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select District",
                          style: satoshiRegular.copyWith(
                            fontSize: Dimensions.fontSize12,
                          )),
                      const SizedBox(height: 5),
                      TypeAheadField(
                        builder:
                            (buildContext, textEditingController, focusNode) {
                          return TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please District of Posting';
                              }
                              return null;
                            },
                            controller: districtController,
                            decoration: const InputDecoration(
                              labelText: 'Select District of Posting',
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                        suggestionsCallback: (pattern) async {
                          if (pattern != null) {
                            districtController.text = pattern;
                            authControl.setPPostingDistrict(pattern);
                          }
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSelected: (String value) {
                          authControl.setDistrict(value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
