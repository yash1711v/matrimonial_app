import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/controllers/profile_controller.dart';
import 'package:bureau_couple/getx/features/widgets/custom_dropdown_button_field.dart';
import 'package:bureau_couple/getx/features/widgets/custom_typeahead_field.dart';
import 'package:bureau_couple/getx/features/widgets/edit_details_textfield.dart';
import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/getx/utils/styles.dart';
import 'package:bureau_couple/src/constants/colors.dart';
import 'package:bureau_couple/src/constants/fonts.dart';
import 'package:bureau_couple/src/constants/sizedboxe.dart';
import 'package:bureau_couple/src/utils/widgets/buttons.dart';
import 'package:bureau_couple/src/utils/widgets/customAppbar.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../getx/data/response/profile_model.dart';
import '../../../../getx/utils/app_constants.dart';
import '../../../apis/profile_apis/basic_info_api.dart';
import '../../../apis/profile_apis/get_profile_api.dart';
import '../../../apis/profile_apis/images_apis.dart';
import '../../../constants/assets.dart';
import '../../../constants/string.dart';
import '../../../constants/textstyles.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../models/images_model.dart';
import '../../../models/info_model.dart';
import '../../../utils/widgets/common_widgets.dart';
import '../../../utils/widgets/name_edit_dialog.dart';
import '../../../utils/widgets/textfield_decoration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'edit_photos.dart';
import 'edit_preferred_matches.dart';
import 'our_images_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditBasicInfoScreen extends StatefulWidget {
 final  List<PhotosModel> photos;
   const EditBasicInfoScreen({super.key, required this.photos});

  @override
  State<EditBasicInfoScreen> createState() => _EditBasicInfoScreenState();
}

class _EditBasicInfoScreenState extends State<EditBasicInfoScreen> {
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final professionController = TextEditingController();
  final genderController = TextEditingController();
  final religionController = TextEditingController();
  final smokingController = TextEditingController();
  final drinkingController = TextEditingController();
  final birthDateController = TextEditingController();
  final communityController = TextEditingController();
  final motherTongueController = TextEditingController();
  final marriedStatusController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final financialCondition = TextEditingController();
  final dietTypeController = TextEditingController();
  final aboutUs = TextEditingController();
  final disablityController = TextEditingController();

  final _professionIdController = TextEditingController();
  final _religionIdController = TextEditingController();
  final _casteIdController = TextEditingController();
  final _motherTongueIdController = TextEditingController();
  final _smokingIdController = TextEditingController();
  final _drinkingIdController = TextEditingController();

