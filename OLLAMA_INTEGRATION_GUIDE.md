# Ollama Local AI Integration Guide

## Overview

The Mensa app now supports **local AI inference** using Ollama, with automatic fallback to Gemini AI. This allows:

- 🚀 **Faster responses** - Local processing without API latency
- 💰 **Cost savings** - No API calls for local models
- 🔒 **Privacy** - Data stays on your machine
- 🌐 **Offline capability** - Works without internet (after model download)
- 🔄 **Automatic fallback** - Uses Gemini if Ollama is unavailable

## Architecture

```
Flutter App
    ↓
Backend API
    ↓
Ollama Router
    ├─→ Ollama Service (Local AI) ✅ Fast
    └─→ Gemini Service (Cloud AI) 🔄 Fallback
```

## Setup Instructions

### Step 1: Install Ollama

**Windows:**
1. Download from https://ollama.ai
2. Run the installer
3. Ollama will start automatically

**macOS:**
```bash
brew install ollama
ollama serve
```

**Linux:**
```bash
curl https://ollama.ai/install.sh | sh
ollama serve
```

### Step 2: Download a Model

Open PowerShell/Terminal and run:

```bash
ollama pull mistral
```

Or choose another model:
- `ollama pull llama2` - Meta's Llama 2 (7B)
- `ollama pull neural-chat` - Intel's Neural Chat
- `ollama pull dolphin-mixtral` - Dolphin Mixtral
- `ollama pull openchat` - OpenChat

**Model sizes:**
- Mistral: ~4GB
- Llama2: ~4GB
- Dolphin-Mixtral: ~26GB

### Step 3: Verify Ollama is Running

```powershell
Invoke-WebRequest -Uri "http://localhost:11434/api/tags" -UseBasicParsing
```

Should return a list of available models.

### Step 4: Configure Backend

Update `server/.env`:

```env
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=mistral
```

### Step 5: Start Backend Server

```bash
cd server
npm run dev
```

You should see:
```
✅ Ollama AI initialized
📦 Available models: mistral
```

### Step 6: Test the Integration

Check AI service status:

```powershell
Invoke-WebRequest -Uri "http://localhost:3000/api/ollama/status" -UseBasicParsing
```

Response:
```json
{
  "available": true,
  "baseUrl": "http://localhost:11434",
  "model": "mistral",
  "message": "Ollama is running with mistral model"
}
```

## How It Works

### Chat Flow

1. **User sends message** in app
2. **Backend receives request**
3. **Ollama service tries** to generate response
4. **If successful** → Returns response with `source: "ollama"`
5. **If failed** → Falls back to Gemini
6. **Response sent** to app with source indicator

### Example Request

```bash
curl -X POST http://localhost:3000/api/ollama/chat/menstruation \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user123",
    "message": "What are period cramps?",
    "history": []
  }'
```

Response:
```json
{
  "response": "Period cramps are...",
  "source": "ollama"
}
```

## Endpoints

### Status
- `GET /api/ollama/status` - Check if Ollama is available

### Chat Endpoints
- `POST /api/ollama/chat/menstruation` - Menstruation tracker chat
- `POST /api/ollama/chat/pregnancy` - Pregnancy tracker chat
- `POST /api/ollama/chat/menopause` - Menopause tracker chat
- `POST /api/ollama/chat/education` - Education chat

### Generic
- `POST /api/ollama/generate` - Generic text generation

## Request Format

```json
{
  "userId": "user_id",
  "message": "Your question here",
  "history": [
    {"role": "user", "content": "Previous question"},
    {"role": "assistant", "content": "Previous answer"}
  ],
  "userProfile": {
    "age": 25,
    "medical_conditions": ["PCOS"],
    "allergies": ["Penicillin"]
  }
}
```

## Response Format

```json
{
  "response": "AI generated response",
  "source": "ollama" or "gemini"
}
```

## Model Recommendations

### For Menstruation/Pregnancy/Menopause
- **Mistral** (4GB) - Best balance of speed and quality
- **Neural-Chat** (4GB) - Good for conversational responses
- **Llama2** (4GB) - Reliable and well-tested

### For Education
- **Dolphin-Mixtral** (26GB) - Best quality, slower
- **Openchat** (7GB) - Good balance

## Performance Tips

1. **Use smaller models** for faster responses
   - Mistral: ~2-5 seconds per response
   - Llama2: ~3-8 seconds per response

2. **Increase RAM** for better performance
   - Minimum: 8GB
   - Recommended: 16GB+

3. **Use GPU acceleration** (if available)
   - NVIDIA: Ollama uses CUDA automatically
   - AMD: Use `OLLAMA_CUDA_COMPUTE_CAPABILITY`

4. **Adjust temperature** for different responses
   - Lower (0.3-0.5): More focused, consistent
   - Higher (0.7-0.9): More creative, varied

## Troubleshooting

### Ollama not connecting

**Error:** "Ollama not available"

**Solution:**
1. Check if Ollama is running: `ollama serve`
2. Verify URL in `.env`: `OLLAMA_BASE_URL=http://localhost:11434`
3. Check firewall settings

### Model not found

**Error:** "Model not found"

**Solution:**
```bash
ollama pull mistral
ollama list  # See all models
```

### Slow responses

**Solution:**
1. Use smaller model: `ollama pull mistral`
2. Increase RAM allocation
3. Close other applications
4. Enable GPU acceleration

### Out of memory

**Error:** "CUDA out of memory"

**Solution:**
1. Use smaller model
2. Reduce `max_tokens` in request
3. Increase system RAM

## Monitoring

### Check Ollama logs

```bash
# Windows
Get-Content $env:APPDATA\Ollama\logs\server.log

# macOS/Linux
tail -f ~/.ollama/logs/server.log
```

### Monitor resource usage

```bash
# Windows Task Manager
# Look for "ollama" process

# macOS
top -p $(pgrep ollama)

# Linux
ps aux | grep ollama
```

## Advanced Configuration

### Custom Model Parameters

Edit `server/src/services/ollamaService.js`:

```javascript
const response = await axios.post(
  `${this.baseUrl}/api/generate`,
  {
    model: this.model,
    prompt: fullPrompt,
    stream: false,
    temperature: 0.5,  // Lower = more focused
    top_k: 40,
    top_p: 0.95,
    num_predict: 256,  // Max tokens
  }
);
```

### Use Different Models

Update `.env`:
```env
OLLAMA_MODEL=llama2
```

Or use multiple models:
```javascript
// In ollamaService.js
const models = ['mistral', 'llama2', 'neural-chat'];
const model = models[Math.floor(Math.random() * models.length)];
```

## Fallback Behavior

If Ollama fails:
1. Backend logs warning
2. Automatically tries Gemini
3. Returns response with `source: "gemini"`
4. App continues normally

No user-facing errors!

## Future Enhancements

- [ ] Model switching UI in app
- [ ] Response time monitoring
- [ ] Model performance analytics
- [ ] Custom model fine-tuning
- [ ] Streaming responses
- [ ] Multi-model ensemble

## Support

For Ollama issues: https://github.com/ollama/ollama/issues
For Mensa issues: Check the main README

## Notes

- Ollama runs on `localhost:11434` by default
- Models are stored in `~/.ollama/models`
- First run downloads the model (~4GB for Mistral)
- Responses are faster on subsequent runs (cached)
- Works offline after model is downloaded
