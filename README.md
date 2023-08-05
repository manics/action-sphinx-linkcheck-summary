# GitHub Action: Run Sphinx linkcheck and summarise results

[![GitHub Action badge](https://github.com/manics/action-sphinx-linkcheck-summary/workflows/Test/badge.svg)](https://github.com/manics/action-sphinx-linkcheck-summary/actions)

## Pre-requisites

The repository must contain a [Sphinx project](https://www.sphinx-doc.org) with a `Makefile` that supports the `linkcheck` target.
For example, you can use the `sphinx-quickstart` utility.

## Optional input parameters

- `docs-dir`: The directory containing the Sphinx documentation.
- `build-dir`: The directory containing the built documentation.
- `sphinx-options`: Sphinx linkchecker options.
- `no-error`: Default is to fail if the linkcheck returns a non-zero exit code, set to `false` to disable. Note this may hide other errors.

## Outputs

- `broken-links-count`: The number of broken links.
- `permanent-redirects-count`: The number of permanent redirects.

## Example

```yaml
name: Example workflow

on:
  pull_request:
  push:
  workflow_dispatch:

jobs:
  test_linkcheck:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: "3.10"
      - run: pip install Sphinx
      - uses: manics/action-sphinx-linkcheck-summary@main
        with:
          docs-dir: docs
          build-dir: docs/_build
```

## Development

You can run the summary script locally:

```sh
./summarise-linkcheck-output.bash docs/_build/linkcheck/output.json
```

where `docs/_build/linkcheck/output.json` is the output of the Sphinx linkchecker.
