> # ⚠️ NOTE: temporary name
> This repository has the name `swf-modulair-kern` because this is a pilot for a modular
> GovChat. Súdwest-Fryslân started the pilot with the approval of GovChat-NL. If the pilot
> is a success and all parties agree, the name can become `GovChat-NL-kern`.

<img src="icon.svg" width="64" height="64" alt="">

# swf-modulair-kern

The kern is the basic GovChat on Kubernetes. It is [LibreChat](https://www.librechat.ai)
with the official Helm chart, and the settings that make it GovChat. An employee logs in
with the account of the organisation, asks a question and gets an answer. All other
functions are off.

There is no fork, no own image and no own chart. This repository contains settings only.
It is the same for each organisation.

> **Start here: the deploy repository.**
> You do not deploy from this repository. The deployment is done in the deploy repository
> of your organisation. To install GovChat, or to test it on your computer, start with
> [`swf-modulair-deploy-template`](https://github.com/GovChat-NL/swf-modulair-deploy-template)
> and obey its README.

This is one of four repositories that belong together:

| Repository | Function |
|---|---|
| **`swf-modulair-kern`** | The basic chat (this repository). |
| [`swf-modulair-app-time`](https://github.com/GovChat-NL/swf-modulair-app-time) | The trial app, and the example of an app. |
| [`swf-modulair-manager`](https://github.com/GovChat-NL/swf-modulair-manager) | The `govchat` command, and the rules for an app. |
| [`swf-modulair-deploy-template`](https://github.com/GovChat-NL/swf-modulair-deploy-template) | The start point for the deploy repository of an organisation. |

## The files

| File | Function |
|---|---|
| `kern.yaml` | Tells the `govchat` command what the kern is: the chart, the version, the names of the Secrets and the settings that an organisation must give. |
| `values.yaml` | The settings of the kern. The full `librechat.yaml` is in this file. |
| `local/services.yaml` | For a local test: a replacement for the language model and a database. |

The kern has two pods: LibreChat, and the MongoDB that comes with the chart.

## What the kern gives

- Login is only possible with the account of the organisation (OpenID Connect). LibreChat refuses local login, registration and password reset.
- Only accounts with the role `govchat-user` get access. The role `govchat-admin` is the administrator.
- Each conversation is deleted after 30 days.
- A disclaimer is shown below the chat.
- A fixed instruction gives a warning when a user enters personal data.
- One connection to a language model (Azure OpenAI). One fixed assistant.
- Off: uploads, search, agents, tools, memory, speech, shared links and the model selection.

The kern does not contain the values of one organisation, the branding, a management tool,
n8n or LiteLLM. These belong in the deploy repository or in an app.

## Versions

| Part | Where the version is set | Now |
|---|---|---|
| The kern | `version` in `kern.yaml`, and the tag of this repository | `0.2.0` |
| The LibreChat chart | `chartVersion` in `kern.yaml` | `3.2.1` |
| The LibreChat image | Comes with the chart | `v0.8.9` |
| MongoDB | Comes with the chart | `8.0.13` |

A tag does not change after it is made.

## How to use the kern

Do not deploy from this repository. An organisation has its own deploy repository, made
from [`swf-modulair-deploy-template`](https://github.com/GovChat-NL/swf-modulair-deploy-template).
In that repository, this command sets the version of the kern:

```sh
./govchat kern set v0.2.0 --env acceptatie
```

The command copies `kern.yaml` and `values.yaml` into the deploy repository. Thus the
reviewer of the pull request sees each change of the kern.

## Local test

Use the local environment of the deploy repository:

```sh
./govchat local up
./govchat verify --env lokaal
```

The replacement model always answers "Dit is een testantwoord van het stubmodel." It
cannot call tools. The MongoDB of the chart has no arm64 image. Thus the local test uses
the MongoDB from `local/services.yaml`.

## How to change the kern

Make an issue and a pull request in this repository. Do not change the kern in a copy.
If an organisation wants an added function, that function is an app.

## Version 0.1.0

Version 0.1.0 was made for the first tool (the app manager). Version 0.2.0 and later are
for the `govchat` command. The settings in `values.yaml` did not change.

## Origin

The content comes from the folder `deploy/` of the branch `swf/modulairKern` of
`GovChat-NL/GovChat-NL`, commit `7e2474d` (20 November 2026). The licence is not chosen
yet. The proposal is EUPL-1.2. The maintainers of GovChat-NL make the decision.
