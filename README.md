# GitHub Action: Run Sphinx linkcheck and summarise results

[![GitHub Action badge](https://github.com/manics/action-sphinx-linkcheck-summary/workflows/Test/badge.svg)](https://github.com/manics/action-sphinx-linkcheck-summary/actions)

## Optional input parameters

- `docs-dir`: The directory containing the Sphinx documentation.
- `build-dir`: The directory containing the built documentation.
- `sphinx-options`: Sphinx linkchecker options.
- `error-on-broken-links`: Default is to fail if there are any broken links, set to `false` to disable.

## Outputs

- `broken-link-count`: The number of broken links.
- `permanent-redirect-count`: The number of permanent redirects.

## Example

```yaml
name: Example workflow
name: Test

on:
  pull_request:
  push:
  workflow_dispatch:

jobs:
  test_linkcheck:
    runs-on: ubuntu-22.04
    name: Test linkchecker and summariser
    steps:
      - uses: actions/checkout@v3
      - name: Local action
        uses: manics/action-sphinx-linkcheck-summary@main
```
