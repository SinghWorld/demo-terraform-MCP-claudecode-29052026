# 🚀 GitHub Codespaces DevContainer — Terraform & AWS CLI (No Docker)

*Codespaces is a fully working computer that lives in the cloud, tied to your GitHub repo, and opens instantly in your browser.
Think of it like this — instead of setting up your workbench at home every time, GitHub hands you a fully-equipped workshop the moment you walk in the door.*

### The Old Way vs Codespaces

| Old way (your laptop) | Codespaces |
|------------------------|-------------|
| Install Git, Python, Terraform, AWS CLI... | Nothing to install |
| Fix version conflicts | Versions are pre-defined |
| "It works on my machine" | Same environment for everyone |
| Breaks if you get a new laptop | Just open a browser |
| Hours of setup | Ready in 2 minutes |

### **What's Actually Running Inside a Codespace?**
When you open a Codespace, GitHub spins up four things for you automatically:
1. **A Linux server** — a real Ubuntu machine running on GitHub's cloud infrastructure. Not your laptop. GitHub's servers.
2. **VS Code in your browser** — the exact same VS Code editor you may already use, but running in a browser tab. No install needed.
3. **Your tools** — whatever you put in devcontainer.json gets auto-installed. In our case: Terraform and AWS CLI.
4. **Your code** — your GitHub repo is automatically cloned inside, ready to work on.

### **Why Do Engineers Use It?**

- **No setup headaches** — a new team member can be productive in 2 minutes instead of half a day fighting installs.
- **Consistent environments** — every developer gets the exact same versions of every tool. No more "it works on my machine."
- **Works on any device** — even a cheap laptop, a tablet, or a Chromebook. The heavy lifting runs on GitHub's servers.
- **Disposable environments** — made a mess? Delete the Codespace and spin up a fresh one in 2 minutes. Your code is safe in GitHub.

> [!CAUTION]
**Free tier** — GitHub gives you 60 hours/month free, 2 hours/day, which is plenty for personal projects and learning.

---

> A simple step-by-step guide to set up a **Dev Container** in GitHub Codespaces with **Terraform** and **AWS CLI** using only `devcontainer.json` — no Dockerfile required.

---

## 📋 Table of Contents

