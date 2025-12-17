# Ollama Quick Start - 5 Minutes

## What You Need

- Ollama installed (https://ollama.ai)
- Backend running
- App running

## Quick Setup

### 1. Start Ollama (if not running)

```powershell
# Ollama starts automatically on Windows
# Or run: ollama serve
```

### 2. Download a Model (first time only)

```powershell
ollama pull mistral
```

Takes ~5-10 minutes depending on internet speed.

### 3. Verify It Works

```powershell
Invoke-WebRequest -Uri "http://localhost:11434/api/tags" -UseBasicParsing
```

Should show: `"name":"mistral"`

### 4. Update Backend .env

```env
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=mistral
```

### 5. Start Backend

```bash
cd server
npm run dev
```

Look for: `✅ Ollama AI initialized`

### 6. Test It

```powershell
Invoke-WebRequest -Uri "http://localhost:3000/api/ollama/status" -UseBasicParsing
```

Should show: `"available":true`

## Done! 🎉

Now when you use the app:
- AI chat uses **Ollama** (fast, local)
- If Ollama fails, uses **Gemini** (automatic fallback)
- No changes needed in the app!

## What Happens

1. Open app → Go to AI Chat
2. Type a question
3. Backend tries Ollama first
4. Gets response in 2-5 seconds
5. Shows response with source indicator

## Models to Try

| Model | Size | Speed | Quality |
|-------|------|-------|---------|
| mistral | 4GB | ⚡⚡⚡ | ⭐⭐⭐ |
| llama2 | 4GB | ⚡⚡ | ⭐⭐⭐ |
| neural-chat | 4GB | ⚡⚡⚡ | ⭐⭐ |
| dolphin-mixtral | 26GB | ⚡ | ⭐⭐⭐⭐ |

Download more:
```powershell
ollama pull llama2
ollama pull neural-chat
```

## Troubleshooting

**Ollama not connecting?**
- Make sure Ollama is running
- Check: `http://localhost:11434/api/tags`

**Model not found?**
- Download it: `ollama pull mistral`

**Slow responses?**
- Use smaller model (mistral is fastest)
- Close other apps
- Check internet (first run downloads model)

**Out of memory?**
- Use mistral (smallest)
- Increase RAM
- Reduce other apps

## Next Steps

1. ✅ Download model
2. ✅ Start Ollama
3. ✅ Start backend
4. ✅ Open app
5. ✅ Try AI chat
6. ✅ Enjoy local AI! 🚀

## Performance

- **First response**: 5-10 seconds (model loading)
- **Subsequent**: 2-5 seconds
- **Gemini fallback**: 1-3 seconds (if Ollama fails)

## Notes

- Ollama runs locally on your machine
- No data sent to cloud (unless using Gemini fallback)
- Works offline after model is downloaded
- Responses are private and secure
