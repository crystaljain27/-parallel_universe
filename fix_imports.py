import os
import re

lib_dir = os.path.abspath('lib')

def get_package_import(current_file_path, import_path):
    if import_path.startswith('package:') or import_path.startswith('dart:'):
        return import_path
    
    if import_path.startswith('./') or import_path.startswith('../'):
        current_dir = os.path.dirname(current_file_path)
        resolved_path = os.path.normpath(os.path.join(current_dir, import_path))
        rel_to_lib = os.path.relpath(resolved_path, lib_dir)
        rel_to_lib = rel_to_lib.replace('\\', '/')
        return f"package:parallel_universe/{rel_to_lib}"
    
    if import_path.startswith('features/') or import_path.startswith('core/'):
        return f"package:parallel_universe/{import_path}"
        
    return import_path

for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart'):
            file_path = os.path.join(root, file)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            def replacer(match):
                prefix = match.group(1)
                import_path = match.group(2)
                suffix = match.group(3)
                new_import = get_package_import(file_path, import_path)
                return f"{prefix}{new_import}{suffix}"
                
            new_content = re.sub(r'(import\s+[\'"])(.*?)([\'"]\s*;)', replacer, content)
            
            if new_content != content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Updated {file_path}")
