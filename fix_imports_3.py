import os

lib_dir = os.path.abspath('lib')

for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart'):
            file_path = os.path.join(root, file)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            new_content = content.replace("package:parallel_universe/features/core/", "package:parallel_universe/core/")
            new_content = new_content.replace("package:parallel_universe/features/dashboard/presentation/pages/widgets/", "package:parallel_universe/features/dashboard/presentation/widgets/")
            
            if new_content != content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Fixed {file_path}")
