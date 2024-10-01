// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:BharatiyAstro/model/kundli.dart';
import 'package:BharatiyAstro/model/kundliBasicDetailMode.dart';
import 'package:BharatiyAstro/model/kundli_model.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:BharatiyAstro/views/kudali/ashtakvargaScreen.dart';
import 'package:BharatiyAstro/views/kudali/basicKundliScreen.dart';
import 'package:BharatiyAstro/views/kudali/chartsScreen.dart';
import 'package:BharatiyAstro/views/kudali/kpScreen.dart';
import 'package:BharatiyAstro/views/kudali/kundliDashaScreen.dart';
import 'package:BharatiyAstro/views/kudali/kundliReportScreen.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class KundliController extends GetxController with GetSingleTickerProviderStateMixin {
  TextEditingController userNameController = TextEditingController();
  TextEditingController birthKundliPlaceController = TextEditingController();

  TextEditingController editNameController = TextEditingController();
  TextEditingController editGenderController = TextEditingController();
  TextEditingController editBirthDateController = TextEditingController();
  TextEditingController editBirthTimeController = TextEditingController();
  TextEditingController editBirthPlaceController = TextEditingController();

  String? selectedGender;
  DateTime? selectedDate;
  String? selectedTime;
  double? lat;
  double? long;
  double? timeZone;
  var pdf = pw.Document();

  String emptyScreenText = "You haven\'t added any kundli yet!";

  bool isDisable = true;
  bool isTimeOfBirthKnow = false;
  bool isSelectedLanEng = true;
  bool isSelectedLanHin = false;
  bool isNorthIn = true;
  bool isSouthIn = false;
  bool isShowMore = false;
  bool isDataTable = false;
  int kundliTabInitialIndex = 5;

  var kundliList = <KundliModel>[];
  var kundaliBasicList = <KundliBasicModel>[];
  var searchKundliList = <KundliModel>[];
  KundliBasicDetail? kundliBasicDetail;
  KundliBasicPanchangDetail? kundliBasicPanchangDetail;
  KundliAvakhdaDetail? kundliAvakhadaDetail;
  KundliPlanetsDetail? kundliPlanetsDetail;
  GemstoneModel? gemstoneList;
  List<List<VimshattariModel>>? vimshattariList = [];
  var planetList = [];
  TabController? tabController;
  KundliPlanetsDetail sunDetails = KundliPlanetsDetail();
  KundliPlanetsDetail moonDetails = KundliPlanetsDetail();
  KundliPlanetsDetail marsDetails = KundliPlanetsDetail();
  KundliPlanetsDetail mercuryDetails = KundliPlanetsDetail();
  KundliPlanetsDetail jupiterDetails = KundliPlanetsDetail();
  KundliPlanetsDetail venusDetails = KundliPlanetsDetail();
  KundliPlanetsDetail saturnDetails = KundliPlanetsDetail();
  KundliPlanetsDetail rahuDetails = KundliPlanetsDetail();
  KundliPlanetsDetail ketuDetails = KundliPlanetsDetail();
  KundliPlanetsDetail ascendantDetails = KundliPlanetsDetail();
  bool? isSadesati;
  bool? isKalsarpa;
  String? generalDesc;

  APIHelper apiHelper = new APIHelper();
  String prefix = '';
  List<KundliGender> gender = [
    KundliGender(title: 'Male', isSelected: false, image: Images.male),
    KundliGender(title: 'Female', isSelected: false, image: Images.female),
    KundliGender(title: 'Other', isSelected: false, image: Images.otherGender),
  ];
  int initialIndex = 0;
  List kundliTitle = ['Hey there! \nWhat is Your name ?', 'What is your gender?', 'Enter your birth date', 'Enter your birth time', 'Where were you born?'];
  List<Kundli> listIcon = [
    Kundli(icon: Icons.person, isSelected: true),
    Kundli(icon: Icons.search, isSelected: false),
    Kundli(icon: Icons.calendar_month, isSelected: false),
    Kundli(icon: Icons.punch_clock_outlined, isSelected: false),
    Kundli(icon: Icons.location_city, isSelected: false),
  ];

  List<KundliDetailTab> reportTab = [
    KundliDetailTab(title: 'General', isSelected: true),
    // KundliDetailTab(title: 'Planetary', isSelected: false),
    // KundliDetailTab(title: 'Vimshottari Dasha', isSelected: false),
    // KundliDetailTab(title: 'Yoga', isSelected: false),
  ];

  // List<KundliDetailTab> remediesTab = [KundliDetailTab(title: 'Rudraksha', isSelected: true), KundliDetailTab(title: 'Gemstones', isSelected: false)];
  List<KundliDetailTab> remediesTab = [KundliDetailTab(title: 'Gemstones', isSelected: false)];
  List<KundliDetailTab> rudrakshaTab = [
    KundliDetailTab(title: '3-Mukhi', isSelected: true),
    KundliDetailTab(title: '12-Mukhi', isSelected: false),
    KundliDetailTab(title: '11-Mukhi', isSelected: false),
  ];
  List<KundliDetailTab> doshaTab = [
    KundliDetailTab(title: 'Manglik', isSelected: true),
    KundliDetailTab(title: 'Kalsarpa', isSelected: false),
    KundliDetailTab(title: 'Sadesati', isSelected: false),
  ];

  // List<KundliDetailTab> dashaTab = [KundliDetailTab(title: 'Vimshattari', isSelected: true), KundliDetailTab(title: 'Yogini', isSelected: false)];
  List<KundliDetailTab> dashaTab = [KundliDetailTab(title: 'Vimshattari', isSelected: true)];

  List<KundliDetailTab> ashtakvargaTab = [
    KundliDetailTab(title: 'Sav', isSelected: true),
    KundliDetailTab(title: 'Asc', isSelected: false),
    KundliDetailTab(title: 'jupiter', isSelected: false),
    KundliDetailTab(title: 'Mars', isSelected: false),
    KundliDetailTab(title: 'Mercury', isSelected: false),
    KundliDetailTab(title: 'Moon', isSelected: false),
    KundliDetailTab(title: 'Saturn', isSelected: false),
    KundliDetailTab(title: 'Sun', isSelected: false),
    KundliDetailTab(title: 'Venus', isSelected: false)
  ];

  List<KundliDetailTab> divisionalTab = [
    KundliDetailTab(title: 'Chalit', isSelected: true),
    KundliDetailTab(title: 'Sun', isSelected: false),
    KundliDetailTab(title: 'Moon', isSelected: false),
    KundliDetailTab(title: 'Hora(D-2)', isSelected: false),
    KundliDetailTab(title: 'Drekkana(D-3)', isSelected: false),
    KundliDetailTab(title: 'Chaturthamsa(D-4)', isSelected: false),
    KundliDetailTab(title: 'Scaptamsa(D-7)', isSelected: false),
    KundliDetailTab(title: 'Dasamsa(D-10)', isSelected: false),
    KundliDetailTab(title: 'Dwadasamsa(D-12)', isSelected: false),
    KundliDetailTab(title: 'Shodasamsa(D-16)', isSelected: false),
    KundliDetailTab(title: 'Vimsamsa(D-20)', isSelected: false),
    KundliDetailTab(title: 'Chaturvimsamsa', isSelected: false),
    KundliDetailTab(title: 'Saptavisamsa', isSelected: false),
    KundliDetailTab(title: 'Trimsamsa(D-30)', isSelected: false),
    KundliDetailTab(title: 'Khavedamsa(D-40)', isSelected: false),
    KundliDetailTab(title: 'Akshavedamsa(D-45)', isSelected: false),
    KundliDetailTab(title: 'Shastiamsa(D-60)', isSelected: false)
  ];

  List<KundliDetailTab> chartKundliTab = [
    KundliDetailTab(title: 'General', isSelected: true),
    KundliDetailTab(title: 'Planetary', isSelected: false),
    KundliDetailTab(title: 'Yoga', isSelected: false),
  ];
  List<KundliDetailTab> planetTab = [KundliDetailTab(title: 'Sign', isSelected: true), KundliDetailTab(title: 'Nakshatra', isSelected: false)];
  List<KundliDetails> basicDetails = [
    KundliDetails(title: 'Name', value: 'Yami'),
    KundliDetails(title: 'Date', value: '02 january 1996'),
    KundliDetails(title: 'Time', value: '01:46 PM'),
    KundliDetails(title: 'Place', value: 'New Delhi,Delhi,india'),
    KundliDetails(title: 'Latitude', value: '28.64'),
    KundliDetails(title: 'Longitude', value: '77.22'),
    KundliDetails(title: 'Timezone', value: 'GMT+5.5'),
    KundliDetails(title: 'Sunrise', value: '7:14:02AM'),
    KundliDetails(title: 'Sunset', value: '5:34:02PM'),
    KundliDetails(title: 'Ayanamsha', value: '23.80117'),
  ];
  List<KundliDetails> panchangDetails = [
    KundliDetails(title: 'Tithi', value: 'Shuklakadashi'),
    KundliDetails(title: 'Karan', value: 'Vishti'),
    KundliDetails(title: 'Yog', value: 'Sadhya'),
    KundliDetails(title: 'Nakshtra', value: 'Krittika'),
    KundliDetails(title: 'Timezone', value: 'GMT+5.5'),
    KundliDetails(title: 'Sunrise', value: '7:14:02AM'),
    KundliDetails(title: 'Sunset', value: '5:34:02PM'),
  ];

  List<KundliDetails> avakhadaDetails = [
    KundliDetails(title: 'Varna', value: 'Kshattriya'),
    KundliDetails(title: 'Vashya', value: 'Chatushpada'),
    KundliDetails(title: 'Yoni', value: 'Chaga'),
    KundliDetails(title: 'GAn', value: 'NewRakshasa'),
    KundliDetails(title: 'Nadi', value: 'Antya'),
    KundliDetails(title: 'Sign', value: 'Aries'),
    KundliDetails(title: 'Sign Lord', value: 'Mars'),
    KundliDetails(title: 'Nakshatra-charan', value: 'Krittika'),
    KundliDetails(title: 'Yog', value: 'Dashya'),
    KundliDetails(title: 'Karan', value: 'Cishti'),
    KundliDetails(title: 'Tithi', value: 'Shuklakadashi'),
    KundliDetails(title: 'Tatva', value: 'Fire'),
    KundliDetails(title: 'Name alphabet', value: 'S'),
    KundliDetails(title: 'Paya', value: 'Iron'),
  ];
  List<Widget> screens = [
    BasicKundliScreen(),
    ChartsScreen(),
    KPScreen(),
    AshtakvargaScreen(),
    KundliDashaScreen(),
    KundliReportScreen(),
  ];

  final List<Map<String, String>> listOfVishattari = [
    {"planet": "SU", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "MO", "start": "6-Jun-2000", "end": "16-Feb-2001"},
    {"planet": "MA", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "RA", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "JU", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "SA", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "ME", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "VE", "start": "16-Feb-1996", "end": "16-Feb-1998"},
  ];

  final List<Map<String, String>> listOfPlanets = [
    {"planet": "SU", "cups": "6", "sign": "Libra", "signLord": "Ve", "starLord": "Ma", "subLord": "Me"},
    {"planet": "Moon", "cups": "4", "sign": "Libra", "signLord": "sa", "starLord": "Ve", "subLord": "Ve"},
    {"planet": "Mars", "cups": "2", "sign": "Libra", "signLord": "Ju", "starLord": "Me", "subLord": "Ma"},
    {"planet": "Rahu", "cups": "6", "sign": "Gemni", "signLord": "Ve", "starLord": "Ma", "subLord": "Me"},
    {"planet": "Jupiter", "cups": "10", "sign": "Libra", "signLord": "Ve", "starLord": "Sa", "subLord": "Ra"},
    {"planet": "Saturn", "cups": "1", "sign": "Libra", "signLord": "Me", "starLord": "Ma", "subLord": "Sa"},
    {"planet": "Mercury", "cups": "12", "sign": "Libra", "signLord": "Ve", "starLord": "Ma", "subLord": "Me"},
    {"planet": "Ketu", "cups": "1", "sign": "Libra", "signLord": "Ve", "starLord": "Ma", "subLord": "Su"},
    {"planet": "Venus", "cups": "6", "sign": "Libra", "signLord": "Ma", "starLord": "Ma", "subLord": "Me"},
    {"planet": "Neptune", "cups": "10", "sign": "Aries", "signLord": "Ve", "starLord": "Ju", "subLord": "Ju"},
    {"planet": "Uranus", "cups": "8", "sign": "Libra", "signLord": "Ve", "starLord": "Ma", "subLord": "Me"},
    {"planet": "Pluto", "cups": "7", "sign": "capricorn", "signLord": "Me", "starLord": "Ju", "subLord": "Me"},
  ];
  final List<Map<String, String>> listOfCups = [
    {"cups": "1", "degree": "9.86", "sign": "Libra", "signLord": "Ve", "starLord": "Ma", "subLord": "Me"},
    {"cups": "2", "degree": "40.6", "sign": "Libra", "signLord": "sa", "starLord": "Ve", "subLord": "Ve"},
    {"cups": "3", "degree": "65.16", "sign": "Libra", "signLord": "Ju", "starLord": "Me", "subLord": "Ma"},
    {"cups": "4", "degree": "88.66", "sign": "Gemni", "signLord": "Ve", "starLord": "Ma", "subLord": "Me"},
    {"cups": "5", "degree": "111.26", "sign": "Libra", "signLord": "Ve", "starLord": "Sa", "subLord": "Ra"},
    {"cups": "6", "degree": "88.61", "sign": "Libra", "signLord": "Me", "starLord": "Ma", "subLord": "Sa"},
    {"cups": "7", "degree": "115.12", "sign": "Libra", "signLord": "Ve", "starLord": "Ma", "subLord": "Me"},
    {"cups": "8", "degree": "116.21", "sign": "Libra", "signLord": "Ve", "starLord": "Ma", "subLord": "Su"},
    {"cups": "9", "degree": "116.26", "sign": "Libra", "signLord": "Ma", "starLord": "Ma", "subLord": "Me"},
    {"cups": "10", "degree": "210.67", "sign": "Aries", "signLord": "Ve", "starLord": "Ju", "subLord": "Ju"},
    {"cups": "11", "degree": "278.99", "sign": "Libra", "signLord": "Ve", "starLord": "Ma", "subLord": "Me"},
    {"cups": "12", "degree": "328.90", "sign": "capricorn", "signLord": "Me", "starLord": "Ju", "subLord": "Me"},
  ];
  final List<Map<String, String>> listOfPlanetsSign = [
    {"planet": "Ascendant", "sign": "Aries", "signLord": "Mars", "degree": "22 \u00b0", "house": "1"},
    {"planet": "Venus", "sign": "Aries", "signLord": "Jupiter", "degree": "22 \u00b0", "house": "11"},
    {"planet": "Ascendant", "sign": "Capricorn", "signLord": "Mars", "degree": "22 \u00b0", "house": "9"},
    {"planet": "Moon", "sign": "Capricorn", "signLord": "Mars", "degree": "22 \u00b0", "house": "10"},
    {"planet": "Ascendant", "sign": "Capricorn", "signLord": "Mars", "degree": "22 \u00b0", "house": "1"},
    {"planet": "Venus", "sign": "Aries", "signLord": "Jupiter", "degree": "22 \u00b0", "house": "8"},
    {"planet": "Rahu", "sign": "Capricorn", "signLord": "Mars", "degree": "22 \u00b0", "house": "1"},
    {"planet": "Rahu", "sign": "Aries", "signLord": "Mars", "degree": "22 \u00b0", "house": "1"},
    {"planet": "Ketu", "sign": "Capricorn", "signLord": "Saturn", "degree": "22 \u00b0", "house": "1"},
    {"planet": "Ascendant", "sign": "Aries", "signLord": "Saturn", "degree": "22 \u00b0", "house": "7"},
    {"planet": "Ascendant", "sign": "Aries", "signLord": "Mars", "degree": "22 \u00b0", "house": "1"},
    {"planet": "pluto", "sign": "Scorpio", "signLord": "Mars", "degree": "22 \u00b0", "house": "10"},
  ];
  DateTime editDOB = DateTime.now();
  @override
  void onInit() async {
    tabController = TabController(vsync: this, length: 6);
    // birthPlaceController.text = 'New Delhi, Delhi, India';
    _init();
    //getKundliList();
    super.onInit();
  }

  _init() async {
    await getKundliList();
  }

  backStepForCreateKundli(int index) {
    initialIndex = index;
  }

  updateIcon(index) {
    listIcon[index].isSelected = true;
    for (int i = 0; i < listIcon.length; i++) {
      if (i == index) {
        listIcon[index].isSelected = true;
        continue;
      } else {
        listIcon[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectTab(index) {
    reportTab[index].isSelected = true;
    for (int i = 0; i < reportTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        reportTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  shareKundli(KundliModel userDetails) async {
    try {
      pdf = pw.Document();
      DateTime dateBasic = userDetails.birthDate;
      int formattedYear = int.parse(DateFormat('yyyy').format(dateBasic));
      int formattedDay = int.parse(DateFormat('dd').format(dateBasic));
      int formattedMonth = int.parse(DateFormat('MM').format(dateBasic));
      int formattedHour = int.parse(DateFormat('HH').format(dateBasic));
      int formattedMint = int.parse(DateFormat('mm').format(dateBasic));

      await getBasicDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails.latitude, lon: userDetails.longitude, tzone: userDetails.timezone);
      await getBasicPanchangDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails.latitude, lon: userDetails.longitude, tzone: userDetails.timezone);
      await getBasicAvakhadaDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails.latitude, lon: userDetails.longitude, tzone: userDetails.timezone);
      await getSadesatiDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails.latitude, lon: userDetails.longitude, tzone: userDetails.timezone);
      await getKalsarpaDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails.latitude, lon: userDetails.longitude, tzone: userDetails.timezone);
      await getGemstoneDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails.latitude, lon: userDetails.longitude, tzone: userDetails.timezone);
      await getChartPlanetsDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails.latitude, lon: userDetails.longitude, tzone: userDetails.timezone);
      await getVimshattariDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails.latitude, lon: userDetails.longitude, tzone: userDetails.timezone);
      await getReportDescDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails.latitude, lon: userDetails.longitude, tzone: userDetails.timezone);

      pdf.addPage(
        pw.Page(
            build: (pw.Context context) => pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      'Basic Details',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF000000),
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Container(
                        padding: pw.EdgeInsets.only(left: 1.5, right: 1.5),
                        decoration: pw.BoxDecoration(
                          //border: pw.Border.all(color: PdfColor.fromInt(0xFF000000)),
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                        child: kundliBasicDetail != null
                            ? pw.Column(
                                children: [
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Name'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text('${userDetails.name}'),
                                        )
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColor.fromInt(0xFFFFFFFF),
                                    ),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Date'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text(
                                            "${DateFormat("dd MMMM yyyy").format(userDetails.birthDate)}",
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Time'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text(
                                            "${userDetails.birthTime}",
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColor.fromInt(0xFFFFFFFF),
                                    ),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Place'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text('${userDetails.birthPlace}'),
                                        )
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Latitude'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text('${kundliBasicDetail!.lat}'),
                                        )
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColor.fromInt(0xFFFFFFFF),
                                    ),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Longitude'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text('${kundliBasicDetail!.lon}'),
                                        )
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Timezone'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text('${kundliBasicDetail!.tzone}'),
                                        )
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColor.fromInt(0xFFFFFFFF),
                                    ),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Sunrise'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text('${kundliBasicDetail!.sunrise}'),
                                        )
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Sunset'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text('${kundliBasicDetail!.sunset}'),
                                        )
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColor.fromInt(0xFFFFFFFF),
                                    ),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.SizedBox(
                                          width: 90,
                                          child: pw.Text('Ayanamsha'),
                                        ),
                                        pw.SizedBox(
                                          width: 180,
                                          child: pw.Text('${kundliBasicDetail!.ayanamsha}'),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : pw.SizedBox()),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Text(
                      'Maglik Analysis',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF000000),
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.all(4),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColor.fromInt(0xFF4CAF50)),
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Row(
                        children: [
                          pw.Container(
                              height: 50,
                              width: 50,
                              alignment: pw.Alignment.center,
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromInt(0xFF4CAF50),
                                //more than 50% of width makes circle
                              ),
                              child: pw.Text('NO', style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF)))),
                          pw.SizedBox(
                            width: 20,
                          ),
                          pw.Text('${userDetails.name}', style: pw.TextStyle(color: PdfColor.fromInt(0xFF000000)))
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Text(
                      'Panchang Details',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF000000),
                      ),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Container(
                        padding: pw.EdgeInsets.only(left: 1.5, right: 1.5),
                        decoration: pw.BoxDecoration(
                          // border: pw.Border.all(color: PdfColor.fromInt(0xFF000000)),
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                        child: pw.Column(
                          children: [
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.SizedBox(
                                    width: 90,
                                    child: pw.Text('Tithi'),
                                  ),
                                  pw.SizedBox(
                                    width: 180,
                                    child: pw.Text('${kundliBasicPanchangDetail!.tithi}'),
                                  )
                                ],
                              ),
                            ),
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromInt(0xFFFFFFFF),
                              ),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.SizedBox(
                                    width: 90,
                                    child: pw.Text('Karan'),
                                  ),
                                  pw.SizedBox(
                                    width: 180,
                                    child: pw.Text('${kundliBasicPanchangDetail!.karan}'),
                                  )
                                ],
                              ),
                            ),
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.SizedBox(
                                    width: 90,
                                    child: pw.Text('Yog'),
                                  ),
                                  pw.SizedBox(
                                    width: 180,
                                    child: pw.Text(
                                      '${kundliBasicPanchangDetail!.yog != null ? kundliBasicPanchangDetail!.yog : '--'}',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromInt(0xFFFFFFFF),
                              ),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.SizedBox(
                                    width: 90,
                                    child: pw.Text('Nakshtra'),
                                  ),
                                  pw.SizedBox(
                                    width: 180,
                                    child: pw.Text('${kundliBasicPanchangDetail!.nakshatra}'),
                                  )
                                ],
                              ),
                            ),
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.SizedBox(
                                    width: 90,
                                    child: pw.Text('Sunrise'),
                                  ),
                                  pw.SizedBox(
                                    width: 180,
                                    child: pw.Text('${kundliBasicPanchangDetail!.sunrise}'),
                                  )
                                ],
                              ),
                            ),
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromInt(0xFFFFFFFF),
                              ),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.SizedBox(
                                    width: 90,
                                    child: pw.Text('Sunset'),
                                  ),
                                  pw.SizedBox(
                                    width: 180,
                                    child: pw.Text('${kundliBasicPanchangDetail!.sunset}'),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                    pw.SizedBox(
                      height: 10,
                    ),
                  ]),
                )),
      );

      pdf.addPage(pw.Page(
        build: (context) => pw.Padding(
            padding: pw.EdgeInsets.all(10),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(
                'Avakhada Details',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF000000),
                ),
              ),
              pw.SizedBox(
                height: 15,
              ),
              pw.Container(
                  padding: pw.EdgeInsets.only(left: 1.5, right: 1.5),
                  decoration: pw.BoxDecoration(
                    //border: pw.Border.all(color: PdfColor.fromInt(0xFF000000)),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Varna'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.varna}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFFFFFFF),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Vashya'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text(
                                "${kundliAvakhadaDetail!.vashya}",
                              ),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Yoni'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text(
                                "${kundliAvakhadaDetail!.yoni}",
                              ),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFFFFFFF),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Gan'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.gan}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Nadi'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.nadi}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFFFFFFF),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Sign'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.sign}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Sign Lord'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.signLord}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFFFFFFF),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              child: pw.Text('Nakshatra-Charan'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.naksahtra}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Yog'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.yog}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFFFFFFF),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Karan'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.karan}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Tithi'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.tithi}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFFFFFFF)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Yunja'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.yunja}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Tatva'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.tatva}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFFFFFFF)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              // width: 100,
                              child: pw.Text('Name albhabet'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.nameAlphabet}'),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6)),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                              width: 90,
                              child: pw.Text('Paya'),
                            ),
                            pw.SizedBox(
                              width: 180,
                              child: pw.Text('${kundliAvakhadaDetail!.paya}'),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ])),
      ));

      pdf.addPage(pw.Page(
        build: (context) => pw.Padding(
            padding: pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Charts',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Text(
                  'Planets',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  '1.Sign',
                  style: pw.TextStyle(
                    fontSize: 11,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Table(
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFEBE7C6),
                        border: pw.Border.all(
                          color: PdfColor.fromInt(0xFF000000),
                        ),
                      ),
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Planet',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFF000000),
                            ),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Sign',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFF000000),
                            ),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Sign lord',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFF000000),
                            ),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Dgrees',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFF000000),
                            ),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'House',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFF000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${ascendantDetails.name}')),
                        pw.Center(child: pw.Text('${ascendantDetails.sign}')),
                        pw.Center(
                          child: pw.Text('${ascendantDetails.signLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${ascendantDetails.fullDegree!.toStringAsFixed(2)}'),
                        ),
                        pw.Center(
                          child: pw.Text('${ascendantDetails.house}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${sunDetails.name}')),
                        pw.Center(child: pw.Text('${sunDetails.sign}')),
                        pw.Center(child: pw.Text('${sunDetails.signLord}')),
                        pw.Center(child: pw.Text('${sunDetails.fullDegree!.toStringAsFixed(2)}')),
                        pw.Center(child: pw.Text('${sunDetails.house}')),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${moonDetails.name}')),
                        pw.Center(child: pw.Text('${moonDetails.sign}')),
                        pw.Center(
                          child: pw.Text('${moonDetails.signLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${moonDetails.fullDegree!.toStringAsFixed(2)}'),
                        ),
                        pw.Center(
                          child: pw.Text('${moonDetails.house}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${mercuryDetails.name}')),
                        pw.Center(child: pw.Text('${mercuryDetails.sign}')),
                        pw.Center(
                          child: pw.Text('${mercuryDetails.signLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${mercuryDetails.fullDegree!.toStringAsFixed(2)}'),
                        ),
                        pw.Center(
                          child: pw.Text('${mercuryDetails.house}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${venusDetails.name}')),
                        pw.Center(child: pw.Text('${venusDetails.sign}')),
                        pw.Center(
                          child: pw.Text('${venusDetails.signLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${venusDetails.fullDegree!.toStringAsFixed(2)}'),
                        ),
                        pw.Center(
                          child: pw.Text('${venusDetails.house}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${marsDetails.name}')),
                        pw.Center(child: pw.Text('${marsDetails.sign}')),
                        pw.Center(
                          child: pw.Text('${marsDetails.signLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${marsDetails.fullDegree!.toStringAsFixed(2)}'),
                        ),
                        pw.Center(
                          child: pw.Text('${marsDetails.house}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${jupiterDetails.name}')),
                        pw.Center(child: pw.Text('${jupiterDetails.sign}')),
                        pw.Center(
                          child: pw.Text('${jupiterDetails.signLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${jupiterDetails.fullDegree!.toStringAsFixed(2)}'),
                        ),
                        pw.Center(
                          child: pw.Text('${jupiterDetails.house}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${saturnDetails.name}')),
                        pw.Center(child: pw.Text('${saturnDetails.sign}')),
                        pw.Center(
                          child: pw.Text('${saturnDetails.signLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${saturnDetails.fullDegree!.toStringAsFixed(2)}'),
                        ),
                        pw.Center(
                          child: pw.Text('${saturnDetails.house}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${rahuDetails.name}')),
                        pw.Center(child: pw.Text('${rahuDetails.sign}')),
                        pw.Center(
                          child: pw.Text('${rahuDetails.signLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${rahuDetails.fullDegree!.toStringAsFixed(2)}'),
                        ),
                        pw.Center(
                          child: pw.Text('${rahuDetails.house}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${ketuDetails.name}')),
                        pw.Center(child: pw.Text('${ketuDetails.sign}')),
                        pw.Center(
                          child: pw.Text('${ketuDetails.signLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${ketuDetails.fullDegree!.toStringAsFixed(2)}'),
                        ),
                        pw.Center(
                          child: pw.Text('${ketuDetails.house}'),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Text(
                  '2.Constellation',
                  style: pw.TextStyle(
                    fontSize: 11,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Table(
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFEBE7C6),
                        border: pw.Border.all(
                          color: PdfColor.fromInt(0xFF000000),
                        ),
                      ),
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Planet',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFF000000),
                            ),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Nakshatra',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFF000000),
                            ),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Nakshatra lord',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFF000000),
                            ),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'House',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFF000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${ascendantDetails.name}')),
                        pw.Center(child: pw.Text('${ascendantDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${ascendantDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${ascendantDetails.house!}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${sunDetails.name}')),
                        pw.Center(child: pw.Text('${sunDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${sunDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${sunDetails.house!}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${moonDetails.name}')),
                        pw.Center(child: pw.Text('${moonDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${moonDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${moonDetails.house!}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${mercuryDetails.name}')),
                        pw.Center(child: pw.Text('${mercuryDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${mercuryDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${mercuryDetails.house!}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${venusDetails.name}')),
                        pw.Center(child: pw.Text('${venusDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${venusDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${venusDetails.house!}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${marsDetails.name}')),
                        pw.Center(child: pw.Text('${marsDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${marsDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${marsDetails.house!}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${jupiterDetails.name}')),
                        pw.Center(child: pw.Text('${jupiterDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${jupiterDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${jupiterDetails.house!}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${saturnDetails.name}')),
                        pw.Center(child: pw.Text('${saturnDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${saturnDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${saturnDetails.house!}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${rahuDetails.name}')),
                        pw.Center(child: pw.Text('${rahuDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${rahuDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${rahuDetails.house!}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))),
                      children: [
                        pw.Center(child: pw.Text('${ketuDetails.name}')),
                        pw.Center(child: pw.Text('${ketuDetails.nakshatra}')),
                        pw.Center(
                          child: pw.Text('${ketuDetails.nakshatraLord}'),
                        ),
                        pw.Center(
                          child: pw.Text('${ketuDetails.house!}'),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )),
      ));

      pdf.addPage(
        pw.Page(
            build: (context) => pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'KP',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF000000),
                      ),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      'Planets',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColor.fromInt(0xFF000000),
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.SizedBox(
                      child: pw.Table(
                        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                        columnWidths: {
                          0: const pw.FixedColumnWidth(300.0),
                          1: const pw.FixedColumnWidth(300.0),
                          2: const pw.FixedColumnWidth(300.0),
                          3: const pw.FixedColumnWidth(300.0),
                          4: const pw.FixedColumnWidth(300.0),
                          5: const pw.FixedColumnWidth(300.0),
                        },
                        children: [
                          pw.TableRow(
                            decoration: pw.BoxDecoration(
                              color: PdfColor.fromInt(0xFFEBE7C6),
                              border: pw.Border.all(
                                color: PdfColor.fromInt(0xFF000000),
                              ),
                            ),
                            children: [
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Planet',
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(0xFF000000),
                                  ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Cusp',
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(0xFF000000),
                                  ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Sign',
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(0xFF000000),
                                  ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Sign lord',
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(0xFF000000),
                                  ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Start lord ',
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(0xFF000000),
                                  ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Sub lord',
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(0xFF000000),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                        child: pw.Table(
                            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                            columnWidths: {
                              0: const pw.FixedColumnWidth(300.0),
                              1: const pw.FixedColumnWidth(300.0),
                              2: const pw.FixedColumnWidth(300.0),
                              3: const pw.FixedColumnWidth(300.0),
                              4: const pw.FixedColumnWidth(300.0),
                              5: const pw.FixedColumnWidth(300.0),
                            },
                            children: listOfPlanets
                                .map((e) => pw.TableRow(decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromInt(0xFF000000))), children: [
                                      pw.Center(child: pw.Text('${e["planet"]}')),
                                      pw.Center(child: pw.Text('${e["cups"]}')),
                                      pw.Center(child: pw.Text('${e["sign"]}')),
                                      pw.Center(child: pw.Text('${e["signLord"]}')),
                                      pw.Center(child: pw.Text('${e["starLord"]}')),
                                      pw.Center(child: pw.Text('${e["subLord"]}')),
                                    ]))
                                .toList())),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      'Ashtakvarga Chart',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF000000),
                      ),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      'The Ashtakavarga system of prediction works on the Bindu or dots. These are basically a point system where each planet except Rahu and Ketu are allotted a specific number in a specific house of your Kundali or birth chart. The higher number denotes the strength of that house in your Kundali. For example, if you have a higher value in the 11th house, which is the house of income, that would be a good sign as the planets in that house have a strong position and influence your Kundali more than others. For that reason, many believe Ashtakavarga in astrology to be even more precise than the birth chart or Janam Kundali analysis.',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColor.fromInt(0xFF000000),
                      ),
                    ),
                  ],
                ))),
      );

      pdf.addPage(pw.Page(
        build: (context) => pw.Padding(
            padding: pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Vimshattari',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Text(
                  'Mahadasha',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                vimshattariList!.isEmpty
                    ? pw.SizedBox()
                    : pw.Container(
                        alignment: pw.Alignment.center,
                        margin: pw.EdgeInsets.only(top: 10),
                        child: pw.Column(
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 122,
                                  decoration: pw.BoxDecoration(
                                    color: PdfColor.fromInt(0xFFEBE7C6),
                                    border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)),
                                    borderRadius: pw.BorderRadius.only(topLeft: pw.Radius.circular(10)),
                                  ),
                                  child: pw.SizedBox(height: 50, width: 100, child: pw.Center(child: pw.Text('Planet', textAlign: pw.TextAlign.center))),
                                ),
                                pw.Container(
                                  width: 122,
                                  decoration: pw.BoxDecoration(
                                      color: PdfColor.fromInt(0xFFEBE7C6),
                                      border: pw.Border(
                                        top: pw.BorderSide(color: PdfColor.fromInt(0xFF9E9E9E)),
                                      )),
                                  child: pw.SizedBox(height: 50, width: 100, child: pw.Center(child: pw.Text('Start Date', textAlign: pw.TextAlign.center))),
                                ),
                                pw.Expanded(
                                  child: pw.Container(
                                    width: 123,
                                    decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEBE7C6), border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)), borderRadius: pw.BorderRadius.only(topRight: pw.Radius.circular(10))),
                                    child: pw.SizedBox(height: 50, width: 100, child: pw.Center(child: pw.Text('End Date', textAlign: pw.TextAlign.center))),
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: vimshattariList!.last
                                  .map(
                                    (e) => pw.Row(
                                      children: [
                                        pw.Container(
                                          width: 122,
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)),
                                          ),
                                          child: pw.SizedBox(height: 50, width: 100, child: pw.Center(child: pw.Text("$prefix${e.planet!.substring(0, 2).toUpperCase()}", textAlign: pw.TextAlign.center))),
                                        ),
                                        pw.Container(
                                          width: 122,
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)),
                                          ),
                                          child: pw.SizedBox(height: 50, width: 100, child: pw.Center(child: pw.Text(e.start!.split(' ')[0], textAlign: pw.TextAlign.center))),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            width: 123,
                                            decoration: pw.BoxDecoration(
                                              border: pw.Border(
                                                bottom: pw.BorderSide(color: PdfColor.fromInt(0xFF9E9E9E)),
                                                top: pw.BorderSide(color: PdfColor.fromInt(0xFF9E9E9E)),
                                                right: pw.BorderSide(color: PdfColor.fromInt(0xFF9E9E9E)),
                                              ),
                                            ),
                                            child: pw.SizedBox(
                                                height: 50,
                                                width: 100,
                                                child: pw.Center(
                                                    child: pw.Row(
                                                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                                  children: [
                                                    pw.Text(e.end!.split(' ')[0], textAlign: pw.TextAlign.center),
                                                  ],
                                                ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            )
                          ],
                        ),
                      ),
              ],
            )),
      ));

      pdf.addPage(pw.Page(
        build: (context) => pw.Padding(
            padding: pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Report',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Text(
                  '1.General',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Text(
                  'Description',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  '$generalDesc',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Text(
                  '2.Remedies',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Text(
                  'Gemstones',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  'Life Stone',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(8),
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Life Stone',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromInt(0xFF000000),
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Text(
                        'You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColor.fromInt(0xFF000000),
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                        width: double.infinity,
                        padding: pw.EdgeInsets.all(8),
                        margin: pw.EdgeInsets.only(bottom: 10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)),
                          borderRadius: pw.BorderRadius.circular(10),
                        ),
                        child: pw.Column(
                          children: [
                            pw.Container(
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.SizedBox(
                                      width: 100,
                                      child: pw.Text(
                                        'Life Stone',
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColor.fromInt(0xFF000000),
                                        ),
                                      )),
                                  pw.SizedBox(
                                    width: 50,
                                  ),
                                  pw.Expanded(
                                      child: pw.Text(
                                    '${gemstoneList!.lifeStone!.name}',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromInt(0xFF000000),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            pw.Container(
                              color: PdfColor.fromInt(0xFFEBE7C6),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.SizedBox(
                                      width: 100,
                                      child: pw.Text(
                                        'How to wear',
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          color: PdfColor.fromInt(0xFF000000),
                                        ),
                                      )),
                                  pw.SizedBox(
                                    width: 50,
                                  ),
                                  pw.Expanded(
                                      child: pw.Text(
                                    '${gemstoneList!.lifeStone!.wearMetal}, ${gemstoneList!.lifeStone!.wearFinger}',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColor.fromInt(0xFF000000),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ));

      pdf.addPage(pw.Page(
        build: (context) => pw.Padding(
            padding: pw.EdgeInsets.all(8),
            child: pw.Column(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Lucky Stone',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromInt(0xFF000000),
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(8),
                        margin: const pw.EdgeInsets.only(bottom: 10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)),
                          borderRadius: pw.BorderRadius.circular(10),
                        ),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Lucky Gemstone',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromInt(0xFF000000),
                              ),
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            pw.Text(
                              'You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp',
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColor.fromInt(0xFF000000),
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Container(
                              width: double.infinity,
                              padding: pw.EdgeInsets.all(8),
                              margin: pw.EdgeInsets.only(bottom: 10),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)),
                                borderRadius: pw.BorderRadius.circular(10),
                              ),
                              child: pw.Column(
                                children: [
                                  pw.Container(
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.start,
                                      children: [
                                        pw.SizedBox(
                                            width: 100,
                                            child: pw.Text(
                                              'lucky stone',
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                                color: PdfColor.fromInt(0xFF000000),
                                              ),
                                            )),
                                        pw.SizedBox(
                                          width: 50,
                                        ),
                                        pw.Expanded(
                                            child: pw.Text(
                                          '${gemstoneList!.luckyStone!.name}',
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                            color: PdfColor.fromInt(0xFF000000),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  pw.SizedBox(
                                    height: 10,
                                  ),
                                  pw.Container(
                                    color: PdfColor.fromInt(0xFFEBE7C6),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.start,
                                      children: [
                                        pw.SizedBox(
                                            width: 100,
                                            child: pw.Text(
                                              'How to wear',
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                                color: PdfColor.fromInt(0xFF000000),
                                              ),
                                            )),
                                        pw.SizedBox(
                                          width: 50,
                                        ),
                                        pw.Expanded(
                                            child: pw.Text(
                                          '${gemstoneList!.luckyStone!.wearMetal}, ${gemstoneList!.luckyStone!.wearFinger}',
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                            color: PdfColor.fromInt(0xFF000000),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  pw.SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Fortune Stone',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromInt(0xFF000000),
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(8),
                        margin: const pw.EdgeInsets.only(bottom: 10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)),
                          borderRadius: pw.BorderRadius.circular(10),
                        ),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Fortune Stone',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromInt(0xFF000000),
                              ),
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            pw.Text(
                              'You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp',
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColor.fromInt(0xFF000000),
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Container(
                              width: double.infinity,
                              padding: pw.EdgeInsets.all(8),
                              margin: pw.EdgeInsets.only(bottom: 10),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E)),
                                borderRadius: pw.BorderRadius.circular(10),
                              ),
                              child: pw.Column(
                                children: [
                                  pw.Container(
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.start,
                                      children: [
                                        pw.SizedBox(
                                            width: 100,
                                            child: pw.Text(
                                              'fortune stone',
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                                color: PdfColor.fromInt(0xFF000000),
                                              ),
                                            )),
                                        pw.SizedBox(
                                          width: 50,
                                        ),
                                        pw.Expanded(
                                            child: pw.Text(
                                          '${gemstoneList!.fortuneStone!.name}',
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                            fontWeight: pw.FontWeight.bold,
                                            color: PdfColor.fromInt(0xFF000000),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  pw.SizedBox(
                                    height: 10,
                                  ),
                                  pw.Container(
                                    color: PdfColor.fromInt(0xFFEBE7C6),
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.start,
                                      children: [
                                        pw.SizedBox(
                                            width: 100,
                                            child: pw.Text(
                                              'How to wear',
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                                color: PdfColor.fromInt(0xFF000000),
                                              ),
                                            )),
                                        pw.SizedBox(
                                          width: 50,
                                        ),
                                        pw.Expanded(
                                            child: pw.Text(
                                          '${gemstoneList!.fortuneStone!.wearMetal}, ${gemstoneList!.fortuneStone!.wearFinger}',
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                            color: PdfColor.fromInt(0xFF000000),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  pw.SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Text(
                        '3.Dasha',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromInt(0xFF000000),
                        ),
                      ),
                      pw.SizedBox(
                        height: 15,
                      ),
                      pw.Text(
                        'i.Manglik',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromInt(0xFF000000),
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Text(
                        'Manglik Analysis',
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromInt(0xFF000000),
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(4),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColor.fromInt(0xFF4CAF50)),
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Container(
                                height: 50,
                                width: 50,
                                alignment: pw.Alignment.center,
                                decoration: pw.BoxDecoration(
                                  color: PdfColor.fromInt(0xFF4CAF50),
                                  //more than 50% of width makes circle
                                ),
                                child: pw.Text('NO', style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF)))),
                            pw.SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'This is a computer generated result. Please consult an Astrologer to confirm & understand this in detail.',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColor.fromInt(0xFF9E9E9E),
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            )),
      ));
      pdf.addPage(pw.Page(
        build: (context) => pw.Padding(
            padding: pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ii.Kalsarpa',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  'Kalsarpa Analysis',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                isKalsarpa == null
                    ? pw.SizedBox()
                    : pw.Container(
                        padding: pw.EdgeInsets.all(4),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: isKalsarpa == true ? PdfColor.fromInt(0xFFF44336) : PdfColor.fromInt(0xFF4CAF50)),
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Container(
                                height: 50,
                                width: 50,
                                alignment: pw.Alignment.center,
                                decoration: pw.BoxDecoration(
                                  color: isKalsarpa == true ? PdfColor.fromInt(0xFFF44336) : PdfColor.fromInt(0xFF4CAF50),
                                  //more than 50% of width makes circle
                                ),
                                child: pw.Text(isKalsarpa == true ? 'YES' : 'NO', style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF)))),
                            pw.SizedBox(
                              width: 10,
                            ),
                            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                              pw.Text(
                                'Kalsarpa',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromInt(0xFF000000),
                                ),
                              ),
                              pw.SizedBox(height: 6),
                              pw.Text(
                                isKalsarpa == true ? 'Kundli is not free from kalsarpa dosha' : 'Kundli is free from kalsarpa dosha',
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  color: PdfColor.fromInt(0xFF000000),
                                ),
                              )
                            ])
                          ],
                        ),
                      ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Text(
                  'iii.Sadesati',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  'Sadesati Analysis',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                isSadesati == null
                    ? pw.SizedBox()
                    : pw.Container(
                        padding: pw.EdgeInsets.all(4),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: isSadesati == true ? PdfColor.fromInt(0xFFF44336) : PdfColor.fromInt(0xFF4CAF50)),
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Container(
                                height: 50,
                                width: 50,
                                alignment: pw.Alignment.center,
                                decoration: pw.BoxDecoration(
                                  color: isSadesati == true ? PdfColor.fromInt(0xFFF44336) : PdfColor.fromInt(0xFF4CAF50),
                                  //more than 50% of width makes circle
                                ),
                                child: pw.Text(isSadesati == true ? 'YES' : 'NO', style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF)))),
                            pw.SizedBox(
                              width: 10,
                            ),
                            pw.Text(
                              'Current Sadesati Status',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromInt(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            )),
      ));
      FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
      String appShareLink;

      String applink;
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://BharatiyAstroupdated.page.link',
        link: Uri.parse("https://BharatiyAstroupdated.page.link/userProfile?screen=astroProfile"),
        androidParameters: AndroidParameters(
          packageName: 'com.BharatiyAstro.app',
          minimumVersion: 1,
        ),
      );
      Uri url;
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
      url = shortLink.shortUrl;
      appShareLink = url.toString();
      applink = appShareLink;
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final temp = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
      final path = '${temp!.path}/$fileName.pdf';
      File(path).writeAsBytesSync(await pdf.save());
      print('path $path');
      await FlutterShare.shareFile(filePath: path, title: 'BharatiyAstro', text: "Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career.Check my chat with .You should also try and see your future  https://play.google.com/store/apps/details?id=com.bharatiyastro.userapp $appShareLink").then((value) {}).catchError((e) {
        print(e);
      });
    } catch (e) {
      print('Excpetion in share kundli $e');
    }
  }

  selectRemediesTab(int index) {
    remediesTab[index].isSelected = true;
    for (int i = 0; i < remediesTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        remediesTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectRudrakshaTab(index) {
    rudrakshaTab[index].isSelected = true;
    for (int i = 0; i < rudrakshaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        rudrakshaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectDoshaTab(int index) {
    doshaTab[index].isSelected = true;
    for (int i = 0; i < doshaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        doshaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectDashaTab(int index) {
    dashaTab[index].isSelected = true;
    for (int i = 0; i < dashaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        dashaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectashtakvargaTab(int index) {
    ashtakvargaTab[index].isSelected = true;
    for (int i = 0; i < ashtakvargaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        ashtakvargaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectDivisionTab(int index) {
    divisionalTab[index].isSelected = true;
    for (int i = 0; i < divisionalTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        divisionalTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectPlanetTab(int index) {
    planetTab[index].isSelected = true;
    for (int i = 0; i < planetTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        planetTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectChartKundliTab(int index) {
    chartKundliTab[index].isSelected = true;
    for (int i = 0; i < chartKundliTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        chartKundliTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  updateBg(int index) {
    selectedGender = gender[index].title;
    for (int i = 0; i < gender.length; i++) {
      if (i == index) {
        continue;
      } else {
        gender[i].isSelected = false;
      }
    }
    gender[index].isSelected = true;
    update();
  }

  updateAllBg() {
    for (int i = 0; i < gender.length; i++) {
      gender[i].isSelected = false;
    }

    update();
  }

  updateIsDisable() {
    // ignore: unrelated_type_equality_checks
    if (userNameController.text != "") {
      isDisable = false;
      update();
    } else {
      isDisable = true;
      update();
    }
  }

  updateCheck(value) {
    isTimeOfBirthKnow = value;
    update();
  }

  updateInitialIndex() {
    if (initialIndex < 5) {
      initialIndex = initialIndex + 1;
    } else {
      initialIndex = 0;
    }
    update();
  }

  updateListIndex(int index) {
    if (index < 5) {
      index += 1;
    } else {
      index = 0;
    }
  }

  langugeUpdate({required bool isEng, required bool isHin}) {
    isSelectedLanEng = isEng;
    isSelectedLanHin = isHin;
    update();
  }

  northSouthUpdate({required bool isNorth, required bool isSouth}) {
    isNorthIn = isNorth;
    isSouthIn = isSouth;
    update();
  }

  changeTapIndex(int index) {
    kundliTabInitialIndex = index;
    update();
  }

  showMoreText() {
    isShowMore = !isShowMore;
    update();
  }

  String? dropDownGender;
  List item = ['Male', 'Female', 'Other'];
  String innitialValue(int callId, List<String> item) {
    if (callId == 1) {
      return dropDownGender ?? item[0];
    } else {
      return 'no data';
    }
  }

  void genderChoose(String value) {
    dropDownGender = value;
    update();
  }

  getKundliList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getKundli().then((result) {
            if (result.status == "200") {
              kundliList = result.recordList;
              searchKundliList = kundliList;
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'FAil to get kundli',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  getKundliListById(int index) async {
    try {
      editNameController.text = searchKundliList[index].name;
      editBirthDateController.text = formatDate(searchKundliList[index].birthDate, [dd, '-', mm, '-', yyyy]);
      editBirthTimeController.text = searchKundliList[index].birthTime.toString();
      editBirthPlaceController.text = searchKundliList[index].birthPlace.toString();
      editDOB = searchKundliList[index].birthDate;
      update();
      genderChoose(searchKundliList[index].gender);
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  String? userName;
  getName(String text) {
    userName = text;
    update();
  }

  getselectedDate(DateTime date) {
    selectedDate = date;
    update();
  }

  getSelectedTime(DateTime date) {
    selectedTime = DateFormat.jm().format(date);
    update();
  }

  addKundliData() async {
    List<KundliModel> kundliModel = [
      KundliModel(
        name: userName!,
        gender: selectedGender!,
        birthDate: selectedDate ?? DateTime(1996),
        birthTime: selectedTime ?? DateFormat.jm().format(DateTime.now()),
        birthPlace: birthKundliPlaceController.text,
        latitude: lat,
        longitude: long,
        timezone: timeZone,
      )
    ];
    update();
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.addKundli(kundliModel).then((result) {
          if (result.status == "200") {
            print('success');
          } else {
            global.showToast(
              message: 'Failed to create kundli please try again later!',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  getGeoCodingLatLong({double? latitude, double? longitude}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.geoCoding(lat: latitude, long: longitude).then((result) {
            if (result.status == "true") {
              timeZone = double.parse(result.recordList['timezone'].toString());
              update();
            } else {
              // global.showToast(
              //   message: 'NOt Avalilable',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getGeoCodingLatLong():' + e.toString());
    }
  }

  DateTime? pickedDate;
  updateKundliData(int id) async {
    KundliModel kundliModel = KundliModel(
      name: editNameController.text,
      gender: dropDownGender!,
      birthDate: pickedDate ?? editDOB,
      birthTime: editBirthTimeController.text,
      birthPlace: editBirthPlaceController.text,
      latitude: lat,
      longitude: long,
    );
    update();
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.updateKundli(id, kundliModel).then((result) {
          if (result.status == "200") {
            global.showToast(
              message: 'Your kundli has been updated',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            global.showToast(
              message: 'Failed to update kundli please try again later!',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  deleteKundli(int id) async {
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.deleteKundli(id).then((result) {
          if (result.status == "200") {
            global.showToast(
              message: 'Deleted Successfully',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            global.showToast(
              message: 'Deleted Fail',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  searchKundli(String kundliName) {
    List<KundliModel> result = [];
    if (kundliName.isEmpty) {
      result = kundliList;
    } else {
      result = kundliList.where((element) => element.name.toString().toLowerCase().contains(kundliName.toLowerCase())).toList();
    }
    searchKundliList = result;
    if (searchKundliList.isEmpty) {
      emptyScreenText = "Search result not found";
    }
    update();
  }

  getBasicDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getKundliBasicDetails(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              kundliBasicDetail = KundliBasicDetail.fromJson(map);
              update();
            } else {
              global.showToast(
                message: 'Fail to getKundliBasicDetails ',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getBasicDetail():' + e.toString());
    }
  }

  getBasicPanchangDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getKundliBasicPanchangDetails(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              kundliBasicPanchangDetail = KundliBasicPanchangDetail.fromJson(map);
              update();
            } else {
              global.showToast(
                message: 'Fail to getKundliBasicPanchangDetails',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getBasicPanchangDetail():' + e.toString());
    }
  }

  getBasicAvakhadaDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAvakhadaDetails(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              kundliAvakhadaDetail = KundliAvakhdaDetail.fromJson(map);
              update();
            } else {
              global.showToast(
                message: 'Failed to getAvakhadaDetails',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getBasicAvakhadaDetail():' + e.toString());
    }
  }

  getSadesatiDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getSadesati(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              isSadesati = result['sadhesati_status'];
              update();
            } else {
              global.showToast(
                message: 'Failed to Panchang Detail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getSadesatiDetail():' + e.toString());
    }
  }

  getKalsarpaDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getKalsarpa(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              isKalsarpa = result['present'];
              update();
            } else {
              global.showToast(
                message: 'Failed to Panchang Detail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getKalsarpaDetail():' + e.toString());
    }
  }

  getChartPlanetsDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getPlanetsDetail(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              planetList = result;
              sunDetails = KundliPlanetsDetail.fromJson(planetList[0]);
              moonDetails = KundliPlanetsDetail.fromJson(planetList[1]);
              marsDetails = KundliPlanetsDetail.fromJson(planetList[2]);
              mercuryDetails = KundliPlanetsDetail.fromJson(planetList[3]);
              jupiterDetails = KundliPlanetsDetail.fromJson(planetList[4]);
              venusDetails = KundliPlanetsDetail.fromJson(planetList[5]);
              saturnDetails = KundliPlanetsDetail.fromJson(planetList[6]);
              rahuDetails = KundliPlanetsDetail.fromJson(planetList[7]);
              ketuDetails = KundliPlanetsDetail.fromJson(planetList[8]);
              ascendantDetails = KundliPlanetsDetail.fromJson(planetList[9]);
              update();
            } else {
              global.showToast(
                message: 'Failed to Plantes Detail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getChartPlanetsDetail():' + e.toString());
    }
  }

  getGemstoneDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      gemstoneList = null;

      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getGemstone(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              gemstoneList = GemstoneModel.fromJson(map);

              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get Get gemstone',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  getVimshattariDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getVimshattari(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              vimshattariList!.add(result);

              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get vimshattari',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  getAntardashaDetail({String? antarName, int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAntardasha(antarDasha: antarName, day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              vimshattariList!.add(result);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get getAntardashaDetail',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAntarDasha():' + e.toString());
    }
  }

  getPatyantarDashaDetail({String? anterName, String? patyantarName, int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getPatynatarDasha(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              vimshattariList!.add(result);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get getPatyantarDashaDetail',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAntarDasha():' + e.toString());
    }
  }

  getSookshmaDashaDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getSookshmaDasha(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              vimshattariList!.add(result);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get SookshmaDasha',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAntarDasha():' + e.toString());
    }
  }

  getPranaDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getPrana(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              vimshattariList!.add(result);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get  Get vimshattari',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAntarDasha():' + e.toString());
    }
  }

  getReportDescDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getReport(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result != null) {
              generalDesc = result['asc_report']['report'];
              update();
            } else {
              global.showToast(
                message: 'Failed to Report',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getSadesatiDetail():' + e.toString());
    }
  }

  addPlanetKundliData(int id) async {
    global.checkBody().then((result) async {
      if (result) {
        apiHelper.addPlanetKundli(id).then((result) {
          if (result.status == "200") {
            print('success');
          } else {
            global.showToast(
              message: 'Failed to add kundli please try again later!',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }
}
