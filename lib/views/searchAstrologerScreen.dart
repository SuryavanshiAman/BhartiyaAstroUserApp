// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:BharatiyAstro/controllers/astromallController.dart';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/callController.dart';
import 'package:BharatiyAstro/controllers/history_controller.dart';
import 'package:BharatiyAstro/controllers/search_controller.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/astromall/astromallScreen.dart';
import 'package:BharatiyAstro/views/astromall/productDetailScreen.dart';
import 'package:BharatiyAstro/views/bottomNavigationBarScreen.dart';
import 'package:BharatiyAstro/views/callIntakeFormScreen.dart';
import 'package:BharatiyAstro/views/customer_support/customerSupportChatScreen.dart';
import 'package:BharatiyAstro/views/liveAstrologerList.dart';
import 'package:BharatiyAstro/views/paymentInformationScreen.dart';
import 'package:BharatiyAstro/views/profile/editUserProfileScreen.dart';
import 'package:BharatiyAstro/widget/popular_search_widget.dart';
import 'package:BharatiyAstro/widget/quickLinkWiget.dart';
import 'package:BharatiyAstro/widget/topServicesWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import '../controllers/astrologer_assistant_controller.dart';
import '../controllers/chatController.dart';
import '../controllers/customer_support_controller.dart';
import '../controllers/razorPayController.dart';
import '../controllers/reviewController.dart';
import '../controllers/walletController.dart';
import 'astrologerProfile/astrologerProfile.dart';

