# Azure “Watchdog” – Cost & Health Lab
|  |  |
|---|---|
| **Deploy in one line** | `az deployment sub create -l eastus -f main.bicep -p adminPassword=<Your@Pwd1>` |
| **What it builds** | RG (`watchdog-rg`) with 2 × B1s VMs, storage, Log Analytics, budget, locks & alerts |
| **Why it matters** | Shows governance, monitoring and cost-control patterns used by real-world clients |

![Architecture diagram](docs/screens/arch-graph.png)

## Architecture

* Resource Group tagged `env=dev`, **read-only lock**
* 2 × B1s Windows 2019 VMs (Update Mgmt)
* VNet 10.10.0.0/16, subnet /24
* Log Analytics (30-day retention)
* Hot-tier storage account
* Monthly **budget** with 80 % alert (e-mail / Teams)

---

## CI/CD

GitHub Actions (`.github/workflows/deploy.yml`) validates & deploys on push to **main**.

## Workbook preview

![Workbook demo](docs/screens/workbook-demo.gif)