import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../const.dart';
import '../../model/datetime.dart';
import '../../model/qrcustom_model.dart';
import '../../storage/qrstorage.dart';

class EmailScan extends StatefulWidget {
  List<String> data = [];
  EmailScan({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EmailScan> createState() => _EmailScanState();
}

class _EmailScanState extends State<EmailScan> {
  StorageProvider save = StorageProvider();
  Future<void> addHistoryCustom() async {
    //store the user entered data in user object
    //store the user entered data in user object
    final now = DateTime.now();
    String dayStr = '';
    if (now.weekday == DateTime.monday) {
      dayStr = 'Moday';
    } else if (now.weekday == DateTime.tuesday) {
      dayStr = 'Tuesday';
    } else if (now.weekday == DateTime.wednesday) {
      dayStr = 'Wednesday';
    } else if (now.weekday == DateTime.thursday) {
      dayStr = 'Thursday';
    } else if (now.weekday == DateTime.friday) {
      dayStr = 'Friday';
    } else if (now.weekday == DateTime.saturday) {
      dayStr = 'Saturday';
    } else if (now.weekday == DateTime.sunday) {
      dayStr = 'Sunday';
    }
    String time = now.hour.toString() + ':' + now.minute.toString();
    DateTimeModel date =
        DateTimeModel(dayStr, now.year, now.month, now.day, time);

    QrCustomModel qrCustomModel = new QrCustomModel(
        data:
            'MATMSG:TO:${widget.data[0]};SUB:${widget.data[1]};BODY:${widget.data[2]};;',
        type: widget.data[0],
        image: 'assets/iconcustom/email.png',
        titleType: 'Email',
        typeicon: 'Email',
        bodyColor: black.toString().substring(6, 16),
        eyeColor: black.toString().substring(6, 16),
        bodyvalue: 1,
        eyevalue: 1,
        date: date,
        favorite: false);

    // encode / convert object into json string
    String dataQr = jsonEncode(qrCustomModel);
    print(dataQr);
    //save the data into sharedPreferences using key-value pairs
    save.addDataScanner(dataQr);
  }

  @override
  void initState() {
    setState(() {
      addHistoryCustom();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Navigator.of(context).push(
                        //   new MaterialPageRoute(builder: (ctx) => MainPage()),
                        // );
                        Navigator.of(context).pop(true);
                      });
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 35,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        child: Icon(Icons.email, size: 30),
                      ),
                      Container(
                        width: 5,
                      ),
                      Text(
                        'Email',
                        style: textType,
                      ),
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
            Container(
              height: 250,
              width: double.infinity,
              color: blue.withOpacity(0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'To:',
                            style: textType.copyWith(fontSize: 18),
                          ),
                          Text(
                            'Subject:',
                            style: textType.copyWith(fontSize: 18),
                          ),
                          Text(
                            'Content:',
                            style: textType.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            widget.data[0].isNotEmpty ? widget.data[0] : '',
                            style: textType.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            widget.data[1].isNotEmpty ? widget.data[1] : '',
                            style: textType.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            widget.data[2].isNotEmpty ? widget.data[2] : '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textType.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 50,
                        width: 70,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color?>(
                                        blue.withOpacity(0.8)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  // side: BorderSide(color: Colors.red)
                                ))),
                            onPressed: () {
                              launch(
                                  'mailto:${widget.data[0]}?subject=${widget.data[1]}&body=${widget.data[2]}');
                            },
                            child: Image.asset('assets/iconcustom/email.png')),
                      ),
                      Text(
                        'Send email',
                        style: textType.copyWith(fontSize: 18),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 50,
                        width: 70,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color?>(
                                        blue.withOpacity(0.8)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  // side: BorderSide(color: Colors.red)
                                ))),
                            onPressed: () {},
                            child: Icon(
                              Icons.share,
                              color: black,
                              size: 40,
                            )),
                      ),
                      Text(
                        'Share',
                        style: textType.copyWith(fontSize: 18),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
