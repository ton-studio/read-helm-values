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

## Test locally

If you want to make changes and test it locally, use [act](https://github.com/nektos/act), just:

```bash
act
```

You will get
```text
[test.yml/case-basic] ⭐ Run Set up job
[test.yml/case-basic] 🚀  Start image=catthehacker/ubuntu:act-latest
[test.yml/case-basic]   🐳  docker pull image=catthehacker/ubuntu:act-latest platform= username= forcePull=true
[test.yml/case-basic]   🐳  docker create image=catthehacker/ubuntu:act-latest platform= entrypoint=["tail" "-f" "/dev/null"] cmd=[] network="host"
[test.yml/case-basic]   🐳  docker run image=catthehacker/ubuntu:act-latest platform= entrypoint=["tail" "-f" "/dev/null"] cmd=[] network="host"
[test.yml/case-basic]   🐳  docker exec cmd=[node --no-warnings -e console.log(process.execPath)] user= workdir=
[test.yml/case-basic]   ✅  Success - Set up job
[test.yml/case-basic]   ☁  git clone 'https://github.com/nick-fields/assert-action' # ref=v2
[test.yml/case-basic]   ☁  git clone 'https://github.com/nick-fields/assert-action' # ref=v2
[test.yml/case-basic] ⭐ Run Main checkout
[test.yml/case-basic]   🐳  docker cp src=/Users/sasha/work/github.com/ton-studio/read-helm-values/. dst=/Users/sasha/work/github.com/ton-studio/read-helm-values
[test.yml/case-basic]   ✅  Success - Main checkout [79.149583ms]
[test.yml/case-basic] ⭐ Run Main execute
[test.yml/case-basic] ⭐ Run Main Install yq
[test.yml/case-basic]   🐳  docker exec cmd=[bash --noprofile --norc -e -o pipefail /var/run/act/workflow/execute-composite-0.sh] user= workdir=
[test.yml/case-basic]   ✅  Success - Main Install yq [132.91875ms]
[test.yml/case-basic] ⭐ Run Main Extract Helm values
[test.yml/case-basic]   🐳  docker exec cmd=[bash --noprofile --norc -e -o pipefail /var/run/act/workflow/execute-composite-extract.sh] user= workdir=./tests/basic/
| Read file: values.yml
| Read file: values-override.yml
| Parsed expression: key is 'app_name', value is '.appName'
| Parsed expression: key is 'host', value is '.nginx.host'
[test.yml/case-basic]   ✅  Success - Main Extract Helm values [223.7465ms]
[test.yml/case-basic]   ⚙  ::set-output:: app_name=default
[test.yml/case-basic]   ⚙  ::set-output:: host=ton.org
[test.yml/case-basic]   ✅  Success - Main execute [680.500333ms]
[test.yml/case-basic]   ⚙  ::set-output:: app_name=default
[test.yml/case-basic]   ⚙  ::set-output:: host=ton.org
[test.yml/case-basic] ⭐ Run Main validate result (app_name)
[test.yml/case-basic]   🐳  docker cp src=/Users/sasha/.cache/act/nick-fields-assert-action@v2/ dst=/var/run/act/actions/nick-fields-assert-action@v2/
[test.yml/case-basic]   🐳  docker exec cmd=[/opt/acttoolcache/node/18.20.8/arm64/bin/node /var/run/act/actions/nick-fields-assert-action@v2/dist/index.js] user= workdir=
[test.yml/case-basic]   ✅  Success - Main validate result (app_name) [261.016292ms]
[test.yml/case-basic]   ⚙  ::set-output:: result=passed
[test.yml/case-basic] ⭐ Run Main validate result (host)
[test.yml/case-basic]   🐳  docker cp src=/Users/sasha/.cache/act/nick-fields-assert-action@v2/ dst=/var/run/act/actions/nick-fields-assert-action@v2/
[test.yml/case-basic]   🐳  docker exec cmd=[/opt/acttoolcache/node/18.20.8/arm64/bin/node /var/run/act/actions/nick-fields-assert-action@v2/dist/index.js] user= workdir=
[test.yml/case-basic]   ✅  Success - Main validate result (host) [161.4215ms]
[test.yml/case-basic]   ⚙  ::set-output:: result=passed
[test.yml/case-basic] ⭐ Run Post execute
[test.yml/case-basic]   ✅  Success - Post execute [39.542µs]
[test.yml/case-basic] ⭐ Run Complete job
[test.yml/case-basic] Cleaning up container for job case-basic
[test.yml/case-basic]   ✅  Success - Complete job
[test.yml/case-basic] 🏁  Job succeeded
```