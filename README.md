# Block simulator hosts

[![Step changelog](https://shields.io/github/v/release/ofalvai/block-simulator-hosts?include_prereleases&label=changelog&color=blueviolet)](https://github.com/ofalvai/block-simulator-hosts/releases)

Block various hosts on the build VM to make Apple simulators faster.

<details>
<summary>Description</summary>

Block various hosts on the build VM to make Apple simulators faster. Use at your own risk.
</details>

## 🧩 Get started

Add this step directly to your workflow in the [Bitrise Workflow Editor](https://devcenter.bitrise.io/steps-and-workflows/steps-and-workflows-index/).

You can also run this step directly with [Bitrise CLI](https://github.com/bitrise-io/bitrise).

## ⚙️ Configuration

<details>
<summary>Inputs</summary>

| Key | Description | Flags | Default |
| --- | --- | --- | --- |
| `hosts` | List of hosts to block using the hosts file | required | `api.smoot.apple.com bag.itunes.apple.com cdn.smoot.apple.com gateway.icloud.com gdmf.apple.com mesu.apple.com updates.cdn-apple.com updates-http.cdn-apple.com uts-api.itunes.apple.com` |
</details>

<details>
<summary>Outputs</summary>
There are no outputs defined in this step
</details>

