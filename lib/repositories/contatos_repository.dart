import '../models/contatos_model.dart';
import 'back4app_custom_dio.dart';

class ContatosRepository {
  final _customDio = Back4AppCustomDio();
  ContatosRepository() {}

  Future<ContatosModel> obterContatos() async {
    var url = "/contatos";

    var result = await _customDio.dio.get(url);

    return ContatosModel.fromJson(result.data);
  }

  Future<Contato> obterContatoEspecifico(String id) async {
    var url = "/contatos?where={\"objectId\":\"$id\"}";

    var result = await _customDio.dio.get(url);
    ContatosModel contatoLista = ContatosModel.fromJson(result.data);
    Contato contato = contatoLista.contatosLista[0];
    return contato;
  }

  Future<void> criarContato(Contato contatoModel) async {
    try {
      await _customDio.dio.post("/contatos", data: contatoModel.salvarJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> atualizar(Contato contatoModel) async {
    try {
      await _customDio.dio.put("/contatos/${contatoModel.objectId}",
          data: contatoModel.salvarJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> deletar(String id) async {
    try {
      await _customDio.dio.delete(
        "/contatos/${id}",
      );
    } catch (e) {
      throw e;
    }
  }
}
