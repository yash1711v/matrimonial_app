import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/utils/colors.dart';
import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/src/constants/fonts.dart';
import 'package:bureau_couple/src/utils/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../src/utils/widgets/buttons.dart';

class EditInterestScreen extends StatefulWidget {
  const EditInterestScreen({Key? key}) : super(key: key);

  @override
  State<EditInterestScreen> createState() => _EditInterestScreenState();
}

class _EditInterestScreenState extends State<EditInterestScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Simulating API data
      Get.find<AuthController>().getInterests().then((value) {
        List<Map<String, dynamic>> interests = [];
        value.forEach((element) {
          interests.add({
            "category_name": element.interestName,
            "interests": element.hobbies
          });
        });
        Get.find<AuthController>().initCategories(interests);
      });
      debugPrint("UserInterest:===>${Get.find<AuthController>().selectedInterests}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Edit Interest',
        isBackButtonExist: true,
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            children: [
              Visibility(
                visible: authController.selectedInterests.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Your Habits",
                            style: kManrope25Black.copyWith(fontSize: 22),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8.0,
                                children: authController.selectedInterests
                                    .map((interest) {
                                  return GetBuilder<AuthController>(
                                      builder: (controller) {
                                    return ChoiceChip(
                                      backgroundColor: controller
                                              .selectedInterests
                                              .contains(interest)
                                          ? color4B164C.withOpacity(0.80)
                                          : Colors.white,
                                      selectedColor:
                                          color4B164C.withOpacity(0.80),
                                      label: Text(
                                        interest,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: controller.selectedInterests
                                                    .contains(interest)
                                                ? Colors.white
                                                : color4B164C
                                                    .withOpacity(0.80)),
                                      ),
                                      selected: controller.selectedInterests
                                          .contains(interest),
                                      onSelected: (selected) {
                                        controller.selectInterest(interest);
                                      },
                                    );
                                  });
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: authController.selectedInterests.isNotEmpty,
                  child: const SizedBox(height: 20)),
              Row(
                children: [
                  Text(
                    "Select Your Habbit",
                    style: kManrope25Black.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: authController.categories.map((category) {
                  final visibleInterests = category.isExpanded.value
                      ? category.interests
                      : category.interests.take(6).toList();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              category.name,
                              style: kManrope25Black.copyWith(fontSize: 22),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8.0,
                                  children: visibleInterests.map((interest) {
                                    return GetBuilder<AuthController>(
                                        builder: (controller) {
                                      return ChoiceChip(
                                        backgroundColor: controller
                                                .selectedInterests
                                                .contains(interest)
                                            ? color4B164C.withOpacity(0.80)
                                            : Colors.white,
                                        selectedColor:
                                            color4B164C.withOpacity(0.80),
                                        label: Text(
                                          interest,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: controller
                                                      .selectedInterests
                                                      .contains(interest)
                                                  ? Colors.white
                                                  : color4B164C
                                                      .withOpacity(0.80)),
                                        ),
                                        selected: controller.selectedInterests
                                            .contains(interest),
                                        onSelected: (selected) {
                                          controller.selectInterest(
                                              interest, category);
                                        },
                                      );
                                    });
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: button(context: context, onTap: () {
              final authController = Get.find<AuthController>();
              authController.saveInterests();
              // Get.back();
            }, title: "Save"),
          ),
        ),
      ),
    );
  }
}
