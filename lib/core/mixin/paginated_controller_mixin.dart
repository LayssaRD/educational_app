import 'package:flutter/widgets.dart';

mixin PaginatedControllerMixin<T> on ChangeNotifier {
  final List<T> _items = [];
  final int _limit = 10;
  int _offset = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  ScrollController? _scrollController;

  List<T> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  int get limit => _limit;
  int get offset => _offset;

  ScrollController get scrollController {
    _scrollController ??= ScrollController()..addListener(_onScroll);
    return _scrollController!;
  }

  void _onScroll() {
    if (_scrollController == null) return;
    if (_scrollController!.hasClients) {
      final threshold = 200.0;
      if (_scrollController!.position.pixels >=
          _scrollController!.position.maxScrollExtent - threshold) {
        loadMore();
      }
    }
  }

  Future<List<T>> fetchItems(int limit, int offset);

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> initLoad() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    _offset = 0;
    _hasMore = true;
    _items.clear();
    notifyListeners();

    try {
      final newItems = await fetchItems(_limit, _offset);
      _items.addAll(newItems);
      _offset += newItems.length;
      if (newItems.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = 'Não foi possível carregar os dados.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newItems = await fetchItems(_limit, _offset);
      _items.addAll(newItems);
      _offset += newItems.length;
      if (newItems.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = 'Não foi possível carregar mais registros.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }
}
