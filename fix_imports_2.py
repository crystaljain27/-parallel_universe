import os
import re

fixes = [
    {
        "file": "lib/features/dashboard/presentation/pages/tabs/home_feed_tab.dart",
        "replacements": [
            ("package:parallel_universe/features/dashboard/presentation/pages/widgets/universe_card.dart", "package:parallel_universe/features/dashboard/presentation/widgets/universe_card.dart"),
            ("package:parallel_universe/features/dashboard/presentation/pages/widgets/feed_skeleton.dart", "package:parallel_universe/features/dashboard/presentation/widgets/feed_skeleton.dart")
        ]
    },
    {
        "file": "lib/features/future_self/presentation/pages/future_chat_screen.dart",
        "replacements": [
            ("package:parallel_universe/features/core/di/dependency_injection.dart", "package:parallel_universe/core/di/dependency_injection.dart"),
            ("package:parallel_universe/features/features/universe_generation/domain/entities/generated_universe_entity.dart", "package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart"),
            ("package:parallel_universe/features/features/chat/presentation/widgets/chat_input_bar.dart", "package:parallel_universe/features/chat/presentation/widgets/chat_input_bar.dart")
        ]
    },
    {
        "file": "lib/features/universe_generation/presentation/pages/generation_loading_screen.dart",
        "replacements": [
            ("package:parallel_universe/features/core/di/dependency_injection.dart", "package:parallel_universe/core/di/dependency_injection.dart"),
            ("package:parallel_universe/features/core/routing/app_router.dart", "package:parallel_universe/core/routing/app_router.dart")
        ]
    },
    {
        "file": "lib/features/universe_generation/presentation/pages/universe_results_screen.dart",
        "replacements": [
            ("package:parallel_universe/features/core/di/dependency_injection.dart", "package:parallel_universe/core/di/dependency_injection.dart"),
            ("package:parallel_universe/features/core/routing/app_router.dart", "package:parallel_universe/core/routing/app_router.dart")
        ]
    }
]

for fix in fixes:
    path = fix['file']
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        for old, new in fix['replacements']:
            content = content.replace(old, new)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {path}")
    else:
        print(f"File not found: {path}")

# Add AppRouter import to universe_details_screen.dart if missing
details_path = "lib/features/universe_generation/presentation/pages/universe_details_screen.dart"
if os.path.exists(details_path):
    with open(details_path, 'r', encoding='utf-8') as f:
        content = f.read()
    if "package:parallel_universe/core/routing/app_router.dart" not in content:
        content = "import 'package:parallel_universe/core/routing/app_router.dart';\n" + content
        with open(details_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Added AppRouter to universe_details_screen.dart")
