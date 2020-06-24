import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iselectaplication1990/src/screems/s/widgets_pages/adiciona_servico.dart';

class LocalizacaoServico extends StatefulWidget {

  @override
  _LocalizacaoServicoState createState() =>
      _LocalizacaoServicoState();
}

class _LocalizacaoServicoState extends State<LocalizacaoServico> { _LocalizacaoServicoState();

double latitude;
double longitude;
String cidade;
String rua;
String estado;
String pais;

bool japassei =false;

GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

Completer<GoogleMapController> _controller = Completer();

CameraPosition _posicaoCamera =
CameraPosition(target: LatLng(-23.442503, -58.443832), zoom: 6);

_onMapCreated(GoogleMapController googleMapController) {
  _controller.complete(googleMapController);
}

_movimentarCamera() async {
  GoogleMapController googleMapController = await _controller.future;
  googleMapController
      .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
}

_recuperarLocalizacaoAtual() async {
  Position position = await Geolocator().getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );
  //print("Localização atual: " + _position.toString());
  setState(() {
    _posicaoCamera = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 16);
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

  if (listEndereco != null && listEndereco.length > 0) {
    Placemark endereco = listEndereco[0];

    String ruaServico = endereco.thoroughfare;
    String estadoServico = endereco.administrativeArea;
    String cidadeServico = endereco.subAdministrativeArea;
    String paisServico = endereco.country;
    double lat = position.latitude;
    double long = position.longitude;

    Marker marcador = Marker(
        markerId:
        MarkerId("marcador-${position.latitude}-${position.longitude}"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: rua,
        ));


    latitude = lat;
    longitude = long;
    cidade = cidadeServico;
    rua = ruaServico;
    estado = estadoServico;
    pais = paisServico;

    /*Firestore.instance.collection("users").document(_idUsuarioLogado)
          .updateData(toMapLocal());*/

    setState(() {
      _marcadores.add(marcador);
    });
    _recuperarLocalizacaoAtual();
  }
}

Set<Marker> _marcadores = {};

@override
void initState() {
  super.initState();
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
          icon: Icon(
            Icons.help,
            size: 30,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Ayuda",
                    style: GoogleFonts.amaranth(
                        color: Colors.orange[700],
                        decoration: TextDecoration.underline),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      textColor: Colors.green,
                      child: Text(
                        "Ok",
                        style: GoogleFonts.varela(
                          textStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            " - Para elegir su local haga clic en el Boton",
                            style: GoogleFonts.acme(
                                textStyle: TextStyle(fontSize: 12)),
                          ),
                          Icon(
                            Icons.add_location,
                            size: 28,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ],
                  ),
                ));
          },
        )
      ],
    ),
    floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
        _recuperarEnderecoParaLatLong();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Datos guardados con Êxito",
                  style: GoogleFonts.amaranth(
                    textStyle: TextStyle(color: Colors.green),
                  )),
              content: Text("Haga Clic em Ok para continuar",
                  style: GoogleFonts.amaranth(
                    textStyle: TextStyle(color: Colors.grey[700]),
                  )),
              actions: [
                FlatButton(
                  textColor: Colors.green,
                  child: Text(
                    "Ok",
                    style: GoogleFonts.varela(
                      textStyle: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdiconaServicos(
                            longitude: longitude,
                            latitude: latitude,
                            cidade: cidade,
                            rua: rua,
                            estado: estado,
                            pais: pais
                        )
                    ))..then((_) => Navigator.of(context).pop())//-> fechando o Dialog
                      ..then((_) => Navigator.of(context).pop() //-> Voltando para a pagina de servicos
                      );
                  },
                )
              ],
            ));
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
