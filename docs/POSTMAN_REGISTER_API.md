# Test POST /api/user/register from Postman

Use this to confirm marg_api works without CORS (Postman is not a browser, so CORS does not apply).

## 1. Get a valid idToken from the Flutter app

1. Run the Flutter app (web): `flutter run -d chrome`
2. Log in with **phone + OTP** (or email/Google).
3. In the **terminal** where Flutter is running, after the register attempt you’ll see:
   ```
   MargApi REGISTER │ --- idToken for Postman (copy next line) ---
   eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczov...
   MargApi REGISTER │ --- end idToken ---
   ```
4. **Copy the full token** (the long line between the two "---" lines). It’s a JWT and expires in about an hour.

## 2. Request in Postman

| Field | Value |
|--------|--------|
| **Method** | `POST` |
| **URL** | `http://localhost:3000/api/user/register` |
| **Headers** | `Content-Type` = `application/json` |
| **Body** | raw, JSON |

**Body (raw JSON):**

```json
{
  "idToken": "PASTE_THE_TOKEN_YOU_COPIED",
  "name": "+919606796516"
}
```

Replace `PASTE_THE_TOKEN_YOU_COPIED` with the token from step 1. You can keep or change `name`.

## 3. Send and check

- **If you get 201** and a JSON body with `success: true` and user `data` → the API and DB are fine; the issue is CORS when calling from the Flutter **browser**.
- **If you get 401** → token invalid or expired; log in again in the app and copy a fresh token.
- **If you get “Could not get response” / connection error** → marg_api is not running or not on port 3000; start it with `npm start` or `npm run dev` in the `marg_api` folder.

## 4. If Postman works but Flutter web still “Failed to fetch”

Then the problem is CORS. Ensure:

- marg_api was **restarted** after the CORS config change.
- `marg_api/.env` does **not** set `CORS_ORIGIN`, so the default allows any localhost origin.  
  Or set e.g. `CORS_ORIGIN=http://localhost:3000,http://localhost:8080` (add the port your Flutter web app shows in the browser URL).
