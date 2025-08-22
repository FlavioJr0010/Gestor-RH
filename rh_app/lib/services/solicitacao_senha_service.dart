// lib/services/solicitacao_senha_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rh_app/models/solicitacao_senha.dart';

class SolicitacaoSenhaService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('solicitacoesSenha');

  // Cria uma nova solicitação no banco
  Future<void> criarSolicitacao(Map<String, dynamic> dadosSolicitacao) {
    return _collection.add(dadosSolicitacao);
  }

  // Lista todas as solicitações pendentes em tempo real
  Stream<List<SolicitacaoSenha>> listarSolicitacoesPendentes() {
    return _collection.orderBy('dataSolicitacao').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => SolicitacaoSenha.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList());
  }

  // Remove (nega/aprova) uma solicitação pelo seu ID
  Future<void> removerSolicitacao(String id) {
    return _collection.doc(id).delete();
  }
}