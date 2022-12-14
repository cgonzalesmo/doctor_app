import 'package:doctor_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThursdayScreen extends StatefulWidget {
  final String doctorId;
  ThursdayScreen(this.doctorId);

  @override
  _ThursdayScreenState createState() => _ThursdayScreenState(doctorId);
}

class _ThursdayScreenState extends State<ThursdayScreen> {
  final String doctorId;
  _ThursdayScreenState(this.doctorId);

  final _formKey = GlobalKey<FormState>();

  final _clinic = TextEditingController();
  final _timeController = TextEditingController();

  String clinicText;

  String _chosenValue;

  TimeOfDay time;

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );
    if (newTime == null) return;
    setState(() {
      time = newTime;
      _timeController.text = newTime.format(context);
    });
  }

  void sendData() async {
    final String url =
        'https://doctor-api.up.railway.app/api/thursday/$doctorId/';
    var response = await http.put(Uri.parse(url), body: {
      "thursday_id": doctorId,
      "chamber_location": clinicText,
      "available_time": _timeController.text,
      "slots_available": _chosenValue,
      "thursday_name": doctorId
    });

    if (response.statusCode == 200) {
      print(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Jueves Clínica cargado")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Algo salió mal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "THURSDAY",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Palette.scaffoldColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //! Clinic Location
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text("Ubicación de la clínica"),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        controller: _clinic,
                        validator: clinicValidate,
                        onSaved: (value) {
                          clinicText = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //! Slots Available
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          label: Text("Elija cantidad de pacientes"),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null
                            ? 'El campo no debe estar vacío'
                            : null,
                        isExpanded: true,
                        value: _chosenValue,
                        items: [
                          '0',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10',
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
                      SizedBox(height: 20),

                      //! Available Time
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            // color: Colors.red,
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: Text("Tiempo disponible"),
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                              ),
                              enabled: false,
                              controller: _timeController,
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                              icon: Icon(Icons.access_time),
                              onPressed: () {
                                pickTime(context);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    sendData();
                  }
                  print(clinicText);
                  print(_chosenValue);
                  print(_timeController.text);

                  FocusScope.of(context).unfocus();
                },
                child: Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String clinicValidate(String clinic) {
    if (clinic.isEmpty) {
      return "La clínica no debe estar vacía.";
    } else {
      return null;
    }
  }
}
