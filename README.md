> # ⚠️ LET OP: tijdelijke naam
> Deze repository heet nu `modulair-kern` omdat dit een pilot is voor een modulaire GovChat,
> gestart door Súdwest-Fryslân met toestemming van GovChat-NL. Werkt de pilot en is iedereen
> het eens, dan kan de naam in de toekomst `GovChat-NL-kern` worden.

<img src="icon.svg" width="64" height="64" alt="">

# modulair-kern

De kale GovChat op Kubernetes: [LibreChat](https://www.librechat.ai) met de officiële
Helm-chart, en de instellingen die er GovChat van maken. Een medewerker logt in met het
account van de eigen organisatie, stelt een vraag en krijgt een antwoord. Verder staat
alles uit.

Er is geen fork, geen eigen image en geen eigen chart. Deze repository bevat alleen
instellingen, en is voor elke organisatie gelijk.

Dit is één van vier repositories die bij elkaar horen:

| Repository | Wat |
|---|---|
| **`modulair-kern`** | de kale chat (deze repository) |
| [`modulair-app-time`](https://github.com/GovChat-NL/modulair-app-time) | de proefapp, en het voorbeeld van hoe een app eruitziet |
| [`modulair-manager`](https://github.com/GovChat-NL/modulair-manager) | de app-manager, die de uitrol samenstelt; hier staat ook het appcontract |
| [`modulair-deploy-template`](https://github.com/GovChat-NL/modulair-deploy-template) | de uitrolbasis waar een organisatie één keer een eigen repository van maakt |

## Wat erin zit

| Waar | Wat |
|---|---|
| `kern.yaml` | Wat de kern is: de chart, de versie, de Secrets bij naam en wat een organisatie moet invullen. Gelezen door de app-manager. |
| `values.yaml` | De instellingen van de kern, met het hele `librechat.yaml` erin. |
| `local/` | Een lokale proef zonder Azure en zonder Entra. |
| `controles/afscherming.sh` | Toont van buitenaf aan dat je er zonder het account van de organisatie niet in komt. |

Wat er draait: twee pods, LibreChat en de MongoDB die bij de chart hoort.

## Wat de kern meebrengt

- Inloggen kan alleen met het account van de eigen organisatie (OpenID Connect). Lokaal inloggen, registreren en een wachtwoord herstellen worden geweigerd.
- Alleen accounts met de rol `govchat-user` komen binnen; `govchat-admin` is beheerder.
- Elk gesprek is na 30 dagen weg.
- Onder de chat staat de disclaimer.
- Een vaste instructie waarschuwt bij het invoeren van persoonsgegevens.
- Eén verbinding met een taalmodel (Azure OpenAI). Eén vaste assistent.
- Uit: uploads, zoeken, agents, tools, geheugen, spraak, gedeelde links, de modelkeuze.

Wat er niet in zit: de waarden van één organisatie, branding, een beheertool, n8n, LiteLLM.
Die horen in de uitrolrepository of in een app.

## Versies

| Wat | Waar het vaststaat | Nu |
|---|---|---|
| De kern | `version` in `kern.yaml`, en de tag van deze repository | `0.1.0` |
| De LibreChat-chart | `chartVersion` in `kern.yaml` | `3.2.1` |
| Het LibreChat-image | volgt de chart | `v0.8.9` |
| MongoDB | volgt de chart | `8.0.13` |

Een organisatie verwijst naar de kern met het adres van deze repository en een versie.
Een tag verandert daarna niet meer.

## Lokaal proberen

Op een eigen wegwerpcluster, bijvoorbeeld Rancher Desktop, k3d of kind. Je hebt `kubectl`
en `helm` nodig. Het image van LibreChat is 4,3 GB; de eerste keer duurt ruim tien minuten.

```sh
git clone --branch v0.1.0 https://github.com/GovChat-NL/modulair-kern.git
cd modulair-kern
local/start.sh
kubectl -n govchat port-forward service/librechat-librechat 3080:3080
```

Open http://localhost:3080, maak een account en stel een vraag. Het stubmodel antwoordt
altijd "Dit is een testantwoord van het stubmodel." Het stubmodel kan geen tools aanroepen.

`local/services.yaml` brengt het stubmodel mee en een MongoDB zonder wachtwoord. De MongoDB
van de chart heeft geen arm64-image en draait dus niet op een Mac met Apple Silicon.

## Uitrollen

Niet vanuit deze repository. Een organisatie maakt één keer een eigen repository van
[`modulair-deploy-template`](https://github.com/GovChat-NL/modulair-deploy-template), kiest
daar de versie van de kern en de apps, en laat de app-manager de uitrol samenstellen.

## Een installatie controleren

```sh
controles/afscherming.sh https://govchat.example.nl
```

De controle kijkt van buitenaf of lokaal inloggen, registreren en een wachtwoord herstellen
worden geweigerd, en of de API zonder login niets geeft. De verzoeken veranderen niets.
Met de hand: een account met de rol `govchat-user` kan chatten, een account zonder niet.

## Iets wijzigen

Een wijziging aan de kern gaat via een issue en een pull request in deze repository.
Niemand past de kern aan in een eigen kopie. Wat een organisatie erbij wil, is een app.

## Herkomst

Gevuld vanuit de map `deploy/` van de branch `swf/modulairKern` van `GovChat-NL/GovChat-NL`,
commit `7e2474d` (20 november 2026). De licentie is nog niet gekozen; het voorstel is
EUPL-1.2 en het besluit ligt bij de maintainers van GovChat-NL.