  bool load = false;
  bool loading = false;
  bool isLoading = false;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      careerInfo();
      // Get.find<ProfileController>().getUserDetailsApi();
      Get.find<AuthController>().getReligionsList();
      Get.find<AuthController>().getCommunityList();
      Get.find<AuthController>().getSmokingList();
      Get.find<AuthController>().getDrinkingList();
      Get.find<AuthController>().getProfessionList();
      Get.find<AuthController>().getMotherTongueList();
      getImage();
    });
    super.initState();
  }

  File pickedImage = File("");
  final ImagePicker _imgPicker = ImagePicker();

  BasicInfo basicInfo = BasicInfo();
  InfoModel mainInfo = InfoModel();
  String profilePic = "";
  careerInfo() {
    isLoading = true;
    var resp = getProfileApi();
    resp.then((value) {
      // physicalData.clear();
      if (value['status'] == true) {
        setState(() {
          var physicalAttributesData = value['data']['user']['basic_info'];
          profilePic = value['data']['user']['profile_image_url'];
          if (physicalAttributesData != null) {
            setState(() {
              basicInfo = BasicInfo.fromJson(physicalAttributesData);
              // fields();
            });
          }
          var info = value['data']['user'];
          if (info != null) {
            setState(() {
              mainInfo = InfoModel.fromJson(info);
              fields();
            });
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
 bool? picAsProfile = false;
  Map<String,dynamic> ImageAsPic = {
    "index":0,
    "image":false
  };
  void fields() {
    firstNameController.text = mainInfo?.firstname.toString() ?? '';
    middleNameController.text = mainInfo?.middlename.toString() ?? '';
    lastNameController.text = mainInfo?.lastname.toString() ?? '';
    userNameController.text = mainInfo?.username.toString() ?? '';
    emailController.text = mainInfo?.email.toString() ?? '';
    professionController.text = basicInfo?.professionName.toString() ?? '';
    genderController.text = basicInfo?.gender?.toString() ?? '';
    religionController.text = basicInfo?.religionName.toString() ?? '';
    smokingController.text = basicInfo?.smokingName.toString() ?? '';
    drinkingController.text = basicInfo?.drinkingName.toString() ?? '';
    birthDateController.text = basicInfo?.birthDate?.toString() ?? '';
    communityController.text = basicInfo?.communityName.toString() ?? '';
    motherTongueController.text = basicInfo?.motherTongueName.toString() ?? '';
    marriedStatusController.text = (basicInfo?.maritalStatus == "1"?"Married":"Single")?.toString() ?? '';
    stateController.text = basicInfo?.presentAddress?.state?.toString() ?? '';
    zipController.text = basicInfo?.presentAddress?.zip?.toString() ?? '';
    countryController.text = basicInfo?.presentAddress?.country?.toString() ?? '';
    // cityController.text = basicInfo?.presentAddress?.district?.toString() ?? '';
    financialCondition.text = basicInfo?.financialCondition?.toString() ?? '';
    aboutUs.text = basicInfo?.aboutUs?.toString() ?? '';
    _professionIdController.text = basicInfo?.profession  ?? '';
    _religionIdController.text =   Get.find<ProfileController>().profile?.religion ?? '';
    _casteIdController.text = basicInfo?.community ?? '';
    _motherTongueIdController.text = basicInfo.motherTongue ?? '';
    _smokingIdController.text = basicInfo.smokingStatus.toString() ?? '';
    _drinkingIdController.text = basicInfo.drinkingStatus.toString() ?? '';
    dietTypeController.text = basicInfo.diet.toString() ?? '';
    disablityController.text = basicInfo.disability.toString() ?? '';
   Get.find<AuthController>().getCasteList(Get.find<ProfileController>().profile?.religion);

  }

  List<PhotosModel> photos = [];

  void getImage() {
    setState(() {
      isLoading = true;
    });

    var resp = getImagesApi();
    resp.then((value) {
      if (!mounted) return; // Check if the widget is still in the tree
      setState(() {
        isLoading = false;
        photos.clear();
        if (value['status'] == true) {
          List<dynamic> data = value['data'];
          for (var obj in data) {
            List<dynamic> galleries = obj['galleries'];
            for (var gallery in galleries) {
              photos.add(PhotosModel.fromJson(gallery));
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authControl) {
      print('print  ============================= >>${Get.find<AuthController>().professionId.toString()}');

      return  Scaffold(
        appBar: const CustomAppBar(title: "Basic Info",),
        bottomNavigationBar: buildBottombarPadding(context,authControl),
        body: isLoading
            ? const BasicInfoShimmerWidget()
            : SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft,
                    child: Text("Basic Info",style:styleSatoshiMedium(size: 16, color: primaryColor))),
                sizedBox16(),
                GestureDetector(
                  onTap: () async {
                    XFile? v = await _imgPicker.pickImage(source: ImageSource.gallery);
                    if (v != null) {
                      setState(
                            () {
                          pickedImage = File(v.path);
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 104,
                    width: 104,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: pickedImage.path.isEmpty
                        ? Image.network(
                      profilePic,
                    )
                        : Image.file(
                      pickedImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                sizedBox16(),
                load
                    ? loadingElevatedButton(
                    color: Colors.green,
                    height: 30,
                    width: 80,
                    context: context)
                    : elevatedButton(
                    color: Colors.green,
                    height: 30,
                    style: styleSatoshiLight(
                        size: 10, color: Colors.white),
                    width: 80,
                    context: context,
                    onTap: () {
                      if (pickedImage.path.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Pick Image First");
                      } else {
                        setState(() {
                          load = true;
                        });
                        addProfileImageAPi(photo: pickedImage.path
                          // id: career[0].id.toString(),
                        )
                            .then((value) {
                          if (value['status'] == true) {
                            setState(() {
                              load = false;
                            });
                            ToastUtil.showToast(
                                "Image Updated Successfully");
                          } else {
                            setState(() {
                              loading = false;
                            });

                            List<dynamic> errors =
                            value['message']['error'];
                            String errorMessage = errors.isNotEmpty
                                ? errors[0]
                                : "An unknown error occurred.";
                            Fluttertoast.showToast(msg: errorMessage);
                          }
                        });
                      }
                    },
                    title: "Add"),

                SizedBox(height: 25,),
                Container(
                  width: double.infinity,
                  height: photos.length>3?325:200,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Photos',
                              style: kManrope25Black.copyWith(
                                  fontSize: Dimensions.fontSize18,
                                  color: Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.65)),
                            ),
                            customContainer(
                                vertical: 5,
                                horizontal: 10,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(ic4Dots),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    const Text("See All")
                                  ],
                                ),
                                radius: 8,
                                color: Colors.white,
                                click: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                          const OurImagesScreen()));
                                }),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                        const EditPhotosScreen()));
                              },
                              child: Icon(
                                Icons.edit,
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.65),
                              ),
                            ),
                          ],
                        ),
                        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Photos',
                        //       style: kManrope25Black.copyWith(fontSize: Dimensions.fontSize18,color: Theme.of(context).primaryColorDark.withOpacity(0.65)),
                        //     ),
                        //     IconButton(onPressed: () {
                        //         Navigator.push(context, MaterialPageRoute(
                        //             builder: (builder) => const EditPhotosScreen()));
                        //     }, icon: Icon(Icons.edit,
                        //     color: Theme.of(context).primaryColorDark.withOpacity(0.65),))
                        //   ],
                        // ),

                        // GestureDetector(onTap: () {
                        //   Navigator.push(context, MaterialPageRoute(
                        //       builder: (builder) => const EditPhotosScreen()));
                        //
                        // },
                        //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text("photos",style:styleSatoshiMedium(size: 16, color: primaryColor)),
                        //       Image.asset(icEdit,height: 20,width: 20,),
                        //     ],
                        //   ),
                        // ),
                        sizedBox16(),
                        photos.isEmpty || photos == null
                            ? Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                        const EditPhotosScreen()));
                              },
                              child: const DottedPlaceHolder(
                                text: 'Add Photos',
                              ),
                            ))
                            : Stack(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              itemCount: photos.length,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (_, i) {
                                return GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      picAsProfile = true;
                                      ImageAsPic['index'] = i;
                                      ImageAsPic['image'] = true;
                                    });
                                  },
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhotoViewScreen(
                                              imageProvider: NetworkImage(
                                                photos[i].image != null
                                                    ? '$baseGalleryImage${photos[i].image}'
                                                    : '',
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                  behavior:
                                  HitTestBehavior.translucent,
                                  child: Container(
                                    height: 220,
                                    width: 130,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          width: 130,
                                          height: 220,
                                          imageUrl: photos[i].image !=
                                              null
                                              ? '$baseGalleryImage${photos[i].image}'
                                              : '',
                                          fit: BoxFit.cover,
                                          errorWidget:
                                              (context, url, error) =>
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  icLogo,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                          progressIndicatorBuilder:
                                              (a, b, c) => customShimmer(
                                            height: 0, /*width: 0,*/
                                          ),
                                        ),
                                        Visibility(
                                          visible: ImageAsPic['image'] &&
                                              ImageAsPic['index'] == i,
                                          child: Container(
                                            height: 220,
                                            width: 130,
                                            color: Colors.black
                                                .withOpacity(0.5),
                                            child: Center(
                                              child: Text(
                                                "Selected",
                                                style: styleSatoshiRegular(
                                                    size: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Visibility(
                              visible: picAsProfile!,
                              child: Positioned(
                                top: MediaQuery.of(context).size.height *
                                    0.2,
                                bottom: 10,
                                right: 10,
                                child: Row(
                                  children: [
                                    elevatedButton(
                                        color: Colors.green,
                                        height: 60,
                                        style: styleSatoshiLight(
                                            size: 14, color: Colors.white),
                                        width: 100,
                                        context: context,
                                        onTap: () {
                                          debugPrint("Make it Profile:'$baseGalleryImage${photos[ImageAsPic['index']].image!}'");
                                          setState(() {
                                            profilePic = '$baseGalleryImage${photos[ImageAsPic['index']].image!}';
                                            ImageAsPic['image'] = false;
                                            picAsProfile = false;
                                          });
                                        },
                                        title: "Make it Profile"),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NameEditDialogWidget(
                          title: 'Introduction',
                          addTextField: TextFormField(
                            maxLength: 500,
                            onChanged: (v) {
                              setState(() {});
                            },
                            onEditingComplete: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            controller: aboutUs,
                            decoration: AppTFDecoration(hint: 'Introduction')
                                .decoration(),
                            //keyboardType: TextInputType.phone,
                          ),
                        );
                      },
                    );

                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditDetailsTextField(title: 'About', controller: aboutUs,),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "About",style: styleSatoshiRegular(size: 14, color: color5E5E5E),
                      //     ),
                      //     const SizedBox(width: 3,),
                      //     const Icon(
                      //       Icons.edit,
                      //       size: 12,
                      //     ),
                      //   ],
                      // ),
                      // aboutUs.text.isEmpty?
                      // const SizedBox() :
                      // Column(
                      //   children: [
                      //     sizedBox16(),
                      //
                      //     Text(
                      //       aboutUs.text.isEmpty
                      //           ? (basicInfo.id == null ||
                      //           basicInfo.aboutUs == null ||
                      //           basicInfo.aboutUs!.isEmpty
                      //           ? ''
                      //           : basicInfo.aboutUs!)
                      //           : aboutUs.text,
                      //       maxLines: 4,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //
                      //   ],
                      // )


                    ],
                  ),
                ),
                sizedBox6(),
                EditDetailsTextField(title: 'First Name', controller: firstNameController,),
                sizedBox6(),
                EditDetailsTextField(title: 'Last Name', controller: lastNameController,),
                sizedBox6(),
                EditDetailsTextField(isNonEditable: true,
                  title: 'User Name', controller: userNameController,
                readOnly: true,),
                sizedBox6(),
                EditDetailsTextField(isNonEditable: true,
                  title: 'Email', controller: emailController, readOnly: true,),
                sizedBox6(),
                EditDetailsTextField(
                  onTap: () {
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

                                    professionController.text = selected.name.toString();
                                    _professionIdController.text = selected.id.toString();

                                  }
                                },

                              ),
                            ],
                          ),),
                      ),
                    );
                  },readOnly:  true,

                  title: 'profession', controller: professionController,),
                sizedBox6(),
                EditDetailsTextField(isNonEditable: true,
                  title: 'Gender', controller: genderController,readOnly: true,),
                sizedBox6(),
                EditDetailsTextField(
                  title: 'Religion', controller: religionController,readOnly: true,
                  onTap:() {
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                'Religion',
                                style: kManrope25Black.copyWith(fontSize: 16),
                              ),
                              sizedBox12(),
                              CustomDropdownButtonFormField<String>(
                                value: authControl.religionList!.firstWhere((religion) => religion.id == authControl.religionMainIndex).name,// Assuming you have a selectedPosition variable
                                items: authControl.religionList!.map((position) => position.name!).toList(),
                                hintText: "Select Religion",
                                onChanged: (String? value) {
                                  if (value != null) {
                                    var selected = authControl.religionList!.firstWhere((position) => position.name == value);
                                    authControl.setReligionMainIndex(selected.id, true);
                                    religionController.text = selected.name.toString();
                                    _religionIdController.text = selected.id.toString();
                                    authControl.getCasteList(selected.id.toString());

                                  }
                                },

                              ),
                            ],
                          ),),
                      ),
                    );
                  },
                ),
                sizedBox6(),
                EditDetailsTextField(title: 'Smoking Habit', controller: smokingController,readOnly: true,
                onTap: () {
                  Get.bottomSheet(
                    SingleChildScrollView(
                      child: Container(color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Column(
                          children: [
                            Text(
                              'Smoking Habit',
                              style: kManrope25Black.copyWith(fontSize: 16),
                            ),
                            sizedBox12(),
                            CustomDropdownButtonFormField<String>(
                              value: authControl.smokingList!.firstWhere((religion) => religion.id == authControl.smokingIndex).name,// Assuming you have a selectedPosition variable
                              items: authControl.smokingList!.map((position) => position.name!).toList(),
                              hintText: "Smoking Habit",
                              onChanged: (String? value) {
                                if (value != null) {
                                  var selected = authControl.smokingList!.firstWhere((position) => position.name == value);
                                  authControl.setSmokingIndex(selected.id!,true);
                                  smokingController.text = selected.name.toString();
                                  _smokingIdController.text = selected.id.toString();

                                }
                              },

                            ),
                          ],
                        ),),
                    ),
                  );
                },),
                sizedBox6(),
                EditDetailsTextField(title: 'Drinking Habit', controller: drinkingController,readOnly: true,
                  onTap: () {
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                'Drinking Habit',
                                style: kManrope25Black.copyWith(fontSize: 16),
                              ),
                              sizedBox12(),
                              CustomDropdownButtonFormField<String>(
                                value: authControl.drikingList!.firstWhere((religion) => religion.id == authControl.drikingIndex).name,// Assuming you have a selectedPosition variable
                                items: authControl.drikingList!.map((position) => position.name!).toList(),
                                hintText: "Drinking Habit",
                                onChanged: (String? value) {
                                  if (value != null) {
                                    var selected = authControl.drikingList!.firstWhere((position) => position.name == value);
                                    authControl.setDrikingIndex(selected.id!,true);
                                    drinkingController.text = selected.name.toString();
                                    _drinkingIdController.text = selected.id.toString();

                                  }
                                },

                              ),
                            ],
                          ),),
                      ),
                    );
                  },),
                sizedBox6(),
                EditDetailsTextField(title: 'Drinking Habit', controller: drinkingController,readOnly: true,
                  onTap: () {
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                'Drinking Habit',
                                style: kManrope25Black.copyWith(fontSize: 16),
                              ),
                              sizedBox12(),
                              CustomDropdownButtonFormField<String>(
                                value: authControl.drikingList!.firstWhere((religion) => religion.id == authControl.drikingIndex).name,// Assuming you have a selectedPosition variable
                                items: authControl.drikingList!.map((position) => position.name!).toList(),
                                hintText: "Drinking Habit",
                                onChanged: (String? value) {
                                  if (value != null) {
                                    var selected = authControl.drikingList!.firstWhere((position) => position.name == value);
                                    authControl.setDrikingIndex(selected.id!,true);
                                    drinkingController.text = selected.name.toString();
                                    _drinkingIdController.text = selected.id.toString();

                                  }
                                },

                              ),
                            ],
                          ),),
                      ),
                    );
                  },),
                sizedBox6(),
                EditDetailsTextField(title: 'DOB', controller: birthDateController,readOnly: true,isNonEditable: true,),
                sizedBox6(),
                EditDetailsTextField(title: 'Caste', controller: communityController,readOnly: true,
                  onTap: () {
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                'Community',
                                style: kManrope25Black.copyWith(fontSize: 16),
                              ),
                              sizedBox12(),
                              CustomDropdownButtonFormField<String>(
                                value: authControl.casteList!.firstWhere((religion) => religion.id == authControl.casteMainIndex).name,// Assuming you have a selectedPosition variable
                                items: authControl.casteList!.map((position) => position.name!).toList(),
                                hintText: "Select Community",
                                onChanged: (String? value) {
                                  if (value != null) {
                                    var selected = authControl.casteList!.firstWhere((position) => position.name == value);
                                    authControl.setCasteMainIndex(selected.id, true);
                                    communityController.text = selected.name.toString();
                                    _casteIdController.text = selected.id.toString();

                                  }
                                },

                              ),
                            ],
                          ),),
                      ),
                    );
                  },),
                sizedBox6(),
                EditDetailsTextField(title: 'Diet', controller: dietTypeController,readOnly: true,
                  onTap: () {
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                'Diet',
                                style: kManrope25Black.copyWith(fontSize: Dimensions.fontSize18),
                              ),
                              sizedBox12(),
                              CustomDropdownButtonFormField<String>(
                                value: authControl.diet ,
                                items: authControl.dietList,
                                hintText: "Select Diet Type",
                                onChanged: (value) {
                                  authControl.setDiet(value!);
                                  print(authControl.diet);
                                  dietTypeController.text = authControl.diet!;
                                },

                              ),
                            ],
                          ),),
                      ),
                    );
                  },),
                sizedBox6(),
                Visibility(
                  visible: financialCondition.text.isNotEmpty,
                  child: EditDetailsTextField(title: 'Annual Income', controller: financialCondition,readOnly: true,
                    onTap: () {
                      Get.bottomSheet(
                        SingleChildScrollView(
                          child: Container(color: Theme.of(context).cardColor,
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Column(
                              children: [
                                Text(
                                  'Annual Income',
                                  style: kManrope25Black.copyWith(fontSize: 16),
                                ),
                                sizedBox12(),
                                CustomDropdownButtonFormField<String>(
                                  value:  authControl.annualIncome ?? authControl.annualIncomeList.first,// Assuming you have a selectedPosition variable
                                  items: authControl.annualIncomeList,
                                  hintText: "Select Annual Income",
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      authControl.setAnnualIncome(value);
                                      financialCondition.text = value;
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
                              ],
                            ),),
                        ),
                      );
                    },),
                ),
                sizedBox6(),
                EditDetailsTextField(title: 'Mother Tongue', controller: motherTongueController,readOnly: true,
                  onTap: () {
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                'Mother Tongue',
                                style: kManrope25Black.copyWith(fontSize: 16),
                              ),
                              sizedBox12(),
                              CustomDropdownButtonFormField<String>(
                                value: authControl.motherTongueList!.firstWhere((religion) => religion.id == authControl.motherTongueIndex).name,// Assuming you have a selectedPosition variable
                                items: authControl.motherTongueList!.map((position) => position.name!).toList(),
                                hintText: "Mother Tongue",
                                onChanged: (String? value) {
                                  if (value != null) {
                                    var selected = authControl.motherTongueList!.firstWhere((position) => position.name == value);
                                    authControl.setMotherTongueIndex(selected.id, true);
                                    motherTongueController.text = selected.name.toString();
                                    _motherTongueIdController.text = selected.id.toString();
                                    authControl.getCasteList(selected.id.toString());

                                  }
                                },

                              ),
                            ],
                          ),),
                      ),
                    );
                  },),
                sizedBox6(),
                EditDetailsTextField(title: 'State', controller: stateController,readOnly: true,
                  onTap: () {
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                'State',
                                style: kManrope25Black.copyWith(fontSize: 16),
                              ),
                              sizedBox12(),
                              CustomDropdownButtonFormField<String>(
                                value: authControl.selectedState,
                                items: authControl.states,
                                hintText: "Select State/UT",
                                onChanged: (String? value) {
                                  if (value != null) {
                                    authControl.setState(value);
                                    stateController.text = value;
                                    print(authControl.selectedState);
                                  }
                                },
                              ),
                            ],
                          ),),
                      ),
                    );
                  },),
                sizedBox6(),
                EditDetailsTextField(title: 'Disability', controller: disablityController,readOnly: false,
                  onTap: () {
                  },),
                sizedBox6(),
                EditDetailsTextField(title: 'Married Status', controller: marriedStatusController,readOnly: false,
                  onTap: () {
                  },),

                // sizedBox6(),
                // EditDetailsTextField(title: 'About', controller: aboutUs,),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return NameEditDialogWidget(
                //           title: 'First Name',
                //           addTextField: TextFormField(
                //             maxLength: 40,
                //             onChanged: (v) {
                //               setState(() {});
                //             },
                //             onEditingComplete: () {
                //               Navigator.pop(context); // Close the dialog
                //             },
                //             controller: firstNameController,
                //             decoration: AppTFDecoration(hint: 'First Name')
                //                 .decoration(),
                //             //keyboardType: TextInputType.phone,
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: buildDataAddRow(
                //     widget: const Icon(
                //       Icons.edit,
                //       size: 12,
                //     ),
                //     // widget: const Icon(
                //     //   Icons.edit,
                //     //   size: 12,
                //     // ),
                //     title: 'First Name',
                //     data1: firstNameController.text.isEmpty
                //         ? (mainInfo == null ||
                //         mainInfo.firstname == null ||
                //         mainInfo.firstname!.isEmpty
                //         ? 'Not Added'
                //         : StringUtils.capitalize(mainInfo.firstname!))
                //         : firstNameController.text,
                //     data2: StringUtils.capitalize(firstNameController.text),
                //     isControllerTextEmpty: firstNameController.text.isEmpty,
                //   ),
                // ),
                // sizedBox6(),
                // const Divider(),
            // mainInfo == null ||
            //     mainInfo.middlename == null ||
            //     mainInfo.middlename!.isEmpty
            //     ? SizedBox() :
            // Column(
            //       children: [
            //         // mainInfo != null &&
            //         //     (mainInfo.middlename == null || mainInfo.middlename!.isEmpty) &&
            //         //     middleNameController.text.isEmpty
            //         //     ? const SizedBox()
            //         //     : Column(
            //         //   children: [
            //         //     buildDataAddRow(
            //         //       widget: const SizedBox(),
            //         //       // widget: const Icon(
            //         //       //   Icons.edit,
            //         //       //   size: 12,
            //         //       // ),
            //         //       title: 'Middle Name',
            //         //       data1: middleNameController.text.isEmpty
            //         //           ? (mainInfo == null ||
            //         //           mainInfo.middlename == null ||
            //         //           mainInfo.middlename!.isEmpty
            //         //           ? 'Not Added'
            //         //           : StringUtils.capitalize(mainInfo.middlename!))
            //         //           : StringUtils.capitalize(middleNameController.text),
            //         //       data2: StringUtils.capitalize(middleNameController.text),
            //         //       isControllerTextEmpty: middleNameController.text.isEmpty,
            //         //     ),
            //         //     const Divider(),
            //         //   ],
            //         // ),
            //
            //       ],
            //     ),
            //     sizedBox6(),
            //     GestureDetector(
            //       behavior: HitTestBehavior.translucent,
            //       onTap: () {
            //         showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return NameEditDialogWidget(
            //               title: 'Last Name',
            //               addTextField: TextFormField(
            //                 maxLength: 40,
            //                 onChanged: (v) {
            //                   setState(() {});
            //                 },
            //                 onEditingComplete: () {
            //                   Navigator.pop(context);
            //                 },
            //                 controller: lastNameController,
            //                 decoration: AppTFDecoration(hint: 'Last Name')
            //                     .decoration(),
            //                 //keyboardType: TextInputType.phone,
            //               ),
            //             );
            //           },
            //         );
            //       },
            //       child: buildDataAddRow(
            //         widget: const Icon(
            //           Icons.edit,
            //           size: 12,
            //         ),
            //         title: 'Last Name',
            //         data1: lastNameController.text.isEmpty
            //             ? (mainInfo == null ||
            //             mainInfo.lastname == null ||
            //             mainInfo.lastname!.isEmpty
            //             ? 'Not Added'
            //             : StringUtils.capitalize(mainInfo.lastname!))
            //             : StringUtils.capitalize(lastNameController.text),
            //         data2: StringUtils.capitalize(lastNameController.text),
            //         isControllerTextEmpty: lastNameController.text.isEmpty,
            //       ),
            //     ),
            //     sizedBox6(),
            //     const Divider(),
            //     sizedBox6(),
            //     GestureDetector(
            //       behavior: HitTestBehavior.translucent,
            //       onTap: () {
            //         // showDialog(
            //         //   context: context,
            //         //   builder: (BuildContext context) {
            //         //     return NameEditDialogWidget(
            //         //       title: 'User Name',
            //         //       addTextField: TextFormField(
            //         //         maxLength: 40,
            //         //         onChanged: (v) {
            //         //           setState(() {});
            //         //         },
            //         //         onEditingComplete: () {
            //         //           Navigator.pop(context); // Close the dialog
            //         //         },
            //         //         controller: userNameController,
            //         //         decoration: AppTFDecoration(hint: 'User Name')
            //         //             .decoration(),
            //         //         //keyboardType: TextInputType.phone,
            //         //       ),
            //         //     );
            //         //   },
            //         // );
            //       },
            //       child: buildDataAddRow(
            //         widget: const SizedBox(),
            //         // widget: const Icon(
            //         //   Icons.edit,
            //         //   size: 12,
            //         // ),
            //         title: 'User Name',
            //         data1: userNameController.text.isEmpty
            //             ? (mainInfo == null ||
            //             mainInfo.username == null ||
            //             mainInfo.username!.isEmpty
            //             ? 'User Name'
            //             : mainInfo.username!)
            //             : userNameController.text,
            //         data2: userNameController.text,
            //         isControllerTextEmpty: userNameController.text.isEmpty,
            //       ),
            //     ),
            //     sizedBox6(),
            //     const Divider(),
            //     sizedBox6(),
            //     GestureDetector(
            //       behavior: HitTestBehavior.translucent,
            //       onTap: () {
            //         // Get.dialog(NameEditDialogWidget(
            //         //   title: 'Email',
            //         //   addTextField: TextFormField(
            //         //     maxLength: 40,
            //         //     onChanged: (v) {
            //         //       setState(() {});
            //         //     },
            //         //     onEditingComplete: () {
            //         //       Navigator.pop(context); // Close the dialog
            //         //     },
            //         //     controller: emailController,
            //         //     decoration: AppTFDecoration(hint: 'Email')
            //         //         .decoration(),
            //         //     //keyboardType: TextInputType.phone,
            //         //   ),
            //         // ));
            //       },
            //       child: buildDataAddRow(
            //         widget: const SizedBox(),
            //         // widget: const Icon(
            //         //   Icons.edit,
            //         //   size: 12,
            //         // ),
            //         title: 'Email ',
            //         data1: emailController.text.isEmpty
            //             ? (mainInfo == null ||
            //             mainInfo.username == null ||
            //             mainInfo.username!.isEmpty
            //             ? 'Email'
            //             : mainInfo.username!)
            //             : emailController.text,
            //         data2: emailController.text,
            //         isControllerTextEmpty: emailController.text.isEmpty,
            //       ),
            //     ),
            //     sizedBox6(),
            //     const Divider(),
            //     sizedBox6(),
            //     GestureDetector(
            //       behavior: HitTestBehavior.translucent,
            //       onTap: () {
            //         Get.bottomSheet(
            //           SingleChildScrollView(
            //             child: Container(color: Theme.of(context).cardColor,
            //               padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            //               child: Column(
            //               children: [
            //                 Text(
            //                   'Profession',
            //                   style: kManrope25Black.copyWith(fontSize: 16),
            //                 ),
            //                 sizedBox12(),
            //                 CustomDropdownButtonFormField<String>(
            //                   value: authControl.professionList!.firstWhere((religion) => religion.id == authControl.professionIndex).name,// Assuming you have a selectedPosition variable
            //                   items: authControl.professionList!.map((position) => position.name!).toList(),
            //                   hintText: "Select Position",
            //                   onChanged: (String? value) {
            //                     if (value != null) {
            //                       var selected = authControl.professionList!.firstWhere((position) => position.name == value);
            //                       authControl.setProfessionIndex(selected.id, true);
            //
            //                       professionController.text = selected.name.toString();
            //                       _professionIdController.text = selected.id.toString();
            //
            //                     }
            //                   },
            //
            //                 ),
            //               ],
            //             ),),
            //           ),
            //        );
            //         // showDialog(
            //         //   context: context,
            //         //   builder: (BuildContext context) {
            //         //     return NameEditDialogWidget(
            //         //       title: 'Profession',
            //         //       addTextField: TextFormField(
            //         //         maxLength: 40,
            //         //         onChanged: (v) {
            //         //           setState(() {});
            //         //         },
            //         //         onEditingComplete: () {
            //         //           Navigator.pop(context); // Close the dialog
            //         //         },
            //         //         controller: professionController,
            //         //         decoration: AppTFDecoration(hint: 'Profession')
            //         //             .decoration(),
            //         //         //keyboardType: TextInputType.phone,
            //         //       ),
            //         //     );
            //         //   },
            //         // );
            //       },
            //       child: buildDataAddRow(
            //         // widget: const SizedBox(),
            //         widget: const Icon(
            //           Icons.edit,
            //           size: 12,
            //         ),
            //         title: 'Profession',
            //         data1:
            //         professionController.text.isEmpty
            //             ? (basicInfo.id == null ||
            //             basicInfo.profession == null ||
            //             basicInfo.professionName!.isEmpty
            //             ? 'Not Added'
            //             : basicInfo.professionName.toString() )
            //             : professionController.text,
            //
            //         data2:
            //         StringUtils.capitalize(professionController.text),
            //         isControllerTextEmpty:
            //         professionController.text.isEmpty,
            //       ),
            //       // child: CarRowWidget(favourites: favourites!,)
            //     ),
            //     sizedBox6(),
            //     const Divider(),
            //     sizedBox6(),
            //     GestureDetector(
            //       behavior: HitTestBehavior.translucent,
            //       onTap: () {},
            //       child: buildDataAddRow(
            //         widget: const SizedBox(),
            //         title: 'Gender',
            //         data1: genderController.text.isEmpty
            //             ? (basicInfo.id == null ||
            //             basicInfo.gender == null ||
            //             basicInfo.gender!.isEmpty
            //             ? 'Not Added'
            //             : basicInfo.gender.toString())
            //             : genderController.text,
            //         data2: StringUtils.capitalize(genderController.text.contains("F") ? "Female" :"Male"),
            //         isControllerTextEmpty: genderController.text.isEmpty,
            //       ),
            //       // child: CarRowWidget(favourites: favourites!,)
            //     ),
            //     sizedBox6(),
            //     const Divider(),
            //     sizedBox6(),
            //     GestureDetector(
            //       behavior: HitTestBehavior.translucent,
            //       onTap: () {
            //         Get.bottomSheet(
            //           SingleChildScrollView(
            //             child: Container(color: Theme.of(context).cardColor,
            //               padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            //               child: Column(
            //                 children: [
            //                   Text(
            //                     'Religion',
            //                     style: kManrope25Black.copyWith(fontSize: 16),
            //                   ),
            //                   sizedBox12(),
            //                   CustomDropdownButtonFormField<String>(
            //                     value: authControl.religionList!.firstWhere((religion) => religion.id == authControl.religionMainIndex).name,// Assuming you have a selectedPosition variable
            //                     items: authControl.religionList!.map((position) => position.name!).toList(),
            //                     hintText: "Select Religion",
            //                     onChanged: (String? value) {
            //                       if (value != null) {
            //                         var selected = authControl.religionList!.firstWhere((position) => position.name == value);
            //                         authControl.setReligionMainIndex(selected.id, true);
            //                         religionController.text = selected.name.toString();
            //                         _religionIdController.text = selected.id.toString();
            //                         authControl.getCasteList(selected.id.toString());
            //
            //                       }
            //                     },
            //
            //                   ),
            //                 ],
            //               ),),
            //           ),
            //         );
            //
            //
            //       },
            //       child: buildDataAddRow(
            //         widget: const Icon(
            //           Icons.edit,
            //           size: 12,
            //         ),
            //         title: 'Religion',
            //         data1: religionController.text.isEmpty
            //             ? (basicInfo.id == null ||
            //             basicInfo.religion == null ||
            //             basicInfo.religionName!.isEmpty
            //             ? 'Not Added'
            //             : basicInfo.religion.toString())
            //             : religionController.text,
            //         data2: religionController.text,
            //         isControllerTextEmpty: religionController.text.isEmpty,
            //       ),
            //       // child: CarRowWidget(favourites: favourites!,)
            //     ),
            //     sizedBox16(),
            //     const Divider(),
            //     GestureDetector(
            //       behavior: HitTestBehavior.translucent,
            //       onTap: () {},
            //       child: buildDataAddRow(
            //         widget: const SizedBox(),
            //         title: 'Married Status',
            //         data1: marriedStatusController.text.isEmpty
            //             ? (basicInfo.id == null ||
            //             basicInfo.maritalStatus == null ||
            //             basicInfo.maritalStatus!.isEmpty
            //             ? 'Not Added'
            //             : basicInfo.maritalStatus.toString())
            //             : marriedStatusController.text,
            //         data2: StringUtils.capitalize(
            //             marriedStatusController.text),
            //         isControllerTextEmpty:
            //         marriedStatusController.text.isEmpty,
            //       ),
            //     ),
                // sizedBox16(),
                // sizedBox6(),
                // const Divider(),
                // sizedBox6(),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     Get.bottomSheet(
                //       SingleChildScrollView(
                //         child: Container(color: Theme.of(context).cardColor,
                //           padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                //           child: Column(
                //             children: [
                //               Text(
                //                 'Smoking Habit',
                //                 style: kManrope25Black.copyWith(fontSize: 16),
                //               ),
                //               sizedBox12(),
                //               CustomDropdownButtonFormField<String>(
                //                 value: authControl.smokingList!.firstWhere((religion) => religion.id == authControl.smokingIndex).name,// Assuming you have a selectedPosition variable
                //                 items: authControl.smokingList!.map((position) => position.name!).toList(),
                //                 hintText: "Smoking Habit",
                //                 onChanged: (String? value) {
                //                   if (value != null) {
                //                     var selected = authControl.smokingList!.firstWhere((position) => position.name == value);
                //                     authControl.setSmokingIndex(selected.id!,true);
                //                     smokingController.text = selected.name.toString();
                //                     _smokingIdController.text = selected.id.toString();
                //
                //                   }
                //                 },
                //
                //               ),
                //             ],
                //           ),),
                //       ),
                //     );
                //   },
                //   child: buildDataAddRow(
                //     title: 'Smoking Habit',
                //     widget: const Icon(
                //       Icons.edit,
                //       size: 12,
                //     ),
                //     data1: smokingController.text.isEmpty
                //         ? (basicInfo.id == null ||
                //         basicInfo.smokingName == null
                //         ? 'Not Added'
                //         : basicInfo.smokingName.toString())
                //         : smokingController.text,
                //     data2: smokingController.text,
                //     isControllerTextEmpty: smokingController.text.isEmpty,
                //   ),
                // ),
                // sizedBox6(),
                // const Divider(),
                // sizedBox6(),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     Get.bottomSheet(
                //       SingleChildScrollView(
                //         child: Container(color: Theme.of(context).cardColor,
                //           padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                //           child: Column(
                //             children: [
                //               Text(
                //                 'Smoking Habit',
                //                 style: kManrope25Black.copyWith(fontSize: 16),
                //               ),
                //               sizedBox12(),
                //               CustomDropdownButtonFormField<String>(
                //                 value: authControl.drikingList!.firstWhere((religion) => religion.id == authControl.drikingIndex).name,// Assuming you have a selectedPosition variable
                //                 items: authControl.drikingList!.map((position) => position.name!).toList(),
                //                 hintText: "Mother Tongue",
                //                 onChanged: (String? value) {
                //                   if (value != null) {
                //                     var selected = authControl.drikingList!.firstWhere((position) => position.name == value);
                //                     authControl.setDrikingIndex(selected.id!,true);
                //                     drinkingController.text = selected.name.toString();
                //                     _drinkingIdController.text = selected.id.toString();
                //
                //                   }
                //                 },
                //
                //               ),
                //             ],
                //           ),),
                //       ),
                //     );
                //   },
                //   child: buildDataAddRow(
                //     title: 'Drinking Habit',
                //     widget: const Icon(
                //       Icons.edit,
                //       size: 12,
                //     ),
                //     data1: drinkingController.text.isEmpty
                //         ? (basicInfo.id == null ||
                //         basicInfo.drinkingName == null
                //         ? 'Not Added'
                //         : basicInfo.drinkingName.toString())
                //         : drinkingController.text,
                //     data2: drinkingController.text,
                //     isControllerTextEmpty: drinkingController.text.isEmpty,
                //   ),
                //   // child: CarRowWidget(drinkingController)
                // ),
                // sizedBox6(),
                // const Divider(),
                // sizedBox6(),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {},
                //   child: buildDataAddRow(
                //     widget: const SizedBox(),
                //     title: 'Birth date',
                //     data1: birthDateController.text.isEmpty
                //         ? (basicInfo.id == null ||
                //         basicInfo.birthDate == null ||
                //         basicInfo.birthDate!.isEmpty
                //         ? 'Not Added'
                //         : basicInfo.birthDate!.toString())
                //         : birthDateController.text,
                //     data2: birthDateController.text,
                //     isControllerTextEmpty: birthDateController.text.isEmpty,
                //   ),
                // ),
                // sizedBox6(),
                // const Divider(),
                // sizedBox6(),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     Get.bottomSheet(
                //       SingleChildScrollView(
                //         child: Container(color: Theme.of(context).cardColor,
                //           padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                //           child: Column(
                //             children: [
                //               Text(
                //                 'Caste',
                //                 style: kManrope25Black.copyWith(fontSize: 16),
                //               ),
                //               sizedBox12(),
                //               CustomDropdownButtonFormField<String>(
                //                 value: authControl.casteList!.firstWhere((religion) => religion.id == authControl.casteMainIndex).name,// Assuming you have a selectedPosition variable
                //                 items: authControl.casteList!.map((position) => position.name!).toList(),
                //                 hintText: "Select Caste",
                //                 onChanged: (String? value) {
                //                   if (value != null) {
                //                     var selected = authControl.casteList!.firstWhere((position) => position.name == value);
                //                     authControl.setCasteMainIndex(selected.id, true);
                //                     communityController.text = selected.name.toString();
                //                     _casteIdController.text = selected.id.toString();
                //
                //                   }
                //                 },
                //
                //               ),
                //             ],
                //           ),),
                //       ),
                //     );
                //     // showModalBottomSheet(
                //     //   context: context,
                //     //   builder: (BuildContext context) {
                //     //     return CommuitySheet(
                //     //       privacyStatus: '',
                //     //       onPop: (val) {
                //     //         communityController.text = val;
                //     //         print(communityController.text);
                //     //       },
                //     //     );
                //     //   },
                //     // );
                //   },
                //   child: buildDataAddRow(
                //     title: 'Caste',
                //     // widget: const SizedBox(),
                //     widget: const Icon(
                //       Icons.edit,
                //       size: 12,
                //     ),
                //     data1: communityController.text.isEmpty
                //         ? (basicInfo.id == null ||
                //         basicInfo.community == null ||
                //         basicInfo.communityName == null
                //         ? 'Not Added'
                //         : basicInfo.communityName.toString())
                //         : communityController.text,
                //     data2: communityController.text,
                //     isControllerTextEmpty: communityController.text.isEmpty,
                //   ),
                //
                // ),
                // sizedBox6(),
                // const Divider(),
                // sizedBox6(),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     Get.bottomSheet(
                //       SingleChildScrollView(
                //         child: Container(color: Theme.of(context).cardColor,
                //           padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                //           child: Column(
                //             children: [
                //               Text(
                //                 'Annual Income',
                //                 style: kManrope25Black.copyWith(fontSize: 16),
                //               ),
                //               sizedBox12(),
                //               CustomDropdownButtonFormField<String>(
                //                 value:  authControl.annualIncome ?? authControl.annualIncomeList.first,// Assuming you have a selectedPosition variable
                //                 items: authControl.annualIncomeList,
                //                 hintText: "Select Annual Income",
                //                 onChanged: (String? value) {
                //                   if (value != null) {
                //                     authControl.setAnnualIncome(value);
                //                     financialCondition.text = value;
                //                     print(authControl.annualIncome);
                //                   }
                //                 },
                //                 // itemLabelBuilder: (String item) => item,
                //                 validator: (value) {
                //                   if (value == null || value.isEmpty) {
                //                     return 'Please Select Annual Income';
                //                   }
                //                   return null;
                //                 },
                //               ),
                //             ],
                //           ),),
                //       ),
                //     );
                //   },
                //   child: buildDataAddRow(
                //     title: 'Annual Income',
                //     widget: const Icon(
                //       Icons.edit,
                //       size: 12,
                //     ),
                //     data1: financialCondition.text.isEmpty
                //         ? (basicInfo.id == null ||
                //         basicInfo.financialCondition == null
                //         ? 'Not Added'
                //         : basicInfo.financialCondition.toString())
                //         : financialCondition.text,
                //     data2: financialCondition.text,
                //     isControllerTextEmpty: financialCondition.text.isEmpty,
                //   ),
                // ),
                // sizedBox6(),
                // const Divider(),
                // sizedBox6(),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     Get.bottomSheet(
                //       SingleChildScrollView(
                //         child: Container(color: Theme.of(context).cardColor,
                //           padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                //           child: Column(
                //             children: [
                //               Text(
                //                 'Mother Tongue',
                //                 style: kManrope25Black.copyWith(fontSize: 16),
                //               ),
                //               sizedBox12(),
                //               CustomDropdownButtonFormField<String>(
                //                 value: authControl.motherTongueList!.firstWhere((religion) => religion.id == authControl.motherTongueIndex).name,// Assuming you have a selectedPosition variable
                //                 items: authControl.motherTongueList!.map((position) => position.name!).toList(),
                //                 hintText: "Mother Tongue",
                //                 onChanged: (String? value) {
                //                   if (value != null) {
                //                     var selected = authControl.motherTongueList!.firstWhere((position) => position.name == value);
                //                     authControl.setMotherTongueIndex(selected.id, true);
                //                     motherTongueController.text = selected.name.toString();
                //                     _motherTongueIdController.text = selected.id.toString();
                //                     authControl.getCasteList(selected.id.toString());
                //
                //                   }
                //                 },
                //
                //               ),
                //             ],
                //           ),),
                //       ),
                //     );
                //   },
                //   child: buildDataAddRow(
                //     title: 'Mother Tongue',
                //     widget: const Icon(
                //       Icons.edit,
                //       size: 12,
                //     ),
                //     data1: motherTongueController.text.isEmpty
                //         ? (basicInfo.id == null ||
                //         basicInfo.motherTongueName == null ||
                //         basicInfo.motherTongueName == null ||
                //         basicInfo.motherTongueName!.isEmpty
                //         ? 'Not Added'
                //         : basicInfo.motherTongueName.toString())
                //         : motherTongueController.text,
                //     data2: StringUtils.capitalize(motherTongueController.text),
                //     isControllerTextEmpty: motherTongueController.text.isEmpty,
                //   ),
                //
                // ),
                // sizedBox16(),
                // const Divider(),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return NameEditDialogWidget(
                //           title: 'District',
                //           addTextField: TextFormField(
                //             maxLength: 40,
                //             onChanged: (v) {
                //               setState(() {});
                //             },
                //             onEditingComplete: () {
                //               Navigator.pop(context); // Close the dialog
                //             },
                //             controller: cityController,
                //             decoration:
                //             AppTFDecoration(hint: 'District').decoration(),
                //             //keyboardType: TextInputType.phone,
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: buildDataAddRow(
                //     widget: const Icon(
                //       Icons.edit,
                //       size: 12,
                //     ),
                //     title: 'District',
                //     data1: cityController.text.isEmpty
                //         ? (basicInfo.presentAddress?.district == null
                //         ? 'District'
                //         : basicInfo.presentAddress!.district!)
                //         : cityController.text,
                //     data2: StringUtils.capitalize(cityController.text),
                //     isControllerTextEmpty: cityController.text.isEmpty,
                //   ),
                //   // child: CarRowWidget(favourites: favourites!,)
                // ),
                // sizedBox16(),
                // sizedBox6(),
                // const Divider(),
                // sizedBox6(),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     Get.bottomSheet(
                //       SingleChildScrollView(
                //         child: Container(color: Theme.of(context).cardColor,
                //           padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                //           child: Column(
                //             children: [
                //               Text(
                //                 'State',
                //                 style: kManrope25Black.copyWith(fontSize: 16),
                //               ),
                //               sizedBox12(),
                //               CustomDropdownButtonFormField<String>(
                //                 value: authControl.selectedState,
                //                 items: authControl.states,
                //                 hintText: "Select State/UT",
                //                 onChanged: (String? value) {
                //                   if (value != null) {
                //                     authControl.setState(value);
                //                     stateController.text = value;
                //                     print(authControl.selectedState);
                //                   }
                //                 },
                //               ),
                //             ],
                //           ),),
                //       ),
                //     );
                //
                //     // showDialog(
                //     //   context: context,
                //     //   builder: (BuildContext context) {
                //     //     return NameEditDialogWidget(
                //     //       title: 'State',
                //     //       addTextField: TextFormField(
                //     //         maxLength: 40,
                //     //         onChanged: (v) {
                //     //           setState(() {});
                //     //         },
                //     //         onEditingComplete: () {
                //     //           Navigator.pop(context); // Close the dialog
                //     //         },
                //     //         controller: stateController,
                //     //         decoration:
                //     //         AppTFDecoration(hint: 'State').decoration(),
                //     //         //keyboardType: TextInputType.phone,
                //     //       ),
                //     //     );
                //     //   },
                //     // );
                //   },
                //   child: buildDataAddRow(
                //     widget: const Icon(
                //       Icons.edit,
                //       size: 12,
                //     ),
                //     title: 'State',
                //     data1: stateController.text.isEmpty
                //         ? (basicInfo.presentAddress == null ||
                //         basicInfo.presentAddress!.state == null
                //         ? 'State'
                //         : basicInfo.presentAddress!.state!)
                //         : stateController.text,
                //     data2: StringUtils.capitalize(stateController.text),
                //     isControllerTextEmpty: stateController.text.isEmpty,
                //   ),
                //   // child: CarRowWidget(favourites: favourites!,)
                // ),
                // sizedBox6(),
                // const Divider(),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return NameEditDialogWidget(
                //           title: 'Zip Code',
                //           addTextField: TextFormField(
                //             keyboardType: TextInputType.number,
                //             maxLength: 40,
                //             onChanged: (v) {
                //               setState(() {});
                //             },
                //             onEditingComplete: () {
                //               Navigator.pop(context); // Close the dialog
                //             },
                //             controller: zipController,
                //             decoration: AppTFDecoration(hint: 'Zip Code')
                //                 .decoration(),
                //             //keyboardType: TextInputType.phone,
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: buildDataAddRow(
                //     widget: const Icon(
                //       Icons.edit,
                //       size: 12,
                //     ),
                //     title: 'Zip Code',
                //     data1: zipController.text.isEmpty
                //         ? (basicInfo.presentAddress == null ||
                //         basicInfo.presentAddress!.zip == null
                //         ? 'Zip Code'
                //         : basicInfo.presentAddress!.zip!)
                //         : zipController.text,
                //     data2: zipController.text,
                //     isControllerTextEmpty: zipController.text.isEmpty,
                //   ),
                //
                //   // chil
                //   // d: CarRowWidget(favourites: favourites!,)
                // ),
                // sizedBox16(),
            /*    const Divider(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NameEditDialogWidget(
                          title: 'Country',
                          addTextField: TextFormField(
                            maxLength: 40,
                            onChanged: (v) {
                              setState(() {});
                            },
                            onEditingComplete: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            controller: countryController,
                            decoration: AppTFDecoration(hint: 'Country')
                                .decoration(),
                            //keyboardType: TextInputType.phone,
                          ),
                        );
                      },
                    );
                  },
                  child: buildDataAddRow(
                    widget: const Icon(
                      Icons.edit,
                      size: 12,
                    ),
                    title: 'Country',
                    data1: countryController.text.isEmpty
                        ? (basicInfo.presentAddress == null ||
                        basicInfo.presentAddress!.country == null
                        ? 'Country'
                        : basicInfo.presentAddress!.country!)
                        : countryController.text,
                    data2: countryController.text,
                    isControllerTextEmpty: countryController.text.isEmpty,
                  ),
                  // child: CarRowWidget(favourites: favourites!,)
                ),*/
              ],
            ),
          ),
        ),
      );
    });
  }

  Padding buildBottombarPadding(BuildContext context,AuthController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: loading
            ? loadingButton(context: context)
            : button(
                context: context,
                onTap: () {

                  setState(() {
                    loading = true;
                  });
                  updateBasicInfo(
                          profession:_professionIdController.text,
                          religion: _religionIdController.text,
                          motherTongue:  _motherTongueIdController.text,
                          community: _casteIdController.text,
                          smokingStatus: _smokingIdController.text,
                          drinkingStatus:  _drinkingIdController.text,
                          maritalStatus: marriedStatusController.text,
                          birthDate: birthDateController.text,
                          state: stateController.text,
                          zip: zipController.text,
                          city: cityController.text,
                          country: countryController.text,
                          gender: genderController.text,
                          financialCondition: financialCondition.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                         diet: dietTypeController.text,
                      disability: disablityController.text,
                      aboutUs: aboutUs.text)
                      .then((value) {
                    setState(() {});
                    if (value['status'] == true) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.pop(context);
                      // dynamic message = value['message']['original']['message'];
                      List<String> errors = [];

                      // if (message != null && message is Map) {
                      //   message.forEach((key, value) {
                      //     errors.addAll(value);
                      //   });
                      // }
                      //
                      // String errorMessage = errors.isNotEmpty
                      //     ? errors.join(", ")
                      //     : "Update succesfully.";
                      // Fluttertoast.showToast(msg: errorMessage);
                    } else {
                      setState(() {
                        loading = false;
                      });
                      // List<dynamic> errors =
                      //     value['message']['original']['message'];
                      // String errorMessage = errors.isNotEmpty
                      //     ? errors[0]
                      //     : "An unknown error occurred.";
                      // Fluttertoast.showToast(msg: errorMessage);
                    }
                  });
                },
                title: "Save"),
      ),
    );
  }

  Row buildDataAddRow({
    required String title,
    required String data1,
    required String data2,
    required bool isControllerTextEmpty,
    required Widget widget,
  }) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                title, style: styleSatoshiRegular(size: 14, color: color5E5E5E),
              ),
              const SizedBox(
                width: 3,
              ),
              widget,
            ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            data1,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: SizedBox(
                  width: 180,
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
                ),
              )
      ],
    );
  }

}

