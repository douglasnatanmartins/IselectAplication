import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/user_model.dart';
import 'package:iselectaplication1990/src/home/home_screem_botton_navigator.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/signup/signup_screem.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/login/componentes/bleaze_container.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:validadores/validadores.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _passController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('o'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(PageTransition(
            type: PageTransitionType.scale, child: SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No tengo cuenta!',
              style: GoogleFonts.amaranth(
                  textStyle: TextStyle(fontSize: 16, color: Colors.grey[800])),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Registrar',
              style: GoogleFonts.amaranth(
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.deepOrange,
                      decoration: TextDecoration.underline)),
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
          text: 'L',
          style: GoogleFonts.portLligatSans(
            // ignore: deprecated_member_use
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'og',
              style: TextStyle(color: Colors.black, fontSize: 40),
            ),
            TextSpan(
              text: 'in',
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
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Form(
              key: _formKey,
              child: ListView(
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
                                SizedBox(height: 60),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 3),
                                      child: Text(
                                        "Correo",
                                        style: GoogleFonts.amaranth(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                      ),
                                    )
                                  ],
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      hintText: "correo@gmail.com",
                                      hintStyle: GoogleFonts.amaranth(
                                          textStyle:
                                              TextStyle(color: Colors.grey)),
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (text) {
                                    return Validador()
                                        .add(Validar.OBRIGATORIO,
                                            msg: "intente un correo diferente")
                                        .minLength(6)
                                        .valido(text);
                                  },
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 3),
                                      child: Text(
                                        "Contraseña",
                                        style: GoogleFonts.amaranth(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                      ),
                                    )
                                  ],
                                ),
                                TextFormField(
                                  controller: _passController,
                                  decoration: InputDecoration(
                                    hintText: "contraseña",
                                    hintStyle: GoogleFonts.amaranth(
                                        textStyle:
                                            TextStyle(color: Colors.grey)),
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true,
                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  validator: (text) {
                                    return Validador()
                                        .add(Validar.OBRIGATORIO,
                                            msg: "debe contener 6 caracteres")
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
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
                                            colors: [
                                              Color(0xfffbb448),
                                              Color(0xfff7892b)
                                            ])),
                                    child: Text(
                                      'Entrar',
                                      style: GoogleFonts.acme(
                                          textStyle: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  onTap: () {
                                    if (_formKey.currentState.validate()) {
                                      model.signIn(
                                          email: _emailController.text,
                                          pass: _passController.text,
                                          onSuccess: _onSuccess,
                                          onFail: _onFail
                                      );
                                    }
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(_emailController.text.isEmpty)
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text("Insira su correo, para recuperación"),
                                        backgroundColor: Colors.redAccent,
                                        duration: Duration(seconds: 3),
                                      ));
                                    else{
                                      model.recoverPass(_emailController.text);
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text("Revisa tu correo!"),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                      ));
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.centerRight,
                                    child: Text('Olvide mi contraseña! >',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                _divider(),
                                SizedBox(height: 20),
                                _createAccountLabel(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        }));
  }

  void _onSuccess() {
    Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.scale,
        child: HomeScreen(),
        duration: Duration(milliseconds: 600)));
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao entrar"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}