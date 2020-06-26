import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iselectaplication1990/model/model_servico.dart';
import 'package:iselectaplication1990/src/screems/s/widgets_pages/detalhe_anuncio.dart';
import 'package:iselectaplication1990/src/tiles/item_servico_favorito.dart';


class Favoritos extends StatefulWidget {
  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {

  final _controller = StreamController<QuerySnapshot>.broadcast();


  bool isSerach = false;
  var selecCurrency;
  String _idUsuarioLogado;



  _recuperarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerFavoritos() async  {
    await _recuperarUsuario(); /// Recuperar o Usuario antes de executar a consulta


    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_favoritos")
        .document(_idUsuarioLogado).collection("favoritos")
        .snapshots();

    stream.listen((dados){
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarUsuario();
    _adicionarListenerFavoritos();
  }

  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery.of(context).orientation;

    return Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 25),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:

                    QuerySnapshot querySnapshot = snapshot.data;

                    if( querySnapshot.documents.length == 0 ){
                      return Container(
                          padding: EdgeInsets.all(25),
                          child: Center(
                            child: Text("Ningún Favorito! :( ", style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),                          )
                      );
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: (orientation == Orientation.portrait) ? 2 :3,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.7,
                                mainAxisSpacing: 10
                            ),
                            itemCount: querySnapshot.documents.length,
                            itemBuilder: (_, index){

                              List<DocumentSnapshot> servicos =
                              querySnapshot.documents.toList();
                              DocumentSnapshot documentSnapshot = servicos[index];
                              ModelServico favorito = ModelServico.fromdocumentSnapshot(documentSnapshot);


                              return ItemServicoFavoritos(
                                servico: favorito,
                                onTapItem: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetalheAnuncio(favorito)
                                  ));
                                }, onTapRemover:null,
                              );
                            }
                        ),
                      ),
                    );
                }
                return Container();
              },
            )
          ],
        )
    );
  }
}