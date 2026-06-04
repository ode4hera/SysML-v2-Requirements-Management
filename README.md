![ODE4HERA Logo](https://github.com/ode4hera/SysML-v2-Requirements-Management/blob/main/ode4hera_logo.png)

# ODE4HERA SysML v2 Libraries: Requirements Management

[![Package Checks](https://github.com/ode4hera/SysML-v2-Requirements-Management/workflows/Package%20Checks/badge.svg)](https://github.com/ode4hera/SysML-v2-Requirements-Management/actions/workflows/package_checks.yml)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

This repository contains a SysML v2 library package for requirements management, which adds a database of INCOSE-recommended attributes to requirements and needs.
Refer to the package [readme](requirements_management/readme.md) and [examples](requirements_management/examples/) for more details.

*The library presented in this repository has originally been developed in the [ODE4HERA](https://www.ode4hera.eu/) (Open Digital Environment for Hybrid-Electric Regional Architectures) project and has received funding from the European Union Clean Aviation Joint Undertaking under grant agreement nr 101140510.*

## Getting Started

To get started using the library, either clone the repo or install it from the [Sysand](https://sysand.com/) package index:

```cmd
sysand add ode4hera/requirements-management
```

When cloning locally, be sure to install any needed dependencies:
```cmd
sysand sync
```

The library is best viewed and used with [Syside Editor](https://docs.sensmetry.com/editor/).

## Citing

If you are using the library in your work, please cite:

Bussemaker, J.H., Torrigiani, F., & Cabaleiro, C. (2026). HERA Architecture Framework Libraries. ODE4HERA Consortium.
doi: [10.5281/zenodo.18267042](https://doi.org/10.5281/zenodo.18267042)

## Contributing

The project is a joint effort by the ODE4HERA consortium, however everyone is encouraged to contribute!

If you find a bug or have suggestions for improvement, please file an issue using the Github issue tracker.
If you require support or want to collaborate in other ways, feel free to contact us (see below for contact details).

If you want to contribute to the library:

- Fork the repository and commit your contributions to the fork
  - Make sure to update or add documentation and/or examples if needed
- Read and sign the [Contributor License Agreement (CLA)](https://github.com/ode4hera/SysML-v2-Requirements-Management/blob/main/ODE4HERA%20Libraries%20Individual%20Contributor%20License%20Agreement.docx), and send it to the email address below
- Create a pull request into the `main` branch

The project is administered by the DLR Institute of System Architectures in Aeronautics.
You can contact us at *jasper.bussemaker at dlr.de*.

### Repository Structure

The repository is built up in the following way:

- `requirements_management`: contains the actual library package, which is a Sysand project
  - The package has example models in the `examples` sub-folder that demonstrate usage of the library
  - The package additionally has: a readme (shown on the Sysand package page) with documentation, a changelog, and a license file
- `package_checks`: contains code for testing the package before merging/releasing, written as Python code using pytest
  - The checks need [Syside Automator](https://docs.sensmetry.com/automator/), which is commercial software
  - The repository has a license key configured so the checks can be executed
- `examples_dev`: contains models for demonstrating/developing the package that are not part of the published package, used for example for internal discussions or demonstrations

Refer to the [Sysand index documentation](https://docs.sysand.com/) to learn more about how the package should be structured to be publishable.

### Version Release Process

To release a new version, first ensure all relevant branches have been merged into main using pull requests
(and ensure package checks pass, the kpar can be built, and the CLA has been signed if needed).

Then to release a new version:

1. Update version numbers in files and `.project.json`.
2. Create a new release with a tag in the form `v0.0.0`.
   - The kpar will be built and uploaded to Sysand automatically.
3. Verify that the new version is available on Sysand.

Currently, there is no predefined release schedule.
