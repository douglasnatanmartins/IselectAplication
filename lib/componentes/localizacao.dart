import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/config/perfil_config/perfil_config.dart';

class Localizacao extends StatefulWidget {

  @override
  _LocalizacaoState createState() => _LocalizacaoState();
}

class _LocalizacaoState extends State<Localizacao> {



  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  String _idUsuarioLogado;

  _recuperarDadosDoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
  }


  Completer<GoogleMapController> _controller = Completer( );


  CameraPosition _posicaoCamera = CameraPosition(
      target: LatLng( -23.442503, -58.443832 ),
      zoom: 6
  );


  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);
  }

  _movimentarCamera () async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
            _posicaoCamera
        )
    );
  }

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    //print("Localização atual: " + _position.toString());
    setState(() {
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16

      );
      _movimentarCamera();
    });
  }

  _recuperarEnderecoParaLatLong() async {
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    List<Placemark> listEndereco = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    print("total" + listEndereco.length.toString());

    if(listEndereco != null && listEndereco.length > 0){

      Placemark endereco  = listEndereco[0];

      String rua = endereco.thoroughfare;
      String estado = endereco.administrativeArea;
      String cidade = endereco.subAdministrativeArea;
      String pais = endereco.country;
      double lat = position.latitude;
      double long = position.longitude;

      Marker marcador = Marker(
          markerId: MarkerId("marcador-${position.latitude}-${position.longitude}"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: rua,
          )
      );

      Map<String, dynamic> atualizarLocal ={
        "rua": rua,
        "lat": lat,
        "long": long,
        "estado": estado,
        "cidade": cidade,
        "pais": pais,
      };



      Firestore.instance.collection("users").document(_idUsuarioLogado)
          .updateData(atualizarLocal);

      setState(()  {
        _marcadores.add(marcador);
      });
      _recuperarLocalizacaoAtual();

    }
  }


  Set<Marker> _marcadores = {};


  @override
  void initState() {
    super.initState();
    _recuperarDadosDoUsuario();
    _recuperarEnderecoParaLatLong();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        centerTitle: true,
        title: Text(
          "Mapa",
          style: GoogleFonts.amaranth(),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 16),
            icon: Icon(Icons.help, size: 30,),
            onPressed: (){
              showDialog(context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Ayuda",
                      style: GoogleFonts.amaranth(
                          color: Colors.orange[700],
                          decoration: TextDecoration.underline
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        textColor: Colors.green,
                        child: Text("Ok",
                          style: GoogleFonts.varela(
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(" - Para elegir su local haga clic en el Boton",
                              style: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                      fontSize: 12
                                  )
                              ),
                            ),
                            Icon(Icons.add_location, size: 28, color: Colors.blue,)
                          ],
                        ),
                      ],
                    ),
                  )
              );
            },
          )
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          _recuperarEnderecoParaLatLong();
          showDialog(context: context,
              builder: (context) => AlertDialog(
                title: Text(
                    "Datos guardados con Êxito",
                    style: GoogleFonts.amaranth(
                      textStyle: TextStyle(
                          color: Colors.green
                      ),
                    )
                ),
                content: Text(
                    "Vuelva para continuar editando el servicio",
                    style: GoogleFonts.amaranth(
                      textStyle: TextStyle(
                          color: Colors.grey[700]
                      ),
                    )
                ),
                actions: [
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PerfilConfig()
                      ));
                    },
                    child: Text(
                      "Ok",
                      style: GoogleFonts.amaranth(
                        color: Colors.green,
                        fontSize: 18
                      ),
                    ),
                  )
                ],
              )
          );

        },
        child: Icon(Icons.add_location),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          markers: _marcadores,
        ),
      ),
    );
  }
}
