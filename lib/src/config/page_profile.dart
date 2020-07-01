import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/componentes/localizacao.dart';
import 'package:iselectaplication1990/componentes/localizacao_servico.dart';
import 'package:iselectaplication1990/model/model_servico.dart';
import 'package:iselectaplication1990/src/edita_servico/edita_servico.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/config/perfil_config/perfil_config.dart';
import 'package:iselectaplication1990/src/tiles/item_servico_tile.dart';
import 'package:iselectaplication1990/src/tiles/item_servico_tile_misservicos.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class PageProfile extends StatefulWidget {
  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile>{

  TextEditingController _controller = TextEditingController();
  final _controllerStream = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionaListenerAnuncio() async {
    await _recuperarDadosDoUsuario();

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_servicos")
        .document(_idUsuarioLogado)
        .collection("servico")
        .snapshots();

    stream.listen((dados) {
      _controllerStream.add(dados);
    });
  }

  // File _image;
  String _email;

  // bool _subindoImagen = false;
  String _urlImagemRecuperada;
  String name;
  String _telefone;
  double _lat;
  double _long;

  String _idUsuarioLogado;

  _recuperarDadosDoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("users").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
    _controller.text = dados["name"];


    if (dados["icon"] != null) {
      setState(() {
        _urlImagemRecuperada = snapshot.data["icon"];
      });
    }
    if (dados["name"] != null) {
      setState(() {
        name = snapshot.data["name"];
      });
    }
    if (dados["telefone"] != null) {
      setState(() {
        _telefone = dados["telefone"];
      });
    }
    if (dados["lat"] != null) {
      setState(() {
        _lat = dados["lat"];
      });
    }
    if (dados["long"] != null) {
      setState(() {
        _long = dados["long"];
      });
    }
  }

  ///PO documento só pode ser removido depois que não tiver mais nada,
  ///dentro dele se nao o Firebase nao permite remover.
  Future<void> _removeClasifiacao(String servicoId) async {
    await Firestore.instance.
    collection("qualificacoes").
    document(servicoId).collection("stars").
    document(_idUsuarioLogado).delete();
  }

  _removerServico(String idServico) {
    Firestore db = Firestore.instance;

    db
        .collection("meus_servicos")
        .document(_idUsuarioLogado)
        .collection("servico")
        .document(idServico)
        .delete()
        .then((_) {
      db.collection("servicos").document(idServico).delete().then((_) {
        db
            .collection("meus_favoritos")
            .document(_idUsuarioLogado)
            .collection("favoritos")
            .document(idServico)
            .delete()
            .then((_) {
          return showDialog(
              context: context,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text(
                  "Servicio excluido con sucesso",
                  style: GoogleFonts.amaranth(color: Colors.green),
                ),
                actions: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text(
                      "Ok",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosDoUsuario();
    _adicionaListenerAnuncio();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.orange[700],
              Colors.orange[400],
              Colors.orange[300],
              Colors.orange[200],
              Colors.white
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, top: 15, right: 15),
                  height: 160,
                  width: MediaQuery.of(context).size.width - 25,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[700],
                          blurRadius: 3.0,
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0),
                        )
                      ],
                      gradient: LinearGradient(
                          colors: [
                            Colors.orange[500],
                            Colors.orange[400],
                            Colors.orange[300],
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              backgroundImage: _urlImagemRecuperada != null
                                  ? NetworkImage(_urlImagemRecuperada)
                                  : AssetImage("images/ideia.jpg")),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _lat != null
                                  ? IconButton(
                                icon: Icon(Icons.location_on,
                                    color: Colors.black, size: 28),
                                onPressed: () {
                                  launch(
                                      "https://www.google.com/maps/search/?api=1&query=${_lat},"
                                          "${_long}");
                                },
                              )
                                  : Text(""),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Hola,  ",
                                    style: GoogleFonts.portLligatSans(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Text(
                                    name != null ? name : "",
                                    style: GoogleFonts.portLligatSans(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _telefone != null ? _telefone : "",
                                    style: GoogleFonts.portLligatSans(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Servicios",
                                  style: GoogleFonts.portLligatSans(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 15),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      "Mis Servicios",
                      style: GoogleFonts.amaranth(
                          textStyle:
                          TextStyle(color: Colors.black, fontSize: 16)),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 0, right: 10),
                  child: Divider(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LocalizacaoServico()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 50,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[700],
                              blurRadius: 4.0,
                              spreadRadius: 0.0,
                              offset: Offset(1.0, 1.0),
                            )
                          ],
                          gradient: LinearGradient(
                              colors: [
                                Colors.orange[400],
                                Colors.orange[300],
                                Colors.orange[200],
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(),
                          Text(
                            "Adiccionar Servicio",
                            style: GoogleFonts.amaranth(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: StreamBuilder(
              stream: _controllerStream.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return SizedBox(
                      height: 20,
                      width: 80,
                      child: Shimmer.fromColors(
                          period: Duration(seconds: 10),
                          child: Container(
                            color: Colors.grey.withAlpha(50),
                            margin: EdgeInsets.symmetric(vertical: 2),
                          ),
                          baseColor: Colors.yellow[800],
                          highlightColor: Colors.grey
                      ),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot = snapshot.data;

                    if (querySnapshot.documents.length == 0) {
                      return Container(
                          padding: EdgeInsets.all(25),
                          child: Column(
                            children: [
                              Text(
                                "Sin servicios Registrados!",
                                style: GoogleFonts.amaranth(
                                    color: Colors.orange[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Cuando tengas se van listar aqui!",
                                style: GoogleFonts.amaranth(
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Empieza, Registra un servicio!",
                                style: GoogleFonts.amaranth(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ));
                    }
                    return ListView.builder(
                        itemCount: querySnapshot.documents.length,
                        itemBuilder: (context, index) {
                          List<DocumentSnapshot> servicos =
                          querySnapshot.documents.toList();

                          DocumentSnapshot documentSnapshot = servicos[index];
                          ModelServico servicoM = ModelServico.fromdocumentSnapshot(documentSnapshot);

                          return ItemServicoTileMeusServicos(
                            servico: servicoM,
                            onTapEditing: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditaServico(servicoM)
                                ));
                            },
                            onTapRemover: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12)),
                                    title: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "images/icons/alarma.png"))),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width -
                                                350),
                                        Text(
                                          "Confirmación",
                                          style:
                                          GoogleFonts.portLligatSans(
                                              color:
                                              Colors.orange[600],
                                              decoration:
                                              TextDecoration
                                                  .underline,
                                              fontSize: 22,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "¿Realmente quieres eliminar el servicio?",
                                          style:
                                          GoogleFonts.portLligatSans(
                                              color:
                                              Colors.orange[600],
                                              fontSize: 16),
                                        ),
                                        Text(
                                          "Perderás todas tus calificaciones",
                                          style:
                                          GoogleFonts.portLligatSans(
                                            color: Colors.orange[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      RaisedButton(
                                          color: Colors.grey[600],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          child: Text(
                                            "No, Cancelar",
                                            style: GoogleFonts.amaranth(
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(true);
                                          }),
                                      RaisedButton(
                                          color: Colors.red[600],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          child: Text(
                                            "Sí, eliminar",
                                            style: GoogleFonts.amaranth(
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (context) =>
                                                    AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                      title: Text(
                                                        "¿Confirma la eliminación?",
                                                        style: GoogleFonts.portLligatSans(
                                                            color: Colors
                                                                .orange[
                                                            600],
                                                            decoration:
                                                            TextDecoration
                                                                .underline,
                                                            fontSize:
                                                            22,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      actions: [
                                                        RaisedButton(
                                                            color: Colors.red[
                                                            600],
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(
                                                                    12)),
                                                            child:
                                                            Text(
                                                              "Sí",
                                                              style: GoogleFonts.amaranth(
                                                                  color:
                                                                  Colors.white),
                                                            ),
                                                            onPressed:
                                                                ()  async {
                                                                  _removeClasifiacao(servicoM.id);
                                                                  await _removerServico(servicoM.id);
                                                                   Navigator.of(context).pop(true);
                                                            }),
                                                        RaisedButton(
                                                            color: Colors.grey[
                                                            600],
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(
                                                                    12)),
                                                            child:
                                                            Text(
                                                              "No",
                                                              style: GoogleFonts.amaranth(
                                                                  color:
                                                                  Colors.white),
                                                            ),
                                                            onPressed:
                                                                () {
                                                              Navigator.of(context)
                                                                  .pop(true);
                                                            }),
                                                      ],
                                                    )).then((_) {
                                              Navigator.of(context)
                                                  .pop(true);
                                            });
                                          })
                                    ],
                                  ));
                            },
                          );
                        });
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
