#!/usr/bin/env python3

import json, time, base64, subprocess, urllib.request, os, sys

key_id = os.environ["APP_STORE_CONNECT_KEY_ID"]
issuer_id = os.environ["APP_STORE_CONNECT_ISSUER_ID"]
key_path = os.path.expanduser(os.environ["KEY_PATH"])
build_number = os.environ["GITHUB_RUN_NUMBER"]
notes = os.environ["NOTES"]


def b64url(data):
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode()


def generate_jwt():
    now = int(time.time())
    header = b64url(json.dumps({"alg": "ES256", "kid": key_id, "typ": "JWT"}).encode())
    payload = b64url(
        json.dumps(
            {"iss": issuer_id, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"}
        ).encode()
    )
    msg = f"{header}.{payload}".encode()
    sig_der = subprocess.check_output(
        ["openssl", "dgst", "-sha256", "-sign", key_path], input=msg, stderr=subprocess.DEVNULL
    )
    i = 2
    if sig_der[1] & 0x80:
        i += sig_der[1] & 0x7F
    r_len = sig_der[i + 1]
    r = sig_der[i + 2 : i + 2 + r_len]
    i += 2 + r_len
    s_len = sig_der[i + 1]
    s = sig_der[i + 2 : i + 2 + s_len]
    r = r[-32:].rjust(32, b"\x00")
    s = s[-32:].rjust(32, b"\x00")
    return f"{header}.{payload}.{b64url(r + s)}"


def api_request(url, method="GET", body=None):
    headers = {"Authorization": f"Bearer {generate_jwt()}", "Content-Type": "application/json"}
    data = json.dumps(body).encode() if body else None
    req = urllib.request.Request(url, data=data, method=method, headers=headers)
    return json.loads(urllib.request.urlopen(req).read())


def find_build():
    for attempt in range(20):
        try:
            resp = api_request(
                f"https://api.appstoreconnect.apple.com/v1/builds"
                f"?filter[version]={build_number}&filter[app]=6738300344"
            )
            if resp["data"]:
                return resp["data"][0]["id"]
        except Exception:
            pass
        print(f"Waiting for build... attempt {attempt + 1}")
        time.sleep(30)
    return None


def set_whats_new(build_id):
    body = {
        "data": {
            "type": "betaBuildLocalizations",
            "attributes": {"locale": "en-US", "whatsNew": notes},
            "relationships": {"build": {"data": {"type": "builds", "id": build_id}}},
        }
    }
    try:
        api_request("https://api.appstoreconnect.apple.com/v1/betaBuildLocalizations", "POST", body)
        print(f"What to Test set for build {build_number}")
    except urllib.error.HTTPError:
        locs = api_request(
            f"https://api.appstoreconnect.apple.com/v1/builds/{build_id}/betaBuildLocalizations"
        )
        if locs["data"]:
            loc_id = locs["data"][0]["id"]
            patch = {
                "data": {
                    "type": "betaBuildLocalizations",
                    "id": loc_id,
                    "attributes": {"whatsNew": notes},
                }
            }
            api_request(
                f"https://api.appstoreconnect.apple.com/v1/betaBuildLocalizations/{loc_id}",
                "PATCH",
                patch,
            )
            print(f"What to Test updated for build {build_number}")


build_id = find_build()
if build_id:
    set_whats_new(build_id)
else:
    print("Build not found, skipping What to Test")
