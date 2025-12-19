---
const axios = require("axios");

const url = "https://api.agora.io/api/conversational-ai-agent/v2/projects/:appid/join";

const headers = {
  "Authorization": "Basic <your_base64_encoded_credentials>"
};

const data = {
  name: "unique_name",
  properties: {
    channel: "channel_name",
    token: "token",
    agent_rtc_uid: "1001",
    remote_rtc_uids: ["1002"],
    idle_timeout: 120,
    advanced_features: {
      enable_aivad: true
    },
    llm: {
      url: "https://api.openai.com/v1/chat/completions",
      api_key: "<your_llm_key>",
      system_messages: [
        {
          role: "system",
          content: "You are a helpful chatbot."
        }
      ],
      max_history: 32,
      greeting_message: "Hello, how can I assist you today?",
      failure_message: "Please hold on a second.",
      params: {
        model: "gpt-4o-mini"
      }
    },
    tts: {
      vendor: "microsoft",
      params: {
        key: "<your_tts_api_key>",
        region: "eastus",
        voice_name: "en-US-AndrewMultilingualNeural"
      }
    },
    asr: {
      language: "en-US"
    }
  }
};

axios
  .post(url, data, { headers })
  .then(response => {
    console.log("Status:", response.status);
    console.log("Response:", response.data);
  })
  .catch(error => {
    console.error("Error:", error.response ? error.response.data : error.message);
  });

title: REST quickstart
description: Set up real-time interaction with a Conversational AI agent.
sidebar_position: 1
platform: android
exported_from: https://docs.agora.io/en/conversational-ai/get-started/quickstart
exported_on: '2025-11-15T11:00:05.984561Z'
exported_file: quickstart.md
---

