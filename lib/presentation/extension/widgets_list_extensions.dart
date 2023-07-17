extension WidgetsListExtensions<T> on List<T> {
  List<T> addSeparator(T separator) {
    if (length <= 1) return this;
    final List<T> updatedList = [...this];
    for (int i = updatedList.length - 1; i > 0; i--) {
      updatedList.insert(i, separator);
    }
    return updatedList;
  }
}
