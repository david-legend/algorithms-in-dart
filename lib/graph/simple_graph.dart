import 'vertex.dart';

/// A Graph Type
class SimpleGraph<T> {
  Set<Vertex<T>> _vertices;

  /// Vertices of this graph
  List<Vertex<T>> get vertices => List<Vertex<T>>.unmodifiable(_vertices);

  /// Settings for this graph
  /// Is this a Digraph?
  final bool isDigraph;

  /// Create a new graph
  SimpleGraph({this.isDigraph = true}) {
    _vertices = <Vertex<T>>{};
  }

  /// Total number of vertices for this graph
  int get numberOfVertices => _vertices.length;

  /// Total number of edges
  int get numberOfEdges =>
      _vertices.map((v) => v.outDegree).fold(0, (a, b) => a + b);

  /// Adds an edge
  void addEdge(Vertex src, Vertex dst, [num weight = 1]) {
    unlockVertices(<Vertex>{src, dst});
    if (src.key == dst.key) throw Error();

    src = _getOrAddVertex(src);
    dst = _getOrAddVertex(dst);
    src.addConnection(dst, weight);

    if (!isDigraph) dst.addConnection(src, weight);
    lockVertices(<Vertex>{src, dst});
  }

  /// Checks if vertex is included
  bool containsVertex(Vertex vertex) => _vertices.contains(vertex);

  /// Checks if this is a null graph
  bool get isNull => numberOfVertices == 0;

  /// Checks if this is a singleton graph
  bool get isSingleton => numberOfVertices == 1;

  /// Checks if this is an empty graph
  bool get isEmpty => numberOfEdges == 0;

  /// Adds a new vertex
  bool addVertex(Vertex vertex) => _vertices.add(vertex);

  Vertex<T> _getOrAddVertex(Vertex vertex) =>
      _vertices.add(vertex) ? vertex : vertex;

  /// Gets an edge list for [this].
  List<List> get edges => [
        for (var vertex in _vertices) ...[
          for (var connection in vertex.outgoingConnections.entries)
            [vertex, connection.key, connection.value]
        ]
      ];
}