class PrivacyStatusBottomSheet extends StatefulWidget {
  final String privacyStatus;
  final Function(String) onPop;

  const PrivacyStatusBottomSheet(
      {Key? key, required this.privacyStatus, required this.onPop})
      : super(key: key);

  @override
  State<PrivacyStatusBottomSheet> createState() => _PrivacyStatusBottomSheet();
}

class _PrivacyStatusBottomSheet extends State<PrivacyStatusBottomSheet> {
  int _gIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Smoking Status",
                  style: styleSatoshiMedium(size: 16, color: Colors.black),
                ),
                sizedBox16(),
                GestureDetector(
                  onTap: () => setState(() {
                    _gIndex = 0;
                    Navigator.of(context).pop();
                    widget.onPop("1");
                  }),
                  child: Container(
                    height: 44,
                    width: 78,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: _gIndex == 0 ? primaryColor : Colors.transparent,
                    ),
                    child: Center(
                        child: Text(
                      'Yes',
                      style: styleSatoshiLight(
                          size: 14,
                          color: _gIndex == 0 ? Colors.white : Colors.black),
                      // style: _gIndex == 0
                      //     ? textColorF7E64114w400
                      //     : ColorSelect.colorF7E641
                    )),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _gIndex = 1;
                    Navigator.of(context).pop();
                    widget.onPop("0");
                  }),
                  child: Container(
                    height: 44,
                    width: 78,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: _gIndex == 1 ? primaryColor : Colors.transparent,
                    ),
                    child: Center(
                        child: Text(
                      'No',
                      style: styleSatoshiLight(
                          size: 14,
                          color: _gIndex == 1 ? Colors.white : Colors.black),
                      // style
                      // : _gIndex == 1
                      //     ? kManRope_500_16_white
                      //     : kManRope_500_16_626A6A,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.privacyStatus == "1") {
      _gIndex = 0;
    } else if (widget.privacyStatus == "0") {
      _gIndex = 1;
    }
    super.initState();
  }
}

