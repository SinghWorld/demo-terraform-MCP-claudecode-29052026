# Claude Code + NVIDIA NIM API + LiteLLM + Terraform MCP: A Full Stack AI Dev Setup
<!-- # Free Claude Code Setup: Complete Technical Implementation Guide -->

<img width="1494" height="928" alt="Image" src="https://github.com/user-attachments/assets/3c8512d5-4c3e-4711-8be6-7ab3ceea9cbe" />

### I've Been Using Claude Code for Free — Here's the Exact Setup Nobody Talks About

> You can run Claude Code against NVIDIA's free NIM API (powered by DeepSeek V4 Pro) through a local proxy — with full MCP Terraform server support. This guide walks through every step, every error I hit, and exactly how I fixed them.

---

I'll be honest with you. When I first saw the Claude Code pricing, I closed the tab.

Not because I didn't want it. I *really* wanted it. But paying a subscription just to try it out felt like buying concert tickets before listening to the album. So I started digging.

Turns out, there's a clean, legitimate way to use Claude Code against NVIDIA's NIM API endpoint — which gives you access to powerful models like DeepSeek V4 Pro, completely free (with API limits). You run a lightweight local proxy on your machine, point Claude Code at it, and it works exactly as advertised.

This is the guide I wish I had when I started.

---

## About Setup

Connect **Claude Code** to **NVIDIA's free API** using **LiteLLM** as a translation proxy. Run any of 150+ models — including DeepSeek V4 pro — without paying a cent.

| Tool | Role |
|------|------|
| **Claude Code** | Anthropic's terminal-based AI coding agent |
| **LiteLLM** | Translation proxy (Anthropic ↔ OpenAI format) |
| **NVIDIA NIM API** | Free model hosting platform |
| **DeepSeek V4 Pro** | 284B MoE model — coding-optimized, 1M context |

---

## 🖥️ Requirements

| Requirement | Detail |
|------------|--------|
| OS | Windows / Mac / Linux |
| Python | 3.10 or higher |
| Node.js | v18 or higher |
| GPU | ❌ Not required |
| API Key | Free — build.nvidia.com |


