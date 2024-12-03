import 'dart:convert';
import 'dart:html';

final backendUrl = (() {
  final currentUrl = Uri.base;

  // Extrahiere Host und prüfe, ob es sich um eine Codespaces-URL handelt
  final host = currentUrl.host;
  if (host.contains('.app.github.dev')) {
    // Zerlege die Subdomain und ersetze den Port-Teil
    final regex = RegExp(r'-(\d+)\.app\.github\.dev$');
    final match = regex.firstMatch(host);
    if (match != null) {
      final backendHost = host.replaceFirst('-${match.group(1)}', '-8080');
      return currentUrl.replace(host: backendHost, port: null, path: '').toString();
    }
  }
})();

void main() {
  final itemNameInput = querySelector('#item-name') as InputElement;
  final itemAmountInput = querySelector('#item-amount') as InputElement;
  final addItemButton = querySelector('#add-item-button') as ButtonElement;

  final updateNameInput = querySelector('#update-name') as InputElement;
  final updateAmountInput = querySelector('#update-amount') as InputElement;
  final updateItemButton = querySelector('#update-item-button') as ButtonElement;

  final deleteNameInput = querySelector('#delete-name') as InputElement;
  final deleteItemButton = querySelector('#delete-item-button') as ButtonElement;

  final itemsTableBody = querySelector('#items-table-body') as TableSectionElement;

  loadItems(itemsTableBody);

  addItemButton.onClick.listen((_) async {
    final name = itemNameInput.value!.trim();
    final amount = int.tryParse(itemAmountInput.value!.trim() ?? '');

    if (name.isNotEmpty && amount != null) {
      try {
        await HttpRequest.request(
          '$backendUrl/items',
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

  updateItemButton.onClick.listen((_) async {
    final name = updateNameInput.value!.trim();
    final newAmount = int.tryParse(updateAmountInput.value!.trim() ?? '');

    if (name.isNotEmpty && newAmount != null) {
      try {
        await HttpRequest.request(
          '$backendUrl/items/$name',
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

  deleteItemButton.onClick.listen((_) async {
    final name = deleteNameInput.value!.trim();

    if (name.isNotEmpty) {
      try {
        await HttpRequest.request(
          '$backendUrl/items/$name',
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

Future<void> loadItems(TableSectionElement tableBody) async {
  try {
    final response = await HttpRequest.getString('$backendUrl/items');
    final items = (jsonDecode(response) as List<dynamic>?)
        ?.map((item) => item as Map<String, dynamic>)
        .toList() ?? [];
    renderItemsTable(tableBody, items);
  } catch (e) {
    window.alert('Fehler beim Laden der Artikel: $e');
  }
}

void renderItemsTable(TableSectionElement tableBody, List<Map<String, dynamic>> items) {
  tableBody.children.clear();

  for (final item in items) {
    final row = TableRowElement()
      ..append(TableCellElement()..text = item['name'])
      ..append(TableCellElement()..text = item['amount'].toString());
    tableBody.append(row);
  }
}