class DrinkingStatusBottomSheet extends StatefulWidget {
  final String privacyStatus;
  final Function(String) onPop;

  const DrinkingStatusBottomSheet(
      {Key? key, required this.privacyStatus, required this.onPop})
      : super(key: key);

  @override
  State<DrinkingStatusBottomSheet> createState() =>
      _DrinkingStatusBottomSheet();
}

class _DrinkingStatusBottomSheet extends State<DrinkingStatusBottomSheet> {
  int _gIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Drinking Status",
                  style: styleSatoshiMedium(size: 16, color: Colors.black),
                ),
                sizedBox16(),
                GestureDetector(
                  onTap: () => setState(() {
                    _gIndex = 0;
                    Navigator.of(context).pop();
                    widget.onPop("1");
                  }),
                  child: Container(
                    height: 44,
                    width: 78,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: _gIndex == 0 ? primaryColor : Colors.transparent,
                    ),
                    child: Center(
                        child: Text(
                      'Yes',
                      style: styleSatoshiLight(
                          size: 14,
                          color: _gIndex == 0 ? Colors.white : Colors.black),
                      // style: _gIndex == 0
                      //     ? textColorF7E64114w400
                      //     : ColorSelect.colorF7E641
                    )),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _gIndex = 1;
                    Navigator.of(context).pop();
                    widget.onPop("0");
                  }),
                  child: Container(
                    height: 44,
                    width: 78,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: _gIndex == 1 ? primaryColor : Colors.transparent,
                    ),
                    child: Center(
                        child: Text(
                      'No',
                      style: styleSatoshiLight(
                          size: 14,
                          color: _gIndex == 1 ? Colors.white : Colors.black),
                      // style
                      // : _gIndex == 1
                      //     ? kManRope_500_16_white
                      //     : kManRope_500_16_626A6A,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.privacyStatus == "1") {
      _gIndex = 0;
    } else if (widget.privacyStatus == "0") {
      _gIndex = 1;
    }
    super.initState();
  }
}



