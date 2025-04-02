# CrewAI Setup Guide

## Installation Steps

### 1. Install Python
Ensure you have Python installed on your system. You can download it from [Python's official website](https://www.python.org/downloads/).

### 2. Create a Project Folder
```bash
mkdir Crew-example
cd Crew-example
```

### 3. Create and Activate a Virtual Environment
#### Windows (Command Prompt):
```cmd
python -m venv venv
venv\Scripts\activate
```

#### Windows (PowerShell):
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

#### macOS/Linux (Bash):
```bash
python3 -m venv venv
source venv/bin/activate
```

Ensure you are in the correct directory where the `venv` folder is located before activating.

### 4. Install CrewAI
```bash
pip install crewai
```

### 5. Create a New CrewAI Project
```bash
crewai create crew devops-ai-project
```
This command generates all the required files for your project.

### 6. Select a Provider
CrewAI supports multiple providers:
- **Ollama:** If you use Ollama, ensure the required model is downloaded.
- **Gemini:** If you use Gemini, you do not need to download a model; just provide your API key.

### 7. Modify the Project Files
Navigate to the newly created folder:
```bash
cd devops-ai-project
```
Modify the `main.py` file according to your needs. For example, to set the topic to Kubernetes:
```python
# In main.py
TOPIC = "Kubernetes"
```
You can also customize the `.yaml` files.

### 8. Install Dependencies
```bash
crewai install
```

### 9. Run CrewAI
```bash
crewai run
```

### 10. View Generated Report
After execution, a `report.md` file will be generated with the results.

---

## Troubleshooting
- Ensure you are inside the virtual environment before running CrewAI commands.
- If you face issues with API keys, verify them in your environment variables.
- If using Ollama, make sure the required models are downloaded and available.



