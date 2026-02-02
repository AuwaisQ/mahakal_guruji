import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/support/controllers/support_ticket_controller.dart';
import 'package:mahakal/features/support/domain/models/support_ticket_body.dart';
import 'package:mahakal/features/support/widgets/priority_bottom_sheet_widget.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';
import 'package:mahakal/common/basewidget/custom_app_bar_widget.dart';
import 'package:mahakal/common/basewidget/custom_button_widget.dart';
import 'package:mahakal/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:mahakal/common/basewidget/custom_textfield_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../auth/controllers/auth_controller.dart';
import '../model/issueslist_model.dart';
import '../model/support_ticket_model.dart';

class AddTicketScreen extends StatefulWidget {
  // final TicketModel ticketModel;
  const AddTicketScreen({super.key});

  @override
  AddTicketScreenState createState() => AddTicketScreenState();
}

class AddTicketScreenState extends State<AddTicketScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _subjectNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  String userToken = "";

  @override
  void initState() {
    super.initState();
    userToken =
        Provider.of<AuthController>(Get.context!, listen: false).getUserToken();
    getTicketList();
  }

  int selectedTicketIndex = -1;
  int selectedIssueIndex = -1;
  String selectedTicket = "Select query";
  String selectedIssue = "Ticket issues";
  String queryId = "";
  String issueId = "";
  List<Ticketlist> ticketModelList = <Ticketlist>[];
  List<Issuelist> issuesModelList = <Issuelist>[];

  void getTicketList() async {
    var res = await HttpService().getApi(AppConstants.supportIssuesTypeUrl);
    print("Api respons add ticket $res");
    List ticketList = res["data"];
    ticketModelList.addAll(ticketList.map((e) => Ticketlist.fromJson(e)));
  }

  Future<void> getIssue(String id) async {
    final response = await http.post(
      Uri.parse(AppConstants.baseUrl + AppConstants.supportIssuesUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"type": id}),
    );
    print("coupon post api: $id");
    var data = jsonDecode(response.body);
    if (data["status"] == 1) {
      setState(() {
        issuesModelList.clear();
        print("Api respons add issues $data");
        List issuetList = data["data"];
        issuesModelList.addAll(issuetList.map((e) => Issuelist.fromJson(e)));
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('add_new_ticket', context),
      ),
      body: Consumer<SupportTicketController>(
          builder: (context, supportTicketProvider, _) {
        return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            children: [
              // Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeTwelve),
              //     decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.125),
              //         border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.15)),
              //         borderRadius: BorderRadius.circular(Dimensions.paddingSizeEight)),
              //     margin:  const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
              //     child: Row(children: [
              //       SizedBox(width: 20, child: Image.asset(Images.icon)),
              //       Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              //           child: Text("changes", style: textBold))])),

              // ticket query
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                  child: InkWell(
                      onTap: () => showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) => Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(
                                            Dimensions.paddingSizeDefault))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.1),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: ticketModelList.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  selectedTicket =
                                                      ticketModelList[index]
                                                          .name;
                                                  selectedTicketIndex = index;
                                                  selectedIssueIndex = -1;
                                                  selectedIssue =
                                                      "Ticket issues";
                                                  queryId =
                                                      "${ticketModelList[index].id}";
                                                  getIssue(
                                                      "${ticketModelList[index].id}");
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        selectedTicketIndex ==
                                                                index
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                                .withOpacity(.1)
                                                            : Theme.of(context)
                                                                .cardColor),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeDefault),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                          ticketModelList[index]
                                                              .name,
                                                          style: textRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeDefault,
                                                              color: selectedTicketIndex ==
                                                                      index
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge
                                                                      ?.color),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              )),
                      child: Container(
                          width: MediaQuery.of(context).size.width * .5,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(.5))),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall),
                              child: Row(children: [
                                Expanded(
                                    child: Text(selectedTicket,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeLarge))),
                                const Icon(Icons.arrow_drop_down)
                              ]))))),

              // ticket issues
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                  child: InkWell(
                      onTap: () => showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) => Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(
                                            Dimensions.paddingSizeDefault))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.1),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: issuesModelList.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  selectedIssue =
                                                      issuesModelList[index]
                                                          .issueName;
                                                  selectedIssueIndex = index;
                                                  issueId =
                                                      "${issuesModelList[index].id}";
                                                  print(queryId);
                                                  print(issueId);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: selectedIssueIndex ==
                                                            index
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.1)
                                                        : Theme.of(context)
                                                            .cardColor),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeDefault),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                          issuesModelList[index]
                                                              .issueName,
                                                          style: textRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeDefault,
                                                              color: selectedIssueIndex ==
                                                                      index
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge
                                                                      ?.color),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              )),
                      child: Container(
                          width: MediaQuery.of(context).size.width * .5,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(.5))),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall),
                              child: Row(children: [
                                Expanded(
                                    child: Text(selectedIssue,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeLarge))),
                                const Icon(Icons.arrow_drop_down)
                              ]))))),

              Padding(
                  padding:
                      const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                  child: InkWell(
                      onTap: () => showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) => const PriorityBottomSheetWidget()),
                      child: Container(
                          width: MediaQuery.of(context).size.width * .5,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(.5))),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall),
                              child: Row(children: [
                                Expanded(
                                    child: Text(
                                        supportTicketProvider.selectedPriority,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeLarge))),
                                const Icon(Icons.arrow_drop_down)
                              ]))))),

              CustomTextFieldWidget(
                focusNode: _subjectNode,
                nextFocus: _descriptionNode,
                required: true,
                inputAction: TextInputAction.next,
                labelText: '${getTranslated('subject', context)}',
                hintText: getTranslated('write_your_subject', context),
                controller: _subjectController,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              CustomTextFieldWidget(
                  required: true,
                  focusNode: _descriptionNode,
                  inputAction: TextInputAction.newline,
                  hintText: getTranslated('issue_description', context),
                  inputType: TextInputType.multiline,
                  controller: _descriptionController,
                  labelText: '${getTranslated('description', context)}',
                  maxLines: 5),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      supportTicketProvider.pickedImageFileStored.length + 1,
                  itemBuilder: (BuildContext context, index) {
                    return index ==
                            supportTicketProvider.pickedImageFileStored.length
                        ? InkWell(
                            onTap: () =>
                                supportTicketProvider.pickMultipleImage(
                                  false,
                                ),
                            child: DottedBorder(
                                strokeWidth: 2,
                                dashPattern: const [10, 5],
                                color: Theme.of(context).hintColor,
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(
                                    Dimensions.paddingSizeSmall),
                                child: Stack(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.paddingSizeSmall),
                                      child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4.3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child:
                                              Image.asset(Images.placeholder))),
                                  Positioned(
                                      bottom: 0,
                                      right: 0,
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .paddingSizeSmall))))
                                ])))
                        : Stack(children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeSmall),
                                child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(Dimensions
                                                .paddingSizeExtraSmall)),
                                        child: Image.file(
                                            File(supportTicketProvider
                                                .pickedImageFileStored[index]
                                                .path),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4.3,
                                            fit: BoxFit.cover)))),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                    onTap: () => supportTicketProvider
                                        .pickMultipleImage(true, index: index),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Dimensions
                                                    .paddingSizeDefault))),
                                        child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                                Icons.delete_forever_rounded,
                                                color: Colors.red,
                                                size: 15)))))
                          ]);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10)),
            ]);
      }),
      bottomNavigationBar: Provider.of<SupportTicketController>(context)
              .isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor))),
              ],
            )
          : Container(
              color: Theme.of(context).cardColor,
              child: Consumer<SupportTicketController>(
                key: _scaffoldKey,
                builder: (context, supportTicketProvider, _) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall),
                  child: CustomButton(
                      buttonText: getTranslated('submit', context),
                      onTap: () {
                        if (selectedTicketIndex == -1) {
                          showCustomSnackBar("Query is required", context);
                        } else if (selectedIssueIndex == -1) {
                          showCustomSnackBar("Issues is required", context);
                        } else if (_subjectController.text.isEmpty) {
                          showCustomSnackBar(
                              getTranslated('subject_is_required', context),
                              context);
                        } else if (_descriptionController.text.isEmpty) {
                          showCustomSnackBar(
                              getTranslated('description_is_required', context),
                              context);
                        } else if (supportTicketProvider
                                .selectedPriorityIndex ==
                            -1) {
                          showCustomSnackBar(
                              getTranslated('priority_is_required', context),
                              context);
                        } else {
                          print(queryId);
                          print(issueId);
                          SupportTicketBody supportTicketModel =
                              SupportTicketBody(
                                  queryId,
                                  issueId,
                                  _subjectController.text,
                                  _descriptionController.text,
                                  supportTicketProvider.selectedPriority);
                          supportTicketProvider
                              .createSupportTicket(supportTicketModel);
                        }
                      }),
                ),
              ),
            ),
    );
  }
}
