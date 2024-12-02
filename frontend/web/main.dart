import 'dart:html';

void main() {
  // Referenzen zu den relevanten HTML-Elementen erstellen
  final itemNameInput = querySelector('#item-name') as InputElement;
  final itemAmountInput = querySelector('#item-amount') as InputElement;
  final addItemButton = querySelector('#add-item-button') as ButtonElement;

  final updateNameInput = querySelector('#update-name') as InputElement;
  final updateAmountInput = querySelector('#update-amount') as InputElement;
  final updateItemButton = querySelector('#update-item-button') as ButtonElement;

  final deleteNameInput = querySelector('#delete-name') as InputElement;
  final deleteItemButton = querySelector('#delete-item-button') as ButtonElement;

  final itemsTableBody = querySelector('#items-table-body') as TableSectionElement;

  // Liste für die Speicherung der Artikel
  final items = <Map<String, dynamic>>[];

  // Artikel zur Liste hinzufügen
  addItemButton.onClick.listen((_) {
    final name = itemNameInput.value!.trim();
    final amount = int.tryParse(itemAmountInput.value!.trim() ?? '');

    if (name.isNotEmpty && amount != null) {
      items.add({'name': name, 'amount': amount});
      itemNameInput.value = '';
      itemAmountInput.value = '';
      renderItemsTable(itemsTableBody, items);
    }
  });

  // Artikel in der Liste aktualisieren
  updateItemButton.onClick.listen((_) {
    final name = updateNameInput.value!.trim();
    final newAmount = int.tryParse(updateAmountInput.value!.trim() ?? '');

    if (name.isNotEmpty && newAmount != null) {
      for (final item in items) {
        if (item['name'] == name) {
          item['amount'] = newAmount;
          break;
        }
      }
      updateNameInput.value = '';
      updateAmountInput.value = '';
      renderItemsTable(itemsTableBody, items);
    }
  });

  // Artikel aus der Liste löschen
  deleteItemButton.onClick.listen((_) {
    final name = deleteNameInput.value!.trim();

    if (name.isNotEmpty) {
      items.removeWhere((item) => item['name'] == name);
      deleteNameInput.value = '';
      renderItemsTable(itemsTableBody, items);
    }
  });
}

// Funktion, um die Artikelliste im DOM anzuzeigen
void renderItemsTable(TableSectionElement tableBody, List<Map<String, dynamic>> items) {
  tableBody.children.clear(); // Bestehende Zeilen entfernen

  for (final item in items) {
    final row = TableRowElement()
      ..append(TableCellElement()..text = item['name'])
      ..append(TableCellElement()..text = item['amount'].toString());
    tableBody.append(row);
  }
}
