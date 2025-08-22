// lib/models/solicitacao_senha.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SolicitacaoSenha {
  final String id;
  final String usuarioId;
  final String usuarioEmail;
  final String usuarioNome;
  final String novaSenhaSugerida;
  final Timestamp dataSolicitacao;

  SolicitacaoSenha({
    required this.id,
    required this.usuarioId,
    required this.usuarioEmail,
    required this.usuarioNome,
    required this.novaSenhaSugerida,
    required this.dataSolicitacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'usuarioEmail': usuarioEmail,
      'usuarioNome': usuarioNome,
      'novaSenhaSugerida': novaSenhaSugerida,
      'dataSolicitacao': dataSolicitacao,
    };
  }

  factory SolicitacaoSenha.fromMap(String id, Map<String, dynamic> map) {
    return SolicitacaoSenha(
      id: id,
      usuarioId: map['usuarioId'] ?? '',
      usuarioEmail: map['usuarioEmail'] ?? '',
      usuarioNome: map['usuarioNome'] ?? 'Nome não encontrado',
      novaSenhaSugerida: map['novaSenhaSugerida'] ?? '',
      dataSolicitacao: map['dataSolicitacao'] ?? Timestamp.now(),
    );
  }
}