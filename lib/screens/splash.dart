import 'package:flutter/material.dart';
import 'package:chapa_tu_aula/screens/home.dart';

class MyAppSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chapa Tu Aula',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePageSplash()
    );
  }
}

class MyHomePageSplash extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePageSplash> {
  @override
  void initState() {
    super.initState();
    _navigateHome();
  }

  _navigateHome() async {
    await Future.delayed(Duration(milliseconds: 4000), () {});

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5359DC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 320,
              height: 320,
              child: Image.asset('assets/images/logo_unmsm.png'),
            )
          ],
        ),
      ),

    );
  }


}