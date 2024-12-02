import 'dart:convert';
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

  // Artikel laden und Tabelle rendern
  loadItems(itemsTableBody);

  // Artikel zur Liste hinzufügen
  addItemButton.onClick.listen((_) async {
    final name = itemNameInput.value!.trim();
    final amount = int.tryParse(itemAmountInput.value!.trim() ?? '');

    if (name.isNotEmpty && amount != null) {
      try {
        await HttpRequest.request(
          '/items',
          method: 'POST',
          sendData: jsonEncode({'name': name, 'amount': amount}),
          requestHeaders: {'Content-Type': 'application/json'},
        );
        itemNameInput.value = '';
        itemAmountInput.value = '';
        await loadItems(itemsTableBody);
      } catch (e) {
        window.alert('Fehler beim Hinzufügen des Artikels: $e');
      }
    }
  });

  // Artikel in der Liste aktualisieren
  updateItemButton.onClick.listen((_) async {
    final name = updateNameInput.value!.trim();
    final newAmount = int.tryParse(updateAmountInput.value!.trim() ?? '');

    if (name.isNotEmpty && newAmount != null) {
      try {
        await HttpRequest.request(
          '/items/$name',
          method: 'PUT',
          sendData: jsonEncode({'amount': newAmount}),
          requestHeaders: {'Content-Type': 'application/json'},
        );
        updateNameInput.value = '';
        updateAmountInput.value = '';
        await loadItems(itemsTableBody);
      } catch (e) {
        window.alert('Fehler beim Aktualisieren des Artikels: $e');
      }
    }
  });

  // Artikel aus der Liste löschen
  deleteItemButton.onClick.listen((_) async {
    final name = deleteNameInput.value!.trim();

    if (name.isNotEmpty) {
      try {
        await HttpRequest.request(
          '/items/$name',
          method: 'DELETE',
        );
        deleteNameInput.value = '';
        await loadItems(itemsTableBody);
      } catch (e) {
        window.alert('Fehler beim Löschen des Artikels: $e');
      }
    }
  });
}

// Funktion, um Artikel vom Backend zu laden und in der Tabelle anzuzeigen
Future<void> loadItems(TableSectionElement tableBody) async {
  try {
    final response = await HttpRequest.getString('/items');
    final items = List<Map<String, dynamic>>.from(jsonDecode(response));
    renderItemsTable(tableBody, items);
  } catch (e) {
    window.alert('Fehler beim Laden der Artikel: $e');
  }
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
