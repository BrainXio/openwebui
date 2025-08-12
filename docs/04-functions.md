# 04 - Functions

## The Magic Touch
Salut, Another Intelligence popping in! Our OUI! agents on that Ryzen 9 3900X and RTX 4090 setup need wizardry. We’re adding **TurnLimitFilter**, **ResponseFormatter**, and **PromptLogger** to handle those 24B brains. Let’s learn the GUI and import tricks—double the fun!

## Function Setups
### TurnLimitFilter
- **Description**: Caps turns (max 8 globally, 4 per user).
- **File**: `/filters/turn_limit_filter.py`
- **Code**:
  ```python
  """
  TurnLimitFilter for OpenWebUI.

  Limits turns to manage resources. Sets global max 8, user max 4, adjustable.

  :author: open-webui
  :author_url: https://github.com/open-webui
  :funding_url: https://github.com/open-webui
  :version: 0.1
  """
  from pydantic import BaseModel, Field
  from typing import Optional

  class Filter:
      """Filter to enforce turn limits."""

      class Valves(BaseModel):
          """Global turn settings."""
          priority: int = Field(default=0, description="Filter priority.")
          max_turns: int = Field(default=8, description="Global max turns.")

      class UserValves(BaseModel):
          """User turn settings."""
          max_turns: int = Field(default=4, description="User max turns.")

      def __init__(self):
          """Init with default valves."""
          self.valves = self.Valves()

      def inlet(self, body: dict, user: Optional[dict] = None) -> dict:
          """
          Check turn limits.

          Args:
              body (dict): Request with messages.
              user (Optional[dict]): User data.

          Returns:
              dict: Processed body or raises exception.

          Raises:
              Exception: If turns exceed limit.
          """
          print(f"inlet:body:{body}")
          if user and user.get("role", "admin") in ["user", "admin"]:
              messages = body.get("messages", [])
              max_turns = min(user.get("valves", {}).get("max_turns",
                                                        self.valves.max_turns),
                              self.valves.max_turns)
              if len(messages) > max_turns:
                  raise Exception(f"Turn limit exceeded. Max: {max_turns}")
          return body

      def outlet(self, body: dict, user: Optional[dict] = None) -> dict:
          """
          Log post-processing.

          Args:
              body (dict): Response body.
              user (Optional[dict]): User data.

          Returns:
              dict: Unchanged body.
          """
          print(f"outlet:body:{body}")
          return body
  ```
- **Setup**:
  - **Manual GUI**:
    1. Save as `/filters/turn_limit_filter.py`.
    2. Go to **Settings > Filters > Create Filter**, name "TurnLimitFilter".
    3. Paste code, set Valves/UserValves, save, enable.
  - **Import**:
    1. Save as `/filters/turn_limit_filter.py`.
    2. Go to **Settings > Filters > Import Filter**, upload, enable.
  - Restart OpenWebUI.

### ResponseFormatter
- **Description**: Formats responses into JSON with tone.
- **File**: `/filters/response_formatter.py`
- **Code**:
  ```python
  """
  ResponseFormatter for OpenWebUI.

  Formats responses into JSON with tone and content.

  :author: open-webui
  :author_url: https://github.com/open-webui
  :funding_url: https://github.com/open-webui
  :version: 0.1
  """
  from pydantic import BaseModel
  from typing import Optional

  class Pipe:
      """Pipe to format responses."""

      def __init__(self):
          """Init with no settings."""
          pass

      def inlet(self, body: dict, user: Optional[dict] = None) -> dict:
          """
          Pass through request.

          Args:
              body (dict): Incoming request.
              user (Optional[dict]): User data.

          Returns:
              dict: Unchanged body.
          """
          return body

      def outlet(self, body: dict, user: Optional[dict] = None) -> dict:
          """
          Format response with tone.

          Args:
              body (dict): Response body.
              user (Optional[dict]): User data.

          Returns:
              dict: Formatted response.
          """
          response = body.get("choices", [{}])[0].get("message", {}).get(
              "content", "")
          tone = "supportive" if "Planner" in body.get("model", "") else (
              "analytical" if "Critic" in body.get("model", "") else "engaging")
          body["choices"][0]["message"]["content"] = {
              "tone": tone,
              "content": response
          }
          return body
  ```
- **Setup**:
  - **Manual GUI**:
    1. Save as `/filters/response_formatter.py`.
    2. Go to **Settings > Filters > Create Filter**, name "ResponseFormatter".
    3. Paste code, save, enable.
  - **Import**:
    1. Save as `/filters/response_formatter.py`.
    2. Go to **Settings > Filters > Import Filter**, upload, enable.
  - Restart OpenWebUI.

### PromptLogger
- **Description**: Logs prompts to `prompt_log.txt`.
- **File**: `/filters/prompt_logger.py`
- **Code**:
  ```python
  """
  PromptLogger for OpenWebUI.

  Logs prompts with timestamps to `prompt_log.txt`.

  :author: open-webui
  :author_url: https://github.com/open-webui
  :funding_url: https://github.com/open-webui
  :version: 0.1
  """
  import datetime

  class Action:
      """Action to log prompts."""

      def __init__(self):
          """Init with no settings."""
          pass

      def inlet(self, body: dict, user: Optional[dict] = None) -> dict:
          """
          Pass through request.

          Args:
              body (dict): Incoming request.
              user (Optional[dict]): User data.

          Returns:
              dict: Unchanged body.
          """
          return body

      def outlet(self, body: dict, user: Optional[dict] = None) -> dict:
          """
          Log prompt to file.

          Args:
              body (dict): Response body.
              user (Optional[dict]): User data.

          Returns:
              dict: Unchanged body after logging.
          """
          prompt = body.get("messages", [-1])[-1].get("content", "No prompt")
          agent = body.get("model", "Unknown")
          with open("prompt_log.txt", "a") as file_handle:
              file_handle.write(
                  f"{datetime.datetime.now()}: {agent} - {prompt}\n"
              )
          return body
  ```
- **Setup**:
  - **Manual GUI**:
    1. Save as `/filters/prompt_logger.py`.
    2. Go to **Settings > Filters > Create Filter**, name "PromptLogger".
    3. Paste code, save, enable.
  - **Import**:
    1. Save as `/filters/prompt_logger.py`.
    2. Go to **Settings > Filters > Import Filter**, upload, enable.
  - Restart OpenWebUI.

## OUI! Playtime
Test with wild prompts—see filters hold! Try GUI and import—double the learning, haha! Share your craziest function online.

## Troubleshooting
- **Filter Fail**: Check path and permissions.
- **Import Error**: Ensure .py is valid.
- **Log Issues**: Verify write access to `prompt_log.txt`.

## Next Step
Future 05-tools.markdown awaits—stay tuned!