class SearchAstrologerScreen extends StatelessWidget {
  final String type;
  SearchAstrologerScreen({Key? key, this.type = 'Chat'}) : super(key: key);
  final ChatController chatController = ChatController();
  WalletController walletController = Get.find<WalletController>();
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  CallController callController = Get.find<CallController>();
  SearchController searchControllerr = Get.find<SearchController>();
  HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SearchController searchController = Get.find<SearchController>();
        searchController.serachTextController.clear();
        searchController.searchText = "";
        searchController.update();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          leading: IconButton(
            onPressed: () {
              SearchController searchController = Get.find<SearchController>();
              searchController.serachTextController.clear();
              searchController.searchText = "";
              searchController.update();
              Get.back();
            },
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Get.theme.iconTheme.color,
            ),
          ),
          title: GetBuilder<SearchController>(builder: (searchController) {
            return FutureBuilder(
                future: global.translatedText('Search astrologers, astromall products'),
                builder: (context, snapdhot) {
                  return TextField(
                      controller: searchController.serachTextController,
                      onChanged: (value) async {
                        searchController.searchText = value;
                        if (value.length > 2) {
                          // searchController.searchFnode.unfocus();
                          // global.showOnlyLoaderDialog(context);
                          searchController.astrologerList.clear();
                          searchController.astroProduct.clear();
                          searchController.isAllDataLoaded = false;
                          searchController.isAllDataLoadedForAstromall = false;
                          searchController.searchString = value;
                          searchController.update();
                          await searchController.getSearchResult(value, null, false);
                          // global.hideLoader();
                        }
                        searchController.update();
                      },
                      focusNode: searchControllerr.searchFnode,
                      decoration: InputDecoration(
                          hintText: snapdhot.data,
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          suffix: searchController.serachTextController.text != ""
                              ? GestureDetector(
                                  child: Icon(Icons.close),
                                  onTap: () {
                                    searchController.serachTextController.clear();
                                    searchController.searchText = '';
                                    searchControllerr.update();
                                  },
                                )
                              : SizedBox()));
                });
          }),
        ),
        body: GetBuilder<SearchController>(builder: (searchController) {
          return searchController.searchText == ""
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text('Top Services'),
                      SizedBox(
                        height: 8,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          TopServicesWidget(
                            icon: Icons.phone,
                            color: Color.fromARGB(255, 212, 228, 241),
                            text: 'Call',
                            onTap: () {
                              BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                              bottomNavigationController.setIndex(3, 0);
                              Get.to(() => BottomNavigationBarScreen(
                                    index: 3,
                                  ));
                            },
                          ),
                          TopServicesWidget(
                            icon: Icons.chat,
                            color: Color.fromARGB(255, 238, 221, 236),
                            text: 'Chat',
                            onTap: () {
                              BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                              bottomNavigationController.setIndex(1, 0);
                              Get.to(() => BottomNavigationBarScreen(
                                    index: 1,
                                  ));
                            },
                          ),
                          TopServicesWidget(
                            icon: Icons.live_tv,
                            color: Color.fromARGB(255, 235, 236, 221),
                            text: 'Live',
                            onTap: () {
                              Get.to(() => LiveAstrologerListScreen());
                            },
                          ),
                          TopServicesWidget(
                              icon: Icons.shopping_bag,
                              color: Color.fromARGB(255, 223, 240, 221),
                              text: 'Astromall',
                              onTap: () {
                                Get.to(() => AstromallScreen());
                              })
                        ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Quick Link'),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuickLinnkWidget(
                            text: 'Wallet',
                            image: Images.wallet,
                            onTap: () async {
                              bool isLogin = await global.isLogin();
                              if (isLogin) {
                                historyController.paymentAllDataLoaded = false;
                                historyController.walletTransactionList.clear();
                                historyController.walletAllDataLoaded = false;
                                historyController.update();
                                await historyController.getPaymentLogs(global.currentUserId!, false);
                                await historyController.getWalletTransaction(global.currentUserId!, false);
                                BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                                bottomNavigationController.setIndex(4, 0);
                                callController.setTabIndex(0);
                                Get.to(() => BottomNavigationBarScreen(index: 4));
                              }
                            },
                          ),
                          QuickLinnkWidget(
                            text: 'Customer Support',
                            image: Images.customerService,
                            onTap: () async {
                              bool isLogin = await global.isLogin();
                              if (isLogin) {
                                CustomerSupportController customerSupportController = Get.find<CustomerSupportController>();
                                AstrologerAssistantController astrologerAssistantController =
                                    Get.find<AstrologerAssistantController>();
                                // global.showOnlyLoaderDialog(context);
                                await customerSupportController.getCustomerTickets();
                                await astrologerAssistantController.getChatWithAstrologerAssisteant();
                                // global.hideLoader();
                                Get.to(() => CustomerSupportChat());
                              }
                            },
                          ),
                          QuickLinnkWidget(
                            text: 'Order History',
                            image: Images.shopBag,
                            onTap: () async {
                              bool isLogin = await global.isLogin();
                              if (isLogin) {
                                historyController.callHistoryList = [];
                                historyController.callHistoryList.clear();
                                historyController.callAllDataLoaded = false;
                                historyController.update();
                                await historyController.getCallHistory(global.currentUserId!, false);
                                BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                                bottomNavigationController.setIndex(4, 1);
                                callController.setTabIndex(1);
                                Get.to(() => BottomNavigationBarScreen(index: 4));
                              }
                            },
                          ),
                          QuickLinnkWidget(
                            text: 'Profile',
                            image: Images.userProfile,
                            onTap: () async {
                              bool isLogin = await global.isLogin();
                              if (isLogin) {
                                SplashController splashController = Get.find<SplashController>();
                                global.showOnlyLoaderDialog(context);
                                await splashController.getCurrentUserData();
                                global.hideLoader();
                                Get.to(() => EditUserProfile());
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : !searchController.isAllDataAstroLoaded
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: searchController.searchData.length,
                              itemBuilder: (context, index) {
                                return GetBuilder<SearchController>(builder: (c) {
                                  return GestureDetector(
                                    onTap: () {
                                      global.showOnlyLoaderDialog(context);
                                      searchController.selectSearchTab(index);
                                      searchController.astrologerList.clear();
                                      searchController.astroProduct.clear();
                                      searchController.isAllDataLoaded = false;
                                      searchController.isAllDataLoadedForAstromall = false;
                                      searchController.searchString = searchController.searchText;
                                      searchController.update();
                                      searchController.getSearchResult(searchController.searchText, null, false);
                                      global.hideLoader();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            color: searchController.searchData[index].isSelected
                                                ? Color.fromARGB(255, 247, 243, 213)
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: searchController.searchData[index].isSelected
                                                    ? Get.theme.primaryColor
                                                    : Colors.black),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Text(searchController.searchData[index].title, style: TextStyle(fontSize: 13))),
                                    ),
                                  );
                                });
                              }),
                        ),
                        searchController.searchTabIndex == 0
                            ? Expanded(
                                child: searchController.astrologerList.isEmpty
                                    ? searchResultNotFound()
                                    : ListView.builder(
                                        itemCount: searchController.astrologerList.length,
                                        shrinkWrap: true,
                                        controller: searchController.searchScrollController,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () async {
                                              Get.find<ReviewController>()
                                                  .getReviewData(searchController.astrologerList[index].id ?? 0);
                                              global.showOnlyLoaderDialog(context);
                                              await bottomNavigationController
                                                  .getAstrologerbyId(searchController.astrologerList[index].id ?? 0);
                                              global.hideLoader();
                                              Get.to(() => AstrologerProfile(
                                                    index: index,
                                                  ));
                                            },
                                            child: Column(
                                              children: [
                                                Card(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 10),
                                                                      child: Container(
                                                                        height: 75,
                                                                        width: 75,
                                                                        decoration: BoxDecoration(
                                                                          // border: Border.all(
                                                                          //     color: Get.theme.primaryColor),
                                                                          borderRadius: BorderRadius.circular(7),
                                                                        ),
                                                                        child: CircleAvatar(
                                                                          radius: 35,
                                                                          backgroundColor: Colors.white,
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(15),
                                                                            child: CachedNetworkImage(
                                                                              height: 75,
                                                                              width: 85,
                                                                              fit: BoxFit.cover,
                                                                              imageUrl:
                                                                                  '${global.imgBaseurl}${searchController.astrologerList[index].profileImage}',
                                                                              placeholder: (context, url) => const Center(
                                                                                  child: CircularProgressIndicator()),
                                                                              errorWidget: (context, url, error) => Image.asset(
                                                                                Images.deafultUser,
                                                                                fit: BoxFit.cover,
                                                                                height: 50,
                                                                                width: 40,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Positioned(
                                                                    //     right: 0,
                                                                    //     top: 2,
                                                                    //     child:)
                                                                  ],
                                                                ),
                                                                RatingBar.builder(
                                                                  initialRating: 0,
                                                                  itemCount: 5,
                                                                  allowHalfRating: false,
                                                                  itemSize: 15,
                                                                  ignoreGestures: true,
                                                                  itemBuilder: (context, _) => Icon(
                                                                    Icons.star,
                                                                    color: Get.theme.primaryColor,
                                                                  ),
                                                                  onRatingUpdate: (rating) {},
                                                                ),
                                                                searchController.astrologerList[index].totalOrder == 0 ||
                                                                        searchController.astrologerList[index].totalOrder == null
                                                                    ? SizedBox()
                                                                    : Text(
                                                                        '${searchController.astrologerList[index].totalOrder} orders',
                                                                        style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                          fontWeight: FontWeight.w300,
                                                                          fontSize: 9,
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      searchController.astrologerList[index].name ?? "",
                                                                    ),
                                                                    searchController.astrologerList[index].allSkill == ""
                                                                        ? const SizedBox()
                                                                        : Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.skateboarding_outlined,
                                                                                color: Colors.grey[600],
                                                                                size: 15,
                                                                              ),
                                                                              SizedBox(
                                                                                width: Get.width * 0.60,
                                                                                child: Text(
                                                                                  searchController
                                                                                          .astrologerList[index].allSkill ??
                                                                                      "",
                                                                                  style: Get.theme.primaryTextTheme.bodySmall!
                                                                                      .copyWith(
                                                                                    fontWeight: FontWeight.w300,
                                                                                    color: Colors.grey[600],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                    searchController.astrologerList[index].languageKnown == ""
                                                                        ? const SizedBox()
                                                                        : Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.language,
                                                                                color: Colors.grey[600],
                                                                                size: 15,
                                                                              ),
                                                                              SizedBox(
                                                                                width: Get.width * 0.60,
                                                                                child: Text(
                                                                                  searchController
                                                                                          .astrologerList[index].languageKnown ??
                                                                                      "",
                                                                                  style: Get.theme.primaryTextTheme.bodySmall!
                                                                                      .copyWith(
                                                                                    fontWeight: FontWeight.w300,
                                                                                    color: Colors.grey[600],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.perm_contact_cal_outlined,
                                                                          color: Colors.grey[600],
                                                                          size: 15,
                                                                        ),
                                                                        Text(
                                                                          'Experience : ${searchController.astrologerList[index].experienceInYears} Years',
                                                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                            fontWeight: FontWeight.w300,
                                                                            color: Colors.grey[600],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        // searchController.astrologerList[index].isFreeAvailable ==
                                                                        //         true
                                                                        //     ? Text(
                                                                        //         'FREE',
                                                                        //         style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                        //           fontSize: 12,
                                                                        //           fontWeight: FontWeight.w500,
                                                                        //           letterSpacing: 0,
                                                                        //           color: Color.fromARGB(255, 167, 1, 1),
                                                                        //         ),
                                                                        //       )
                                                                        //     : const SizedBox(),
                                                                        // SizedBox(
                                                                        //   width: searchController
                                                                        //               .astrologerList[index].isFreeAvailable ==
                                                                        //           true
                                                                        //       ? 10
                                                                        //       : 0,
                                                                        // ),
                                                                        Text(
                                                                          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${searchController.astrologerList[index].charge}/min',
                                                                          style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                            fontSize: 12,
                                                                            fontWeight: FontWeight.w500,
                                                                            letterSpacing: 0,
                                                                            // decoration: searchController
                                                                            //             .astrologerList[index].isFreeAvailable ==
                                                                            //         true
                                                                            //     ? TextDecoration.lineThrough
                                                                            //     : null,
                                                                            color:
                                                                            //  searchController
                                                                            //             .astrologerList[index].isFreeAvailable ==
                                                                            //         true
                                                                            //     ? Colors.grey
                                                                                // :
                                                                                 Color.fromARGB(255, 167, 1, 1),
                                                                          ),
                                                                        ),
                                                                        searchController.astrologerList[index].chatStatus ==
                                                                                "Online"
                                                                            ? Icon(
                                                                                Icons.circle,
                                                                                color: Colors.green,
                                                                                size: 20,
                                                                              )
                                                                            : Icon(
                                                                                Icons.circle,
                                                                                color: Colors.red,
                                                                                size: 20,
                                                                              )
                                                                    
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons.verified,
                                                              color: Color.fromARGB(255, 21, 123, 17),
                                                            )
                                                            //     Column(
                                                            //       children: [
                                                            //  ,

                                                            //       ],
                                                            //     )
                                                          ],
                                                        ),
                                                        SizedBox(height: 15),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            buttonWidget('Chat', Images.chatSmall, () async {
                                                              bool isLogin = await global.isLogin();
                                                              log("==============balance amount${searchController.astrologerList[index].charge! *
                                                               5}==============${searchController.astrologerList[index].charge! * 5
                                                                <= (global.splashController.currentUser!.walletAmount ?? 0.0)}===========================>${
                                                                  global.splashController.currentUser!.walletAmount}");
                                                              if (isLogin) {
                                                                if (global.user.name == "") {
                                                                  global.showOnlyLoaderDialog(context);
                                                                  await global.splashController.getCurrentUserData();
                                                                  global.hideLoader();
                                                                  Get.to(() => EditUserProfile());
                                                                } else if (searchController.astrologerList[index].charge! * 5 <=
                                                                    (global.splashController.currentUser!.walletAmount ?? 0.0)) {
                                                                  await bottomNavigationController.checkAlreadyInReq(
                                                                      searchController.astrologerList[index].id ?? 0);
                                                                  if (bottomNavigationController.isUserAlreadyInChatReq ==
                                                                      false) {
                                                                    if (searchController.astrologerList[index].chatStatus ==
                                                                            "Online" ||
                                                                        searchController.astrologerList[index].chatStatus ==
                                                                            "Wait Time") {
                                                                      global.showOnlyLoaderDialog(context);

                                                                      if (searchController.astrologerList[index].chatWaitTime !=
                                                                          null) {
                                                                        if (searchController.astrologerList[index].chatWaitTime!
                                                                                .difference(DateTime.now())
                                                                                .inMinutes <
                                                                            0) {
                                                                          await bottomNavigationController.changeOfflineStatus(
                                                                              searchController.astrologerList[index].id,
                                                                              "Online");
                                                                        }
                                                                      }
                                                                      log("   id =====================>${searchController.astrologerList[index].id}  name==============>  ${searchController.astrologerList[index].name}");
                                                                      await Get.to(() => CallIntakeFormScreen(
                                                                            type: "Chat",
                                                                            astrologerId:
                                                                                searchController.astrologerList[index].id ?? 0,
                                                                            astrologerName:
                                                                                searchController.astrologerList[index].name ?? "",
                                                                            astrologerProfile: searchController
                                                                                    .astrologerList[index].profileImage ??
                                                                                "",
                                                                            isFreeAvailable: searchController
                                                                                .astrologerList[index].isFreeAvailable,
                                                                          ));

                                                                      global.hideLoader();
                                                                    } else if (searchController
                                                                            .astrologerList[index].chatStatus ==
                                                                        "Offline") {
                                                                      bottomNavigationController
                                                                          .dialogForJoinInWaitListForListPageOnly(
                                                                        context,
                                                                        searchController.astrologerList[index].name ?? "",
                                                                        true,
                                                                        searchController.astrologerList[index].id ?? 0,
                                                                        searchController.astrologerList[index].profileImage ?? "",
                                                                        searchController.astrologerList[index].charge ?? 0,
                                                                        searchController.astrologerList[index].isFreeAvailable ??
                                                                            false,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    bottomNavigationController
                                                                        .dialogForNotCreatingSession(context);
                                                                  }
                                                                } else {
                                                                  global.showOnlyLoaderDialog(context);
                                                                  await walletController.getAmount();
                                                                  global.hideLoader();
                                                                  openBottomSheetRechrage(
                                                                      context,
                                                                      (searchController.astrologerList[index].charge! * 5)
                                                                          .toString(),
                                                                      searchController.astrologerList[index].name ?? "");
                                                                }
                                                              }
                                                            }, false),
                                                            buttonWidget('Call', Images.callSmall, () async {
                                                              bool isLogin = await global.isLogin();
                                                              if (isLogin) {
                                                                log(
                                                                    'charge${global.splashController.currentUser!.walletAmount! * 5}');
                                                                if (searchController.astrologerList[index].charge! * 5 <=
                                                                        global.splashController.currentUser!.walletAmount!
                                                                    ) {
                                                                  await bottomNavigationController.checkAlreadyInReqForCall(
                                                                      searchController.astrologerList[index].id ?? 0);
                                                                  if (bottomNavigationController.isUserAlreadyInCallReq ==
                                                                      false) {
                                                                    if (searchController.astrologerList[index].callStatus ==
                                                                            "Online" ||
                                                                        searchController.astrologerList[index].callStatus ==
                                                                            "Wait Time") {
                                                                      global.showOnlyLoaderDialog(context);
                                                                      if (searchController.astrologerList[index].callWaitTime !=
                                                                          null) {
                                                                        if (searchController.astrologerList[index].callWaitTime!
                                                                                .difference(DateTime.now())
                                                                                .inMinutes <
                                                                            0) {
                                                                          await bottomNavigationController
                                                                              .changeOfflineCallStatus(
                                                                                  searchController.astrologerList[index].id,
                                                                                  "Online");
                                                                        }
                                                                      }
                                                                      await Get.to(() => CallIntakeFormScreen(
                                                                            astrologerProfile: searchController
                                                                                    .astrologerList[index].profileImage ??
                                                                                "",
                                                                            type: "Call",
                                                                            astrologerId:
                                                                                searchController.astrologerList[index].id ?? 0,
                                                                            astrologerName:
                                                                                searchController.astrologerList[index].name ?? "",
                                                                            isFreeAvailable: searchController
                                                                                .astrologerList[index].isFreeAvailable,
                                                                          ));

                                                                      global.hideLoader();
                                                                    } else if (searchController
                                                                            .astrologerList[index].callStatus ==
                                                                        "Offline") {
                                                                      bottomNavigationController
                                                                          .dialogForJoinInWaitListForListPageOnly(
                                                                        context,
                                                                        searchController.astrologerList[index].name ?? "",
                                                                        false,
                                                                        searchController.astrologerList[index].id ?? 0,
                                                                        searchController.astrologerList[index].profileImage ?? "",
                                                                        searchController.astrologerList[index].charge ?? 0,
                                                                        searchController.astrologerList[index].isFreeAvailable ??
                                                                            false,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    bottomNavigationController
                                                                        .dialogForNotCreatingSession(context);
                                                                  }
                                                                } else {
                                                                  global.showOnlyLoaderDialog(context);
                                                                  await walletController.getAmount();
                                                                  global.hideLoader();
                                                                  openBottomSheetRechrage(
                                                                      context,
                                                                      (searchController.astrologerList[index].charge! * 5)
                                                                          .toString(),
                                                                      '${searchController.astrologerList[index].name}');
                                                                }
                                                              }
                                                            }, false),
                                                            buttonWidget('VideoCall', Images.videoCall, () async {
                                                              //     await [Permission.microphone, Permission.camera].request();
                                                              // Get.to(()=>VideoCallScreen());

                                                              //               bool isLogin = await global.isLogin();
                                                              // if (isLogin) {
                                                              //      if (astrologerList[index].charge * 5 <=
                                                              //         global.splashController.currentUser!
                                                              //             .walletAmount! ||
                                                              //     astrologerList[index].isFreeAvailable == true) {
                                                              //          await bottomNavigationController
                                                              //         .checkAlreadyInReqForVideoCall(
                                                              //             astrologerList[index].id);
                                                              //      if (bottomNavigationController.isUserAlreadyInVideoCallReq==false) {
                                                              //             await Get.to(() => CallIntakeFormScreen(
                                                              //         astrologerProfile:
                                                              //             astrologerList[index].profileImage,
                                                              //         type: "VideoCall",
                                                              //         astrologerId: astrologerList[index].id,
                                                              //         astrologerName: astrologerList[index].name,
                                                              //         isFreeAvailable:
                                                              //             astrologerList[index].isFreeAvailable,
                                                              //       ));
                                                              //      } else {
                                                              //       bottomNavigationController
                                                              //           .dialogForNotCreatingSession(context);}

                                                              // } else {
                                                              //   global.showOnlyLoaderDialog(context);
                                                              //   await walletController.getAmount();
                                                              //   global.hideLoader();
                                                              //   openBottomSheetRechrage(
                                                              //       context,
                                                              //       (astrologerList[index].charge * 5).toString(),
                                                              //       '${astrologerList[index].name}');
                                                              // }
                                                              // }

                                                              // bool isLogin = await global.isLogin();
                                                              // if (isLogin) {
                                                              //   print('charge${global.splashController.currentUser!.walletAmount! * 5}');
                                                              //   if (astrologerList[index].charge * 5 <= global.splashController.currentUser!.walletAmount! || astrologerList[index].isFreeAvailable == true) {
                                                              //     await bottomNavigationController.checkAlreadyInReqForCall(astrologerList[index].id);
                                                              //     if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                                                              //       if (astrologerList[index].callStatus == "Online" || astrologerList[index].callStatus == "Wait Time") {
                                                              //         global.showOnlyLoaderDialog(context);
                                                              //         if (astrologerList[index].callWaitTime != null) {
                                                              //           if (astrologerList[index].callWaitTime!.difference(DateTime.now()).inMinutes < 0) {
                                                              //             await bottomNavigationController.changeOfflineCallStatus(astrologerList[index].id, "Online");
                                                              //           }
                                                              //         }
                                                              //         await Get.to(() => CallIntakeFormScreen(
                                                              //               astrologerProfile: astrologerList[index].profileImage,
                                                              //               type: "Video Call",
                                                              //               astrologerId: astrologerList[index].id,
                                                              //               astrologerName: astrologerList[index].name,
                                                              //               isFreeAvailable: astrologerList[index].isFreeAvailable,
                                                              //             ));

                                                              //         global.hideLoader();
                                                              //       } else if (astrologerList[index].callStatus == "Offline") {
                                                              //         bottomNavigationController.dialogForJoinInWaitListForListPageOnly(
                                                              //           context,
                                                              //           astrologerList[index].name,
                                                              //           false,
                                                              //           astrologerList[index].id,
                                                              //           astrologerList[index].profileImage,
                                                              //           astrologerList[index].charge,
                                                              //           astrologerList[index].isFreeAvailable,
                                                              //         );
                                                              //       }
                                                              //     } else {
                                                              //       bottomNavigationController.dialogForNotCreatingSession(context);
                                                              //     }
                                                              //   } else {
                                                              //     global.showOnlyLoaderDialog(context);
                                                              //     await walletController.getAmount();
                                                              //     global.hideLoader();
                                                              //     openBottomSheetRechrage(context, (astrologerList[index].charge * 5).toString(), '${astrologerList[index].name}');
                                                              //   }
                                                              // }
                                                            }, true)
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                bottomNavigationController.isMoreDataAvailable == true &&
                                                        !bottomNavigationController.isAllDataLoaded &&
                                                        searchController.astrologerList.length - 1 == index
                                                    ? Column(
                                                        children: [
                                                          const CircularProgressIndicator(),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                                if (index == searchController.astrologerList.length - 1)
                                                  const SizedBox(
                                                    height: 30,
                                                  )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              )
                            : Expanded(
                                child: searchController.astroProduct.isEmpty
                                    ? searchResultNotFound()
                                    : ListView.builder(
                                        itemCount: searchController.astroProduct.length,
                                        shrinkWrap: true,
                                        controller: searchController.searchAstromallScrollController,
                                        padding: const EdgeInsets.all(10),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () async {
                                              AstromallController astromallController = Get.find<AstromallController>();
                                              global.showOnlyLoaderDialog(context);
                                              print('selected product id:- ${searchController.astroProduct[index].id}');
                                              await astromallController.getproductById(searchController.astroProduct[index].id);
                                              global.hideLoader();
                                              Get.to(() => ProductDetailScreen(index: index));
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Card(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 38,
                                                          backgroundColor: Get.theme.primaryColor,
                                                          child: CircleAvatar(
                                                            radius: 35,
                                                            backgroundColor: Colors.white,
                                                            child: CachedNetworkImage(
                                                              imageUrl:
                                                                  '${global.imgBaseurl}${searchController.astroProduct[index].productImage}',
                                                              imageBuilder: (context, imageProvider) =>
                                                                  CircleAvatar(radius: 35, backgroundImage: imageProvider),
                                                              placeholder: (context, url) =>
                                                                  const Center(child: CircularProgressIndicator()),
                                                              errorWidget: (context, url, error) => Image.asset(
                                                                Images.deafultUser,
                                                                fit: BoxFit.cover,
                                                                height: 50,
                                                                width: 40,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(searchController.astroProduct[index].name),
                                                              Text(
                                                                '${searchController.astroProduct[index].features}',
                                                                style: Get.textTheme.bodySmall,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Starting from: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${searchController.astroProduct[index].amount}/-',
                                                                    style: Get.textTheme.bodySmall,
                                                                  ),
                                                                  Container(
                                                                    padding: const EdgeInsets.all(5),
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(color: Colors.grey, width: 2),
                                                                      borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                                    child: Text('Buy Now'),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                searchController.isMoreDataAvailableForAstromall == true &&
                                                        !searchController.isAllDataLoadedForAstromall &&
                                                        searchController.astroProduct.length - 1 == index
                                                    ? const CircularProgressIndicator()
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ),
                      ],
                    );
        }),
      ),
    );
  }

  Widget searchResultNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.red,
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text('oops! No result found'),
          Text('try searching something else'),
          Text(
            'Popular Searches',
            style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
          FittedBox(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              PopularSearchWidget(
                icon: Icons.phone,
                color: Color.fromARGB(255, 212, 228, 241),
                text: 'Call',
                onTap: () {
                  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                  bottomNavigationController.setIndex(3, 0);
                  Get.to(() => BottomNavigationBarScreen(
                        index: 3,
                      ));
                },
              ),
              PopularSearchWidget(
                icon: Icons.chat,
                color: Color.fromARGB(255, 238, 221, 236),
                text: 'Chat',
                onTap: () {
                  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                  bottomNavigationController.setIndex(1, 0);
                  Get.to(() => BottomNavigationBarScreen(
                        index: 1,
                      ));
                },
              ),
              PopularSearchWidget(
                icon: Icons.live_tv,
                color: Color.fromARGB(255, 235, 236, 221),
                text: 'Live',
                onTap: () {
                  Get.to(() => LiveAstrologerListScreen());
                },
              ),
              PopularSearchWidget(
                  icon: Icons.shopping_bag,
                  color: Color.fromARGB(255, 223, 240, 221),
                  text: 'Astromall',
                  onTap: () {
                    Get.to(() => AstromallScreen());
                  })
            ]),
          ),
        ],
      ),
    );
  }

  void openBottomSheetRechrage(BuildContext context, String minBalance, String astrologer) {
    Get.bottomSheet(
      Wrap(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.85,
                                  child: minBalance != ''
                                      ? Text(
                                          'Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start conversation with $astrologer ',
                                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red))
                                      : const SizedBox(),
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: minBalance == '' ? const EdgeInsets.only(top: 8) : const EdgeInsets.only(top: 0),
                                    child: Icon(Icons.close, size: 18),
                                  ),
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                              child: Text('Recharge Now', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(Icons.lightbulb_rounded, color: Get.theme.primaryColor, size: 13),
                                ),
                                Expanded(
                                    child: Text(
                                        'Minimum balance required ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance',
                                        style: TextStyle(fontSize: 12)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
              child: GridView.builder(
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:MediaQuery.of(context).size.width<300?2:3,
                        childAspectRatio: 3 / 3.5,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                  // physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: walletController.rechrage.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.delete<RazorPayController>();
                        Get.to(() => PaymentInformationScreen(
                              amount: double.parse(walletController.paymentAmount[index].amount.toString()),
                              extraAmount: walletController.paymentAmount[index].amount! *
                                  (walletController.paymentAmount[index].offer! / 100),
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Container(
                          // padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: 2, color: Colors.black38)],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  gradient: LinearGradient(
                                      transform: GradientRotation(180), colors: [Colors.white, Get.theme.primaryColor]),
                                  borderRadius:
                                      BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                                height: 25,
                                child: Center(
                                  child: Text(
                                    '${walletController.paymentAmount[index].offer}% Extra',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.paymentAmount[index].amount}',
                                    style: Get.textTheme.titleSmall!.copyWith(color: Colors.black, fontSize: 16),
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  Text(
                                    'Get',
                                    style: Get.textTheme.titleSmall!.copyWith(
                                      color: Get.theme.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}  ${walletController.paymentAmount[index].amount! + (walletController.paymentAmount[index].offer! / 100) * int.parse("${walletController.paymentAmount[index].amount}")}',
                                    style: Get.textTheme.titleSmall!.copyWith(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }

  Widget buttonWidget(String name, String image, callBack, bool isVideo) {
    return InkWell(
      onTap: callBack,
      child: Container(
        height: !isVideo ? 38 : 38,
        width: !isVideo ? 100 : 120,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(offset: Offset(1, 1), color: Colors.black.withOpacity(0.15), blurRadius: 8, spreadRadius: 0)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                image,
                height: 25,
                width: 20,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '$name',
              style: Get.theme.primaryTextTheme.labelMedium!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 21, 123, 17)),
            )
          ],
        ),
      ),
    );
  }
}
