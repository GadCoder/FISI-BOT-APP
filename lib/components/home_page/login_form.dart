import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chapa_tu_aula/screens/home.dart';
import 'package:chapa_tu_aula/services/login.dart';
import 'package:chapa_tu_aula/services/api_sum.dart';
import 'package:chapa_tu_aula/components/home_page/input_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final apiSUM = SumAPI();

  final login = Login();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade400,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(
            left: 0.0, top: 200.0, right: 0.0, bottom: 0.0),
        child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0)
                ]),
            clipBehavior: Clip.antiAlias,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      // Add bottom margin
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Iniciar sesión",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    EmailField(inputController: emailController),
                    PasswordField(inputController: passwordController),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 36.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade400,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                makeLoginRequest(emailController.text,
                                    passwordController.text);
                              },
                              child: const Text("Iniciar sesión")),
                        )),
                    InkWell(
                      onTap: () async {
                        await launchUrl(Uri.parse(
                            'https://webmail.unmsm.edu.pe/app/cambioclave/')); // Add URL which you want here
                        // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                      },
                      child: const Text(
                        '¿No recuerdas tu contraseña?',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  void makeLoginRequest(String email, String password) async {
    final dynamic result = await apiSUM.login(
      email.split("@")[0],
      password,
    );

    if (result != null ) {
      Map<String, dynamic> responseData = result['response'];
      Map<String, String> cookies = result['cookies'];
      login.showAlertToast("Correctamente logeado.");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(responseData: responseData, cookies: cookies)));
    } else {
      login.showAlertToast("Correo o contraseña incorrecta");
    }
  }
}
