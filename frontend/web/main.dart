import 'dart:html';

void main() {
  //HTML-Elemente referenzieren
  final InputElement todoInput = querySelector('#todo-input') as InputElement;
  final ButtonElement addButton = querySelector('#add-button') as ButtonElement;
  final UListElement todoList = querySelector('#todo-list') as UListElement;

  // Button-Listener
  addButton.onClick.listen((_) {
    final String task = todoInput.value!.trim();
    if (task.isNotEmpty) {
      addTodoItem(task, todoList);
      todoInput.value = ''; //Eingabefeld leeren nach erstellen eines Tasks
    }
  });

  // Enter-Taste Support
  todoInput.onKeyDown.listen((KeyboardEvent event) {
    if (event.key == 'Enter') {
      addButton.click();
    }
  });
}

// Funktion zum Hinzufügen eines neuen To-Do-Eintrags
void addTodoItem(String task, UListElement todoList) {
  // Neues Listen-Element erstellen
  final LIElement newTodo = LIElement();
  newTodo.appendText(task);

  // "Löschen"-Button hinzufügen
  final ButtonElement deleteButton = ButtonElement();
  deleteButton.text = '✔ Done';
  deleteButton.addEventListener('click', (event) {
    newTodo.remove();
  });

  // Element hinzufügen
  todoList.append(newTodo);

  // Element löschen
  newTodo.append(deleteButton);
}
