"""
Package testing function:
- Checks if the models can be loaded correctly and there are no errors
  - The libraries themselves
  - The library examples
- Checks if all relevant SysML files are correctly included in the Sysand package

Note that this file is shared between all the ode4hera/SysML-v2-* repositories.
So if any change is made to this file, ensure it is updated in the other
repositories as well.

MIT License

Copyright: (c) 2026, The Contributors to the ODE4HERA SysML v2 Libraries.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
import json
import syside
import pathlib

PACKAGES_PATH = pathlib.Path(__file__).parent.parent.resolve()


def run_package_checks(package: str, dependencies: list[str] = None):
    """
    Runs checks for a given package:
    - Checks the libraries in the package for errors
    - Checks the example models for errors
    - Checks which models are declared part of the package
    
    The function returns whether there were any errors encountered at any step.
    """
    has_errors = False

    # Create the environment of the package
    default_env = syside.Environment.get_default()

    dependency_files = []
    for dependency in (dependencies or []):
        # Load dependency packages as part of the environment for this package
        dependency_files += _get_package_files(dependency, dependency_files)
        dependency_files += _get_package_dependencies(dependency, dependency_files)

    # Load dependencies of this package
    dependency_files += _get_package_dependencies(package, dependency_files)

    dependency_model, _ = syside.load_model(dependency_files, environment=default_env)

    env = syside.Environment.from_documents(default_env.documents + dependency_model.documents)

    # Check the main package files for errors
    package_files = _get_package_files(package, dependency_files)
    package_has_errors, model = _load_print_errors(package_files, env)
    if package_has_errors:
        has_errors = True

    # Check the example files for errors
    examples_env = syside.Environment.from_documents(env.documents + model.documents)

    example_files = _get_package_example_files(package)
    examples_have_errors, _ = _load_print_errors(example_files, examples_env)
    if examples_have_errors:
        has_errors = True
    
    # Check the files declared to be part of the package
    if _check_declared_package_contents(package):
        has_errors = True

    return has_errors


def _get_package_files(package: str, existing_paths: list):
    """
    Gets model files that are part of a package:
    the SysML files in the root folder of the package.
    """
    existing_filenames = {path.name for path in existing_paths}

    package_files = list((PACKAGES_PATH / package).glob('*.sysml'))

    # Also include shipped libraries (temporary until they are available on Sysand themselves)
    for dependency_file in (PACKAGES_PATH / package).glob('lib/*.sysml'):
        if dependency_file.name not in existing_filenames:
            package_files.append(dependency_file)
            existing_filenames.add(dependency_file.name)

    return package_files


def _get_package_example_files(package: str):
    """
    Gets model files that are the examples of a package.
    """
    return list((PACKAGES_PATH / package / 'examples').glob('**/*.sysml'))


def _get_package_dependencies(package: str, existing_paths: list):
    """
    Get model files that are dependencies of a package as managed
    through Sysand dependencies.
    """
    existing_filenames = {path.name for path in existing_paths}

    package_dependencies = []
    package_path = PACKAGES_PATH / package
    
    for dependency_file in package_path.glob('.sysand/lib/*/*.sysml'):
        if dependency_file.name not in existing_filenames:
            package_dependencies.append(dependency_file)
            existing_filenames.add(dependency_file.name)
    
    return package_dependencies


def _load_print_errors(model_paths, environment):
    """
    Try to load the provided SysML models using Sysand Automator and report if there are any errors.
    """

    # Load the models
    print(f'\nLOADING: {", ".join([str(path.relative_to(PACKAGES_PATH)) for path in model_paths])}')
    model, diagnostics = syside.try_load_model(model_paths, environment)

    # Print diagnostics
    has_errors = False
    base_path = PACKAGES_PATH.as_posix()+'/'
    for diag in diagnostics.all:
        if not has_errors:
            print('=== DIAGNOSTICS ===')
        print(str(diag).replace(base_path, ''))
        has_errors = True

    if has_errors:
        print('=== END OF DIAGNOSTICS ===')
    else:
        print('MODELS OK')
    return has_errors, model


def _check_declared_package_contents(package: str):
    """
    Check if all SysML model files are correctly declared to be part of the package.
    """
    package_path = PACKAGES_PATH / package

    # Load files that should be part of the package: the main model files and the examples
    package_model_files = {file.relative_to(package_path).as_posix()
                           for file in (_get_package_files(package, []) + _get_package_example_files(package))}

    # Load files that are declared to be part of the package in the .meta.json file
    declared_package_model_files = []
    with open(package_path / '.meta.json', 'rb') as fp:
        meta_data = json.load(fp)

    for filename in meta_data.get('checksum', {}):
        declared_package_model_files.append(filename)

    for filename in meta_data.get('index', {}).values():
        declared_package_model_files.append(filename)

    declared_package_model_files = set(declared_package_model_files)

    # Compare the file lists and report any discrepancies
    files_not_in_declared = package_model_files - declared_package_model_files
    files_declared_but_not_existing = declared_package_model_files - package_model_files

    if len(files_not_in_declared) > 0 or len(files_declared_but_not_existing) > 0:
        print(f'\n=== PACKAGE FILE DECLARATION INCONSISTENCIES: {package} ===')

        if len(files_not_in_declared) > 0:
            print(f'{len(files_not_in_declared)} files not part of package, to fix it run:')
            print(f'sysand include {" ".join(files_not_in_declared)}')

        if len(files_declared_but_not_existing) > 0:
            print(f'{len(files_declared_but_not_existing)} non-existent files declared to be part of package, to fix it run:')
            print(f'sysand exclude {" ".join(files_declared_but_not_existing)}')

        print(f'=== END OF FILE DECLARATION INCONSISTENCIES ===')

        return True  # has_errors
    else:
        print(f'PACKAGE FILE DECLARATIONS OK: {package}')

    return False
