To get the api key:

```
kubectl -n flux get secret ollama-api-key -o jsonpath='{.data.OLLAMA_API_KEY}' | base64 -d
```

Example config in `~/.config/opencode/opencode.json`:

```
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "homelab-ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Homelab Ollama",
      "options": {
        "baseURL": "https://ollama.beansnet.net/v1",
        "apiKey": "{env:OLLAMA_API_KEY}"
      },
      "models": {
        "qwen2.5-coder:3b": { "name": "Qwen2.5 Coder 3B" }
      }
    }
  }
}
```