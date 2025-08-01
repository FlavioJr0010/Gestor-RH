// services/funcionario_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/funcionario.dart';

class FuncionarioService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('funcionarios');

  Future<void> adicionar(Funcionario funcionario) => _collection.add(funcionario.toMap());

  Future<void> atualizar(Funcionario funcionario) =>
      _collection.doc(funcionario.id).update(funcionario.toMap());

  Future<void> excluir(String id) => _collection.doc(id).delete();

  Stream<List<Funcionario>> listarTodos() => _collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Funcionario.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList(),
      );

  // NOVO MÉTODO DE BUSCA
  Stream<List<Funcionario>> buscarPorNome(String nome) {
    // Se o nome da busca estiver vazio, retorna todos.
    if (nome.isEmpty) {
      return listarTodos();
    }
    // Senão, faz a busca. O `\uf8ff` é um truque para pegar todos os nomes que começam com o texto da busca.
    return _collection
        .where('nome', isGreaterThanOrEqualTo: nome)
        .where('nome', isLessThanOrEqualTo: '$nome\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Funcionario.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}