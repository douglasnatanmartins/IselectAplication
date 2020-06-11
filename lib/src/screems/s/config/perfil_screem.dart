import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/user_model.dart';
import 'package:iselectaplication1990/src/screems/s/config/perfil_config.dart';
import 'package:scoped_model/scoped_model.dart';

class PerfilScreem extends StatefulWidget {
  @override
  _PerfilScreemState createState() => _PerfilScreemState();
}

class _PerfilScreemState extends State<PerfilScreem> {

  String _idUsuarioLogado;
  String _urlImagemRecuperada;
  String _name;
  String _email;

  _recuperarDadosDoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
    await db.collection("users").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = await snapshot.data;


    if (dados["icon"] != null) {
      setState(() {
        _urlImagemRecuperada = dados["icon"];
      });
    }
    if (dados["name"] != null) {
      setState(() {
        _name = dados["name"];
      });
    }
    if (dados["email"] != null) {
      setState(() {
        _email= dados["email"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosDoUsuario();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: _urlImagemRecuperada != null
                      ? NetworkImage(_urlImagemRecuperada)
                      : AssetImage("images/ideia.jpg"),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 70, top: 60),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Center(
                          child: CircleAvatar(
                              backgroundColor: Colors.orange[400],
                              radius: 15,
                              child: IconButton(
                                icon: Icon(Icons.edit,
                                    color: Colors.black, size: 14),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PerfilConfig()));
                                },
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Text(
                  _name != null ? _name : "Nome do Usuario",
                  style: GoogleFonts.amaranth(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  _email != null ? _email : "email@gmail.com",
                  style: GoogleFonts.amaranth(
                      color:  Colors.black,
                      fontSize: 16
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width-220,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black
                    ),
                    child: Center(
                      child: Text(
                          'Upgrade to PRO',
                          style:GoogleFonts.acme(
                              color: Colors.orange[400]
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width-30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.orange[400]
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Icon(Icons.security, color: Colors.black),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width -340,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Privacidade",
                                style: GoogleFonts.amaranth(
                                    color: Colors.black,
                                    fontSize: 22
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width -240),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      )
                  ),
                ),
                SizedBox(height: 15),
                Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width-30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.orange[400]
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(Icons.card_giftcard, color: Colors.black),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width -340,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Histórico",
                              style: GoogleFonts.amaranth(
                                  color: Colors.black,
                                  fontSize: 22
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width -210),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    )
                ),
                SizedBox(height: 15),
                Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width-30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.orange[400]
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(Icons.help, color: Colors.black),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width -340,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Help y Soporte",
                              style: GoogleFonts.amaranth(
                                  color: Colors.black,
                                  fontSize: 22
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width -268),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    )
                ),
                SizedBox(height: 15),
                ScopedModelDescendant<UserModel>(
                  builder: (context, child, model){
                    if(!model.isloggedIn())
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return GestureDetector(
                      onTap: (){
                        model.signOut();
                      },
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width-30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.orange[400]
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Icon(Icons.exit_to_app, color: Colors.black),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width -340,),
                              Row(
                                mainAxisAlignment:MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Salir del App",
                                    style: GoogleFonts.amaranth(
                                        color: Colors.black,
                                        fontSize: 22
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width -250),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          )
                      ),
                    );
                  },
                ),
                SizedBox(height: 15),
              ],
            ),
          ],
        )
    );
  }
}
