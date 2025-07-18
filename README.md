# GitHub Action "Read Helm values"

Given a list of `values.yaml` files, this action reads specified variables from the merged result using [`yq`](https://github.com/mikefarah/yq).

## Inputs

| Name               | Description                                                       | Required |
|--------------------|-------------------------------------------------------------------|--------|
| `working-directory`| Base directory for values files                                   | No     |
| `values`           | List of values files, newline-separated                           | Yes      |
| `output`           | Key-value list in format `key = .yq.path`, also newline-separated | Yes    |

Checkout [YAML Multiline](https://yaml-multiline.info/) to know how to properly format YAML files to get newlines.
Or look example below

## Outputs

Output is defined by the `output` input.

Basically, evaluated expressions are written to `$GITHUB_OUTPUT`

## Example Usage

See [test.yml](.github/workflows/test.yml)

```yaml
- uses: ton-studio/read-helm-values@v1
  id: execute
  with:
    working-directory: ./tests/basic/
    values: |
      values.yml
      values-override.yml
    output: |
      app_name = .appName
      host = .nginx.host
```

## How It Works

Installs [yq](https://github.com/mikefarah/yq) if not present.

Merges all given values.yaml files, each file overrides values from previous.

Extracts requested keys using provided .yq expressions.

Writes results to $GITHUB_OUTPUT.
