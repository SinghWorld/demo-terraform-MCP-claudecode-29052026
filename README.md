# Claude Code + NVIDIA NIM + Terraform MCP: A Full Stack AI Dev Setup
<!-- # Free Claude Code Setup: Complete Technical Implementation Guide -->

<img width="1389" height="863" alt="Image" src="https://github.com/user-attachments/assets/57b05e52-10b6-4b1f-aa6b-5da7d8ec9cd1" />

### I've Been Using Claude Code for Free — Here's the Exact Setup Nobody Talks About

> You can run Claude Code against NVIDIA's free NIM API (powered by DeepSeek V4 Pro) through a local proxy — with full MCP Terraform server support. This guide walks through every step, every error I hit, and exactly how I fixed them.

---

I'll be honest with you. When I first saw the Claude Code pricing, I closed the tab.

Not because I didn't want it. I *really* wanted it. But paying a subscription just to try it out felt like buying concert tickets before listening to the album. So I started digging.

Turns out, there's a clean, legitimate way to use Claude Code against NVIDIA's NIM API endpoint — which gives you access to powerful models like DeepSeek V4 Pro, completely free (with API limits). You run a lightweight local proxy on your machine, point Claude Code at it, and it works exactly as advertised.

This is the guide I wish I had when I started.

---
## **Tech stack involved:**
- `Node.js` — Claude Code CLI runtime requirement - [Download Link](https://nodejs.org/en/download)
- `npm` — Package manager for the install - [Download Link](https://nodejs.org/en/download)
- `uv` — Fast Python package/environment manager (from Astral)
- `Python 3.14` — Proxy server runtime
- `Go` — Required to build the Terraform MCP server binary
- `Git` — Clone the proxy repo - [Download Link](https://git-scm.com/install/windows)   
- `Terraform` — For the MCP integration - [Download Link](https://developer.hashicorp.com/terraform/install)
- `NVIDIA NIM API` — The free model endpoint - [Download Link](https://build.nvidia.com/)
- `DeepSeek V4 Pro` — The model doing the actual work
- `uvicorn` — ASGI server that runs the local proxy
- `AWS CLI` - AWS configuration - [Download Link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)  

Let's go.

## Step-by-Step Implementation

### Environment Setup


#### Step 1: Verify `Node.js` Installation

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

#### Step 2: install UV on Windows VM

**Step 2.1 — Open PowerShell as Administrator**

```sh
Press:

Start → PowerShell → Right Click → Run as Administrator
```

**Step 2.2 — Fix PowerShell Execution Policy, if required**

Run:
```sh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Press:
Y

Verify: 
Get-ExecutionPolicy -List
```

**Step 2.3 — Install uv**
*The recommended installation method on Windows is:*
```sh
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```
**Outcome**
```sh
PS C:\> powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
downloading uv 0.11.16 (x86_64-pc-windows-msvc)
installing to C:\Users\Administrator\.local\bin
  uv.exe
  uvx.exe
  uvw.exe
everything's installed!

To add C:\Users\Administrator\.local\bin to your PATH, either restart your shell or run:

    set Path=C:\Users\Administrator\.local\bin;%Path%   (cmd)
    $env:Path = "C:\Users\Administrator\.local\bin;$env:Path"   (powershell)
PS C:\>
```

**Step 2.4 — Set the path to environment**
```sh
$env:Path = "C:\Users\Administrator\.local\bin;$env:Path"
```

After installation, close PowerShell completely and reopen it.

**Step 2.5 — Verify uv Installation**

Run:
```sh
uv --version
```
You should see something like:
```sh
uv 0.x.x
```

**Step 2.6 — Install Python 3.14 Using uv**

Run:
```sh
uv python install 3.14
```

This downloads and installs Python 3.14 automatically.

**Step 2.7 — Verify Python Installation**

List installed Python versions:
```sh
uv python list
```

You should see Python 3.14 in the list.

**Step 2.8 — Use Python 3.14**

Run Python directly:
```sh
uv run --python 3.14 python --version
```
Expected:
```sh
Python 3.14.x
```

**Step 2.9 — Create a Virtual Environment (Recommended)**

Go to your project and create virtual environment
```sh
cd:\projectname
mkdir test_demo
cd  test_demo
```

**Create venv:**
```sh
uv venv --python 3.14
```

**Activate it:**
```sh
.venv\Scripts\activate
```

Verify:
```sh
python --version
```

**Step 2.10 — Install Packages**

Example:
```sh
uv pip install requests boto3
```

---

<details><summary><b>Common Troubleshooting, If uv command is not found</b></summary><br>

Check:
```sh
$env:Path
```
You should see:
```sh
C:\Users\<USERNAME>\.local\bin
```
If not, temporarily add it:
```sh
$env:Path += ";$HOME\.local\bin"
```
Then retry:
```sh
uv --version
```
</details>

---

### Step 3: Install Claude Code CLI

**Step 3.1 — Install [Claude Code](https://code.claude.com/docs/en/quickstart) using powershell:**

**Step 3.1.1 - Open `new Windows PowerShell` as a administrator:**
```bash
irm https://claude.ai/install.ps1 | iex
```
> [!NOTE]
> *Be patient as it will take 2- 3 min for installation*


<img width="1115" height="456" alt="Image" src="https://github.com/user-attachments/assets/bf836ba0-c201-48a8-b92c-4d74068426db" />

<details><summary><b>Windows CMD</b></summary><br>

```bash
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

> [!NOTE]
> [Officially Page](https://code.claude.com/docs/en/overview)
> If you see The token '&&' is not a valid statement separator, you’re in PowerShell, not CMD. If you see 'irm' is not recognized as an internal or external command, you’re in CMD, not PowerShell. Your prompt shows PS C:\ when you’re in PowerShell and C:\ without the PS when you’re in CMD.
</details>

---

**Step 3.2 — Add to System PATH (all users)**
```bash
$path = [Environment]::GetEnvironmentVariable("Path", "Machine")
$newPath = "$path;C:\Users\Administrator\.local\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
```

> [!IMPORTANT] 
> *Close and reopen your terminal to make it effective*

**Step 3.3 — Verify Claude Code Installation**

```bash
claude --version
```
<img width="930" height="256" alt="Image" src="https://github.com/user-attachments/assets/3e69c734-30ff-4d1f-888c-59e3d67e3019" />

If installed correctly, the version number will be displayed.

---

### Step 4: Install Claude Code VS Code Extension**

1. Open VS Code
2. Go to **Extensions**
3. Search for **Claude Code**
4. Install the official extension
<img width="972" height="836" alt="Image" src="https://github.com/user-attachments/assets/3f22a227-1113-4d11-b89c-f294e89bf2fa" />

---

### Step 5 — Download the NVIDIA NIM Proxy Folder

**Step 5.1 — download NVIDIA NIM Proxy from GitHub**
```bash
sudo apt install git -y # install git in case if it is not installed.

git clone https://github.com/Alishahryar1/free-claude-code.git nvidia-nim

cd nvidia-nim
```

> 💡 The exact clone URL is available on [compilefuture.com](https://compilefuture.com/blog/how-to-use-claude-code-free-unlimited/) — the reference site for this video series.

**Step 5.2 — Create Your `.env` File**

```bash
# macOS / Linux
cp .env.example .env
```

**Step 5.3 — Configure Your API Key and Model**

Open the `.env` file in VS Code or any text editor:

```bash
code .       # Opens in VS Code
```

Inside `.env`, you'll see two fields to fill in:

```env
NVIDIA_NIM_API_KEY=your_api_key_here
NVIDIA_NIM_MODEL=nvidia/deepseek-v4-0709-pro

# You will see like below
MODEL="nvidia_nim/deepseek-ai/deepseek-v4-pro"
```

> [!NOTE]
> **To replace your model using command:**
> 
> *sed -i 's|MODEL="nvidia_nim/nvidia/nemotron-3-super-120b-a12b"|MODEL="nvidia_nim/deepseek-ai/deepseek-v4-pro"|' .env*


**Step 5.4 — To get your API key:**

1. Go to [https://build.nvidia.com](https://build.nvidia.com)
2. Sign up and verify your account with a phone number
3. Click **Generate API Key**
4. Name it something like `claude-code`, set expiry to **Never Expire**
5. Copy and paste the key into `.env`

**Step 5.5 — To get the model name:**

1. On the NVIDIA NIM site, click **Models**
2. Pick a model (e.g. DeepSeek V4 Pro)
3. Click **View Code**
4. Copy the model string shown (e.g. `deepseek-ai/deepseek-v4-0709-pro`)
5. In `.env`, the `nvidia/` prefix is already there — just replace the placeholder portion

### Step 6: Start the NVIDIA NIM Proxy Server

```bash
# From inside the nvidia-nim directory

uv run uvicorn server:app --host 0.0.0.0 --port 8082

# presh allow for Python popup window

# uv run main.py
```
You'll see package downloads on the first run, then the local API server starts. **Keep this terminal window open** — Claude Code needs it running in the background.

> [!NOTE]
> *You always have to keep running this API Server in the background to use Nvida Nim with Claude Code*.

<img width="619" height="243" alt="Image" src="https://github.com/user-attachments/assets/26557fee-a6c9-463b-af2d-9b68f38a0db1" />

<!-- ### Step 7 — Install Claude Code

Open a **new** terminal window and run:

```bash
# npm install -g @anthropic-ai/claude-code
curl -fsSL https://claude.ai/install.sh | bash
```

Restart your terminal once after installation.

<img width="658" height="297" alt="Image" src="https://github.com/user-attachments/assets/a8c27a24-e29b-46f9-ba86-b3585ab0ab3f" />
 -->

---

### Step 7: Install `Go` packages

**Step 7.1 — Verify and install `Go` packages**

Open a new PowerShell as Administrator and verify/install these:

a) Check if Go is installed (needed only if building from source)
```powershell
go version
```
If missing → download from https://go.dev/dl/ (Windows .msi installer). Install and reopen PowerShell.

**Step 7.2 — Get the `terraform-mcp-server` Binary**

<!-- Option A: Download pre-built binary (fastest)
Go to the GitHub releases page:
https://github.com/hashicorp/terraform-mcp-server/releases
Look for a file like terraform-mcp-server_windows_amd64.zip or terraform-mcp-server_windows_amd64.exe. Download and extract it to a permanent location, for example:
C:\tools\terraform-mcp-server\terraform-mcp-server.exe -->

**Step 7.2.1 — Build from source (if no binary release exists for Windows)**

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

**Step 7.3 — Verify the binary runs:**
```powershell
C:\tools\terraform-mcp-server\terraform-mcp-server.exe --version
# or
C:\tools\terraform-mcp-server\terraform-mcp-server.exe --help
```

---

### Step 8:  Configure the MCP Client**

**Step 8.1 —For Claude Code CLI**

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
claude mcp get terraform # name of the MCP Server
```
<!-- **Step 8.2 — Restart the MCP Client**
- Claude Code CLI: No restart needed; config is read fresh each session. -->

---

### Step 9:   — Launch Claude Code (Pointed at NVIDIA NIM)

Navigate to your project folder, then run the startup command (it sets the `ANTHROPIC_BASE_URL` and `ANTHROPIC_API_KEY` environment variables before invoking `claude`):

> [!CAUTION] 
> ANTHROPIC_AUTH_TOKEN="freecc" ANTHROPIC_BASE_URL="http://localhost:8082" claude

```bash
cd ~/your-project-folder

# The exact command sets env vars for the NIM endpoint — copy from compilefuture.com

# ANTHROPIC_BASE_URL=http://localhost:<port> ANTHROPIC_API_KEY=dummy claude

ANTHROPIC_AUTH_TOKEN="freecc" ANTHROPIC_BASE_URL="http://localhost:8082" claude
```

Choose **Dark Mode** when prompted, then press Enter. Claude Code will start up and connect to the local NIM proxy.

**Verify the connection:**

```
/status
```

You should see the localhost URL confirming the NIM endpoint is active.

<img width="904" height="606" alt="Image" src="https://github.com/user-attachments/assets/0656bf34-5428-415c-9e9a-3ffd0271de8a" />



### Step 10: Verify the MCP Server is Loaded

**Step 10.1 — Create Project Directory**

```bash
# Create a new directory for the project
mkdir Terraform_Demo
cd Terraform_Demo

# Initialize npm project
# npm init -y
```

**In Claude Code CLI**
```powershell
claude mcp list
```
Should show terraform in the connected servers list.

**Step 10.2 — Test Against Your Terraform Code**

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

## Full Setup Recap

| Step | What You're Doing | Tool |
|------|-------------------|------|
| 1 | Install Node.js runtime | `choco` / installer |
| 2 | Install Python env manager | `uv` |
| 3 | Install Claude Code CLI | `curl` / `irm` |
| 4 | Install VS Code extension | VS Code Marketplace |
| 5 | Clone & configure NIM proxy | `git`, `.env` |
| 6 | Start the local proxy server | `uvicorn` |
| 7 | Build Terraform MCP binary | `go build` |
| 8 | Register MCP with Claude Code | `~/.claude.json` |
| 9 | Launch Claude Code → NIM | env vars + `claude` |
| 10 | Verify Terraform MCP works | `mcp list` + test prompts |

---
## Things That Tripped Me Up (So They Don't Trip You Up)

**The `&&` separator error in PowerShell** — CMD commands don't translate directly. If you're copy-pasting from docs, check which shell you're in. `PS C:\` = PowerShell. `C:\` = CMD.

**Node installed but not found** — Almost always a PATH issue. The machine-level PATH fix in Step 1 solves it 99% of the time. On Windows Server specifically, you often need a full sign-out/reboot for it to take effect.

**uv not found after install** — You need to manually add `~\.local\bin` to PATH in the current session. The installer tells you exactly what to run; don't skip that output.

**Proxy 403 or connection refused errors** — Make sure the uvicorn server (Step 6) is still running in its own terminal. If you closed it, restart it before launching Claude Code.

**MCP not showing in `mcp list`** — Double check the path in `~/.claude.json`. On Windows, backslashes in JSON need to be doubled (`C:\\tools\\...`).

---

## Why This Works the Way It Works

Claude Code respects two environment variables: `ANTHROPIC_BASE_URL` and `ANTHROPIC_AUTH_TOKEN`. When you override the base URL to point at `localhost:8082`, all API traffic goes to your local proxy instead of Anthropic's servers. The proxy then reformats the request to match NVIDIA NIM's API spec and forwards it to the NIM cloud. The response comes back, gets reformatted again, and Claude Code receives it exactly as if Anthropic had responded.

The `freecc` token is just a dummy value — the proxy doesn't validate it. The real authentication happens between the proxy and NVIDIA NIM using your NIM API key.

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