[HTML Version](https://docs.agora.io/en/conversational-ai/get-started/quickstart)

# REST quickstart


This page describes how to call the Conversational AI Engine RESTful APIs to start and stop an AI agent.

## Understand the tech

Agora’s Conversational AI technology enables real-time voice interactions between users and an AI-driven agent within an Agora channel. The basic process is as follows:

1. **User joins a Agora channel**:  A user joins an Agora channel.
1. **Start an AI agent**: The user sends a request to your business server, which then makes an API call to the Conversational AI engine to start an agent. The agent joins the same channel as the user.
1. **Real-time interaction**: The user communicates with the AI agent through voice, leveraging the specified LLM, a text-to-speech service, and Agora's low-latency Software-Defined Real-Time Network (SDRTN®).
1. **Stop the AI agent**: When the user ends the conversation, the business server sends a request to stop the AI agent. The agent then leaves the Agora channel.
1. **User leaves the Agora channel**: The user disconnects from the session.

**Conversational AI Engine workflow**

![](https://docs-md.agora.io/images/conversational-ai/ai-agent-tech.svg)

## Prerequisites

Before you begin, make sure that you have:

- Implemented the [Voice Calling](https://docs-md.agora.io/en/voice-calling/get-started/get-started-sdk.md) or [Video Calling quickstart](https://docs-md.agora.io/en/video-calling/get-started/get-started-sdk.md).
- [Enabled Agora conversational AI](https://docs-md.agora.io/en/conversational-ai/get-started/manage-agora-account.md) for your project.
- The following information from Agora Console:
    - [App ID](https://docs-md.agora.io/en/conversational-ai/get-started/manage-agora-account.md): The string identifier for your project used to call the Conversational AI Engine RESTful API.
    - [Customer ID and Customer secret](https://docs-md.agora.io/en/conversational-ai/rest-api/restful-authentication.md): Used for HTTP authentication when calling the RESTful APIs.
    - A [temporary token](https://docs-md.agora.io/en/conversational-ai/get-started/manage-agora-account.md): The token is used by the agent for authentication when joining an Agora channel. 
- Obtained an API key and callback URL from a Large Language Model (LLM) provider such as [OpenAI](https://openai.com/index/openai-api/).
- Obtained an API key from a text-to-speech (TTS) provider such as [Microsoft Azure](https://azure.microsoft.com/en-us/products/ai-services/ai-speech).
- Implemented the [voice](https://docs-md.agora.io/en/voice-calling/get-started/get-started-sdk.md) or [video](https://docs-md.agora.io/en/video-calling/get-started/get-started-sdk.md) calling quickstart.

    > ℹ️ **Info**
    > For the best conversational experience, Agora recommends using Conversational AI Engine with specific Agora Video/Voice SDK versions. For details, [contact technical support](https://docs-md.agora.io/en/mailto:support@agora.io.md).

## Implementation

This section introduces the basic RESTful API requests you use to start and stop a Conversational AI agent. In a production environment, implement these requests on your business server.

### Start a conversational AI agent

Call the `join` endpoint to create an agent instance that joins an Agora channel. Pass in the `channel` name and `token` for agent authentication. To generate your base64-encoded credentials, see [RESTful authentication](https://docs-md.agora.io/en/conversational-ai/rest-api/restful-authentication.mdx.md).

**Node.js**
```js
const fetch = require('node-fetch');

const url = "https://api.agora.io/api/conversational-ai-agent/v2/projects/:appid/join";

const headers = {
"Authorization": "Basic <your_base64_encoded_credentials>",
"Content-Type": "application/json"
};

const data = {
"name": "unique_name",
"properties": {
  "channel": "<your_channel_name>",
  "token": "<your_rtc_token>",
  "agent_rtc_uid": "0",
  "remote_rtc_uids": ["1002"],
  "enable_string_uid": false,
  "idle_timeout": 120,
  "llm": {
    "url": "https://api.openai.com/v1/chat/completions",
    "api_key": "<your_llm_api_key>",
    "system_messages": [
      {
        "role": "system",
        "content": "You are a helpful chatbot."
      }
    ],
    "greeting_message": "Hello, how can I help you?",
    "failure_message": "Sorry, I don't know how to answer this question.",
    "max_history": 10,
    "params": {
      "model": "gpt-4o-mini"
    }
  },
  "asr": {
    "language": "en-US"
  },
  "tts": {
    "vendor": "microsoft",
    "params": {
        "key": "<your_tts_api_key>",
        "region": "eastus",
        "voice_name": "en-US-AndrewMultilingualNeural"
    }
  }
}
};

fetch(url, {
method: "POST",
headers: headers,
body: JSON.stringify(data)
})
.then(response => response.json())
.then(json => console.log(json))
.catch(error => console.error("Error:", error));
```

**Curl**
```json
curl --request POST \
  --url https://api.agora.io/api/conversational-ai-agent/v2/projects/:appid/join \
  --header 'Authorization: Basic <your_base64_encoded_credentials>' \
  --header 'Content-Type: application/json' \
  --data '
{
  "name": "unique_name",
  "properties": {
    "channel": "<your_channel_name>",
    "token": "<your_rtc_token>",
    "agent_rtc_uid": "0",
    "remote_rtc_uids": ["1002"],
    "enable_string_uid": false,
    "idle_timeout": 120,
    "llm": {
      "url": "https://api.openai.com/v1/chat/completions",
      "api_key": "<your_llm_api_key>",
      "system_messages": [
        {
          "role": "system",
          "content": "You are a helpful chatbot."
        }
      ],
      "greeting_message": "Hello, how can I help you?",
      "failure_message": "Sorry, I don't know how to answer this question.",
      "max_history": 10,
      "params": {
        "model": "gpt-4o-mini"
      }
    },
    "asr": {
      "language": "en-US"
    },
    "tts": {
      "vendor": "microsoft",
      "params": {
          "key": "<your_tts_api_key>",
          "region": "eastus",
          "voice_name": "en-US-AndrewMultilingualNeural"
      }
    }
  }
}'
```

**Python**
```python
import requests
import json

url = "https://api.agora.io/api/conversational-ai-agent/v2/projects/:appid/join"

headers = {
  "Authorization": "Basic <your_base64_encoded_credentials>",
  "Content-Type": "application/json"
}

data = {
  "name": "unique_name",
  "properties": {
      "channel": "<your_channel_name>",
      "token": "<your_rtc_token>",
      "agent_rtc_uid": "0",
      "remote_rtc_uids": ["1002"],
      "enable_string_uid": False,
      "idle_timeout": 120,
      "llm": {
          "url": "https://api.openai.com/v1/chat/completions",
          "api_key": "<your_llm_api_key>",
          "system_messages": [
              {
                  "role": "system",
                  "content": "You are a helpful chatbot."
              }
          ],
          "greeting_message": "Hello, how can I help you?",
          "failure_message": "Sorry, I don't know how to answer this question.",
          "max_history": 10,
          "params": {
              "model": "gpt-4o-mini"
          }
      },
      "asr": {
          "language": "en-US"
      },
      "tts": {
          "vendor": "microsoft",
          "params": {
              "key": "<your_tts_api_key>",
              "region": "eastus",
              "voice_name": "en-US-AndrewMultilingualNeural"
          }
      }
  }
}

response = requests.post(url, headers=headers, data=json.dumps(data))
print(response.text)
```


For complete information on all request parameters, see [Start a conversational AI agent](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/join.md).

If the request is successful, you receive the following response:

```json
// 200 OK
{
  "agent_id": "1NT29X10YHxxxxxWJOXLYHNYB",
  "create_ts": 1737111452,
  "status": "RUNNING"
}
```

Store the `agent_id` for use in subsequent API calls to [query](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/query.md), [update](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/update.md), and [stop](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/leave.md) the AI agent.

### Stop the conversational AI agent

To end the conversation with the AI agent, call the `leave` endpoint. This causes the agent to leave the Agora channel.

**Node.js**
```js
const url = 'https://api.agora.io/api/conversational-ai-agent/v2/projects/:appid/agents/:agentId/leave';

const options = {
method: 'POST',
headers: {
  'Authorization': 'Basic <your_base64_encoded_credentials>',
  'Content-Type': 'application/json'
}
};

fetch(url, options)
.then(res => res.json())
.then(json => console.log(json))
.catch(err => console.error(err));
```

**Curl**
```bash
curl --request post \
  --url https://api.agora.io/api/conversational-ai-agent/v2/projects/:appid/agents/:agentId/leave \
  --header 'Authorization: Basic <your_base64_encoded_credentials>'
```

**Python**
```python
import requests

url = "https://api.agora.io/api/conversational-ai-agent/v2/projects/:appid/agents/:agentId/leave"

headers = {
  "Authorization": "Basic <your_base64_encoded_credentials>",
  "Content-Type": "application/json"
}

response = requests.post(url, headers=headers)
print(response.text)
```


If the request is successful, the server responds with a `200 OK` status and an empty JSON object.

```json
// 200 OK
{}
```

> ℹ️ **Info**
> The number of Peak Concurrent Users (PCU) allowed to call the server API under a single App ID is limited to 20. If you need to increase this limit, please [contact technical support](https://docs-md.agora.io/en/mailto:support@agora.io.md).

## Reference

This section contains content that completes the information on this page, or points you to documentation that explains other aspects to this product.

### API reference

- [Start a conversational AI agent](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/join.md)
- [Stop a conversational AI agent](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/leave.md)
- [Update agent configuration](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/update.md)
- [Query agent status](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/query.md)
- [Retrieve a list of agents](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/list.md)
---
title: ARES
description: Integrate ARES ASR into Conversational AI Engine.
sidebar_position: 2
platform: android
exported_from: https://docs.agora.io/en/conversational-ai/models/asr/ares
exported_on: '2025-11-15T11:00:06.714125Z'
exported_file: ares.md
---

[HTML Version](https://docs.agora.io/en/conversational-ai/models/asr/ares)

# ARES


Adaptive Recognition Engine for Speech (ARES) provides built-in real-time speech-to-text, offering seamless integration with low latency and reliable performance for conversational AI applications.

> ℹ️ **Info**
> Using Ares ASR incurs charges under the "ARES ASR Task" pricing category. See the [pricing](https://docs-md.agora.io/en/conversational-ai/overview/pricing.md) page for details.

### Sample configuration

The following example shows a starting `asr` parameter configuration you can use when you [Start a conversational AI agent](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/join.md).

```json
"asr": {
  "vendor": "ares",
  "language": "en-US"
}
```

### Key parameters

<ParameterList title="asr" required={true}>
 <Parameter name="vendor" type="string" required={true}>
 ASR provider. Set to `ares` to use Adaptive Recognition Engine for Speech.
 </Parameter>
 <Parameter name="language" type="string" required={true} possibleValues="ar-EG, ar-JO, ar-SA, ar-AE, bn-IN, zh-CN, zh-HK, zh-TW, nl-NL, en-IN, en-US, fil-PH, fr-FR, de-DE, gu-IN, he-IL, hi-IN, id-ID, it-IT, ja-JP, kn-IN, ko-KR, ms-MY, fa-IR, pt-PT, ru-RU, es-ES, ta-IN, te-IN, th-TH, tr-TR, vi-VN">  
 The BCP-47 language tag identifying the primary language used for agent interaction. 
 </Parameter>
</ParameterList>
---
title: Google Gemini
description: Integrate a Google Gemini LLM into Conversational AI Engine.
sidebar_position: 5
platform: android
exported_from: https://docs.agora.io/en/conversational-ai/models/llm/gemini
exported_on: '2025-11-15T11:00:12.137304Z'
exported_file: gemini.md
---

[HTML Version](https://docs.agora.io/en/conversational-ai/models/llm/gemini)

# Google Gemini

Google Gemini provides advanced multimodal AI capabilities with fast performance and efficient processing for conversational AI applications.

### Sample configuration

The following example shows a starting `llm` parameter configuration you can use when you [Start a conversational AI agent](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/join.md).

```json
"llm": {
   "url": "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:streamGenerateContent?alt=sse&key=<api_key>",
   "system_messages": [
       {
           "parts": [
               {
                   "text": "You are a helpful chatbot"
               }
           ],
           "role": "user"
       }
   ],
   "max_history": 32,
   "greeting_message": "Good to see you!",
   "failure_message": "Hold on a second.",
   "params": {
       "model": "gemini-2.5-flash" 
   },
   "style": "gemini"
}
```

### Key parameters

<ParameterList title="llm" required={true}>
  <Parameter name="url" type="string" required={true}>  
  Note that the API key is passed in the URL query parameter. Get your API key from [Google AI Studio](https://aistudio.google.com/app/apikey).
  </Parameter>
  <Parameter name="system_messages" type="array[object]" required={false}>  
  Use `parts` array with `text` objects instead of simple `content` string.
  </Parameter>
  <Parameter name="style" type="string" required={true}>  
  Set to `gemini` to use Gemini's message format.
  </Parameter>
  <Parameter name="ignore_empty" type="boolean" required={false}>  
  Set to `true` to handle empty responses appropriately.
  </Parameter>
  <Parameter name="params" type="object" required={true}>  
    <Parameter name="model" type="string" required={true}>  
    Refer to [Gemini models](https://ai.google.dev/gemini-api/docs/models/gemini) for available models.
    </Parameter>
  </Parameter>
</ParameterList>

For advanced configuration options, model capabilities, and detailed parameter descriptions, see the [Google Gemini API documentation](https://ai.google.dev/api/generate-content#method:-models.streamgeneratecontent).
---
title: Cartesia (Beta)
description: Integrate Cartesia TTS into Conversational AI Engine.
sidebar_position: 4
platform: android
exported_from: https://docs.agora.io/en/conversational-ai/models/tts/cartesia
exported_on: '2025-11-15T11:00:15.434527Z'
exported_file: cartesia.md
---

[HTML Version](https://docs.agora.io/en/conversational-ai/models/tts/cartesia)

# Cartesia (Beta)


Cartesia provides ultra-fast, low-latency text-to-speech with real-time streaming capabilities, optimized for interactive conversational AI applications.

### Sample configuration

The following example shows a starting `tts` parameter configuration you can use when you [Start a conversational AI agent](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/join.md).

```json
"tts": {
  "vendor": "cartesia",
  "params": {
    "api_key": "<your_cartesia_key>",
    "model_id": "sonic-2",
    "voice": {
        "mode": "id",
        "id": "<voice_id>"
    },
    "output_format": {
        "container": "raw",
        "sample_rate": 16000
    },
    "language": "en"
  }
}
```

### Key parameters

<ParameterList title="params" required={true}>
 <Parameter name="api_key" type="string" required={true}>  
 The API key used for authentication. Get your API key from the [Cartesia Console](https://play.cartesia.ai/sign-up).
 </Parameter>
 <Parameter name="model_id" type="string" required={true}>
 Identifier of the model to be used.
 </Parameter>
  <Parameter name="voice" type="object" required={true}>  
 Voice configuration object.
 
   <Parameter name="mode" type="string" required={true}>
   Voice selection mode. Use `id` to select by voice identifier.
   </Parameter>
   
   <Parameter name="id" type="string" required={true}>
   The identifier of the selected voice for speech synthesis. 
   </Parameter>
 </Parameter>
 <Parameter name="output_format" type="object" required={false}>  
  Audio output format configuration
 
   <Parameter name="container" type="string" required={false}>
   Audio container format for the output stream.
   </Parameter>
   
   <Parameter name="sample_rate" type="number" defaultValue="16000" possibleValues="8000, 16000, 22050, 24000, 44100, 48000" required={false}>
   Audio sampling rate in Hz
   </Parameter> 
 </Parameter>
 <Parameter name="language" type="string" required={false}>
  Target language for speech synthesis.
 </Parameter> 
</ParameterList>

For advanced configuration options, voice customization, and detailed parameter descriptions, see the [Cartesia TTS documentation](https://docs.cartesia.ai/).
---
title: Google Gemini Live
description: Integrate Google Gemini Live MLLM into Conversational AI Engine.
sidebar_position: 3
platform: android
exported_from: https://docs.agora.io/en/conversational-ai/models/mllm/gemini
exported_on: '2025-11-15T11:00:13.974412Z'
exported_file: gemini.md
---

[HTML Version](https://docs.agora.io/en/conversational-ai/models/mllm/gemini)

# Google Gemini Live


Google Gemini Live provides multimodal large language model capabilities with real-time audio processing, enabling natural voice conversations without separate ASR/TTS components.

### Enable MLLM

To enable MLLM functionality, set `enable_mllm` to `true` under `advanced_features`.

```json
"advanced_features": {
  "enable_mllm": true
}
```

### Sample configuration

The following example shows a starting `mllm` parameter configuration you can use when you [Start a conversational AI agent](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/join.md).

```json
"mllm": {
    "params": {
        "model": "gemini-live-2.5-flash-preview-native-audio-09-2025",
        "adc_credentials_string": "<GOOGLE_APPLICATION_CREDENTIALS_STRING>",
        "project_id": "<GOOGLE_ASR_PROJECT_ID>",
        "location": "<GOOGLE_CLOUD_REGION>",
        "messages": [{
            "role": "user",
            "content": "<HISTORY_CONTENT>"
        }],
        "instructions": "<YOUR_SYSTEM_PROMPT>",
        "voice": "Aoede", 
        "transcribe_agent": true,
        "transcribe_user": true
    },
    "greeting_message": "Hi, how can I assist you today?",
    "input_modalities": [
        "audio"
    ],
    "output_modalities": [
        "audio"
    ],
    "vendor": "vertexai",
    "style": "openai"
}

"turn_detection": {
    "type": "server_vad"
}
```
### Key parameters

<ParameterList title="mllm" required={true}>
  <Parameter name="params" type="object" required={true}>
  Main configuration object for the Gemini Live model.
    <Parameter name="model" type="string" required={true}>
    The Gemini Live model identifier. 
    </Parameter>
    <Parameter name="adc_credentials_string" type="string" required={true}>
    Base64-encoded Google Cloud Application Default Credentials (ADC).  
    </Parameter>
    <Parameter name="project_id" type="string" required={true}>
    Your Google Cloud project ID for Vertex AI access.
    </Parameter>
    <Parameter name="location" type="string" required={true}>
    The Google Cloud region hosting the Gemini Live model. Check the Google Cloud documentation for the full list of available regions.
    </Parameter>
    <Parameter name="instructions" type="string" required={false}>
    System instructions that define the agent’s behavior or tone. 
    </Parameter>
    <Parameter name="messages" type="array[object]" required={false}>
    Optional array of conversation history items used for short-term memory.  
    </Parameter>
    <Parameter name="voice" type="string" required={false}>
    The voice identifier for audio output. For example, "Aoede", "Puck", "Charon", "Kore", "Fenrir", "Leda", "Orus", or "Zephyr".
    </Parameter>
    <Parameter name="transcribe_agent" type="boolean" required={false}>
    Whether to transcribe the agent’s speech in real time.
    </Parameter>
    <Parameter name="transcribe_user" type="boolean" required={false}>
    Whether to transcribe the user’s speech in real time.
    </Parameter>
  </Parameter>

  <Parameter name="input_modalities" type="array[string]" defaultValue='["audio"]' required={false}>
  Input modalities for the MLLM.  
  - `["audio"]`: Audio-only input  
  - `["audio", "text"]`: Accept both audio and text input
  </Parameter>

  <Parameter name="output_modalities" type="array[string]" defaultValue='["audio"]' required={false}>
  Output modalities for the MLLM.  
  - `["audio"]`: Audio-only response  
  - `["text", "audio"]`: Combined text and audio output
  </Parameter>

  <Parameter name="greeting_message" type="string" required={false}>
  Initial message the agent speaks when a user joins the channel. Example: `"Hi, how can I assist you today?"`.
  </Parameter>

  <Parameter name="vendor" type="string" required={true}>
  MLLM provider identifier. Set to `"vertexai"` for Google Gemini Live.
  </Parameter>

  <Parameter name="style" type="string" required={true}>
  API request style. Set to `"openai"` for OpenAI-compatible request formatting.
  </Parameter>
</ParameterList>

For comprehensive API reference, real-time capabilities, and detailed parameter descriptions, see the [Google Gemini Live API](https://cloud.google.com/vertex-ai/generative-ai/docs/live-api).
---
title: Optimize audio
description: Configure audio settings for a better AI-human conversation experience.
sidebar_position: 1
platform: android
exported_from: https://docs.agora.io/en/conversational-ai/best-practices/audio-setup
exported_on: '2025-11-15T11:00:01.231984Z'
exported_file: audio-setup.md
---

[HTML Version](https://docs.agora.io/en/conversational-ai/best-practices/audio-setup)

# Optimize audio

In real-time audio interactions, the rhythm, continuity, and intonation of conversations between humans and AI often differ from those between humans. To improve the AI–human conversation experience, it's important to optimize audio settings.

When using the Android or iOS Video/Voice SDK with the Conversational AI Engine, follow the best practices in this guide to improve conversation fluency and reliability, especially in complex network environments.

## Server configuration

When calling the server API to create a Conversational AI agent, use the default values for audio-related parameters to ensure the best audio experience.

## Client configuration

To configure the client app, implement the following:

### Integrate the required dynamic libraries

For the best Conversational AI Engine audio experience, integrate and load the following dynamic libraries in your project:

**Android**
- AI noise suppression plugin: `libagora_ai_noise_suppression_extension.so`
- AI echo cancellation plug-in: `libagora_ai_echo_cancellation_extension.so`

For integration details, refer to [App size optimization](https://docs-md.agora.io/en/voice-calling/best-practices/app-size-optimization_android.md).

**iOS**
- AI noise suppression plugin: `AgoraAiNoiseSuppressionExtension.xcframework`
- AI echo cancellation plug-in: `AgoraAiEchoCancellationExtension.xcframework`

For integration details, refer to [App size optimization](https://docs-md.agora.io/en/voice-calling/best-practices/app-size-optimization_ios.md).

> ℹ️ **Info**
> Optimizing audio uses AI Noise Suppression, which is a paid feature.

## Optimize audio for optimal performance

You can optimize audio settings in the following ways:

* **(Recommended) Use the Toolkit APIs**

    Supported in Video/Voice SDK version 4.5.1 and above.

* **Use the Video/Voice SDK APIs directly**

    Supported in SDK version 4.3.1 and above.

### Use the toolkit APIs

In this solution, you use the toolkit APIs to optimize audio settings.

**Android**

1. **Integrate the toolkit**

    Copy the [`convoaiApi`](https://github.com/AgoraIO-Community/Conversational-AI-Demo/tree/main/Android/scenes/convoai/src/main/java/io/agora/scene/convoai/convoaiApi) folder to your project and import the toolkit before calling the toolkit API. Refer to [Folder structure](#folder-structure) to understand the role of each file.

1. **Create a toolkit instance**

    Create a configuration object with the Video SDK and Signaling engine instances. Use the configuration to create a toolkit instance.

    ```kotlin
    // Create a configuration object for the Video SDK and Chat SDK instances
        val config = ConversationalAIAPIConfig(
            rtcEngine = rtcEngineInstance,
            rtmClient = rtmClientInstance,
            enableLog = true
        )
    
        // Create the toolkit instance
        val api = ConversationalAIAPIImpl(config)
    ```

1. **Set optimal audio settings**

    Before joining the Video SDK channel, call the `loadAudioSettings()` method to apply the optimal audio parameters.

    The component monitors audio route changes internally. If the audio route changes, it automatically calls this method again to reset the optimal parameters.

    ```kotlin
    api.loadAudioSettings()
       rtcEngine.joinChannel(token, channelName, null, userId)
    ```

1. **Add a Conversational AI agent to the channel**

    To [start a Conversational AI agent](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/join.md), configure the following parameters in your `POST` request:

    | Parameter       | Description   | Required |
    | ----------------| ------------- | -------- |
    | `advanced_features.enable_rtm: true`    | Starts the Signaling service | Yes  |
    | `parameters.data_channel: "rtm"`  | Enables Signaling as the data transmission channel | Yes |
    | `parameters.enable_metrics: true`  | Enables agent performance data collection    | Optional |
    | `parameters.enable_error_message: true` | Enables reporting of agent error events  | Optional |

    After a successful response, the agent joins the specified Video SDK channel and is ready to interact with the user.

1. **Release resources**

    At the end of each call, use the `destroy` method to clean up the cache.

    ```kotlin
    api.destroy()
    ```

**iOS**

1. **Integrate the toolkit**

    Copy the [`ConversationalAIAPI`](https://github.com/AgoraIO-Community/Conversational-AI-Demo/tree/main/iOS/Scenes/ConvoAI/ConvoAI/ConvoAI/Classes/ConversationalAIAPI) folder to your project and import the toolkit before calling the toolkit APIs. Refer to [Folder structure](#folder-structure) to understand the role of each file.

1. **Create a toolkit instance**

    Create a configuration object with the Video SDK and Signaling engine instances, then use the configuration to create a toolkit instance.

    ```swift
    // Create configuration objects for the Video SDK and Chat SDK instances
        let config = ConversationalAIAPIConfig(
            rtcEngine: rtcEngine, 
            rtmEngine: rtmEngine,
            enableLog: true
        )
        /// Create component instance
        convoAIAPI = ConversationalAIAPIImpl(config: config)
    ```

1. **Set optimal audio settings**

    Before joining the Video SDK channel, call the `loadAudioSettings()` method to apply the optimal audio parameters.

    The component monitors audio route changes internally. If the audio route changes, it automatically calls this method again to reset the optimal parameters.

    ```kotlin
    convoAIAPI.loadAudioSettings()
       rtcEngine.joinChannel(rtcToken: token, channelName: channelName, uid: uid, isIndependent: independent)
    ```

1. **Agent joins the channel**

    To [start a Conversational AI agent](https://docs-md.agora.io/en/conversational-ai/rest-api/agent/join.md), configure the following parameters in your `POST` request:

    | Parameter                         | Required | Description                                    |
    | --------------------------------- | -------- | ---------------------------------------------- |
    | `advanced_features.enable_rtm`    | Yes      | Enables the Chat service. |
    | `parameters.data_channel`         | Yes      | Sets the data transmission channel to `"rtm"`. |
    | `parameters.enable_metrics`       | Optional | Enables collection of agent performance data.  |
    | `parameters.enable_error_message` | Optional | Enables reporting of agent error events.       |

    After a successful request, the agent joins the specified Video SDK channel and the user can begin interacting with it.

1. **Release resources**

    At the end of each call, use the `destroy` method to clean up the cache.

    ```swift
    convoAIAPI.destroy()
    ```


### Use the SDK APIs

In this solution, you use the Voice/Video SDK to optimize audio settings.

#### Set audio parameters

The settings in this section apply to Video/Voice SDK versions 4.3.1 and above. If you are using an earlier version, upgrade to version 4.5.1 or above or [Contact Technical Support](https://docs-md.agora.io/en/mailto:support@agora.io.md).

**Android**
For the best conversational AI audio experience, apply the following settings:

1. **Set the audio scenario**: When initializing the engine, set the audio scenario to the AI client scenario. You can also set the scenario before joining a channel by calling the `setAudioScenario` method.

2. **Configure audio parameters**: Call `setParameters` before joining a channel and whenever the `onAudioRouteChanged` callback is triggered. This configuration sets audio 3A plug-ins (acoustic echo cancellation, noise suppression, and automatic gain control), the audio sampling rate, the audio processing mode, and other settings. For recommended parameter values, refer to the sample code.

> ℹ️ **Info**
> Since Video/Voice SDK versions 4.3.1 to 4.5.0 do not support the AI client audio scenario, set the scenario to `AUDIO_SCENARIO_CHORUS` to improve the audio experience. However, the audio experience cannot be aligned with versions 4.5.1 and above. To get the best audio experience, upgrade the SDK to version 4.5.1 or higher.

The following sample code defines a `setAudioConfigParameters` function to configure audio parameters. Call this function before joining a channel and whenever the audio route changes.

```kotlin
private var rtcEngine: RtcEngineEx? = null
private var mAudioRouting = Constants.AUDIO_ROUTE_DEFAULT

// highlight-start
// Set audio configuration parameters
private fun setAudioConfigParameters(routing: Int) {
    mAudioRouting = routing
    rtcEngine?.apply {
        setParameters("{"che.audio.aec.split_srate_for_48k":16000}")
        setParameters("{"che.audio.sf.enabled":true}")
        setParameters("{"che.audio.sf.stftType":6}")
        setParameters("{"che.audio.sf.ainlpLowLatencyFlag":1}")
        setParameters("{"che.audio.sf.ainsLowLatencyFlag":1}")
        setParameters("{"che.audio.sf.procChainMode":1}")
        setParameters("{"che.audio.sf.nlpDynamicMode":1}")

        if (routing == Constants.AUDIO_ROUTE_HEADSET // 0
            || routing == Constants.AUDIO_ROUTE_EARPIECE // 1
            || routing == Constants.AUDIO_ROUTE_HEADSETNOMIC // 2
            || routing == Constants.AUDIO_ROUTE_BLUETOOTH_DEVICE_HFP // 5
            || routing == Constants.AUDIO_ROUTE_BLUETOOTH_DEVICE_A2DP) { // 10
            setParameters("{"che.audio.sf.nlpAlgRoute":0}")
        } else {
            setParameters("{"che.audio.sf.nlpAlgRoute":1}")
        }
        
        setParameters("{"che.audio.sf.ainlpModelPref":10}")
        setParameters("{"che.audio.sf.nsngAlgRoute":12}")
        setParameters("{"che.audio.sf.ainsModelPref":10}")
        setParameters("{"che.audio.sf.nsngPredefAgg":11}")
        setParameters("{"che.audio.agc.enable":false}")
    }
}
// highlight-end

// Create and initialize the RTC engine
fun createRtcEngine(rtcCallback: IRtcEngineEventHandler): RtcEngineEx {
    val config = RtcEngineConfig()
    config.mContext = AgentApp.instance()
    config.mAppId = ServerConfig.rtcAppId
    config.mChannelProfile = Constants.CHANNEL_PROFILE_LIVE_BROADCASTING
    // highlight-start
    // Set the audio scene to AI dialogue scene (supported by 4.5.1 and above)
    // Version 4.3.1 ~ 4.5.0 is set to chorus scene AUDIO_SCENARIO_CHORUS
    config.mAudioScenario = Constants.AUDIO_SCENARIO_AI_CLIENT
    // Register audio route change callback
    config.mEventHandler = object : IRtcEngineEventHandler() {
        override fun onAudioRouteChanged(routing: Int) {
            super.onAudioRouteChanged(routing)
            // Set audio related parameters
            setAudioConfigParameters(routing)
        }
    }
    // highlight-end
    try {
        rtcEngine = (RtcEngine.create(config) as RtcEngineEx).apply {
            // highlight-start
            // Load the audio plugin
            loadExtensionProvider("ai_echo_cancellation_extension")
            loadExtensionProvider("ai_noise_suppression_extension")
            // highlight-end
        }
    } catch (e: Exception) {
        Log.e("CovAgoraManager", "createRtcEngine error: $e")
    }
    return rtcEngine!!
}

// Join the channel
fun joinChannel(rtcToken: String, channelName: String, uid: Int, isIndependent: Boolean = false) {

    // highlight-start
    // Initialize audio configuration parameters
    setAudioConfigParameters(mAudioRouting)
    // highlight-end

    // Configure channel options and join the channel
    val options = ChannelMediaOptions()
    options.clientRoleType = CLIENT_ROLE_BROADCASTER
    options.publishMicrophoneTrack = true
    options.publishCameraTrack = false
    options.autoSubscribeAudio = true
    options.autoSubscribeVideo = false       
    val ret = rtcEngine?.joinChannel(rtcToken, channelName, uid, options)
}
```

**iOS**
For the best conversational AI audio experience, apply the following settings:

1. **Set the audio scenario**: When initializing the engine, set the audio scenario to the AI client scenario. You can also set the scenario before joining a channel by calling the `setAudioScenario` method.

2. **Configure audio parameters**: Call `setParameters` before joining a channel and whenever the `rtcEngine:didAudioRouteChanged:` callback is triggered. This configuration sets audio 3A plug-ins (acoustic echo cancellation, noise suppression, and automatic gain control), the audio sampling rate, the audio processing mode, and other settings. For recommended parameter values, refer to the sample code.

> ℹ️ **Info**
> Since Video/Voice SDK versions 4.3.1 to 4.5.0 do not support the AI client audio scenario, set the scenario to `AgoraAudioScenarioChorus` to improve the audio experience. However, the audio experience cannot be aligned with versions 4.5.1 and above. To get the best audio experience, upgrade the SDK to version 4.5.1 or higher.

The following sample code defines a `setAudioConfigParameters` function to configure audio parameters. Call this function before joining a channel and whenever the audio route changes.

```swift
class RTCManager: NSObject {
    private var rtcEngine: AgoraRtcEngineKit!
    private var audioDumpEnabled: Bool = false
    private var audioRouting = AgoraAudioOutputRouting.default
    
    // highlight-start
    // Set audio related parameters
    private func setAudioConfigParameters(routing: AgoraAudioOutputRouting) {
        audioRouting = routing
        rtcEngine.setParameters("{"che.audio.aec.split_srate_for_48k":16000}")
        rtcEngine.setParameters("{"che.audio.sf.enabled":true}")
        rtcEngine.setParameters("{"che.audio.sf.stftType":6}")
        rtcEngine.setParameters("{"che.audio.sf.ainlpLowLatencyFlag":1}")
        rtcEngine.setParameters("{"che.audio.sf.ainsLowLatencyFlag":1}")
        rtcEngine.setParameters("{"che.audio.sf.procChainMode":1}")
        rtcEngine.setParameters("{"che.audio.sf.nlpDynamicMode":1}")
        if routing == .headset ||
            routing == .earpiece ||
            routing == .headsetNoMic ||
            routing == .bluetoothDeviceHfp ||
            routing == .bluetoothDeviceA2dp {
            rtcEngine.setParameters("{"che.audio.sf.nlpAlgRoute":0}")
        } else {
            rtcEngine.setParameters("{"che.audio.sf.nlpAlgRoute":1}")
        }
        rtcEngine.setParameters("{"che.audio.sf.ainlpModelPref":10}")
        rtcEngine.setParameters("{"che.audio.sf.nsngAlgRoute":12}")
        rtcEngine.setParameters("{"che.audio.sf.ainsModelPref":10}")
        rtcEngine.setParameters("{"che.audio.sf.nsngPredefAgg":11}")
        rtcEngine.setParameters("{"che.audio.agc.enable":false}")
    }
    // highlight-end
}

extension RTCManager: RTCManagerProtocol {
    
    func createRtcEngine(delegate: AgoraRtcEngineDelegate) -> AgoraRtcEngineKit {
        let config = AgoraRtcEngineConfig()
        config.appId = AppContext.shared.appId
        config.channelProfile = .liveBroadcasting
        // highlight-start
        // Set the audio scene to AI dialogue scene (supported by 4.5.1 and above)
        // Versions 4.3.1 ~ 4.5.0 support chorus scenes .chorus
        config.audioScenario = .aiClient
        rtcEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: delegate)
        // Register audio route change callback
        rtcEngine.addDelegate(self)
        // highlight-end
        return rtcEngine
    }
    
    func joinChannel(rtcToken: String, channelName: String, uid: String) {
        
        // highlight-start
        // Initialize audio configuration parameters
        setAudioConfigParameters(routing: audioRouting)
        // highlight-end

        // Configure channel options and join the channel
        let options = AgoraRtcChannelMediaOptions()
        options.clientRoleType = .broadcaster
        options.publishMicrophoneTrack = true
        options.publishCameraTrack = false
        options.autoSubscribeAudio = true
        options.autoSubscribeVideo = false
        let ret = rtcEngine.joinChannel(byToken: rtcToken, channelId: channelName, uid: UInt(uid) ?? 0, mediaOptions: options)           
    }
}

// highlight-start
// Implement the AgoraRtcEngineDelegate interface to handle audio route change callbacks
extension RTCManager: AgoraRtcEngineDelegate {
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioRouteChanged routing: AgoraAudioOutputRouting) {
        setAudioConfigParameters(routing: routing)
    }
}
// highlight-end
```


## Reference

This section contains content that completes the information on this page, or points you to documentation that explains other aspects to this product.

### Sample project

Refer to the following open-source sample code to set audio-related parameters.

**Android**
- [`CovRtcManager.kt`](https://github.com/AgoraIO-Community/Conversational-AI-Demo/blob/main/Android/scenes/convoai/src/main/java/io/agora/scene/convoai/rtc/CovRtcManager.kt)

**iOS**
- [`RTCManager.swift`](https://github.com/AgoraIO-Community/Conversational-AI-Demo/blob/main/iOS/Scenes/ConvoAI/ConvoAI/ConvoAI/Classes/Manager/RTCManager.swift)


### Folder structure

**Android**
- `IConversationalAIAPI.kt`: API interface and related data structures and enumerations
- `ConversationalAIAPIImpl.kt`: ConversationalAI API main implementation logic
- `ConversationalAIUtils.kt`: Tool functions and event callback management
- `subRender/`
    - `v3/`: Transcript module
        - `TranscriptionController.kt`: Transcript Controller
        - `MessageParser.kt`: Message Parser

**iOS**
- `ConversationalAIAPI.swift`: API interface and related data structures and enumerations
- `ConversationalAIAPIImpl.swift`: ConversationalAI API main implementation logic
- `Transcription/`
    - `TranscriptionController.swift`: Transcript Controller

**Web**
- `index.ts`: API Class
- `type.ts`: API interface and related data structures and enumerations
- `utils/`
    - `index.ts`: API utility functions
    - `events.ts`: Event management class, which can be extended to easily implement event monitoring and broadcasting
    - `sub-render.ts`: Transcript module


### API reference

**Android**
- SDK
    - [`setAudioScenario`](https://api-ref.agora.io/en/video-sdk/android/4.x/API/class_irtcengine.html#api_irtcengine_setaudioscenario)
    - [`setParameters`](https://api-ref.agora.io/en/video-sdk/android/4.x/API/class_irtcengine.html#api_irtcengine_setparameters)
    - [`onAudioRouteChanged`](https://api-ref.agora.io/en/video-sdk/android/4.x/API/class_irtcengineeventhandler.html#callback_irtcengineeventhandler_onaudioroutingchanged)
- Toolkit
    - [`loadAudioSettings`](https://docs-md.agora.io/en/conversational-ai/reference/android.md)
    - [`destroy`](https://docs-md.agora.io/en/conversational-ai/reference/android.md)

**iOS**
- SDK
    - [`setAudioScenario`](https://api-ref.agora.io/en/video-sdk/ios/4.x/documentation/agorartckit/agorartcenginekit/setaudioscenario(_:))
    - [`setParameters`](https://api-ref.agora.io/en/video-sdk/ios/4.x/documentation/agorartckit/agorartcenginekit/setparameters(_:))
    - [`rtcEngine:didAudioRouteChanged:`](https://api-ref.agora.io/en/video-sdk/ios/4.x/documentation/agorartckit/agorartcenginedelegate/rtcengine(_:didaudioroutechanged:))
- Toolkit
    - [`loadAudioSettings` [1/2]](/conversational-ai/reference/ios#loadaudiosettings12)
    - [`loadAudioSettings` [2/2]](/conversational-ai/reference/ios#loadaudiosettings22)
    - [`destroy`](https://docs-md.agora.io/en/conversational-ai/reference/ios.md)
