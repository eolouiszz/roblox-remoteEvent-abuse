# Roblox Security Research

Security research and proof-of-concept documentation focused on vulnerabilities found in Roblox experiences.

This repository documents research involving **RemoteEvents, client-server communication, input validation, rate limiting, and gameplay security**.

The purpose of this project is to learn, document findings, and help developers understand potential weaknesses in their games.

---

## 🎮 Tested Experience

**Game:** Pumma Talladega

The findings documented in this repository were discovered while researching the game's client-server communication.

---

## 🔎 Finding #1 — `ChangeColour` RemoteEvent Abuse

### Classification

* **Type:** RemoteEvent Abuse
* **Potential weakness:** Missing or insufficient rate limiting
* **Component:** `ChangeColour`
* **Impact:** Potential server-side performance degradation
* **Severity:** Depends on the server-side implementation

### Affected RemoteEvent

```text
workspace.VehicleFolder.EiLouissCar.Colour.ColourScript.ChangeColour
```

### Description

The `ChangeColour` RemoteEvent can be invoked directly by the client.

During testing, it was possible to repeatedly send color values to the server without an apparent client-side restriction or effective server-side rate limit.

This behavior can potentially allow a malicious client to generate an excessive number of requests.

### Proof of Concept

The original proof of concept demonstrates repeated calls to the RemoteEvent while cycling through RGB colors:

```lua
local targetRemote = workspace.VehicleFolder.EiLouissCar.Colour.ColourScript.ChangeColour

local running = true
local hue = 0

while running do
    local color = Color3.fromHSV(hue, 1, 1)

    targetRemote:FireServer(color)

    hue += 0.05

    if hue > 1 then
        hue = 0
    end

    task.wait()
end
```

The purpose of this PoC is to demonstrate the behavior of the RemoteEvent under repeated requests.

### Potential Impact

Depending on how the server handles each request, excessive RemoteEvent calls could result in:

* Increased server workload
* Unnecessary event processing
* Performance degradation
* Abuse of gameplay functionality

The presence of unrestricted requests alone does **not** automatically mean that the game is vulnerable to a denial-of-service attack. The actual impact depends on the server-side implementation and available protections.

---

## 🛡️ Recommended Mitigations

Developers should treat all client input as untrusted.

Possible mitigations include:

* Server-side validation
* Per-player rate limiting
* Cooldowns
* Data-type validation
* Input validation
* Rejecting malformed requests
* Ignoring redundant requests
* Monitoring abnormal RemoteEvent activity

For example, a server could enforce a maximum number of requests allowed from a player within a specific time period.

**Rate limiting must be implemented on the server**, since client-side restrictions can be bypassed by modified clients.

---

## 📖 Research Goals

This repository exists primarily for educational and defensive security research.

Areas of interest include:

* Roblox RemoteEvents
* Client-server architecture
* RemoteEvent abuse
* Server-side validation
* Rate limiting
* Secure game development
* Vulnerability research
* Proof-of-concept development

---

## ⚠️ Disclaimer

This repository is provided **for educational and authorized security research purposes only**.

I do not encourage anyone to use the information or proof-of-concepts contained here to attack, disrupt, abuse, exploit, or interfere with Roblox experiences, servers, developers, or other players.

### No Responsibility for Misuse

I am **not responsible or liable for how other people choose to use the information, code, techniques, or proof-of-concepts contained in this repository**.

If someone copies, modifies, or uses code from this repository to create another exploit, attack a game, disrupt a server, harass players, or perform any other malicious or unauthorized activity, that action is **their own responsibility**.

I do not authorize or endorse malicious use of this research.

The repository is intended to document security research and help developers understand and mitigate potential vulnerabilities.

---

## 📌 Important

A proof-of-concept is not necessarily an indication of a critical vulnerability.

Severity should be determined based on:

1. What the server actually does with the received data.
2. Whether requests are rate-limited.
3. The amount of server-side processing involved.
4. Whether the behavior can affect other players.
5. Whether measurable performance degradation occurs.

Further testing should always be performed in an environment where the researcher has permission.

---

## 📄 License

This repository is intended for educational and security research purposes.

By using any material from this repository, you acknowledge that you are responsible for your own actions and for ensuring that your use complies with applicable laws, platform rules, and the authorization of the system being tested.
