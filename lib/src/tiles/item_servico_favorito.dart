import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/model_servico.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemServicoFavoritos extends StatefulWidget {

  ModelServico servico;
  VoidCallback onTapItem;
  VoidCallback onTapRemover;

  ItemServicoFavoritos({
    @required this.servico,
    @required this.onTapItem,
    @required this.onTapRemover,
  });

  @override
  _ItemServicoFavoritosState createState() => _ItemServicoFavoritosState();
}

class _ItemServicoFavoritosState extends State<ItemServicoFavoritos> {



  var rating = 1.0;
  double initialRating = 0.0;
  double result = 0.0;
  var ratingSoma;
  var idDoc;
  String _idUsuarioLogado;


  _recuperarDadosDoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    await _getClassificacao();
  }



   _getClassificacao(){
    Stream<QuerySnapshot> querySnapshot = Firestore.instance.
    collection("qualificacoes").
    document(widget.servico.id).
    collection("stars").snapshots();

    querySnapshot.map((docs){
      List<DocumentSnapshot> snapshot = docs.documents;
      for(final doc in snapshot){
        if(doc != null){
          final index = snapshot.indexOf(doc);
          idDoc = doc.documentID;
          if(index == 0){
            ratingSoma = doc.data["rating"] - doc.data["rating"];
          }

        }
        result = ratingSoma += doc.data["rating"] / snapshot.length;
        initialRating = result.round().roundToDouble();
      }
      print(initialRating);
    }).toList();
    return initialRating;

  }

  @override
  void initState() {
    super.initState();
      rating = result.round().roundToDouble();

    _recuperarDadosDoUsuario();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
      onTap: widget.onTapItem,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF656565).withOpacity(0.15),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: Offset(4.0, 10.0)
              )
            ]),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 200,
                      height: mediaQueryData.size.height /4.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7.0),
                              topRight: Radius.circular(7.0)),
                          image: DecorationImage(
                              image: NetworkImage(widget.servico.fotos[0]), fit: BoxFit.cover)),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 25.5,
                      width: 85.0,
                      decoration: BoxDecoration(
                          color: Colors.orange[600],
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(5.0))),
                      child: Center(
                          child: Text(
                            "Destacado",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600),
                          )),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Padding(
                    padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                    child: SmoothStarRating(
                      isReadOnly: true,
                      rating: rating,
                      size: 12,
                      borderColor: Colors.grey,
                      color: Colors.amber,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      defaultIconData: Icons.star_border,
                      starCount: 5,
                      allowHalfRating: false,
                      spacing: 2,
                    )
                ),
                Padding(padding: EdgeInsets.only(top: 2.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    widget.servico.title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.amaranth(
                        textStyle: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.black,
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w500,
                            fontSize: 13.0)
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 1.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                      widget.servico.preco,
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(
                            color: Colors.orange[700],
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
