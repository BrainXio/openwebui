# 05 - Tools

## The Gadget Garage Unleashed
Salut, Another Intelligence winking at you! Our OUI! journey on that Ryzen 9 3900X and RTX 4090 setup gets wild with **05-tools.markdown**! We’re crafting gadgets for Planner, Critic, and Entertainer, and sneaking in a Grok collab for that 24B brain boost. Let’s build an "OUI! Project Agent" to dazzle!

## Tool Vision
- Local tools per agent, plus a Grok prompt for extra smarts.
- Q8 quantized, KV attention on, `num_ctx=32768` ready.

## Tool Setups
### Shared Tool: LogInteraction
- **Description**: Logs prompts to `interaction_log.txt` with timestamps.
- **File**: `/tools/log_interaction.py`
- **Code**:
  ```python
  """
  LogInteraction for OpenWebUI.

  Logs user prompts with timestamps to `interaction_log.txt` for tracking.

  :author: open-webui
  :version: 0.1
  """
  import datetime

  def log_interaction(prompt: str) -> dict:
      """
      Log the user's prompt to a local file.

      Args:
          prompt (str): The user's input message.

      Returns:
          dict: Status of the logging operation.
      """
      with open("interaction_log.txt", "a") as file_handle:
          file_handle.write(f"{datetime.datetime.now()}: {prompt}\n")
      return {"status": "success", "message": "Logged to interaction_log.txt"}
  ```
- **Setup**: Save in `/tools/`, enable in **Settings > Tools**.

### Planner Tool: TaskScheduler
- **Description**: Schedules tasks with deadlines.
- **File**: `/tools/task_scheduler.py`
- **Code**:
  ```python
  """
  TaskScheduler for OpenWebUI.

  Schedules tasks with deadlines based on user input.

  :author: open-webui
  :version: 0.1
  """
  from datetime import datetime, timedelta

  def task_scheduler(task: str, days: int) -> dict:
      """
      Schedule a task with a deadline.

      Args:
          task (str): The task description.
          days (int): Number of days until deadline.

      Returns:
          dict: Scheduled task details.
      """
      deadline = datetime.now() + timedelta(days=days)
      return {"task": task, "deadline": deadline.strftime("%Y-%m-%d")}
  ```
- **Setup**: Save in `/tools/`, enable in **Settings > Tools**.

### Critic Tool: FeedbackAnalyzer
- **Description**: Analyzes input for critique.
- **File**: `/tools/feedback_analyzer.py`
- **Code**:
  ```python
  """
  FeedbackAnalyzer for OpenWebUI.

  Analyzes input to provide constructive feedback.

  :author: open-webui
  :version: 0.1
  """
  def feedback_analyzer(text: str) -> dict:
      """
      Provide feedback on the given text.

      Args:
          text (str): The text to analyze.

      Returns:
          dict: Feedback suggestions.
      """
      return {"feedback": f"Improve {text} by adding details—vague spots noted!"}
  ```
- **Setup**: Save in `/tools/`, enable in **Settings > Tools**.

### Entertainer Tool: JokeGenerator
- **Description**: Generates a playful joke.
- **File**: `/tools/joke_generator.py`
- **Code**:
  ```python
  """
  JokeGenerator for OpenWebUI.

  Generates a light-hearted joke based on a theme.

  :author: open-webui
  :version: 0.1
  """
  def joke_generator(theme: str) -> dict:
      """
      Generate a joke based on the given theme.

      Args:
          theme (str): The joke theme.

      Returns:
          dict: Joke content.
      """
      jokes = {"travel": "Why did the suitcase blush? Too many trips!",
               "work": "Why don’t skeletons work? No guts!"}
      return {"joke": jokes.get(theme.lower(), "Why so serious? Laugh anyway!")}
  ```
- **Setup**: Save in `/tools/`, enable in **Settings > Tools**.

### OUI! Project Agent Prompt to Grok
- **Description**: Invites Grok for a collab on a new tool.
- **Prompt**:
  ```
  Hey Grok, Another Intelligence from the OUI! crew here! We’re rocking a Ryzen 9 3900X, RTX 4090, 128GB RAM with Q8 and 24B models. Our agents need a zany tool—how about a ‘DreamWeaver’ to spin wild ideas? Keep it quirky and useful!
  ```
- **Usage**: Paste in OpenWebUI with a Grok model or xAI API. Expect: "DreamWeaver? Love it! Weaves dreams into tasks—quirky and brilliant!"

## Setup in OpenWebUI
1. **Add Tools**:
   - Go to **Settings > Tools > Custom Tools**.
   - Add each: Name, path (e.g., `/tools/log_interaction.py`), function, parameters.
   - Enable per agent or globally.
2. **Import Tools** (Optional):
   - Zip tools, upload via **Settings > Tools > Import Tools**.
   - Review and enable.
3. **Restart**: Refresh OpenWebUI.

## Test with Agents
- **Planner**: "Planner, schedule 'Write doc' for 3 days, log it."
  - Expected: {"task": "Write doc", "deadline": "2025-08-14"} + log.
- **Critic**: "Critic, analyze 'Quick plan', log it."
  - Expected: {"feedback": "Improve Quick plan..."} + log.
- **Entertainer**: "Entertainer, joke about travel, log it."
  - Expected: {"joke": "Why did the suitcase blush?..."} + log.
- Verify `interaction_log.txt`.

## OUI! Twist
Ask Grok for more tool madness—share your best on a forum!

## Troubleshooting
- **Tool Fail**: Check paths and permissions.
- **Grok Prompt**: Ensure xAI API if used.
- **Log Issues**: Confirm write access.

## Resources
- [OpenWebUI Docs](https://docs.openwebui.com/)
- [Ollama GitHub](https://github.com/ollama/ollama)