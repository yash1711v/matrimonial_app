import 'dart:developer';

import 'package:bureau_couple/getx/controllers/profile_controller.dart';
import 'package:bureau_couple/getx/features/widgets/custom_decorated_containers.dart';
import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/getx/utils/styles.dart';
import 'package:bureau_couple/src/constants/fonts.dart';
import 'package:bureau_couple/src/constants/sizedboxe.dart';
import 'package:bureau_couple/src/utils/urls.dart';
import 'package:bureau_couple/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../apis/members_api/request_apis.dart';
import '../../apis/other_user_api/other_user_profile_details.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../constants/textstyles.dart';
import '../../models/other_person_details_models.dart';
import '../../utils/widgets/buttons.dart';
import '../../utils/widgets/custom_image_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/widgets/hobbies_widget.dart';
import '../home/profile/our_images_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  OtherProfileModel model = OtherProfileModel();
  final Set<String>? userHobbies = {};

  getProfileDetails() {
    isLoading = true;
    var resp = getOtherUserProfileApi(otherUserId: widget.userId);
    resp.then((value) {
      log("value $value");
      // matches.clear();
      if (mounted) {
        if (value['status'] == true) {
          setState(() {
            model = OtherProfileModel.fromJson(value);
            isLoading = false;
          });

          (model.data?.matches!.interest ?? []).forEach((element) {
            element.hobbies!.forEach((hobbies) {
              setState(() {
                userHobbies!.add(hobbies);
              });
            });
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  int totalMatches(OtherProfileModel model) {
    int total = 0;

    // Safely check for nulls and increment total for each matching condition
    if (model.data?.matches?.partnerExpectation?.communityName.contains(
        model.data?.user?.partnerExpectation?.communityName)) {
      total++;
    }
    if (model.data?.matches?.partnerExpectation?.motherTongueName.contains(
        model.data?.user?.partnerExpectation?.motherTongueName)) {
      total++;
    }
    if (model.data?.matches?.address?.state ==
        model.data?.user?.address?.state) {
      total++;
    }
    if (model.data?.matches?.partnerExpectation?.professionName.contains(
        model.data?.user?.partnerExpectation?.professionName)) {
      total++;
    }
    if (model.data?.matches?.partnerExpectation?.positionName.contains(
        model.data?.user?.partnerExpectation?.positionName)) {
      total++;
    }

    return total;
  }

  bool isHobbyMatching(List<dynamic>? userData, List<dynamic>? matchData) {
    debugPrint("userData $userData matchData $matchData");

    return matchData!.any((element) => userData!.contains(element));
  }

  bool isHobbyMatchingSingle(String? userData, String? matchData) {
    debugPrint("userData $userData matchData $matchData");

    return matchData == userData;
  }

  DateTime? birthDate;
  int age = 0;
  bool loading = false;
  bool connected = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    String? birthDateString = model.data?.matches?.basicInfo?.birthDate;
    if (birthDateString != null) {
      birthDate = DateFormat('yyyy-MM-dd').parse(birthDateString);
      age = birthDate != null
          ? DateTime
          .now()
          .difference(birthDate!)
          .inDays ~/ 365
          : 0;
    }
    return Scaffold(
      body: isLoading
          ? const UserProfileShimmer()
          : SingleChildScrollView(
        child:
        GetBuilder<ProfileController>(builder: (profileController) {
          debugPrint(
              "model.data?.matches?.galleries?.length ${model.data?.matches
                  ?.galleries?.length}");
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "${StringUtils.capitalize(model.data!.matches!.firstname ?? '')} ${StringUtils.capitalize(model.data!.matches!.lastname ?? 'User')}",
                //         overflow: TextOverflow.ellipsis,
                //         maxLines: 1,
                //         style: styleSatoshiBold(
                //             size: 22, color: Colors.black),
                //       ),
                //     ],
                //   ),
                // ),
                // Image.network("$baseProfilePhotoUrl${model.data!.matches!.image}"),

                Stack(
                  children: [
                    Container(
                      height: 500,
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.srcOver,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: model.data!.matches!.image != null
                              ? '$baseProfilePhotoUrl${model.data!.matches!
                              .image}'
                              : '',
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) =>
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  icLogo,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                          progressIndicatorBuilder: (a, b, c) =>
                              customShimmer(
                                height: 0, /*width: 0,*/
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${StringUtils.capitalize(
                                      model.data!.matches!.firstname ??
                                          '')} ${StringUtils.capitalize(
                                      model.data!.matches!.lastname ??
                                          'User')}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleSatoshiBold(
                                      size: 14, color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '$age yrs',
                                          style: styleSatoshiRegular(
                                              size: 10,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Container(
                                          height: 4,
                                          width: 4,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "${model.data!.matches!
                                              .physicalAttributes!.height ??
                                              ''} ft",
                                          style: styleSatoshiRegular(
                                              size: 10,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model.data!.matches!.basicInfo
                                                ?.professionName ??
                                                '',
                                            style: styleSatoshiRegular(
                                                size: 13,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            overflow:
                                            TextOverflow.ellipsis,
                                            maxLines: 2,
                                            model
                                                .data!
                                                .matches!
                                                .basicInfo
                                                ?.presentAddress
                                                ?.state ??
                                                '',
                                            style: styleSatoshiRegular(
                                                size: 13,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                sizedBox18(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Text(
                        "Photos",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: model.data?.matches?.galleries?.isNotEmpty ??
                      false
                      ? Visibility(
                    visible: model
                        .data?.matches?.galleries?.isNotEmpty ??
                        false,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                      model.data?.matches?.galleries!.length,
                      itemBuilder:
                          (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PhotoViewScreen(
                                      imageProvider: NetworkImage(
                                        model
                                            .data
                                            ?.matches
                                            ?.galleries![index]
                                            .image !=
                                            null
                                            ? '$baseGalleryImage${model.data
                                            ?.matches?.galleries![index].image}'
                                            : '',
                                      ),
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 2),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "$baseGalleryImage${model.data?.matches
                                            ?.galleries![index].image}"))),
                          ),
                        );
                      },
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("NO PHOTOS ADDED "),
                    ],
                  ),
                ),
                // Column(
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: List.generate(
                //         model.data?.matches?.galleries?.length ?? 0,
                //             (index) => Container(
                //           width: 40,
                //           height: 100,
                //           margin: const EdgeInsets.symmetric(
                //               horizontal: 2),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(24),
                //             color: _currentIndex == index
                //                 ? Colors.black
                //                 : Colors.black.withOpacity(0.30),
                //           ),
                //         ),
                //       ),
                //     ),
                //     // Stack(
                //     //   children: [
                //     //     // ClipRRect(
                //     //     //   borderRadius: const BorderRadius.only(
                //     //     //       bottomRight: Radius.circular(32),
                //     //     //       bottomLeft: Radius.circular(32)),
                //     //     //   child: CarouselSlider.builder(
                //     //     //     itemCount:
                //     //     //     model.data?.matches?.galleries?.length ?? 0,
                //     //     //     itemBuilder: (ctx, index, realIndex) {
                //     //     //       return Stack(
                //     //     //         children: [
                //     //     //           ClipRRect(
                //     //     //             borderRadius: const BorderRadius.only(
                //     //     //                 bottomRight: Radius.circular(32),
                //     //     //                 bottomLeft: Radius.circular(32)),
                //     //     //             child: CachedNetworkImage(
                //     //     //               imageUrl:
                //     //     //               '$baseGalleryImage${model.data?.matches?.galleries?[index].image}',
                //     //     //               fit: BoxFit.fill,
                //     //     //               errorWidget: (context, url, error) =>
                //     //     //                   Padding(
                //     //     //                     padding: const EdgeInsets.all(8.0),
                //     //     //                     child: Image.asset(icLogo),
                //     //     //                   ),
                //     //     //               progressIndicatorBuilder: (context,
                //     //     //                   url, downloadProgress) =>
                //     //     //                   customShimmer(height: 0),
                //     //     //             ),
                //     //     //           ),
                //     //     //           Positioned(
                //     //     //             bottom: 0,
                //     //     //             left: 0,
                //     //     //             right: 0,
                //     //     //             child: ClipRect(
                //     //     //               child: Container(
                //     //     //                 height: 170,
                //     //     //                 width: 1.sw,
                //     //     //                 margin: const EdgeInsets.symmetric(
                //     //     //                     horizontal: 0),
                //     //     //                 clipBehavior: Clip.hardEdge,
                //     //     //                 decoration: BoxDecoration(
                //     //     //                     gradient: LinearGradient(
                //     //     //                       colors: [
                //     //     //                         Colors.black
                //     //     //                             .withOpacity(0.8),
                //     //     //                         Colors.transparent
                //     //     //                       ],
                //     //     //                       stops: const [0, 10],
                //     //     //                       begin: Alignment.bottomCenter,
                //     //     //                       end: Alignment.topCenter,
                //     //     //                     ),
                //     //     //                     borderRadius:
                //     //     //                     BorderRadius.circular(32)),
                //     //     //                 // child: Image.asset(images[i],
                //     //     //                 // height: 170,),
                //     //     //               ),
                //     //     //             ),
                //     //     //           ),
                //     //     //         ],
                //     //     //       );
                //     //     //     },
                //     //     //     options: CarouselOptions(
                //     //     //       height: 500,
                //     //     //       viewportFraction: 2,
                //     //     //       enlargeFactor: 0.3,
                //     //     //       aspectRatio: 0.8,
                //     //     //       enableInfiniteScroll: false,
                //     //     //       onPageChanged: (index, reason) {
                //     //     //         setState(() {
                //     //     //           _currentIndex = index;
                //     //     //         });
                //     //     //       },
                //     //     //     ),
                //     //     //   ),
                //     //     // ),
                //     //     Positioned(
                //     //       top: 40,
                //     //       left: 0,
                //     //       right: 0,
                //     //       child: Row(
                //     //         mainAxisAlignment: MainAxisAlignment.center,
                //     //         children: List.generate(
                //     //           model.data?.matches?.galleries?.length ?? 0,
                //     //           (index) => Container(
                //     //             width: 40,
                //     //             height: 6,
                //     //             margin: const EdgeInsets.symmetric(
                //     //                 horizontal: 2),
                //     //             decoration: BoxDecoration(
                //     //               borderRadius: BorderRadius.circular(24),
                //     //               color: _currentIndex == index
                //     //                   ? Colors.black
                //     //                   : Colors.black.withOpacity(0.30),
                //     //             ),
                //     //           ),
                //     //         ),
                //     //       ),
                //     //     ),
                //     //     Positioned(
                //     //       bottom: 30,
                //     //       left: 40,
                //     //       right: 0,
                //     //       child: Row(
                //     //         children: [
                //     //           Expanded(
                //     //             flex: 3,
                //     //             child: Column(
                //     //               mainAxisAlignment:
                //     //                   MainAxisAlignment.center,
                //     //               crossAxisAlignment:
                //     //                   CrossAxisAlignment.start,
                //     //               children: [
                //     //                 Row(
                //     //                   children: [
                //     //                     Expanded(
                //     //                       flex: 3,
                //     //                       child: Column(
                //     //                         mainAxisAlignment:
                //     //                             MainAxisAlignment.center,
                //     //                         crossAxisAlignment:
                //     //                             CrossAxisAlignment.start,
                //     //                         children: [
                //     //                           Row(
                //     //                             children: [
                //     //                               Expanded(
                //     //                                 flex: 4,
                //     //                                 child: Text(
                //     //                                   "${StringUtils.capitalize(model.data!.matches!.firstname ?? '')} ${StringUtils.capitalize(model.data!.matches!.lastname ?? 'User')}",
                //     //                                   overflow:
                //     //                                       TextOverflow
                //     //                                           .ellipsis,
                //     //                                   maxLines: 1,
                //     //                                   style:
                //     //                                       styleSatoshiBold(
                //     //                                           size: 22,
                //     //                                           color: Colors
                //     //                                               .white),
                //     //                                 ),
                //     //                               ),
                //     //                               const SizedBox(
                //     //                                 width: 10,
                //     //                               ),
                //     //                             ],
                //     //                           ),
                //     //                           const SizedBox(
                //     //                             height: 6,
                //     //                           ),
                //     //                           // Row(
                //     //                           //   children: [
                //     //                           //     Container(
                //     //                           //       padding:
                //     //                           //           const EdgeInsets
                //     //                           //               .symmetric(
                //     //                           //               vertical: 4.0,
                //     //                           //               horizontal:
                //     //                           //                   8),
                //     //                           //       decoration: BoxDecoration(
                //     //                           //           color: Colors
                //     //                           //               .greenAccent,
                //     //                           //           borderRadius:
                //     //                           //               BorderRadius
                //     //                           //                   .circular(
                //     //                           //                       12)),
                //     //                           //       child: Text(
                //     //                           //         StringUtils
                //     //                           //             .capitalize(
                //     //                           //                 '$age yrs'),
                //     //                           //         overflow:
                //     //                           //             TextOverflow
                //     //                           //                 .ellipsis,
                //     //                           //         maxLines: 1,
                //     //                           //         style:
                //     //                           //             styleSatoshiLarge(
                //     //                           //                 size: 16,
                //     //                           //                 color: Colors
                //     //                           //                     .black),
                //     //                           //       ),
                //     //                           //     ),
                //     //                           //     const SizedBox(
                //     //                           //       width: 6,
                //     //                           //     ),
                //     //                           //     Container(
                //     //                           //       height: 4,
                //     //                           //       width: 4,
                //     //                           //       decoration:
                //     //                           //           const BoxDecoration(
                //     //                           //         shape:
                //     //                           //             BoxShape.circle,
                //     //                           //         color: Colors.white,
                //     //                           //       ),
                //     //                           //     ),
                //     //                           //     const SizedBox(
                //     //                           //       width: 6,
                //     //                           //     ),
                //     //                           //     Container(
                //     //                           //       padding:
                //     //                           //           const EdgeInsets
                //     //                           //               .symmetric(
                //     //                           //               vertical: 4.0,
                //     //                           //               horizontal:
                //     //                           //                   8),
                //     //                           //       decoration: BoxDecoration(
                //     //                           //           color: Colors
                //     //                           //               .yellowAccent
                //     //                           //               .withOpacity(
                //     //                           //                   0.70),
                //     //                           //           borderRadius:
                //     //                           //               BorderRadius
                //     //                           //                   .circular(
                //     //                           //                       12)),
                //     //                           //       child: Text(
                //     //                           //         StringUtils.capitalize(model
                //     //                           //                 .data
                //     //                           //                 ?.matches
                //     //                           //                 ?.basicInfo
                //     //                           //                 ?.religionName ??
                //     //                           //             ''),
                //     //                           //         overflow:
                //     //                           //             TextOverflow
                //     //                           //                 .ellipsis,
                //     //                           //         maxLines: 1,
                //     //                           //         style:
                //     //                           //             styleSatoshiLarge(
                //     //                           //                 size: 16,
                //     //                           //                 color: Colors
                //     //                           //                     .black),
                //     //                           //       ),
                //     //                           //     ),
                //     //                           //   ],
                //     //                           // ),
                //     //                           sizedBox10(),
                //     //                           // Row(
                //     //                           //   mainAxisAlignment:
                //     //                           //       MainAxisAlignment
                //     //                           //           .start,
                //     //                           //   crossAxisAlignment:
                //     //                           //       CrossAxisAlignment
                //     //                           //           .start,
                //     //                           //   children: [
                //     //                           //     const SizedBox(
                //     //                           //       width: 2,
                //     //                           //     ),
                //     //                           //     Expanded(
                //     //                           //       flex: 10,
                //     //                           //       child: Row(
                //     //                           //         children: [
                //     //                           //           Text(
                //     //                           //             '${model.data!.matches!.basicInfo!.presentAddress!.state ?? ''} • ${model.data!.matches!.basicInfo!.professionName ?? ''} • ${model.data!.matches!.basicInfo!.communityName ?? ''}',
                //     //                           //             overflow:
                //     //                           //                 TextOverflow
                //     //                           //                     .ellipsis,
                //     //                           //             maxLines: 2,
                //     //                           //             style: styleSatoshiLarge(
                //     //                           //                 size: 16,
                //     //                           //                 color: Colors
                //     //                           //                     .white),
                //     //                           //           ),
                //     //                           //         ],
                //     //                           //       ),
                //     //                           //     ),
                //     //                           //   ],
                //     //                           // ),
                //     //                           sizedBox16(),
                //     //                         ],
                //     //                       ),
                //     //                     ),
                //     //                   ],
                //     //                 ),
                //     //               ],
                //     //             ),
                //     //           ),
                //     //         ],
                //     //       ),
                //     //     ),
                //     //     Padding(
                //     //       padding:
                //     //           const EdgeInsets.only(left: 16, top: 50),
                //     //       child: TextButton(
                //     //           onPressed: () {
                //     //             Get.back();
                //     //           },
                //     //           child: Icon(
                //     //             Icons.arrow_back_rounded,
                //     //             size: Dimensions.fontSize40,
                //     //             color: Theme.of(context).cardColor,
                //     //           )),
                //     //     ),
                //     //   ],
                //     // ),
                //   ],
                // ),
                sizedBox20(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      model.data!.matches!.basicInfo!.aboutUs!.isEmpty
                          ? const SizedBox()
                          : CustomBorderContainer(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: kManrope25Black.copyWith(
                                  fontSize: Dimensions.fontSize18,
                                  color: Theme
                                      .of(context)
                                      .primaryColorDark
                                      .withOpacity(0.65)),
                            ),
                            sizedBox10(),
                            ReadMoreText(
                              model.data?.matches?.basicInfo
                                  ?.aboutUs ??
                                  "",
                              trimLines: 4,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: ' Show less',
                              moreStyle: styleSatoshiLight(
                                  size: 14, color: primaryColor),
                              lessStyle: styleSatoshiLight(
                                  size: 14, color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBox10(),
                          CustomBorderContainer(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Basic Info',
                                  style: kManrope25Black.copyWith(
                                      fontSize: Dimensions.fontSize18,
                                      color: Theme
                                          .of(context)
                                          .primaryColorDark
                                          .withOpacity(0.65)),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                buildProfileRow(
                                    image: birthHolder,
                                    title: 'Age',
                                    text: '${age.toString()} Yrs'),
                                const Divider(),
                                buildProfileRow(
                                    image: icHeightIcon,
                                    title: 'Height',
                                    text:
                                    "${model.data?.matches?.physicalAttributes
                                        ?.height} ft" ??
                                        ''),
                                const Divider(),
                                buildProfileRow(
                                    image: icReligionIcon,
                                    title: 'Religion',
                                    text: model
                                        .data!.matches!.religionName
                                        .toString()),
                                const Divider(),
                                buildProfileRow(
                                    image: icMotherToungeIcon,
                                    title: 'Mother Tongue',
                                    text: model
                                        .data!.matches!.motherTongueName
                                        .toString()),
                                const Divider(),
                                buildProfileRow(
                                    image: icMarriedStatusPro,
                                    title: 'Married Status',
                                    text: StringUtils.capitalize((model
                                        .data!
                                        .matches
                                        ?.basicInfo
                                        ?.maritialStatus ??
                                        MaritialStatus(
                                            id: 0, title: ""))
                                        .title ??
                                        "")),
                              ],
                            ),
                          ),
                        ],
                      ),
                      sizedBox16(),
                      CustomBorderContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Professional Info',
                              style: kManrope25Black.copyWith(
                                  fontSize: Dimensions.fontSize18,
                                  color: Theme
                                      .of(context)
                                      .primaryColorDark
                                      .withOpacity(0.65)),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            /*Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              icUserHeightIcon,
                                              height: 20,
                                              width: 20,
                                            ),
                                            sizedBox6(),
                                            Text(
                                              "${model.data?.matches?.physicalAttributes?.height} ft" ??
                                                  "not added yet",
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: styleSatoshiMedium(
                                                size: 14,
                                                color: Colors.black
                                                    .withOpacity(0.70),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              icUserLocationIcon,
                                              height: 20,
                                              width: 20,
                                            ),
                                            sizedBox6(),
                                            Text(
                                              ' ${model.data!.matches!.address!.country ?? ""}',
                                              textAlign: TextAlign.center,
                                              style: styleSatoshiMedium(
                                                size: 14,
                                                color: Colors.black
                                                    .withOpacity(0.70),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  sizedBox16(),*/
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: SvgPicture.asset(
                                          icEducation,
                                          height: 18,
                                          width: 18,
                                        ),
                                      ),
                                      sizedBox6(),
                                      Text(
                                        model
                                            .data
                                            ?.matches
                                            ?.educationInfo?[0]
                                            .degree ??
                                            "",
                                        textAlign: TextAlign.center,
                                        style: styleSatoshiMedium(
                                          size: 14,
                                          color: Colors.black
                                              .withOpacity(0.70),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        icUserBagIcon,
                                        height: 20,
                                        width: 20,
                                      ),
                                      sizedBox6(),
                                      Text(
                                        model
                                            .data!.matches!.professionName
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: styleSatoshiMedium(
                                          size: 14,
                                          color: Colors.black
                                              .withOpacity(0.70),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      sizedBox16(),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .cardColor,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 8),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Interest & Hobbies',
                                      style: kManrope25Black.copyWith(
                                          fontSize: Dimensions.fontSize18,
                                          color: Theme
                                              .of(context)
                                              .primaryColorDark
                                              .withOpacity(0.65)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              HobbiesWrap(
                                allHobbies: userHobbies!,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // CustomBorderContainer(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Interest & Hobbies',
                      //         style: kManrope25Black.copyWith(
                      //             fontSize: Dimensions.fontSize18,
                      //             color: Theme.of(context)
                      //                 .primaryColorDark
                      //                 .withOpacity(0.65)),
                      //       ),
                      //       const SizedBox(
                      //         height: 12,
                      //       ),
                      //       Row(
                      //         children: [
                      //           Expanded(
                      //             child: Wrap(
                      //               alignment: WrapAlignment.start,
                      //               spacing: 4.0,
                      //               children: model.data!.matches!.fun
                      //                   .toString()
                      //                   .split(', ')
                      //                   .map((item) {
                      //                 return Container(
                      //                   margin:
                      //                       const EdgeInsets.symmetric(
                      //                           vertical: Dimensions
                      //                               .paddingSize5),
                      //                   padding: const EdgeInsets.all(
                      //                       Dimensions.paddingSize10),
                      //                   decoration: BoxDecoration(
                      //                       color: color4B164C
                      //                           .withOpacity(0.80),
                      //                       borderRadius:
                      //                           BorderRadius.circular(
                      //                               Dimensions.radius15)),
                      //                   child: Text(
                      //                     item,
                      //                     style: satoshiBold.copyWith(
                      //                         fontSize:
                      //                             Dimensions.fontSize12,
                      //                         color: Theme.of(context)
                      //                             .cardColor),
                      //                   ),
                      //                 );
                      //               }).toList(),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           Expanded(
                      //             child: Wrap(
                      //               alignment: WrapAlignment.start,
                      //               spacing: 4.0,
                      //               children: model
                      //                   .data!.matches!.creative
                      //                   .toString()
                      //                   .split(', ')
                      //                   .map((item) {
                      //                 return Container(
                      //                   margin:
                      //                       const EdgeInsets.symmetric(
                      //                           vertical: Dimensions
                      //                               .paddingSize5),
                      //                   padding: const EdgeInsets.all(
                      //                       Dimensions.paddingSize10),
                      //                   decoration: BoxDecoration(
                      //                       color: color4B164C
                      //                           .withOpacity(0.80),
                      //                       borderRadius:
                      //                           BorderRadius.circular(
                      //                               Dimensions.radius15)),
                      //                   child: Text(
                      //                     item,
                      //                     style: satoshiBold.copyWith(
                      //                         fontSize:
                      //                             Dimensions.fontSize12,
                      //                         color: Theme.of(context)
                      //                             .cardColor),
                      //                   ),
                      //                 );
                      //               }).toList(),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           Expanded(
                      //             child: Wrap(
                      //               alignment: WrapAlignment.start,
                      //               spacing: 4.0,
                      //               children: model.data!.matches!.fitness
                      //                   .toString()
                      //                   .split(', ')
                      //                   .map((item) {
                      //                 return Container(
                      //                   margin:
                      //                       const EdgeInsets.symmetric(
                      //                           vertical: Dimensions
                      //                               .paddingSize5),
                      //                   padding: const EdgeInsets.all(
                      //                       Dimensions.paddingSize10),
                      //                   decoration: BoxDecoration(
                      //                       color: color4B164C
                      //                           .withOpacity(0.80),
                      //                       borderRadius:
                      //                           BorderRadius.circular(
                      //                               Dimensions.radius15)),
                      //                   child: Text(
                      //                     item,
                      //                     style: satoshiBold.copyWith(
                      //                         fontSize:
                      //                             Dimensions.fontSize12,
                      //                         color: Theme.of(context)
                      //                             .cardColor),
                      //                   ),
                      //                 );
                      //               }).toList(),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           Expanded(
                      //             child: Wrap(
                      //               alignment: WrapAlignment.start,
                      //               spacing: 4.0,
                      //               children: model.data!.matches!.hobby
                      //                   .toString()
                      //                   .split(', ')
                      //                   .map((item) {
                      //                 return Container(
                      //                   margin:
                      //                       const EdgeInsets.symmetric(
                      //                           vertical: Dimensions
                      //                               .paddingSize5),
                      //                   padding: const EdgeInsets.all(
                      //                       Dimensions.paddingSize10),
                      //                   decoration: BoxDecoration(
                      //                       color: color4B164C
                      //                           .withOpacity(0.80),
                      //                       borderRadius:
                      //                           BorderRadius.circular(
                      //                               Dimensions.radius15)),
                      //                   child: Text(
                      //                     item,
                      //                     style: satoshiBold.copyWith(
                      //                         fontSize:
                      //                             Dimensions.fontSize12,
                      //                         color: Theme.of(context)
                      //                             .cardColor),
                      //                   ),
                      //                 );
                      //               }).toList(),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           Expanded(
                      //             child: Wrap(
                      //               alignment: WrapAlignment.start,
                      //               spacing: 4.0,
                      //               children: model
                      //                   .data!.matches!.otherInterest
                      //                   .toString()
                      //                   .split(', ')
                      //                   .map((item) {
                      //                 return Container(
                      //                   margin:
                      //                       const EdgeInsets.symmetric(
                      //                           vertical: Dimensions
                      //                               .paddingSize5),
                      //                   padding: const EdgeInsets.all(
                      //                       Dimensions.paddingSize10),
                      //                   decoration: BoxDecoration(
                      //                       color: color4B164C
                      //                           .withOpacity(0.80),
                      //                       borderRadius:
                      //                           BorderRadius.circular(
                      //                               Dimensions.radius15)),
                      //                   child: Text(
                      //                     item,
                      //                     style: satoshiBold.copyWith(
                      //                         fontSize:
                      //                             Dimensions.fontSize12,
                      //                         color: Theme.of(context)
                      //                             .cardColor),
                      //                   ),
                      //                 );
                      //               }).toList(),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      sizedBox16(),
                      CustomBorderContainer(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 70,
                                    ),
                                    Image.asset(
                                      preferenceHolder,
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 35,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey
                                                  .withOpacity(0.40)),
                                          padding:
                                          const EdgeInsets.all(4),
                                          child: ClipOval(
                                              child: CustomImageWidget(
                                                image: model.data?.user
                                                    ?.image !=
                                                    null
                                                    ? '$baseProfilePhotoUrl${model
                                                    .data?.user?.image}'
                                                    : 'fallback_image_url_here',
                                                height: 70,
                                                width: 70,
                                              )),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey
                                                  .withOpacity(0.40)),
                                          padding:
                                          const EdgeInsets.all(4),
                                          child: ClipOval(
                                              child: CustomImageWidget(
                                                image: model.data?.matches
                                                    ?.image !=
                                                    null
                                                    ? '$baseProfilePhotoUrl${model
                                                    .data?.matches?.image}'
                                                    : 'fallback_image_url_here',
                                                height: 70,
                                                width: 70,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 12,
                                  right: 12,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Your Match Preferences",
                                        style: styleSatoshiLight(
                                            size: 16,
                                            color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Spacer(),
                                      Text(
                                        "${totalMatches(model)}  out of 5",
                                        style: styleSatoshiLight(
                                            size: 16,
                                            color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  // buildPrefProfileRow(
                                  //   image: icReligionIcon,
                                  //   title: 'Religion',
                                  //   text: StringUtils.capitalize(
                                  //       model.data?.matches?.religionName ??
                                  //           ""),
                                  //   iconRightWrong:
                                  //       model.data?.matches?.religionName ==
                                  //               model
                                  //                   .data
                                  //                   ?.user
                                  //                   ?.partnerExpectation
                                  //                   ?.religionName
                                  //           ? Icons.done
                                  //           : Icons.close,
                                  // ),
                                  // const Divider(),
                                  Visibility(
                                    visible: model
                                        .data
                                        ?.matches
                                        ?.partnerExpectation
                                        ?.communityName !=
                                        null &&
                                        model
                                            .data
                                            ?.user
                                            ?.partnerExpectation
                                            ?.communityName !=
                                            null,
                                    child: buildPrefProfileRow(
                                      image: icGotraIcon,
                                      title: 'Community',
                                      text: model
                                          .data
                                          ?.matches
                                          ?.partnerExpectation
                                          ?.communityName.take(
                                          3) // Take the first 3 elements
                                          .map((religion) =>
                                      religion[0]
                                          .toUpperCase() +
                                          religion
                                              .substring(1)
                                              .toLowerCase())
                                          .join(', ') +
                                          (model
                                              .data
                                              ?.matches
                                              ?.partnerExpectation
                                              ?.communityName
                                              .length >
                                              3
                                              ? ' ..'
                                              : '') ??
                                          '',
                                      iconRightWrong: isHobbyMatching(
                                        model
                                            .data
                                            ?.user
                                            ?.partnerExpectation
                                            ?.communityName ??
                                            "",
                                        model
                                            .data
                                            ?.matches
                                            ?.partnerExpectation
                                            ?.communityName ??
                                            "",
                                      )
                                          ? Icons.done
                                          : Icons.close,
                                    ),
                                  ),
                                  Visibility(
                                      visible: model
                                          .data
                                          ?.matches
                                          ?.partnerExpectation
                                          ?.motherTongueName !=
                                          null &&
                                          model
                                              .data
                                              ?.user
                                              ?.partnerExpectation
                                              ?.motherTongueName !=
                                              null,
                                      child: const Divider()),
                                  Visibility(
                                    visible: model
                                        .data
                                        ?.matches
                                        ?.partnerExpectation
                                        ?.motherTongueName !=
                                        null &&
                                        model
                                            .data
                                            ?.user
                                            ?.partnerExpectation
                                            ?.motherTongueName !=
                                            null,
                                    child: buildPrefProfileRow(
                                      image: icMotherToungeIcon,
                                      title: 'Mother Tongue',
                                      text: model
                                          .data
                                          ?.user
                                          ?.partnerExpectation
                                          ?.motherTongueName.take(
                                          3) // Take the first 3 elements
                                          .map((religion) =>
                                      religion[0]
                                          .toUpperCase() +
                                          religion
                                              .substring(1)
                                              .toLowerCase())
                                          .join(', ') +
                                          (model
                                              .data
                                              ?.matches
                                              ?.partnerExpectation
                                              ?.communityName
                                              .length >
                                              3
                                              ? ' ..'
                                              : '') ??
                                          '',
                                      iconRightWrong: isHobbyMatching(
                                          model
                                              .data
                                              ?.user
                                              ?.partnerExpectation
                                              ?.motherTongueName ??
                                              "",
                                          model
                                              .data
                                              ?.matches
                                              ?.partnerExpectation
                                              ?.motherTongueName ??
                                              ""
                                      )
                                          ? Icons.done
                                          : Icons.close,
                                    ),
                                  ),
                                  Visibility(
                                      visible: model.data?.matches
                                          ?.address?.state !=
                                          null &&
                                          model.data?.user?.address
                                              ?.state !=
                                              null,
                                      child: const Divider()),
                                  Visibility(
                                    visible: model.data?.matches?.address
                                        ?.state !=
                                        null &&
                                        model.data?.user?.address
                                            ?.state !=
                                            null,
                                    child: buildPrefProfileRow(
                                      image: icState,
                                      title: 'State',
                                      text: StringUtils.capitalize(model
                                          .data
                                          ?.matches
                                          ?.address
                                          ?.state ??
                                          ""),
                                      iconRightWrong: isHobbyMatchingSingle(
                                          model.data?.user?.address
                                              ?.state,
                                          model.data?.matches?.address
                                              ?.state
                                      )
                                      // ?.motherTongue!.name
                                          ? Icons.done
                                          : Icons.close,
                                    ),
                                  ),
                                  Visibility(
                                      visible: model
                                          .data
                                          ?.matches
                                          ?.partnerExpectation
                                          ?.professionName !=
                                          null &&
                                          model
                                              .data
                                              ?.user
                                              ?.partnerExpectation
                                              ?.professionName !=
                                              null,
                                      child: const Divider()),
                                  buildPrefProfileRow(
                                    image: icProfession,
                                    title: 'Profession',
                                    text: "",
                                    // StringUtils.capitalize(model
                                    //         .data
                                    //         ?.matches
                                    //         ?.partnerExpectation
                                    //         ?.professionName ??
                                    //     ""),
                                    iconRightWrong: isHobbyMatching(
                                        model
                                            .data
                                            ?.user
                                            ?.partnerExpectation
                                            ?.professionName,
                                        model
                                            .data
                                            ?.matches
                                            ?.partnerExpectation
                                            ?.professionName
                                    )
                                        ? Icons.done
                                        : Icons.close,
                                  ),
                                  Visibility(
                                      visible: model
                                          .data
                                          ?.matches
                                          ?.partnerExpectation
                                          ?.professionName !=
                                          null &&
                                          model
                                              .data
                                              ?.user
                                              ?.partnerExpectation
                                              ?.professionName !=
                                              null,
                                      child: const Divider()),
                                  Visibility(
                                    visible: model
                                        .data
                                        ?.matches
                                        ?.partnerExpectation
                                        ?.professionName !=
                                        null &&
                                        model
                                            .data
                                            ?.user
                                            ?.partnerExpectation
                                            ?.professionName !=
                                            null,
                                    child: buildPrefProfileRow(
                                      image: icGotraIcon,
                                      title: 'Service',
                                      text: StringUtils.capitalize(model
                                          .data
                                          ?.user
                                          ?.partnerExpectation
                                          ?.positionName ??
                                          ""),
                                      iconRightWrong: model
                                          .data
                                          ?.matches
                                          ?.partnerExpectation
                                          ?.positionName ==
                                          model
                                              .data
                                              ?.user
                                              ?.partnerExpectation
                                              ?.positionName
                                          ? Icons.done
                                          : Icons.close,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      sizedBox16(),
                      sizedBox14(),
                      button(
                          fontSize: 14,
                          height: 45,
                          width: double.infinity,
                          context: context,
                          onTap: () {
                            setState(() {
                              connected = !connected;
                            });
                            sendRequestApi(
                              memberId:
                              model.data!.matches!.id!.toString(),
                            ).then((value) {
                              if (value['status'] == true) {
                                setState(() {});
                                ToastUtil.showToast(
                                    "Connection Request Sent");
                              } else {
                                setState(() {});

                                List<dynamic> errors =
                                value['message']['error'];
                                String errorMessage = errors.isNotEmpty
                                    ? errors[0]
                                    : "An unknown error occurred.";
                                Fluttertoast.showToast(msg: errorMessage);
                              }
                            });
                          },
                          title:
                          connected ? 'Request Sent' : "Connect Now"),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Padding buildProfileRow({
    required String image,
    required String title,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 18.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SvgPicture.asset(
              image,
              height: 48,
              width: 48,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: styleSatoshiMedium(size: 14, color: color6C7378),
                ),
                SizedBox(
                  width: 280,
                  child: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: styleSatoshiLarge(size: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding buildPrefProfileRow({
    required String image,
    required String title,
    required String text,
    required IconData iconRightWrong,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 18.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SvgPicture.asset(
              image,
              height: 48,
              width: 48,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: styleSatoshiMedium(size: 14, color: color6C7378),
                ),
                SizedBox(
                  width: 280,
                  child: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: styleSatoshiLarge(size: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Icon(iconRightWrong))

          // Expanded(
          //     child: Image.asset(
          //   icon,
          //   height: 18,
          // ))
        ],
      ),
    );
  }
}

class UserProfileShimmer extends StatelessWidget {
  const UserProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmerEffect(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(32),
                              bottomLeft: Radius.circular(32)),
                          child: Container(
                            color: Colors.grey.withOpacity(0.40),
                            height: 400,
                            width: double.infinity,
                          )),
                      Positioned(
                        bottom: 26,
                        left: 26,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "User",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: styleSatoshiBold(
                                      size: 30, color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              StringUtils.capitalize("Religion"),
                              style: styleSatoshiBold(
                                  size: 16, color: Colors.white),
                            ),
                            Row(
                              children: [
                                Text(
                                  StringUtils.capitalize('Yrs'),
                                  style: styleSatoshiBold(
                                      size: 16, color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  StringUtils.capitalize('Height'),
                                  style: styleSatoshiBold(
                                      size: 16, color: Colors.white),
                                ),
                              ],
                            ),
                            sizedBox16(),
                            const SimmerTextHolder(
                              width: 200,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 30),
                        child: backButton(
                            context: context,
                            image: icArrowLeft,
                            onTap: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                ],
              ),
              sizedBox20(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: styleSatoshiBold(size: 16, color: color1C1C1c),
                        ),
                        sizedBox10(),
                        ReadMoreText(
                          '' ?? "",
                          trimLines: 4,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: ' Show less',
                          moreStyle:
                          styleSatoshiLight(size: 14, color: primaryColor),
                          lessStyle:
                          styleSatoshiLight(size: 14, color: primaryColor),
                        ),
                      ],
                    ),
                    sizedBox16(),
                    Text(
                      "Professional Info",
                      style: styleSatoshiBold(size: 16, color: color1C1C1c),
                    ),
                    // Text("Professional Info",style:styleSatoshiMedium(size: 16, color: primaryColor)),
                    sizedBox16(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  icEducation,
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                              sizedBox6(),
                              Text(
                                // '' ,
                                'Degree',
                                textAlign: TextAlign.center,
                                style: styleSatoshiMedium(
                                  size: 14,
                                  color: Colors.black.withOpacity(0.70),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                icUserBagIcon,
                                height: 20,
                                width: 20,
                              ),
                              sizedBox6(),
                              Text(
                                StringUtils.capitalize("Profession"),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: styleSatoshiMedium(
                                  size: 14,
                                  color: Colors.black.withOpacity(0.70),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sizedBox12(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                icUserHeightIcon,
                                height: 20,
                                width: 20,
                              ),
                              sizedBox6(),
                              Text(
                                "Height",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: styleSatoshiMedium(
                                  size: 14,
                                  color: Colors.black.withOpacity(0.70),
                                ),
                              )
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Image.asset(
                        //         icUserLocationIcon,
                        //         height: 20,
                        //         width: 20,
                        //       ),
                        //       sizedBox6(),
                        //       Text(
                        //         'Country',
                        //         textAlign: TextAlign.center,
                        //         style: styleSatoshiMedium(
                        //           size: 14,
                        //           color: Colors.black.withOpacity(0.70),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    sizedBox20(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBox10(),
                        Text(
                          "Basic Info",
                          style: styleSatoshiBold(size: 16, color: color1C1C1c),
                        ),
                        sizedBox16(),
                        const SimmerTextHolder(),
                        sizedBox16(),
                        const SimmerTextHolder(
                          width: 200,
                        ),
                        sizedBox16(),
                        const SimmerTextHolder(
                          width: 160,
                        ),
                        // Card(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(12.0),
                        //     child: Column(children: [
                        //       buildProfileRow(image: birthHolder, title: 'Age',
                        //           text:  "Age", onTap: () {  }),
                        //       const Divider(),
                        //       buildProfileRow(image: icHeightIcon, title: 'Height',
                        //           text:
                        //            'Height', onTap: () {  }
                        //       ),
                        //       const Divider(),
                        //
                        //       buildProfileRow(image: icReligionIcon,
                        //           title: 'Religion',
                        //           text: "Religion", onTap: () {  } ),
                        //       const Divider(),
                        //       buildProfileRow(image: icMotherToungeIcon,
                        //           title: 'Mother Tongue',
                        //           text: "Mother Tongue", onTap: () {  }
                        //       ),
                        //       const Divider(),
                        //       buildProfileRow(image: icMarriedStatusPro,
                        //           title: 'Married Status',
                        //           text: "Married Status", onTap: () {  }
                        //       ),
                        //
                        //     ],),
                        //   ),
                        // ),
                        // sizedBox16(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
