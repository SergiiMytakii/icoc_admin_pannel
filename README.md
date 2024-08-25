# icoc_admin_pannel

# to run code generation
    * dart run build_runner watch --delete-conflicting-outputs
# to run project: 
    * flutter run -d chrome --dart-define=openAIKey=your_open_ai_key --web-renderer html 
    * to run in debug mode add .vscode folder and create file launch.json with the following structure:
        {
    "version": "0.2.0",
    "configurations": [
      {
        "name": "icoc-flutter",
        "request": "launch",
        "type": "dart",
        "program": "lib/main.dart",
        "args": [
            "-d",
            "chrome",
            "--dart-define",
            "openAIKey=your_api_key",
            "--web-renderer",
            "html"
        ]
      }
    ]
  }
# to deploy to FB: 
    * flutter build web --web-renderer html
    * firebase deploy

