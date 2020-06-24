import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfiguracoesDoUsuario extends StatefulWidget {

  String cidade;
  String estado;
  String rua;
  String pais;
  ConfiguracoesDoUsuario({this.cidade, this.estado, this.rua, this.pais});

  @override
  _ConfiguracoesDoUsuarioState createState() => _ConfiguracoesDoUsuarioState();
}

class _ConfiguracoesDoUsuarioState extends State<ConfiguracoesDoUsuario> {

  String _cidade;
  String _estado;
  String _rua;
  String _pais;
  bool salvando = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _idUsuarioLogado;

  Future<void> saveDados() async {
    salvando = true;

    Map<String, dynamic> mapData = {
      "cidade": _cidade,
      "estado": _estado,
      "rua": _rua,
      "pais": _pais
    };

    Firestore.instance.collection("users")
        .document(_idUsuarioLogado).updateData(mapData).then((_){
          salvando = false;
    });
  }

  _recuperarDadosDoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
    await db.collection("users").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosDoUsuario();
  }


  @override
  Widget build(BuildContext context) {
    print(widget.rua);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Ajustes",
          style: GoogleFonts.amaranth(),
        ),
      ),
      body:Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12,),
              TextFormField(
                initialValue: widget.rua,
                style: GoogleFonts.amaranth(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Calle"
                ),
                validator: (text){
                  if(text.isEmpty){
                    return "Inválido!";
                  } else {
                    return null;
                  }
                },
                onSaved: (rua) => _rua = rua,
              ),
              const SizedBox(height: 12,),
              TextFormField(
                initialValue: widget.cidade,
                style: GoogleFonts.amaranth(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: "Ciudad"
                ),
                validator: (text){
                  if(text.isEmpty){
                    return "Inválido!";
                  } else {
                    return null;
                  }
                },
                onSaved: (cidade) => _cidade = cidade,
              ),
              const SizedBox(height: 12,),
              TextFormField(
                initialValue: widget.estado,
                style: GoogleFonts.amaranth(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Departamento"
                ),
                validator: (text){
                  if(text.isEmpty){
                    return "Inválido!";
                  } else {
                    return null;
                  }
                },
                onSaved: (estado) => _estado = estado,
              ),
              const SizedBox(height: 12,),
              TextFormField(
                initialValue: widget.pais,
                style: GoogleFonts.amaranth(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Pais"
                ),
                validator: (text){
                  if(text.isEmpty){
                    return "Inválido!";
                  } else {
                    return null;
                  }
                },
                onSaved: (pais) => _pais = pais,
              ),
              const SizedBox(height: 35,),
              Material(
                color: Colors.white,
                child: GestureDetector(
                  onTap: () async {
                    if(_formKey.currentState.validate()){

                      _formKey.currentState.save();

                      await saveDados().then((_){
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                          content: Text(
                            "Datos Guardados con êxito!",
                            style: GoogleFonts.amaranth(
                              color: Colors.white
                            ),
                          ),
                        ));
                        Future.delayed(Duration(seconds: 2)).then((_){
                          Navigator.of(context).pop();
                        });
                      });

                    }
                    
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width -100,
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
                          Icon( salvando ? Icons.file_upload : Icons.save),
                          SizedBox(),
                          if(salvando)
                             CircularProgressIndicator()
                          else
                          Text(
                            " Salvar",
                            style: GoogleFonts.amaranth(
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