- [🚀 GitHub Codespaces DevContainer — Terraform \& AWS CLI (No Docker)](#-github-codespaces-devcontainer--terraform--aws-cli-no-docker)
    - [The Old Way vs Codespaces](#the-old-way-vs-codespaces)
    - [**What's Actually Running Inside a Codespace?**](#whats-actually-running-inside-a-codespace)
    - [**Why Do Engineers Use It?**](#why-do-engineers-use-it)
  - [📋 Table of Contents](#-table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Step 1 — Create a GitHub Repository](#step-1--create-a-github-repository)
  - [Step 2 — Launch GitHub Codespaces](#step-2--launch-github-codespaces)
  - [Step 3 — Configure Codespaces](#step-3--configure-codespaces)
  - [Step 4 — Rebuild the Container](#step-4--rebuild-the-container)
    - [What each section does](#what-each-section-does)
  - [Step 5 — Verify Terraform](#step-5--verify-terraform)
  - [Step 6 — Verify AWS CLI](#step-6--verify-aws-cli)
  - [Step 8 — Configure AWS Credentials](#step-8--configure-aws-credentials)
    - [Recommended — GitHub Codespaces Secrets](#recommended--github-codespaces-secrets)
    - [Alternative — aws configure (quick test)](#alternative--aws-configure-quick-test)
    - [Verify credentials are working](#verify-credentials-are-working)
  - [Folder Structure](#folder-structure)
  - [Troubleshooting](#troubleshooting)
  - [📚 References](#-references)

---

## Prerequisites

| Requirement | Details |
|---|---|
| GitHub Account | Free or paid — [github.com](https://github.com) |
| Codespaces Access | Free tier: 60 hrs/month |
| AWS Account | Needed for Step 8 credential setup |

---

## Step 1 — Create a GitHub Repository

1. Log in to [github.com](https://github.com)
2. Click the **"New"** button (top-left)
3. Enter a repository name, e.g. `tf-aws-codespace`
4. Tick **"Add a README file"**
5. Click **"Create repository"**

> 📸 **Screenshot — New Repository form:**
>
> ![Create Repo](https://docs.github.com/assets/cb-29762/mw-1440/images/help/repository/repo-create-global-nav-update.webp)

---

## Step 2 — Launch GitHub Codespaces

Inside your new repository:

1. Click the green **`<> Code`** button (top right)
2. Click the **"Codespaces"** tab
3. Click **"Create codespace on main"**

> 📸 **Screenshot — Codespaces tab inside the Code button:**
> 
> <img width="945" height="526" alt="Image" src="https://github.com/user-attachments/assets/2e2e3164-2f63-4ded-9170-2316373c43c3" />
> 

> ⏳ Wait ~1 minute for the default Codespace to load (VS Code in browser).

---

## Step 3 — Configure Codespaces

1. Press **`Ctrl+Shift+P`** to open the Command Palette
2. Type **`devcontainer`**
3. Select **"Codespaces: Add Dev Containers Configuration Flies"**
> <img width="1281" height="271" alt="Image" src="https://github.com/user-attachments/assets/4d3a0153-7330-45aa-8912-4cb8eff44e86" />

5. If you have existing container then select **"Modify your active configuration"** else select **"Create a new configuration"**
> <img width="1204" height="252" alt="Image" src="https://github.com/user-attachments/assets/8b55fcdb-8286-4dee-932e-f881055867c1" />

6. Select the package which you required, in our case it would `terraform` and `AWS CLI`
   
   - Select the below packages:- 
     - `"Terraform,tflint, and TFGrant devcontainer"`
     - `AWS CLI devcontainer`
    
> <img width="945" height="526" alt="Image" src="https://github.com/user-attachments/assets/5382b41c-dfa7-4833-93b3-a91193b7d415" />
> <img width="945" height="526" alt="Image" src="https://github.com/user-attachments/assets/5e229162-3ca9-4220-9594-1794d90832aa" />

7. Select `Configuration Options`
> <img width="1182" height="192" alt="Image" src="https://github.com/user-attachments/assets/259cb875-67ac-491e-a917-c3ac9b1e9aee" />

8. Click on `rebuild` 
> <img width="1262" height="601" alt="Image" src="https://github.com/user-attachments/assets/393082e7-9b0d-45f9-8518-4567b8a3c4c5" />


You will see below configuration in the `.devcontainer/devcontainer.json`

```sh
{
	"image": "mcr.microsoft.com/devcontainers/universal:2",
	"features": {
		"ghcr.io/devcontainers/features/aws-cli:1": {
			"verbose": true,
			"version": "latest"
		},
		"ghcr.io/devcontainers/features/terraform:1": {
			"version": "latest",
			"tflint": "latest",
			"terragrunt": "latest"
		}
	}
}
```

## Step 4 — Rebuild the Container

> [!IMPORTANT]
> If you want to change or modification into your container then you need to follow the same procedure and `Rebuild` it.
> <img width="1160" height="371" alt="Image" src="https://github.com/user-attachments/assets/aa2893cc-e2f2-4aef-ad36-38ccff708a52" />

1. Press **`Ctrl+Shift+P`** to open the Command Palette
2. Type **`rebuild`**
3. Select **"Dev Containers: Rebuild Container"**
4. Wait for the rebuild to finish (~3–5 minutes)


<!-- > ```
> Ctrl+Shift+P opens the command palette at the top of the screen
> Type "rebuild" → list filters to show:
>   ▶ Dev Containers: Rebuild Container
> Click it → confirmation prompt → container rebuilds
> Build log appears in the terminal showing features being installed
> ``` -->

> 💡 You may also see a notification banner:
> **"Dev container configuration file has changed."** → Click **"Rebuild"**

---

<!-- 
## Step 3 — Create the `.devcontainer` Folder

Once the Codespace is open, use the **terminal** (`` Ctrl+` ``) and run:

```bash
mkdir -p .devcontainer
```

> 📸 **Screenshot — Terminal in Codespace:**
>
> ```
> Open terminal with Ctrl+` (backtick)
> Type: mkdir -p .devcontainer
> Press Enter
> The Explorer panel (left sidebar) now shows the .devcontainer folder
> ```

Or via the Explorer panel:
- Right-click in the file tree → **"New Folder"** → type `.devcontainer`

---

## Step 4 — Create `devcontainer.json`

This single file does everything — **no Dockerfile needed**.

Create the file:

```bash
touch .devcontainer/devcontainer.json
```

Open it in the editor and paste:

```jsonc
// .devcontainer/devcontainer.json
{
  "name": "Terraform + AWS CLI",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/terraform:1": {
      "version": "latest"
    },
    "ghcr.io/devcontainers/features/aws-cli:1": {
      "version": "latest"
    }
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "hashicorp.terraform",
        "amazonwebservices.aws-toolkit-vscode"
      ]
    }
  },
  "postCreateCommand": "echo '✅ Done!' && terraform version && aws --version"
}
```

> 📸 **Screenshot — devcontainer.json open in VS Code editor:**
>
> ```
> Explorer panel → .devcontainer/devcontainer.json
> Editor shows the JSON content with "features" block listing
> terraform and aws-cli entries
> ``` -->

### What each section does

| Key | Purpose |
|---|---|
| `"image"` | Uses Microsoft's official Ubuntu base image — no custom Dockerfile |
| `"features" → terraform` | Installs Terraform via the official DevContainer feature |
| `"features" → aws-cli` | Installs AWS CLI v2 via the official DevContainer feature |
| `"extensions"` | Auto-installs HashiCorp Terraform + AWS Toolkit in VS Code |
| `"postCreateCommand"` | Runs once after build — confirms both tools are working |

---



## Step 5 — Verify Terraform

Once the rebuild completes, open a terminal and run:

```bash
terraform version
```

**Expected output:**
```
Terraform v1.x.x
on linux_amd64
```

```bash
which terraform
# /usr/local/bin/terraform
```

> 📸 **Screenshot — terraform version in terminal:**
>
> ```
> Terminal panel → terraform version
> Output: Terraform v1.x.x on linux_amd64
> Also check VS Code Extensions panel (left sidebar):
>   HashiCorp Terraform extension showing as installed
> ```

---

## Step 6 — Verify AWS CLI

In the same terminal, run:

```bash
aws --version
```

**Expected output:**
```
aws-cli/2.x.x Python/3.x.x Linux/x86_64
```

```bash
which aws
# /usr/local/bin/aws
```

> 📸 **Screenshot — aws --version in terminal:**
>
> ```
> Terminal panel → aws --version
> Output: aws-cli/2.x.x Python/3.x.x Linux/...
> Also check VS Code Extensions panel:
>   AWS Toolkit extension showing as installed
> ```

---

## Step 8 — Configure AWS Credentials

> ⚠️ Never commit credentials into your repository.

### Recommended — GitHub Codespaces Secrets

1. Go to **GitHub → Settings → Codespaces**
2. Under **"Secrets"**, click **"New secret"**
3. Add each of these:

| Secret Name | Example Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | `wJalrXUtnFEMI/K7MDENG/...` |
| `AWS_DEFAULT_REGION` | `ap-southeast-2` |

> 📸 **Screenshot — GitHub Codespaces Secrets page:**
>
> ```
> github.com → Profile icon (top right) → Settings
> → Left sidebar → "Codespaces"
> → "Secrets" section → "New secret" button
> → Name field: AWS_ACCESS_KEY_ID
> → Value field: your key
> → Click "Add secret"
> ```

These are injected automatically as environment variables when your Codespace starts.

### Alternative — aws configure (quick test)

```bash
aws configure
```

```
AWS Access Key ID:     AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name:   ap-southeast-2
Default output format: json
```

### Verify credentials are working

```bash
aws sts get-caller-identity
```

**Expected output:**
```json
{
    "UserId": "AIDACKCEVSQ6C2EXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/your-username"
}
```

---

## Folder Structure

Your final repo layout:

```
tf-aws-codespace/
│
├── .devcontainer/
│   └── devcontainer.json    ← Single config file — no Dockerfile needed
│
└── README.md
```

That's it — **one file** to get a fully configured Terraform + AWS CLI environment.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `terraform: command not found` | Rebuild container: `Ctrl+Shift+P` → "Rebuild Container" |
| `aws: command not found` | Same as above — check build log for feature install errors |
| `No valid credential sources` | Verify Codespaces Secrets are set; run `env \| grep AWS` to confirm |
| Rebuild takes too long | Normal on first build (~5 min); subsequent rebuilds are faster |
| Feature version error | Change `"version": "latest"` to a specific version e.g. `"1.7.0"` |

---

## 📚 References

| Resource | URL |
|---|---|
| Dev Container Features — Terraform | https://github.com/devcontainers/features/tree/main/src/terraform |
| Dev Container Features — AWS CLI | https://github.com/devcontainers/features/tree/main/src/aws-cli |
| GitHub Codespaces Docs | https://docs.github.com/en/codespaces |
| Codespaces Secrets Setup | https://docs.github.com/en/codespaces/managing-your-codespaces/managing-secrets-for-your-codespaces |

---
