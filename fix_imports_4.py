import os

files = [
    "lib/features/chat/presentation/pages/chat_screen.dart",
    "lib/features/dashboard/presentation/pages/dashboard_screen.dart"
]

import_statement = "import 'package:parallel_universe/core/routing/app_router.dart';\n"

for path in files:
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        if "package:parallel_universe/core/routing/app_router.dart" not in content:
            content = import_statement + content
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Fixed {path}")
