# uv run -m pytest -s -v examples_dev/structured_requirements

import syside
from syside import query, testing
import pathlib


TEST_MODELS_PATH = pathlib.Path(__file__).parent.resolve()
PACKAGE_PATH = TEST_MODELS_PATH.parent.parent / 'requirements_management'


def _load_model(path: pathlib.Path):
    env = _get_environment()
    model, diagnostics = syside.try_load_model([path], env)
    print(diagnostics)
    return model


def _get_environment():
    existing_filenames = set()

    env_files = list(PACKAGE_PATH.glob('*.sysml'))
    for dependency_file in PACKAGE_PATH.glob('.sysand/lib/**/*.sysml'):
        if dependency_file.name not in existing_filenames:
            env_files.append(dependency_file)
            existing_filenames.add(dependency_file.name)
    
    default_env = syside.Environment.get_default()
    env_model, diagnostics = syside.load_model(env_files, environment=default_env)

    return syside.Environment.from_documents(default_env.documents + env_model.documents)


def test_statements():
    model = _load_model(TEST_MODELS_PATH / '01_statements.sysml')

    attr_values = {}
    compiler = syside.Compiler()
    for attr in query.find_elements_of_type(model, syside.AttributeUsage):
        value, report = compiler.evaluate_feature(attr, attr, model.lib)
        if report.fatal:
            raise RuntimeError(report.diagnostics)
        else:
            attr_values[attr.name] = value

    assert attr_values['statement1'] == 'Statement doc'
    assert attr_values['statement2'] == 'Main doc 1'
    assert attr_values['statement3'] == 'ElementWithoutDocs'


def test_resolving():
    model = _load_model(TEST_MODELS_PATH / '02_resolving.sysml')

    features = {}
    compiler = syside.Compiler()
    for ref_usage in query.find_elements_of_type(model, syside.ReferenceUsage):
        value, report = compiler.evaluate_feature(ref_usage, ref_usage, model.lib)
        if report.fatal:
            raise RuntimeError(report.diagnostics)
        else:
            if isinstance(value, syside.BoundMetaclass):
                features[ref_usage.name] = (str(value.element.qualified_name), getattr(value.element, 'value', None), value.metaclass.name)
            else:
                features[ref_usage.name] = value
    
    assert features['attrFeature'] == ('ResolvingTests::myPart::attr', None, 'AttributeUsage')
    assert features['subPartFeature'] == ('ResolvingTests::BasePart::subPart', None, 'PartUsage')
    assert features['attrValue'] == ('None', 'a string ', 'LiteralString')
    assert features['statementValue'] == 'and a statement'
    assert features['concatValue'] == 'concat a string and a statement'