class BasicInfoShimmerWidget extends StatelessWidget {
  const BasicInfoShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: Column(
          children: [
            Container(
              height: 104,
              width: 104,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,

                shape: BoxShape.circle,
              ),

            ),
            sizedBox16(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
                SizedBox(width: 120,),

                Expanded(
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
              ],
            ),
            sizedBox16(),

            sizedBox16(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
                const SizedBox(width: 120,),

                Expanded(
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
              ],
            ),
            sizedBox16(),

            sizedBox16(),
            Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
            ),
            sizedBox16(),

            sizedBox16(),
            Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
            ),
            sizedBox16(),

            sizedBox16(),
            Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
            ),
            sizedBox16(),

            sizedBox16(),
            Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
            ),
            sizedBox16(),

            sizedBox16(),
            Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
            ),
            sizedBox16(),

            sizedBox16(),
            Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
            ),
            sizedBox16(),

            sizedBox16(),
            Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
            ),
            sizedBox16(),

            sizedBox16(),
            Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class SmokingBottomSheet extends StatelessWidget {
  final Function(String) onPop;
  const SmokingBottomSheet({super.key, required this.onPop});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authControl) {
      return SingleChildScrollView(
        child: Container(color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(children: [
            sizedBox20(),
            Align(
              alignment: Alignment.centerLeft, child: Text("Smoking Habit", textAlign: TextAlign.left,
              style: styleSatoshiBold(size: 16, color: Colors.black),),),
            const SizedBox(height: 5,),
            Wrap(
              spacing: 8.0, children: authControl.smokingList!.map((religion) {
              return ChoiceChip(
                selectedColor: color4B164C.withOpacity(0.80),
                backgroundColor: Colors.white,
                label: Text(
                  religion.name!,
                  style: TextStyle(
                    color: authControl.smokingIndex == religion.id
                        ? Colors.white
                        : Colors.black.withOpacity(0.80),
                  ),
                ),
                selected: authControl.smokingIndex == religion.id,
                onSelected: (selected) {
                  if (selected) {
                    authControl.setSmokingIndex(religion.id!,true);
                    onPop(religion.name!);
                  }
                },
              );
            }).toList(),
            ),
          ],
          ),
        ),
      );
    });
  }
}


