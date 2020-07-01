import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/model_servico.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DetalheAnuncio extends StatefulWidget {
  ModelServico servico;
  DetalheAnuncio(this.servico);

  @override
  _DetalheAnuncioState createState() => _DetalheAnuncioState();
}

class _DetalheAnuncioState extends State<DetalheAnuncio> {
  List<ModelServico> servicosModel = [];

  var ratingSoma = 0.0;
  var idDoc;
  double result = 0.0;
  bool duplicado = false;
  String docId;
  bool favoritoexiste = false;
  String _idUsuarioLogado;
  var initialRating = 0.5;
  var rating = 0.5;
  var index;
  var qualificacoes;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controllerCalificacoes = StreamController<QuerySnapshot>.broadcast();

  _recuperarDadosDoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;


    await _adicionarOuvintedeQualificacoes();
    await _getFavoritos();
  }

  List<Widget> _getListImagens() {
    List<String> listaUrlImagens = widget.servico.fotos;
    return listaUrlImagens.map((url) {
      return Container(
        padding: EdgeInsets.only(top: 220, left: 16),
        height: 250,
        decoration: BoxDecoration(
            image:
            DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
      );
    }).toList();
  }
  
  // ignore: missing_return
  Future<Stream<QuerySnapshot>> _adicionarOuvintedeQualificacoes() async {
    Stream<QuerySnapshot> stream =
    Firestore.instance
        .collection("qualificacoes")
        .document(widget.servico.id)
        .collection("stars").snapshots();

    stream.listen((dados) {
      _controllerCalificacoes.add(dados);
    });
  }

  _getFavoritos() async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection("meus_favoritos")
        .document(_idUsuarioLogado)
        .collection("favoritos")
        .document(widget.servico.id)
        .get();

    Map<String, dynamic> dados = snapshot.data;

    if (dados == null) {
      return Text("");
    }
    if (dados["id"] == widget.servico.id) {
      setState(() {
        favoritoexiste = true;
      });
    }
  }

  Future _salvaFavorito() async {
    await Firestore.instance
        .collection("meus_favoritos")
        .document(_idUsuarioLogado)
        .collection("favoritos")
        .document(widget.servico.id)
        .setData(widget.servico.toMap());
  }

  Future _removerFavorito(String idServico) async {
    Firestore db = Firestore.instance;

    await db
        .collection("meus_favoritos")
        .document(_idUsuarioLogado)
        .collection("favoritos")
        .document(widget.servico.id)
        .delete()
        .then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosDoUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          widget.servico.title,
          style: GoogleFonts.amaranth(
              textStyle: TextStyle(color: Colors.black, fontSize: 24)),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                  height: 250,
                  child: Carousel(
                      images: _getListImagens(),
                      dotSize: 5.0,
                      dotColor: Colors.white,
                      autoplay: true,
                      autoplayDuration: Duration(seconds: 5),
                      animationCurve: Curves.linearToEaseOut,
                      dotIncreasedColor: Colors.orange,
                      dotIncreaseSize: 2,
                      dotBgColor: Colors.grey.withAlpha(60))),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Desea Calificar el Servicio",
                                        style:
                                        GoogleFonts.amaranth(fontSize: 16),
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          StreamBuilder<QuerySnapshot>(
                                            stream: Firestore.instance.
                                            collection("qualificacoes").
                                            document(widget.servico.id).
                                            collection("stars").snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return SizedBox(
                                                  height: 10,
                                                  width: 100,
                                                  child: Shimmer.fromColors(
                                                      period: Duration(milliseconds: 1000),
                                                      child: Container(color: Colors.white),
                                                      baseColor: Colors.orange,
                                                      highlightColor: Colors.white),
                                                );
                                              }
                                              QuerySnapshot querySnapshot = snapshot.data;
                                              List<DocumentSnapshot> snapshots = querySnapshot.documents.toList();
                                              for(final doc in snapshots){
                                                if(doc != null){
                                                  final index = snapshots.indexOf(doc);
                                                  idDoc = doc.documentID;
                                                  if(index == 0){
                                                    ratingSoma = doc.data["rating"] - doc.data["rating"];
                                                  }

                                                }
                                                result = ratingSoma += doc.data["rating"] / snapshots.length;
                                                initialRating = result.round().roundToDouble();
                                              }
                                              switch (snapshot.connectionState) {
                                                case ConnectionState.none:
                                                case ConnectionState.waiting:
                                                  return Container();
                                                  break;
                                                case ConnectionState.active:
                                                case ConnectionState.done:
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  return SmoothStarRating(
                                                    rating: initialRating,
                                                    color: Colors.orange[600],
                                                    size: 30,
                                                    borderColor: Colors.grey,
                                                    starCount: 5,
                                                    onRated: (value) {
                                                      rating = value;
                                                    },
                                                  );
                                              }
                                              return Container();
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(12)),
                                            color: Colors.grey[600],
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Cancelar",
                                              style: GoogleFonts.acme(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(12)),
                                            color: Colors.orange,
                                            onPressed: () async {
                                              await Firestore.instance
                                                  .collection("servicos")
                                                  .document(widget.servico.id)
                                                  .updateData(
                                                  {"rating": rating});

                                              await Firestore.instance
                                                  .collection("qualificacoes")
                                                  .document(widget.servico.id)
                                                  .collection("stars")
                                                  .document(_idUsuarioLogado)
                                                  .setData({
                                                "title": widget.servico.title,
                                                "idServico": widget.servico.id,
                                                "rating": rating
                                              }).then((_) {
                                                return showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      Future.delayed(
                                                          Duration(seconds: 2),
                                                              () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          });
                                                      return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12)),
                                                          title: Container(
                                                            padding:
                                                            EdgeInsets.all(
                                                                12),
                                                            child: Text(
                                                              "Agregado con Éxito!!",
                                                              style: GoogleFonts
                                                                  .amaranth(),
                                                            ),
                                                          ));
                                                    });
                                              }).then((_) {
                                                Navigator.of(context).pop(true);
                                              });
                                            },
                                            child: Text(
                                              "Calificar",
                                              style: GoogleFonts.acme(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance.
                            collection("qualificacoes").
                            document(widget.servico.id).
                            collection("stars").snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox(
                                  height: 10,
                                  width: 100,
                                  child: Shimmer.fromColors(
                                      period: Duration(milliseconds: 1000),
                                      child: Container(color: Colors.white),
                                      baseColor: Colors.orange,
                                      highlightColor: Colors.white),
                                );
                              }
                              QuerySnapshot querySnapshot = snapshot.data;
                              List<DocumentSnapshot> snapshots = querySnapshot.documents.toList();
                              for(final doc in snapshots){
                                if(doc != null){
                                  final index = snapshots.indexOf(doc);
                                  idDoc = doc.documentID;
                                  if(index == 0){
                                    ratingSoma = doc.data["rating"] - doc.data["rating"];
                                  }

                                }
                                result = ratingSoma += doc.data["rating"] / snapshots.length;
                                initialRating = result.round().roundToDouble();
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Container();
                                  break;
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return SmoothStarRating(
                                    isReadOnly: true,
                                    rating: initialRating,
                                    color: Colors.orange[600],
                                    size: 30,
                                    borderColor: Colors.grey,
                                    starCount: 5,
                                    onRated: (value) {
                                      setState(() {
                                        initialRating = value;
                                      });
                                    },
                                  );
                              }
                              return Container();
                            },
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 350,
                          ),
                          StreamBuilder(
                            stream: _controllerCalificacoes.stream,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return SizedBox(
                                    height: 10,
                                    width: 100,
                                    child: Shimmer.fromColors(
                                        period: Duration(milliseconds: 500),
                                        child: Container(
                                            color: Colors.white
                                        ),
                                        baseColor: Colors.orange,
                                        highlightColor: Colors.white
                                    ),
                                  );
                                  break;
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  QuerySnapshot query = snapshot.data;

                                  if (query.documents.length == 0) {
                                    return Text(
                                      "0 Evaluaciones",
                                      style: GoogleFonts.amaranth(
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  }
                                  if (query.documents.length == 1) {
                                    return Text(
                                      "${query.documents.length.toString()}  evaluación",
                                      style: GoogleFonts.amaranth(
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  }
                                  return Text(
                                    "${query.documents.length.toString()} evaluaciones",
                                    style: GoogleFonts.amaranth(
                                      color: Colors.grey[600],
                                    ),
                                  );
                              }
                              return Container();
                            },
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                    Row(
                      children: [
                        Text(
                          "Precio:  ",
                          style: GoogleFonts.amaranth(
                              textStyle: TextStyle(
                                fontSize: 18,
                              )),
                        ),
                        Text(
                          widget.servico.preco,
                          style: GoogleFonts.amaranth(
                              textStyle: TextStyle(
                                  fontSize: 18, color: Colors.orange[600])),
                        ),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                !favoritoexiste
                                    ? IconButton(
                                  icon: Icon(Icons.favorite_border,
                                      size: 30, color: Colors.grey[600]),
                                  onPressed: () {
                                    setState(() {
                                      this.favoritoexiste =
                                      !this.favoritoexiste;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    22)),
                                            title: Text(
                                              "Adiccionar a Favoritos?",
                                              style: GoogleFonts.amaranth(
                                                  color: Colors.orange[800]),
                                            ),
                                            actions: [
                                              RaisedButton(
                                                color: Colors.red[500],
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 22,
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      "No",
                                                      style: GoogleFonts
                                                          .amaranth(
                                                          color: Colors
                                                              .white),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    this.favoritoexiste =
                                                    !this.favoritoexiste;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              RaisedButton(
                                                color: Colors.orange[600],
                                                child: Row(
                                                  children: [
                                                    Text("Sí",
                                                        style: GoogleFonts
                                                            .amaranth(
                                                            color: Colors
                                                                .white)),
                                                    SizedBox(width: 3),
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 22,
                                                    )
                                                  ],
                                                ),
                                                onPressed: () {
                                                  _salvaFavorito().then((_) {
                                                    _onSave();
                                                    _onSuccess();
                                                  });
                                                },
                                              ),
                                              SizedBox(width: 50)
                                            ],
                                          );
                                        });
                                  },
                                )
                                    : IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    size: 32,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      this.favoritoexiste =
                                      !this.favoritoexiste;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    22)),
                                            title: Text(
                                              "Quiere Remover de Favoritos?",
                                              style: GoogleFonts.amaranth(
                                                  color: Colors.orange[800]),
                                            ),
                                            actions: [
                                              RaisedButton(
                                                color: Colors.orange[600],
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 22,
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      "No",
                                                      style: GoogleFonts
                                                          .amaranth(
                                                          color: Colors
                                                              .white),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    this.favoritoexiste =
                                                    !this.favoritoexiste;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              RaisedButton(
                                                color: Colors.red,
                                                child: Row(
                                                  children: [
                                                    Text("Sí",
                                                        style: GoogleFonts
                                                            .amaranth(
                                                            color: Colors
                                                                .white)),
                                                    SizedBox(width: 3),
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 22,
                                                    )
                                                  ],
                                                ),
                                                onPressed: () {
                                                  _removerFavorito(
                                                      widget.servico.id)
                                                      .then((_) {
                                                    _onDelete();
                                                    _onDeletSuccess();
                                                  });
                                                },
                                              ),
                                              SizedBox(width: 50)
                                            ],
                                          );
                                        });
                                  },
                                )
                              ],
                            ))
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launch(
                                "tel:${widget.servico.codigoPais}${widget.servico.telefone}");
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width - 220,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.orange[600],
                                      Colors.orange[400],
                                      Colors.orange[200],
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topRight),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.phone),
                                  SizedBox(),
                                  Text(
                                    " Llamar",
                                    style: GoogleFonts.amaranth(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            launch(
                                "https://www.google.com/maps/search/?api=1&query=${widget.servico.long},"
                                    "${widget.servico.lat}");
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width - 220,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.orange[700],
                                      Colors.orange[500],
                                      Colors.orange[300],
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomCenter),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.location_on),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Mapa",
                                    style: GoogleFonts.amaranth(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Descripción",
                          style: GoogleFonts.amaranth(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Divider(),
                    Text(
                      "${widget.servico.desc}",
                      style: GoogleFonts.amaranth(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _onSave() async {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Agregando a tus Favoritos...!"),
      backgroundColor: Colors.orange[600],
      duration: Duration(seconds: 5),
    ));
  }

  _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Adiccionado con Éxito...!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      Navigator.of(context).pop();
    });
  }

  _onDelete() async {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Eliminando de Favoritos...!"),
      backgroundColor: Colors.orange[600],
      duration: Duration(seconds: 5),
    ));
  }

  _onDeletSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Eliminado con Éxito...!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      Navigator.of(context).pop();
    });
  }
}