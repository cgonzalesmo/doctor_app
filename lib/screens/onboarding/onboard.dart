import 'package:doctor_app/config/palette.dart';
import 'package:doctor_app/screens/extra_screens/get_started.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  _storeOnboardInfo() async {
    print('Shared Pref called');
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    final Color kDarkBlueColor = Color(0xFF053149);

    return SafeArea(
      child: OnBoardingSlider(
        finishButtonText: 'Empezar',
        onFinish: () {
          _storeOnboardInfo();
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: GetStartedScreen(),
                  type: PageTransitionType.rightToLeft));
        },
        finishButtonColor: kDarkBlueColor,
        skipFunctionOverride: () {
          _storeOnboardInfo();
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: GetStartedScreen(),
                  type: PageTransitionType.rightToLeft));
        },
        skipTextButton: Text(
          'Saltar',
          style: TextStyle(
            fontSize: 16,
            color: kDarkBlueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        // imageHorizontalOffset: -10,
        imageVerticalOffset: 0,
        controllerColor: kDarkBlueColor,
        totalPage: 5,
        headerBackgroundColor: Palette.scaffoldColor,
        pageBackgroundColor: Palette.scaffoldColor,
        background: [
          // Image.asset(
          //   'assets/images/calendar.png',
          //   height: 400,
          // ),
          Lottie.asset('assets/animations/appointment.json', height: 400),
          // Image.asset(
          //   'assets/images/corona.png',
          //   height: 400,
          // ),
          Lottie.asset('assets/animations/corona.json', height: 400),
          // Image.asset(
          //   'assets/images/news.png',
          //   height: 400,
          // ),
          Lottie.asset('assets/animations/news1.json', height: 400),
          // Image.asset(
          //   'assets/images/bmi.png',
          //   height: 400,
          // ),
          Lottie.asset('assets/animations/bmi1.json', height: 400),
          // Image.asset(
          //   'assets/images/get_started.png',
          //   height: 400,
          // ),
          Lottie.asset('assets/animations/start1.json', height: 400),
        ],
        speed: 1.8,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Reserva de cita',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Reserva cita a tu alcance...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Estadísticas de COVID-19',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Obtenga las últimas estadísticas de COVID de una fuente verificada',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Noticias de Salud',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Obtenga todas las últimas noticias relacionadas con la salud al alcance de su mano',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Índice de masa corporal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Consulta tu IMC con un solo clic',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 480,
                ),
                Text(
                  '¡¡Empezar ahora!!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Haga clic a continuación para comenzar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
