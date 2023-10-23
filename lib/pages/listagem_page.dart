import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:listacontatos/pages/cadastro_page.dart';

import '../models/contatos_model.dart';
import '../repositories/contatos_repository.dart';

class ListagemPage extends StatefulWidget {
  const ListagemPage({super.key});

  @override
  State<ListagemPage> createState() => _ListagemPageState();
}

class _ListagemPageState extends State<ListagemPage> {
  ContatosRepository instanciaRepository = ContatosRepository();

  var _contatos = ContatosModel([]);

  var descricaoController = TextEditingController();
  var id = 0;
  var carregando = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obterContatos();
  }

  obterContatos() async {
    setState(() {
      carregando = true;
    });
    _contatos = await instanciaRepository.obterContatos();

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text("Lista de Contatos"))),
        floatingActionButton: FloatingActionButton(
          child: FaIcon(FontAwesomeIcons.addressBook),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const CadastroPage("0")));
          },
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _contatos == null
                  ? Expanded(
                      child: Center(
                          child: Text("Cadastre algum numero em sua agenda")),
                    )
                  : carregando == true
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: _contatos.contatosLista.length,
                              itemBuilder: (BuildContext bc, int index) {
                                var contato = _contatos.contatosLista[index];
                                print(contato.objectId);
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(contato.nome,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                      subtitle: Text(contato.telefone,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                      trailing: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CadastroPage(
                                                            contato.objectId)));
                                          },
                                          child: FaIcon(FontAwesomeIcons.edit)),
                                      leading: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: contato.foto.startsWith("http")
                                            ? Image.network(
                                                contato.foto,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                File(
                                                  contato.foto,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                );
                              }),
                        ),
            ],
          ),
        ));
  }
}
