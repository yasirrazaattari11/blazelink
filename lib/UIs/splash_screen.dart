import 'package:blaze_link/FirebaseServices/splash_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Center(
              child: Image(image: AssetImage('assets/splash.png'),fit: BoxFit.cover,filterQuality: FilterQuality.high,height:200,width: 200,),
            ),
          ),
          SizedBox(height: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Blaze',style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.black
              ),),
              Text('Link',style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange
              ),),
            ],
          )
        ],
      ),
    );
  }
}
