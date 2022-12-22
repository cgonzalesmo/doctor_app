import 'dart:convert';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:doctor_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class CoronaStats extends StatefulWidget {
  @override
  _CoronaStatsState createState() => _CoronaStatsState();
}

class _CoronaStatsState extends State<CoronaStats> {
  final String url =
      'https://api.apify.com/v2/key-value-stores/toDWvRj1JpTXiM8FF/records/LATEST?disableRedirect=true';

  Map data;
  List state;

  @override
  void initState() {
    super.initState();
    fetchCorona();
  }

  fetchCorona() async {
    var response = await http.get(Uri.parse(url));
    if (!mounted) return;
    setState(() {
      var convertJson = json.decode(response.body);
      data = convertJson;
      state = convertJson['regionData'];
    });
    print(state.length);
  }

  void _launchURL(String url) async {
    if (!await launch(url)) {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "COVID-19",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Palette.scaffoldColor,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: data != null
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        stats(
                          "Casos Totales",
                          "Casos activos",
                          data['totalCases'].toString(),
                          "",
                          data['activeCases'].toString(),
                          data['activeCasesNew'].toString(),
                          false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        stats(
                          "Recuperados",
                          "Fallecidos",
                          data['recovered'].toString(),
                          data['recoveredNew'].toString(),
                          data['deaths'].toString(),
                          data['deathsNew'].toString(),
                          true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.93,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[350],
                                offset: Offset(3.0, 3.0),
                                blurRadius: 5,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                height: 80,
                                width: MediaQuery.of(context).size.width * 0.5,
                                // color: Colors.red,
                                child: AutoSizeText(
                                  "Muestras relizadas",
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  minFontSize: 18,
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    padding:
                                        EdgeInsets.only(right: 10, top: 10),
                                    height: 45,
                                    // color: Colors.red,
                                    child: Text(
                                      data['previousDayTests'].toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    padding: EdgeInsets.only(right: 10),
                                    width: MediaQuery.of(context).size.width *
                                        0.43,

                                    // color: Colors.pink,
                                    child: GestureDetector(
                                      onTap: () {
                                        print("Hizo clic en la fuente");
                                        _launchURL(
                                            'https://analytics.icmr.org.in/public/dashboard/149a9c89-de6d-4779-9326-5e8fed3323b6');
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text("Fuente"),
                                          Icon(
                                            Icons.open_in_new,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Container(
                      // height: 100,
                      // width: 100,
                      child: Lottie.asset(
                        "assets/animations/loading1.json",
                      ),
                    ),
                  ),
          )),
    );
  }

  Widget stats(String heading1, String heading2, String data1, String data2,
      String data3, String data4, bool bracket1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[350],
                offset: Offset(3.0, 3.0),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  heading1 + ":",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: AutoSizeText(
                      data1,
                      maxFontSize: 18,
                      minFontSize: 15,
                    ),
                  ),
                  bracket1
                      ? Container(
                          child: Text(" (" + data2 + ")"),
                        )
                      : Offstage()
                ],
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[350],
                offset: Offset(3.0, 3.0),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  heading2 + ":",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      data3,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(" (" + data4 + ")"),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
