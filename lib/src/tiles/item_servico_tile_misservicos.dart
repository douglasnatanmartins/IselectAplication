import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/model_servico.dart';

class ItemServicoTileMeusServicos extends StatelessWidget {
  ModelServico servico;
  VoidCallback onTapItem;
  VoidCallback onTapRemover;
  VoidCallback onTapEditing;

  ItemServicoTileMeusServicos(
      {@required this.servico,
      @required this.onTapItem,
      @required this.onTapRemover,
      @required this.onTapEditing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Container(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[700],
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                      offset: Offset(1.0, 1.0),
                    )
                  ],
                  gradient: LinearGradient(colors: [
                    Colors.orange[400],
                    Colors.orange[300],
                    Colors.orange[200],
                  ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 8,
                      width: MediaQuery.of(context).size.width / 3.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: NetworkImage(servico.fotos[0]),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width / 3),
                              RichText(
                                text: TextSpan(
                                  text: servico.title,
                                  style: GoogleFonts.amaranth(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                          fontSize: 15,
                                          decoration: TextDecoration.underline)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width / 2.7),
                              Text(
                                servico.preco,
                                style: GoogleFonts.amaranth(
                                    textStyle: TextStyle(
                                      fontSize: 13,
                                    )),
                              ),
                            ],
                          )
                        ],
                      )),
                  Positioned(
                      right: 5,
                      top: 20,
                      child: this.onTapRemover != null
                          ? Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 25,
                              ),
                              onPressed: onTapEditing),
                          IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.redAccent,
                                size: 25,
                              ),
                              onPressed: this.onTapRemover),
                        ],
                      )
                          : Text(""))
                ],
              ),)),
    );
  }
}
