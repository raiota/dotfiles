## MCP Settings

```
claude mcp add context7 --scope user --transport http https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: YOUR_API_KEY"
claude mcp add chrome-devtools --scope user npx chrome-devtools-mcp@latest
claude mcp add voicevox --scope user -- npx @t09tanaka/mcp-simple-voicevox
claude mcp add playwright -- npx @playwright/mcp@latest
```

in order to use mcp-simple-voicevox, run voicevox engine locally

```
docker run --rm -itd -p '127.0.0.1:50021:50021' voicevox/voicevox_engine:latest
```