class DrinkingBottomSheet extends StatelessWidget {
  final Function(String) onPop;
  const DrinkingBottomSheet({super.key, required this.onPop});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authControl) {
      return SingleChildScrollView(
        child: Container(color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(children: [
            sizedBox20(),
            Align(
              alignment: Alignment.centerLeft, child: Text("Drinking Habit", textAlign: TextAlign.left,
              style: styleSatoshiBold(size: 16, color: Colors.black),),),
            const SizedBox(height: 5,),
            Wrap(
              spacing: 8.0, children: authControl.drikingList!.map((religion) {
              return ChoiceChip(
                selectedColor: color4B164C.withOpacity(0.80),
                backgroundColor: Colors.white,
                label: Text(
                  religion.name!,
                  style: TextStyle(
                    color: authControl.drikingIndex == religion.id
                        ? Colors.white
                        : Colors.black.withOpacity(0.80),
                  ),
                ),
                selected: authControl.drikingIndex == religion.id,
                onSelected: (selected) {
                  if (selected) {
                    authControl.setDrikingIndex(religion.id!,true);
                    onPop(religion.name!);
                    print(authControl.drikingIndex);
                  }
                },
              );
            }).toList(),
            ),
          ],
          ),
        ),
      );
    });
  }
}


class SelectStateBottomSheet extends StatefulWidget {
  final Function(String) onStatePop;

