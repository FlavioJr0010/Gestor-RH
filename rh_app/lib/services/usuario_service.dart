// services/usuario_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart'; // Importa o modelo de usuário

class UsuarioService {
  // 1. Altera o nome da coleção para 'usuarios'
  final CollectionReference _collection = FirebaseFirestore.instance.collection('usuarios');

  // Adiciona um novo usuário
  Future<void> adicionar(Usuario usuario) => _collection.add(usuario.toMap());

  // Atualiza um usuário existente
  Future<void> atualizar(Usuario usuario) =>
      _collection.doc(usuario.id).update(usuario.toMap());

  // Exclui um usuário pelo ID
  Future<void> excluir(String id) => _collection.doc(id).delete();

  // Lista todos os usuários em tempo real
  Stream<List<Usuario>> listarTodos() => _collection.snapshots().map(
        (snapshot) => snapshot.docs
            // 2. Usa o construtor Usuario.fromMap
            .map((doc) => Usuario.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList(),
      );

  // Busca usuários pelo nome
  Stream<List<Usuario>> buscarPorNome(String nome) {
    if (nome.isEmpty) {
      return listarTodos();
    }
    return _collection
        .where('nome', isGreaterThanOrEqualTo: nome)
        .where('nome', isLessThanOrEqualTo: '$nome\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
            // 3. Usa o construtor Usuario.fromMap também na busca
            .map((doc) => Usuario.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  // MÉTODO EXTRA: Buscar um usuário pelo email (muito útil para login)
  Future<Usuario?> buscarPorEmail(String email) async {
    final snapshot = await _collection.where('email', isEqualTo: email).limit(1).get();

    if (snapshot.docs.isEmpty) {
      return null; // Nenhum usuário encontrado com esse email
    }

    // Retorna o primeiro usuário encontrado
    return Usuario.fromMap(snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>);
  }
  Future<void> atualizarSenha(String documentId, String novaSenha) {

    return _collection.doc(documentId).update({'senha': novaSenha});
  }

}