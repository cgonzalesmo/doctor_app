import 'package:doctor_app/screens/loginScreen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class UserRegistrationScreen extends StatefulWidget {
  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _visiblePassword;
  bool _visibleConfirmPassword;

  bool isLogin = false;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final String role = 'User';

  String nameText;
  String emailText;
  String phoneText;
  String passwordText;
  String confirmPasswordText;
  String _chosenValue;

  final _auth = FirebaseAuth.instance;

  final databaseReference =
      FirebaseDatabase.instance.reference().child('Users');

  void _saveItem() async {
    try {
      setState(() {
        isLogin = true;
      });
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: emailText, password: passwordText);
      if (newUser != null) {
        final User user = FirebaseAuth.instance.currentUser;
        final userID = user.uid;

        _addUser(userID);

        sendUser(userID);

        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.rightToLeft));
      }
    } catch (e) {
      setState(() {
        isLogin = false;
      });
      print(e);

      String errorText = getMessageFromErrorCode(e);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(errorText),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            )
          ],
        ),
      );
    }
  }

  String getMessageFromErrorCode(error) {
    switch (error.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        isLogin = false;
        return "Correo electronico ya fue usado. Ir a la página de inicio de sesión.";
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        isLogin = false;
        return "Combinación incorrecta de correo electrónico/contraseña.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        isLogin = false;
        return "Ningún usuario encontrado con este correo electrónico.";
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        isLogin = false;
        return "Usuario deshabilitado.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        isLogin = false;
        return "Demasiadas solicitudes para iniciar sesión en esta cuenta.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        isLogin = false;
        return "Error del servidor, inténtalo de nuevo más tarde.";
        break;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        isLogin = false;
        return "Dirección de correo electrónico es inválida.";
        break;
      default:
        isLogin = false;
        return "Error de inicio de sesion. Inténtalo de nuevo.";
        break;
    }
  }

  sendUser(String userID) async {
    // final String url = 'https://doctor-api.up.railway.app/api/user/';
    final String url = 'https://doctor-api.up.railway.app/api/user/';
    try {
      var response = await http.post(Uri.parse(url), body: {
        "registration_id": userID,
        "user_name": nameText,
        "user_gender": _chosenValue,
        "mail_id": emailText,
        "phone_no": phoneText
      });
      if (response.statusCode == 201) {
        print(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void _addUser(String userID) {
    databaseReference.child(userID).set({'name': nameText, 'role': role});
  }

  @override
  void initState() {
    super.initState();
    _visiblePassword = false;
    _visibleConfirmPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  // color: Colors.red,
                  child: Lottie.asset('assets/animations/patient.json'),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Formulario para Usuario",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //! Name
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: Text("Nombre*"),
                            alignLabelWithHint: true,
                          ),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: _name,
                          validator: nameValidate,
                          onSaved: (value) {
                            nameText = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //! Gender
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            label: Text("Elija género*"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) => value == null
                              ? 'El campo no debe estar vacío'
                              : null,
                          isExpanded: true,
                          value: _chosenValue,
                          items: [
                            'Male',
                            'Female',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {
                              _chosenValue = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //! Email
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: Text('Correo*'),
                            alignLabelWithHint: true,
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          validator: emailValidate,
                          onSaved: (value) {
                            emailText = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //! Phone Number
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: Text("Número de teléfono*"),
                            alignLabelWithHint: true,
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: _phone,
                          validator: phoneValidate,
                          onSaved: (value) {
                            phoneText = value;
                          },
                        ),
                        SizedBox(height: 20),

                        //! Password
                        Container(
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      label: Text("Contraseña*"),
                                      alignLabelWithHint: true,
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _visiblePassword =
                                                  !_visiblePassword;
                                            });
                                          },
                                          icon: Icon(_visiblePassword == true
                                              ? Icons.visibility
                                              : Icons.visibility_off))),
                                  obscureText: !_visiblePassword,
                                  obscuringCharacter: "\u2749",
                                  textInputAction: TextInputAction.next,
                                  controller: _password,
                                  validator: passwordValidate,
                                  onSaved: (value) {
                                    passwordText = value;
                                  },
                                ),
                              ),
                              Spacer(),
                              Tooltip(
                                message:
                                    '\n\u2022 Incluir caracteres en minúsculas y mayúsculas\n\u2022 Incluya al menos un número\n\u2022 Incluir al menos un carácter especial\n\u2022 Tener más de 6 caracteres\n',
                                triggerMode: TooltipTriggerMode.tap,
                                showDuration: Duration(seconds: 5),
                                preferBelow: false,
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //! Confirm Password
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              label: Text("Confirmar contraseña*"),
                              alignLabelWithHint: true,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _visibleConfirmPassword =
                                          !_visibleConfirmPassword;
                                    });
                                  },
                                  icon: Icon(_visibleConfirmPassword == true
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                          obscureText: !_visibleConfirmPassword,
                          textInputAction: TextInputAction.go,
                          obscuringCharacter: "\u2749",
                          controller: _confirmPassword,
                          validator: confirmPasswordValidate,
                          onSaved: (value) {
                            confirmPasswordText = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                isLogin == false
                    ? ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            print(role);
                            print(nameText);
                            print(emailText);
                            print(phoneText);
                            print(passwordText);
                            print(confirmPasswordText);

                            _saveItem();
                            FocusScope.of(context).unfocus();
                          }
                        },
                        child: Text('Registrar'),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String nameValidate(String name) {
    if (name.isEmpty) {
      return 'El campo no debe estar vacío';
    } else {
      return null;
    }
  }

  String emailValidate(String email) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regEx = RegExp(pattern);

    if (email.isEmpty) {
      return 'El campo no debe estar vacío';
    } else if (!regEx.hasMatch(email)) {
      return 'Introduzca un correo válido';
    } else {
      return null;
    }
  }

  String phoneValidate(String phone) {
    if (phone.isEmpty) {
      return 'El campo no debe estar vacío';
    } else if (phone.length < 9 || phone.length > 9) {
      return 'El número de teléfono debe contener 9 dígitos';
    } else {
      return null;
    }
  }

  String passwordValidate(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regEx = RegExp(pattern);

    if (password.isEmpty) {
      return 'El campo no debe estar vacío';
    } else if (!regEx.hasMatch(password)) {
      return "Elija una contraseña segura";
    } else {
      return null;
    }
  }

  String confirmPasswordValidate(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'El campo no debe estar vacío';
    } else if (confirmPassword != _password.text) {
      return "La contraseña no coincide";
    } else {
      return null;
    }
  }
}