  SelectStateBottomSheet({super.key, required this.onStatePop, });

  @override
  State<SelectStateBottomSheet> createState() => _SelectStateBottomSheetState();
}

class _SelectStateBottomSheetState extends State<SelectStateBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final stateController = TextEditingController();
    final districtController = TextEditingController();
    return GetBuilder<ProfileController>(builder: (profileControl) {
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
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select State", style: satoshiRegular.copyWith(fontSize: Dimensions.fontSize12,)),
                  const SizedBox(height: 5),
                  // TypeAheadFormField<String>(
                  //   textFieldConfiguration:  TextFieldConfiguration(
                  //     controller: stateController,
                  //     decoration: authDecoration(
                  //         context, "Select State"
                  //     ),
                  //   ),
                  //   suggestionsCallback: (pattern) async {
                  //     return profileControl.states.where((state) => state.toLowerCase().contains(pattern.toLowerCase())).toList();
                  //   },
                  //   itemBuilder: (context, suggestion) {
                  //     return ListTile(
                  //       title: Text(suggestion),
                  //     );
                  //   },
                  //   onSuggestionSelected: (String? suggestion) {
                  //     if (suggestion != null) {
                  //       profileControl.setState(suggestion);
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
                  //   onSaved: (value) => profileControl.setState(value!),
                  // ),

                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}


class ProfessionBottomSheet extends StatelessWidget {
  final Function(String) onPop;
  // final Function(String)? onPopId;
  const ProfessionBottomSheet({super.key, required this.onPop, });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authControl) {
      return SingleChildScrollView(
        child: Container(color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(children: [
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
                      onPop(religion.name!);
                      // onPopId!(religion.id.toString());

                      Navigator.pop(context);
                    }
                  },
                );
              }).toList(),
            ),


          ],
          ),
        ),
      );
    });
  }
}