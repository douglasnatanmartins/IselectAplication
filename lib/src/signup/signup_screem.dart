import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/user_model.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/home/home_screem_page.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/login/login_screem.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/login/componentes/bleaze_container.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:validadores/validadores.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {


  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "+### #### ######", filter: {"#": RegExp(r'[0-9]')});



  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(PageTransition(
            type: PageTransitionType.scale,
            child: LoginPage()
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ya tengo Cuenta!',
              style: GoogleFonts.amaranth(
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800]
                  )
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Entrar',
              style: GoogleFonts.amaranth(
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.deepOrange,
                      decoration: TextDecoration.underline
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Re',
          style: GoogleFonts.portLligatSans(
            // ignore: deprecated_member_use
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'gis',
              style: TextStyle(color: Colors.black, fontSize: 40),
            ),
            TextSpan(
              text: 'tro',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 40),
            ),
          ]),
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            if(model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Form(
                key: _formKey,
                child:ListView(
                  children: <Widget>[
                    Container(
                      height: height,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              top: -height * .15,
                              right: -MediaQuery.of(context).size.width * .4,
                              child: BezierContainer()),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: height * .2),
                                  _title(),
                                  SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10, bottom: 3),
                                        child: Text(
                                          "Nombre y Apellido",
                                          style: GoogleFonts.amaranth(
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                        hintText: "Nombre y Apellido",
                                        hintStyle: GoogleFonts.amaranth(
                                            textStyle: TextStyle( color: Colors.grey[400])),
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true
                                    ),
                                    textInputAction: TextInputAction.send,
                                    textCapitalization: TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    validator: (text) {
                                      return Validador()
                                          .add(Validar.OBRIGATORIO,
                                          msg:
                                          "debe contener 5 caracteres")
                                          .minLength(5)
                                          .valido(text);
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10, bottom: 3),
                                        child: Text(
                                          "Correo",
                                          style: GoogleFonts.amaranth(
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        hintText: "correo@gmail.com",
                                        hintStyle: GoogleFonts.amaranth(
                                            textStyle: TextStyle( color: Colors.grey[400])),
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (text) {
                                      return Validador()
                                          .add(Validar.OBRIGATORIO,
                                          msg:
                                          "intente un correo diferente")
                                          .minLength(6)
                                          .valido(text);
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10, bottom: 3),
                                        child: Text(
                                          "Contraseña",
                                          style: GoogleFonts.amaranth(
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  TextFormField(
                                    controller: _passController,
                                    decoration: InputDecoration(
                                        hintText: "Contraseña",
                                        hintStyle: GoogleFonts.amaranth(
                                            textStyle: TextStyle( color: Colors.grey[400])),
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true
                                    ),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    validator: (text) {
                                      return Validador()
                                          .add(Validar.OBRIGATORIO,
                                          msg:
                                          "debe contener 6 caracteres")
                                          .minLength(6)
                                          .valido(text);
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10, bottom: 3),
                                        child: Text(
                                          "Telefono",
                                          style: GoogleFonts.amaranth(
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  TextFormField(
                                    controller: _phoneController,
                                    inputFormatters: [
                                      maskTextInputFormatter
                                    ],
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        hintText: "+595 1234 123456",
                                        hintStyle: GoogleFonts.amaranth(
                                            textStyle: TextStyle( color: Colors.grey[400])),
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (text) {
                                      return Validador()
                                          .add(Validar.OBRIGATORIO,
                                          msg:
                                          "Intente un telefono válido")
                                          .minLength(6)
                                          .valido(text);
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                offset: Offset(2, 4),
                                                blurRadius: 5,
                                                spreadRadius: 2)
                                          ],
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                                      child: Text(
                                        'Registrar',
                                        style: GoogleFonts.acme(
                                            textStyle: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white
                                            )
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      if(_formKey.currentState.validate()){

                                        Map<String, dynamic> userData = {
                                          "name": _nameController.text,
                                          "email": _emailController.text,
                                          "telefone": _phoneController.text,
                                          "rua": "rua",
                                          "lat": 0.0,
                                          "long": 0.0,
                                          "estado": "estado",
                                          "cidade": "cidade",
                                          "pais": "pais",
                                        };
                                        model.signUp(
                                          userData: userData,
                                          pass: _passController.text,
                                          onSuccess: _onSuccess,
                                          onFail: _onFail,
                                        );

                                      }
                                    },
                                  ),
                                  _createAccountLabel(),
                                  SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
            );
          },
        )
    );
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuario creado con suceso"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((funtion) {
      Navigator.of(context).pushReplacement(PageTransition(
          type: PageTransitionType.rotate,
          child: HomeScreemPage(),
          duration: Duration(milliseconds: 800)));
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuario"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }

}