---
## **Tech stack involved:**
- `Node.js` — Claude Code CLI runtime requirement - [Download Link](https://nodejs.org/en/download)
- `npm` — Package manager for the install - [Download Link](https://nodejs.org/en/download)
- `Python 3.14` — Proxy server runtime
- `Go` — Required to build the Terraform MCP server binary
- `Git` — Clone the proxy repo - [Download Link](https://git-scm.com/install/windows)   
- `Terraform` — For the MCP integration - [Download Link](https://developer.hashicorp.com/terraform/install)
- `NVIDIA API` — The free model endpoint - [Download Link](https://build.nvidia.com/)
- `DeepSeek V4 Pro` — The model doing the actual work
- `AWS CLI` - AWS configuration - [Download Link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)  

---

Let's go.

---

## Step-by-Step Implementation

### Environment Setup


### Step 1: Verify `Node.js` Installation

Open your terminal/PowerShell and confirm Node.js availability:

```bash
# Check Node.js version (should be 16.0.0 or higher)
node --version
# Output example: v20.x.x

# Check npm version
npm --version
# Output example: 11.x.x
```

**What to do if Node.js isn't installed:**
- Go to the official [Node.js](https://nodejs.org/en/download) website
- Download the installer (MSI for Windows) | Download LTS (Long Term Support) version
- Install Node.js
- Verify installation:

Claude Code requires Node.js.

```bash
# Bypass execution policy only for this install
Get-ExecutionPolicy -List
Set-ExecutionPolicy Bypass -Scope Process -Force
# or
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Download and install Chocolatey:
powershell -c "irm https://community.chocolatey.org/install.ps1|iex"

# Open a new terminal and run the below command 
# Download and install Node.js:
choco install nodejs --version="24.15.0"

# Verify the Node.js version:
node -v # Should print "v24.15.0".

# Verify npm version:
npm -v # Should print "11.12.1".
```
<details>
<summary><b>Verify Chocolatey exists</b></summary><br>

**Step 1 — Verify Chocolatey exists**

Run this in PowerShell (Admin):
```bash
Test-Path C:\ProgramData\chocolatey\bin\choco.exe
```
**Expected result:**
```PowerShell
True
```
✅ This confirms Chocolatey is installed correctly.





**Step 2 — Add Chocolatey to PATH (Permanent Fix)**
🔹 Add it for ALL users (recommended)
Still in PowerShell (Admin):
```PowerShell
$env:Path += ";C:\ProgramData\chocolatey\bin"
[Environment]::SetEnvironmentVariable(
  "Path",
  [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\ProgramData\chocolatey\bin",
  "Machine"
)
```
✅ This permanently fixes Chocolatey for:

- PowerShell
- Command Prompt
- Git Bash
- Any terminal


**Step 3 — Restart PowerShell (IMPORTANT)**

Close all PowerShell windows

Open a new PowerShell (Admin)

Then run:
```PowerShell
choco -v
```
You should see something like:
```PowerShell
2.x.x
```
✅ Chocolatey is now working.

**Step 4 — Install Node.js (Correctly)**
Now run:
```PowerShell
choco install nodejs --version="24.15.0" -y
```
Wait for it to finish.

**Step 5 — Verify Node & npm**
Still in PowerShell:
```PowerShell
node -v
npm -v
```
Expected:
```PowerShell
v24.15.0
11.12.1
```

**Step 6 — Make Node work in Git Bash**

Close ALL Git Bash windows
Reopen Git Bash
Run:
If Git Bash still doesn’t see it, run once:
```Shell
echo 'export PATH="$PATH:/c/Program Files/nodejs"' >> ~/.bashrc
source ~/.bashrc
```
</details>

<details>

<summary><b>Verify Node exists</b></summary><br>

**Step 1 — Locate where Node is actually installed**
Run this in PowerShell (Admin):
```Shell
Get-ChildItem "C:\Program Files" -Directory | Where-Object Name -Match "node"
```
One of these should exist:
```shell
C:\Program Files\nodejs
C:\Program Files (x86)\nodejs
```
Now check directly:
```Shell
Test-Path "C:\Program Files\nodejs\node.exe"
Test-Path "C:\Program Files (x86)\nodejs\node.exe"
```
✅ One of these will return True.

**Step 2 — Temporarily test Node (no PATH change yet)**
Replace the path that exists and run:
```Shell
& "C:\Program Files\nodejs\node.exe" -v
```
(or x86 path if that’s the one)

✅ If this prints v24.15.0, Node itself is perfectly fine.

**Step 3 — Permanently fix PATH (SYSTEM‑WIDE)**
This is the real fix.
Run exactly this in PowerShell (Admin):
```shell
[System.Environment]::SetEnvironmentVariable(
  "Path",
  [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Program Files\nodejs",
  "Machine"
)
```
This adds Node to the machine PATH, not just your user.

**Step 4 — Restart PowerShell (MANDATORY)**
- Close ALL PowerShell windows
- Open new PowerShell (Admin)

Then run:
```Shell
node -v
npm -v
```
</details>

<details>
<summary><b>If above both doesn't fix then run it</b></summary><br>

**Check what PATH PowerShell is ACTUALLY using**
Run:
```Shell
$env:Path -split ';'
```
Now look closely:

Do you see C:\Program Files\nodejs?

✅ YES → PATH is present but overridden
❌ NO → Machine PATH is not being loaded

**Step 3 — Check Machine vs User PATH (this is the key)**
Run both:
```Shell
[System.Environment]::GetEnvironmentVariable("Path", "Machine")
```
```Shell
[System.Environment]::GetEnvironmentVariable("Path", "User")
```
⚠️ Important discovery (very likely)

On many Windows Server systems:

User PATH overrides Machine PATH

If User PATH exists and is malformed → Machine PATH is ignored


**Step 4 — HARD FIX (works every time)**

🔥 We will rebuild User PATH to INCLUDE Machine PATH

Run this in PowerShell (Admin):

```Shell
$machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")

if (-not $userPath.Contains("C:\Program Files\nodejs")) {
    [System.Environment]::SetEnvironmentVariable(
        "Path",
        $userPath + ";" + $machinePath,
        "User"
    )
}
```
✅ This forces:

- User PATH ✅
- Machine PATH ✅
- Node PATH ✅


**Step 5 — HARD RESTART REQUIRED**

Environment variables will not refresh properly until:

✅ Do ONE of the following:

Sign out of the Administrator account and sign back in

OR

Reboot the machine (best option)

This is mandatory on Windows Server.
</details>

---
> [!IMPORTANT]
> This is a very important piece of information.

<details><summary><b>Basic AWS Profile Setup</b></summary><br>

0. List All Profiles
```sh
aws configure list-profiles
```

1. Basic AWS Profile Setup

Run this command:
```sh
aws configure --profile terraformlab

It will prompt you for:
	• AWS Access Key ID 
	• AWS Secret Access Key 
	• Default region name (e.g. ap-southeast-2) 
	• Default output format (json, table, text) 
```

Input:
```sh
AWS Access Key ID [None]: AKIAxxxxxxxxxxxx
AWS Secret Access Key [None]: xxxxxxxxxxxxxxxx
Default region name [None]: ap-southeast-2
Default output format [None]: json
```

2. Where AWS Stores Profile

```sh
# Linux / Mac:
~/.aws/credentials
~/.aws/config

# Windows:
C:\Users\<YourUser>\.aws\credentials
C:\Users\<YourUser>\.aws\config
```

3. File Format Example
```sh
credentials file:

[default]
aws_access_key_id=AKIAxxxxxxxx
aws_secret_access_key=xxxxxxxxxxxx

[dev-account]
aws_access_key_id=AKIAyyyyyyyy
aws_secret_access_key=yyyyyyyyyyyy
config file:

[default]
region=us-east-1
output=json

[profile dev-account]
region=ap-southeast-2
output=json
```

4. Use a Specific Profile
```sh
Run commands with profile:

aws s3 ls --profile dev-account
```
Or set environment variable:
```sh
export AWS_PROFILE=dev-account   # Linux/Mac
setx AWS_PROFILE dev-account     # Windows (permanent)
```

5. List All Profiles
```sh
aws configure list-profiles
```

6. Test Profile
```sh
aws sts get-caller-identity --profile dev-account
```

**Best Practice (Enterprise / MNC)**
```
• Use named profiles per account/environment 
		○ dev 
		○ qa 
		○ prod 
• Avoid using default profile in automation 
• Prefer IAM roles / SSO in production setups 


# 🔐 Bonus: AWS SSO Profile (Modern Approach)

aws configure sso --profile dev-sso

Then login:
aws sso login --profile dev-sso
```

</details>

---

### Step 2: install `Python3.13` on Windows VM

**Step 2.1 — Install Python 3.13**

Run:
```sh
winget install Python.Python.3.13
```


**Step 2.2 — Find Python Installation Path**

- Run this command in PowerShell:

```sh
Get-ChildItem "$env:LOCALAPPDATA\Programs\Python" -Recurse -Filter python.exe
```
Example output:
```sh
PS C:\Users\Administrator\Desktop> Get-ChildItem "$env:LOCALAPPDATA\Programs\Python" -Recurse -Filter python.exe


    Directory: C:\Users\Administrator\AppData\Local\Programs\Python\Python313


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         5/10/2026  11:42 AM         106208 python.exe


PS C:\Users\Administrator\Desktop>

```
**Step 2.3 — Verify Python executable location**

After install, run:
```sh
py -3.13 -c "import sys; print(sys.executable)"
```
You should get something like:
```sh
C:\Users\Administrator\AppData\Local\Programs\Python\Python313\python.exe
```
**Step 2.4 — Add Python to User PATH (Recommended)**

- Copy and run this in PowerShell:
```sh
[Environment]::SetEnvironmentVariable(
    "Path",
    $env:Path + ";C:\Users\Administrator\AppData\Local\Programs\Python\Python313\;C:\Users\Administrator\AppData\Local\Programs\Python\Python313\Scripts\",
    "User"
)
```
---
<details><summary><b>**Fix PATH manually (if still missing)**</b></summary><br>

**Open environment variables:**
```sh
rundll32 sysdm.cpl,EditEnvironmentVariables
```
Then add these entries under User PATH:
```sh
C:\Users\Administrator\AppData\Local\Programs\Python\Python313\
C:\Users\Administrator\AppData\Local\Programs\Python\Python313\Scripts\
```
</details>

---

**Step 2.5 — Reload PowerShell**

Close PowerShell and open a new one.

Then verify:
```sh
python --version
py -0
pip --version
where.exe python
```
---

### Step 3: install `LiteLLM` on Windows VM

**Step 3.1 — Open PowerShell as Administrator**

```sh
Press:

Start → PowerShell → Right Click → Run as Administrator
```

**Step 3.2 — Fix PowerShell Execution Policy, if required**

Run:
```sh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Press:
Y

Verify: 
Get-ExecutionPolicy -List
```

**Step 3.3 — Install LiteLLM**

*The recommended installation method on Windows is:*

```sh
pip install litellm python-dotenv
# pip install "litellm[proxy]"

# pip install "litellm[proxy]" python-dotenv

# pip install requests boto3
python.exe -m pip install --upgrade pip

pip install "litellm[proxy]"

# Test
python -c "import litellm; print('OK')"


# Verify Version
litellm --version
```
---

### Step 4: Install Claude Code CLI

**Step 4.1 — Install [Claude Code](https://code.claude.com/docs/en/quickstart) using npm:**

**Step 4.1.1 - Open `new Windows PowerShell` as a administrator:**
```bash
npm install -g @anthropic-ai/claude-code
```
> [!NOTE]
> *Be patient as it will take 2- 3 min for installation*

**outcome **
```sh
PS C:\Users\Administrator\Desktop> npm install -g @anthropic-ai/claude-code

added 2 packages in 25s
npm notice
npm notice New minor version of npm available! 11.12.1 -> 11.16.0
npm notice Changelog: https://github.com/npm/cli/releases/tag/v11.16.0
npm notice To update run: npm install -g npm@11.16.0
npm notice

# Verify claude --version
PS C:\Users\Administrator\Desktop> claude --version
2.1.156 (Claude Code)
PS C:\Users\Administrator\Desktop>
```

<details><summary><b>Windows CMD</b></summary><br>

```bash
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

> [!NOTE]
> [Officially Page](https://code.claude.com/docs/en/overview)
> If you see The token '&&' is not a valid statement separator, you’re in PowerShell, not CMD. If you see 'irm' is not recognized as an internal or external command, you’re in CMD, not PowerShell. Your prompt shows PS C:\ when you’re in PowerShell and C:\ without the PS when you’re in CMD.
</details>

---

**Step 4.2 — Verify Claude Code Installation**

```bash
claude --version
```
<img width="930" height="256" alt="Image" src="https://github.com/user-attachments/assets/3e69c734-30ff-4d1f-888c-59e3d67e3019" />

If installed correctly, the version number will be displayed.

---

### Step 5: Install Claude Code VS Code Extension**

1. Open VS Code
2. Go to **Extensions**
3. Search for **Claude Code**
4. Install the official extension
<img width="972" height="836" alt="Image" src="https://github.com/user-attachments/assets/3f22a227-1113-4d11-b89c-f294e89bf2fa" />

---

### Step 6 — Create NVIDIA API Key

**Step 6.1 — To get your API key:**

1. Go to [https://build.nvidia.com](https://build.nvidia.com)
2. Sign up and verify your account with a phone number
3. Click **Generate API Key**
4. Name it something like `claude-code`, set expiry to **Never Expire**
5. Copy and paste the key into `.env`

**Step 6.2 — To get the model name:**

1. On the NVIDIA NIM site, click **Models**
2. Pick a model (e.g. DeepSeek V4 Pro)
3. Click **View Code**
4. Copy the model string shown (e.g. `deepseek-ai/deepseek-v4-0709-pro`)
5. In `.env`, the `nvidia/` prefix is already there — just replace the placeholder portion



### Step 7 — Create Project Folder

- **Windows (cmd)**

```powershell
mkdir Terraform-MCP-demo && cd Terraform-MCP-demo
```
---

### Step 7.1 — Create `config.yaml`

> *we will direct open it vscode then type `code config.yaml`*
>
```yaml
model_list:
  - model_name: "*"
    litellm_params:
      model: nvidia_nim/deepseek-ai/deepseek-v4-flash
      api_base: https://integrate.api.nvidia.com/v1
      api_key: nvapi-YOUR-KEY-HERE

litellm_settings:
  drop_params: true
```

> ⚠️ `drop_params: true` is **critical** — strips Claude-specific parameters NVIDIA rejects.

---

### Step 8 — Configure Claude Code

Windows (PowerShell)

```powershell
mkdir $env:USERPROFILE\.claude
code $env:USERPROFILE\.claude\settings.json
```

Paste:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:4000",
    "ANTHROPIC_AUTH_TOKEN": "any-key-works"
  }
}
```

---

### Step 9 — Verify the setup is working or not.

- Run the python script [nvidia_api_test.py]
- Here's what the script does, mirroring the screenshot exactly:
  
**Set your NVIDIA NIM API key**
```sh
export NVIDIA_API_KEY="nvapi-xxxxxxxxxxxxxxxxxxxx"
```
Get your API key from `build.nvidia.com → sign in → API Key`. Free tier gives you credits to run all 4 tests.

**Run**
```sh
python nvidia_api_test.py
```
<img width="627" height="641" alt="Image" src="https://github.com/user-attachments/assets/f0de9ce7-a7f8-45ff-8e9d-643ee9336fd3" />

<details><summary><b>**4-Tests covered:**</b></summary><br>

**01. API Test Cases**

---
**Test 1 – List Models**

**Purpose:**  
Retrieve all available models from the API.

**What it does:**
- Sends a `GET /v1/models` request.
- Handles paginated responses automatically.
- Retrieves all available models.
- Prints the total number of models returned.

---

**Test 2 – Search for DeepSeek Models**

**Purpose:**  
Identify all models related to DeepSeek.

**What it does:**
- Retrieves the model list from the API.
- Filters models whose names contain `deepseek`.
- Displays all matching DeepSeek models.

---

**Test 3 – Validate Specific Model**

**Purpose:**  
Verify that a specific DeepSeek model exists and inspect its metadata.

**Target Model:**  
`deepseek-ai/deepseek-v4-flash`

**What it does:**
- Searches for the specified model.
- Retrieves the model details.
- Prints the model owner information.

---

**Test 4 – Chat Completion Test**

**Purpose:**  
Verify that the model can successfully process chat completion requests.

**Target Model:**  
`deepseek-ai/deepseek-v4-flash`

**What it does:**
- Sends a live chat completion request.
- Waits for the model response.
- Prints the generated response.
- Confirms end-to-end inference functionality.

---

**Summary**

| Test | Description | Expected Outcome |
|--------|-------------|------------------|
| Test 1 | List all models | Total model count displayed |
| Test 2 | Filter DeepSeek models | Matching models displayed |
| Test 3 | Validate specific model | Owner information displayed |
| Test 4 | Run chat completion | Model response returned successfully |

</details>

---
### Step 10 — Run LiteLLM Proxy It

**Terminal 1 — Start LiteLLM proxy:**
```bash
cd Terraform-MCP-demo
litellm --config config.yaml --port 4000
```
<img width="627" height="641" alt="Image" src="https://github.com/user-attachments/assets/150b7700-dde0-426e-a0ac-a1d466f83304" />

<details><summary><b>If you get error message mentioned here then we need to run command mention here</b></summary><br>

<img width="1112" height="593" alt="Image" src="https://github.com/user-attachments/assets/4afac657-5c07-4718-81d6-4a6f1f8b449b" />

Noticed that I was using python `3.14` and we need to use `python3.13`.
and need to run the blow command
```sh
pip install "litellm[proxy]"
```
</details>

---

**Terminal 2 — Launch Claude Code:**
```bash
cd Terraform-MCP-demo

# Type `claude`
claude
```
Select the default setting and presh `enter` 

<img width="934" height="708" alt="Image" src="https://github.com/user-attachments/assets/dbbf2b1c-de48-4c26-9cca-8cb28ff30a4b" />

presh `enter 3 times` and you will see below

<img width="1248" height="390" alt="Image" src="https://github.com/user-attachments/assets/7a27f53e-1fa9-44dd-950d-47797b692878" />

in Prompt type `/status` and it will show below model and LiteLLM model.

<img width="1248" height="602" alt="Image" src="https://github.com/user-attachments/assets/e0d642a8-ce2b-4e7a-abbb-cf4ce2993744" />

Test prompt:

```sh
Hey, which model you are using
```

Watch Terminal 1 — you'll see requests flowing through to NVIDIA. ✅

<img width="1555" height="665" alt="Image" src="https://github.com/user-attachments/assets/c917cf1d-b3a7-4fcb-8d9a-f74d6205b480" />

---

## How It Works

```
You type a prompt in Claude Code
        ↓
Claude Code sends request (Anthropic format) to localhost:4000
        ↓
LiteLLM strips Claude-specific params, converts to OpenAI format
        ↓
LiteLLM forwards to NVIDIA's API → DeepSeek V4 Flash
        ↓
Response flows back through LiteLLM → Claude Code
        ↓
You see the result in your terminal
```

> No GPU on your machine. Models run on NVIDIA's servers.

---

### Step 11: Install `Go` packages

**Step 11.1 — Verify and install `Go` packages**

Open a new PowerShell as Administrator and verify/install these:

a) Check if Go is installed (needed only if building from source)
```powershell
go version
```
If missing → download from https://go.dev/dl/ (Windows .msi installer). Install and reopen PowerShell.

**Step 11.2 — Get the `terraform-mcp-server` Binary**

<!-- Option A: Download pre-built binary (fastest)
Go to the GitHub releases page:
https://github.com/hashicorp/terraform-mcp-server/releases
Look for a file like terraform-mcp-server_windows_amd64.zip or terraform-mcp-server_windows_amd64.exe. Download and extract it to a permanent location, for example:
C:\tools\terraform-mcp-server\terraform-mcp-server.exe -->

**Step 11.2.1 — Build from source (if no binary release exists for Windows)**

```powershell
# Clone the repo
git clone https://github.com/hashicorp/terraform-mcp-server.git
cd terraform-mcp-server

# Build the Windows binary in a new ternimal
go build -o terraform-mcp-server.exe ./cmd/terraform-mcp-server

# Move to a permanent location
mkdir C:\tools\terraform-mcp-server
Move-Item terraform-mcp-server.exe C:\tools\terraform-mcp-server\
```

**Step 11.3 — Verify the binary runs:**
```powershell
C:\tools\terraform-mcp-server\terraform-mcp-server.exe --version
# or
C:\tools\terraform-mcp-server\terraform-mcp-server.exe --help
```

---

### Step 12:  Configure the MCP Client**

**Step 12.1 —For Claude Code CLI**

Edit `~/.claude.json` (or run ``claude mcp add`):

```json
{
  "mcpServers": {
    "terraform": {
      "command": "C:\\tools\\terraform-mcp-server\\terraform-mcp-server.exe",
      "args": ["stdio"]
    }
  }
}
```
**Or via CLI:**
```powershell
claude mcp add terraform -s user -- "C:\tools\terraform-mcp-server\terraform-mcp-server.exe" stdio
```
**Verify MCP Server:**
```sh
claude mcp list
claude mcp get <terraform> # name of the MCP Server
```
### Step 13: Verify the MCP Server is Loaded

**Step 13.1 — Go to Project actual Directory**

```bash
# Create a new directory for the project or us existing one
cd Terraform-MCP-demo
```

**In Claude Code CLI**
```powershell
# verify the MCP in claude
/mcp
# claude mcp list
```
Should show terraform in the connected servers list.

<img width="1555" height="665" alt="Image" src="https://github.com/user-attachments/assets/0d7c848c-bcbc-437b-8975-f1140d9d41d7" />

**Step 13.2 — Test Against Your Terraform Code**

> [!NOTE]
Navigate to a folder with your Terraform files, then in Claude (Desktop or Code), try prompts like:

```sh
- Validate the Terraform code in the current directory
- Run a terraform plan against my current workspace and summarise what will change
- List all providers used in this Terraform configuration
- Check for any drift in the resources defined here
```

The MCP server runs actual Terraform commands in your working directory and feeds the results back into Claude's context. It's genuinely impressive once you see it in action.

---

## Things That Tripped Me Up (So They Don't Trip You Up)

**The `&&` separator error in PowerShell** — CMD commands don't translate directly. If you're copy-pasting from docs, check which shell you're in. `PS C:\` = PowerShell. `C:\` = CMD.

**Node installed but not found** — Almost always a PATH issue. The machine-level PATH fix in Step 1 solves it 99% of the time. On Windows Server specifically, you often need a full sign-out/reboot for it to take effect.

**uv not found after install** — You need to manually add `~\.local\bin` to PATH in the current session. The installer tells you exactly what to run; don't skip that output.

**Proxy 403 or connection refused errors** — Make sure the uvicorn server (Step 6) is still running in its own terminal. If you closed it, restart it before launching Claude Code.

**MCP not showing in `mcp list`** — Double check the path in `~/.claude.json`. On Windows, backslashes in JSON need to be doubled (`C:\\tools\\...`).

---
## NVIDIA Free Tier — What to Know

| Item | Detail |
|------|--------|
| Cost | $0.00 — completely free |
| Rate limit | 40 requests/minute |
| Models | 150+ available, ~50 free endpoints |
| Top picks | DeepSeek V4 Flash/Pro, Llama 3.3, Nemotron, Qwen |
| Monitor | LiteLLM debug logs |

---

## Troubleshooting

| Error | Fix |
|-------|-----|
| `401 Unauthorized` | Check API key in `config.yaml` |
| `500 Internal Error` | Add `drop_params: true` to config |
| `Connection refused` | LiteLLM not running — check Terminal 1 |
| `Health check 408` | Normal — sensitive endpoint, API still works |

**Enable debug mode for detailed logs:**
```bash
litellm --config config.yaml --port 4000 --debug
```

---

> [!IMPORTANT]
> 
> - **Switch models:** Change `model:` in `config.yaml` to any NVIDIA model
> - **Use `.env` for keys:** Use `os.environ/NVIDIA_API_KEY` in config
> - **Monitor traffic:** Run with `--debug` flag to see every API call
> - **Kill stale Claude config:** `Remove-Item -Recurse -Force "$env:USERPROFILE\.claude"`

---

<!-- ## Why This Works the Way It Works

Claude Code respects two environment variables: `ANTHROPIC_BASE_URL` and `ANTHROPIC_AUTH_TOKEN`. When you override the base URL to point at `localhost:8082`, all API traffic goes to your local proxy instead of Anthropic's servers. The proxy then reformats the request to match NVIDIA NIM's API spec and forwards it to the NIM cloud. The response comes back, gets reformatted again, and Claude Code receives it exactly as if Anthropic had responded.

The `freecc` token is just a dummy value — the proxy doesn't validate it. The real authentication happens between the proxy and NVIDIA NIM using your NIM API key. -->

---

## What This Setup Gives You

- Claude Code with MCP Terraform support running against a capable model
- No monthly subscription required — just stay within NIM's free tier limits
- Full VS Code extension integration
- A foundation you can extend — swap models, add more MCP servers, integrate into pipelines

The NVIDIA NIM free tier is generous enough for day-to-day dev work. If you ever outgrow it, the proxy architecture makes swapping to a paid provider trivial — just update the `.env` and point to a different endpoint.

---

## Final Thought

The most interesting part of this setup isn't the cost saving — it's the architecture lesson. Once you understand that Claude Code is just an API client, and any compatible server can sit behind it, a lot of possibilities open up. Local models via Ollama, OpenRouter, your own fine-tuned endpoints — the pattern is the same.

If this saved you time, share it. Someone else is probably closing that pricing tab right now.

---

## 🔗 Links

[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=for-the-badge&logo=github)](https://github.com/mrbalraj007)
[![NVIDIA Build](https://img.shields.io/badge/NVIDIA-Free%20API-76b900?style=for-the-badge&logo=nvidia)](https://build.nvidia.com)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Docs-orange?style=for-the-badge)](https://docs.claude.com/en/docs/claude-code)
[![LiteLLM](https://img.shields.io/badge/LiteLLM-Docs-purple?style=for-the-badge)](https://docs.litellm.ai)

## 📺 Watch the Full Video

[![YouTube](https://img.shields.io/badge/YouTube-Watch%20Now-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=5_cZCmrlcow)








<!-- 

### Phase 4: OpenRouter API Configuration

**Connect Claude to OpenRouter**

Instead of logging in with Anthropic directly, connect `Claude Code` to `OpenRouter`. This requires setting a few environment variables.

#### Step 4.1: Create OpenRouter Account

1. Navigate to https://openrouter.ai
2. Click "Sign Up"
3. Complete registration (email/password or OAuth)
4. Verify email address
5. Accept terms and conditions

#### Step 4.2: Generate API Key

1. Log in to OpenRouter dashboard
2. Click your profile icon (top-right corner)
3. Select "Keys" from dropdown menu
4. Click "Create New Key" button
5. Copy the generated API key (appears only once—save securely)

<img width="1706" height="807" alt="Image" src="https://github.com/user-attachments/assets/5442f231-e49a-4837-8420-4da82d1b2d12" />

**Security Note:** Never commit API keys to version control. Always use environment variables.

#### Step 4.3: Find Free Model in OpenRouter

We need to find a free model in `Openrouter` and select the model which suite you.

<img width="1706" height="807" alt="Image" src="https://github.com/user-attachments/assets/cc57ac0a-9d35-426f-bc40-65e740e140a0" />


#### Step 4.4: Configure `settings.json`

1. Edit `settings.json` as per following path and add the following configuration.
```sh
C:\Users\<YourComputerName>\.claude\settings.json
```
Edit in `setting.json` and save it.

```sh
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
    "ANTHROPIC_AUTH_TOKEN": "sk-or-v1-YOUR_API_KEY_HERE",  # Type your OpenRouter Token Value
    "ANTHROPIC_API_KEY": "",
    "ANTHROPIC_MODEL": "nvidia/nemotron-3-super-120b-a12b:free"  # Here you need to type your actual Model Name
  },
  "effortLevel": "high",
  "theme": "dark"
}
```

**Go to your project**
```sh
PS C:\Users\Administrator\Desktop\claude-code-free-setup> pwd

Path
----
C:\Users\Administrator\Desktop\claude-code-free-setup
```

**Open your terminal and type `claude` and it will not ask you for subscription.**
```shell
PS C:\Users\Administrator\Desktop\claude-code-free-setup> claude
```
<img width="1706" height="807" alt="Image" src="https://github.com/user-attachments/assets/51b299ac-41b0-4f6a-bba5-c80bd5d9b7b0" />


#### Step 4.5: Create Environment Configuration File (Optional)

In your project root, create `.env` file:

```env
OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE
OPENROUTER_BASE_URL=https://openrouter.ai/api/v1
CLAUDE_MODEL=claude-3-5-sonnet-20241022
```

*Project Settings File*

Alternatively, you can configure Claude Code using a project-level settings file at .claude/settings.local.json in your project root:

```bash
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
    "ANTHROPIC_AUTH_TOKEN": "<your-openrouter-api-key>",
    "ANTHROPIC_API_KEY": ""
  }
}
```
Replace <your-openrouter-api-key> with your actual OpenRouter API key.

Create `.gitignore` to prevent accidental commit:

```gitignore
.env
node_modules/
*.log
.DS_Store
```

### Phase 5: Monitor Token Usage

Track OpenRouter dashboard usage:
- Navigate to https://openrouter.ai
- Check "Usage" page to see API calls and token consumption
- Monitor costs (typically $0.003-$0.015 per 1K tokens depending on model)

<img width="1710" height="708" alt="Image" src="https://github.com/user-attachments/assets/52e77c87-eb4e-49ad-8801-d7b1c2883603" />

---

## Challenges Addressed

### Challenge 1: API Key Security

**Problem:** Hardcoding API keys in source files poses security risks, especially if code is shared or pushed to repositories.

**Solution Implemented:**
- Environment variables via `.env` file
- `.gitignore` prevents accidental commits
- Key rotation support in OpenRouter dashboard
- Never log API keys in console or logs

```javascript
// ❌ WRONG
const apiKey = "sk-or-v1-abc123...";

// ✅ CORRECT
const apiKey = process.env.OPENROUTER_API_KEY;
```

### Challenge 2: Rate Limiting & Quota Management

**Problem:** Unexpected API rate limits could interrupt development workflows.

**Solution Implemented:**
- OpenRouter provides free tier with reasonable limits
- Monitor usage dashboard in real-time
- Implement request queueing for batch operations
- Add exponential backoff retry logic


### Challenge 3: Model Version Compatibility

**Problem:** OpenRouter continuously updates Claude models; older versions may become deprecated.

**Solution Implemented:**
- Use environment variable for model selection (easy to update)
- Check OpenRouter documentation for latest available models
- Test compatibility before production deployment

```bash
# Easy model switching
CLAUDE_MODEL=claude-3-5-sonnet-20241022  # Current
# or
CLAUDE_MODEL=claude-3-opus-20240229       # Alternative
```

### Challenge 4: Error Handling & Debugging

**Problem:** Opaque API errors make troubleshooting difficult.

**Solution Implemented:**
- Structured error responses
- Detailed logging for development
- Validation of API response format


### Challenge 5: Token Cost Optimization

**Problem:** Large prompts consume tokens, increasing API costs.

**Solution Implemented:**
- Prompt engineering to reduce token count
- Request batching where possible
- Temperature adjustment (lower = faster, more predictable responses)
- Token usage monitoring per request

| Strategy | Impact | Implementation |
|----------|--------|-----------------|
| Prompt compression | ↓ 20-30% tokens | Remove verbose descriptions |
| Model selection | ↓ 15-25% cost | Use faster models for simple tasks |
| Caching responses | ↓ 50%+ API calls | Store similar request results |
| Batch processing | ↓ 10-15% overhead | Group multiple requests |

---

## Project Benefits

### 1. **Cost Efficiency** 💰

| Scenario | Traditional Claude Code | This Solution |
|----------|------------------------|---------------|
| Light User (10-20 requests/day) | $200/month | ~$5-15/month |
| Regular Developer (50-100 requests/day) | $200/month | ~$20-50/month |
| Power User (500+ requests/day) | $200/month | ~$80-150/month |

**Savings:** Up to 90% for occasional users, 25-60% for regular users.

### 2. **Flexibility & Portability**

- **No vendor lock-in:** Switch between Claude, Mistral, Llama, or other models on OpenRouter
- **Easy migration:** Change providers without rewriting code
- **Multiple deployment options:** Local development, Docker containers, cloud functions
- **Team sharing:** Single API key covers entire team/organization

### 3. **Educational & Development Value**

- **Learn API integration:** Understand how modern AI services work at the protocol level
- **Customization capabilities:** Fine-tune prompts and parameters for specific use cases
- **Transparency:** See exact token consumption and costs per request
- **Skill building:** Gain knowledge applicable to other AI/ML integrations

### 4. **Enterprise Scalability**

- **Pay-per-use model:** Costs scale with actual usage, not fixed overhead
- **Team collaboration:** Shared API key enables multiple developers
- **Usage analytics:** Track token consumption by feature/user
- **Batch processing:** Optimize large-scale code generation tasks

### 5. **Operational Independence**

- **No subscription renewal headaches:** Stop API calls, stop paying
- **Audit trails:** Complete logging of all API interactions
- **Compliance ready:** Environment variables allow easy credential rotation
- **Offline capabilities:** Cache responses locally for offline reference

### 6. **Technical Excellence**

- **Real-time debugging:** Direct access to error messages and response codes
- **Customizable behavior:** Adjust temperature, max_tokens, and other parameters
- **Integration ready:** Works with CI/CD pipelines, automation, webhooks
- **Monitoring capability:** Track performance metrics and optimization opportunities

---

## Conclusion

### Project Summary

This implementation successfully demonstrates that premium AI coding capabilities—traditionally locked behind $200/month subscriptions—are accessible through intelligent API routing and open infrastructure. By leveraging OpenRouter as an API gateway and Node.js as the execution environment, developers gain:

1. **Financial Freedom:** 70-90% cost reduction for most usage patterns
2. **Technical Control:** Direct API access with full customization
3. **Operational Flexibility:** Easy switching between models and providers
4. **Enterprise Ready:** Scalable, auditable, and compliance-friendly

### Real-World Applications

This setup is production-ready for:

- **Code Generation:** Automated scaffolding of boilerplate code
- **Documentation:** Generate comprehensive API docs and README files
- **Bug Fixing:** AI-assisted debugging and optimization suggestions
- **Learning Platform:** Build educational tools with AI tutoring capabilities
- **Enterprise Automation:** Batch processing and CI/CD integration
- **Consulting Services:** Offer AI-powered code review as a service

### Next Steps & Recommendations

1. **Immediate:** Set up free OpenRouter account and test with provided scripts
2. **Short-term:** Integrate into your development workflow (IDE extensions)
3. **Medium-term:** Build custom wrappers for your specific use cases
4. **Long-term:** Consider moving to self-hosted solutions (Ollama, LocalAI) for ultimate cost control

### Sustainability & Long-Term Viability

This approach remains viable because:
- **OpenRouter is stable infrastructure** with years of operation
- **Multiple model providers** prevent vendor lock-in
- **Open standards** (REST API) ensure portability
- **Community support** means continuous improvements and tutorials

### Final Thoughts

The democratization of AI tools represents a fundamental shift in software development. What was previously accessible only to well-funded teams is now available to individual developers and small organizations. This project is not just about saving money—it's about empowerment, accessibility, and leveling the playing field in the AI-driven economy. -->

---
<!-- 
## Additional Resources

### YouTube
  - [Use Claude Code FREE with Ollama ](https://www.youtube.com/watch?v=6IW6F_y_EQE&list=PLJcpyd04zn7pg7uc0N5LgwRasQvjPLVVb&index=21
  )

### Official Documentation
- OpenRouter API Docs: https://openrouter.ai/docs
- Node.js Documentation: https://nodejs.org/docs
- Claude Model Information: https://openrouter.ai/docs/models
- 👉 Try Claude Code here: https://claude.com/product/claude-code
- 👉 Try NodeJS here: https://nodejs.org/en
- 👉 Try OpenRouter here: https://openrouter.ai
- 👉 OpenRouter Claude Code Doc: https://openrouter.ai/docs/guides/coding-agents/claude-code-integration


### Community & Support
- OpenRouter Discord: https://openrouter.ai/discord
- Stack Overflow Tag: `openrouter`
- GitHub Issues: Report bugs on project repository

### Related Tools & Services
- **Local Alternatives:** Ollama, LocalAI (self-hosted)
- **Other API Providers:** Together AI, Replicate, Hugging Face
- **IDE Integrations:** VS Code extensions, JetBrains plugins



 -->
