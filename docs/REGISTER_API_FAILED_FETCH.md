# Fix: "ClientException: Failed to fetch" on POST /api/user/register (Flutter Web)

## What you see

After phone OTP (or other) login, the app logs:

```
MargApi REGISTER │ [Phone OTP] Attempting register after verify...
MargApi REGISTER │ POST http://localhost:3000/api/user/register
MargApi REGISTER │ Payload: name=+919606796516, idToken.length=869
MargApi REGISTER │ [Phone OTP] Error: ClientException: Failed to fetch, uri=http://localhost:3000/api/user/register
MargApi REGISTER │ [Phone OTP] Stack: package:http/src/browser_client.dart 83:30  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 623:19  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 648:23  <fn>
... (more frames)
```

## Why it happens

- The Flutter app is running on **web** (browser). The browser sends the request from an origin like `http://localhost:8080` (or whatever port Flutter web uses).
- The **browser** blocks the response when the API does not allow that origin in **CORS**. The request may reach the server, but the browser hides the response and surfaces a generic **"Failed to fetch"**.
- So you get `ClientException: Failed to fetch` and **no user is created** in the database, because the app never sees a successful response.

## Fix

### 1. Allow Flutter web origin in marg_api CORS

**Option A – Use default (recommended for local dev)**  
Do **not** set `CORS_ORIGIN` in `marg_api/.env`. The default in `marg_api/src/config/index.js` allows **any** `http(s)://localhost` and `http(s)://127.0.0.1` (any port), so Flutter web will work regardless of port.

**Option B – Set allowed origins explicitly**  
If you use `CORS_ORIGIN` in `marg_api/.env`, add the origin where your Flutter web app runs, for example:

```env
# Include the port your Flutter web app uses (e.g. 8080, 12345)
CORS_ORIGIN=http://localhost:3000,http://localhost:8080,http://localhost:12345
```

Then restart marg_api so the new CORS config is loaded.

### 2. Ensure marg_api is running and reachable

- Start marg_api: from `marg_api` directory run `npm run dev` (or your start command).
- Ensure it listens on the same host/port the app uses (e.g. `http://localhost:3000`). If the app runs in the browser on the same machine, `localhost:3000` is correct.

### 3. Verify

After restarting marg_api, try phone OTP login again. You should see:

- In the Flutter terminal: `MargApi REGISTER │ Response: statusCode=201` and a response body with user data.
- In the marg_api logs: a `POST /api/user/register` request.
- A new row in the `users` table.

## Full stack trace (what it means)

The stack trace points to the **browser HTTP client** in Dart:

- `package:http/src/browser_client.dart` – the request is made from the browser (Flutter web).
- The actual failure is in the **browser**: either CORS blocked the response or the server was unreachable. The Dart code only sees "Failed to fetch"; it does not get the real HTTP status or body when the browser blocks.

So the fix is always on the **server and network** side (CORS + API running), not in the Flutter code path shown in the stack.
