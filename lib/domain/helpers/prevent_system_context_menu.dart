import 'dart:html' as html;

void preventSystemContextMenu() {
  final script = html.ScriptElement()
    ..type = 'text/javascript'
    ..innerHtml = '''
      document.addEventListener('contextmenu', function(event) {
        event.preventDefault();
      });
    ''';
  html.document.head!.append(script);
}
