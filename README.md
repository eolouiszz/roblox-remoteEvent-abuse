# Roblox Security Research

Security research and proof-of-concept documentation focused on vulnerabilities found in Roblox experiences.

This repository documents research involving **RemoteEvents, client-server communication, input validation, rate limiting, and gameplay security**.

The purpose of this project is to learn, document findings, and help developers understand potential weaknesses in their games.

---

## 🎮 Tested Experience

**Game:** Pumma Talladega

The finding documented in this repository was discovered while researching the game's client-server communication.

---

## 🧰 Tools & Methodology

No advanced exploitation framework, custom toolchain, or sophisticated infrastructure was required to discover this issue.

The research was performed using:

* **Windows**
* **Xeno**
* **Roblox's built-in Developer Console**
* **AI-assisted research and code analysis**
* Several hours of manual testing and investigation

The process primarily consisted of observing the game's client-server behavior, identifying an accessible `RemoteEvent`, experimenting with its parameters, and evaluating what happened when it was invoked repeatedly.

This is worth highlighting because the finding demonstrates that potentially significant security weaknesses can sometimes be identified using relatively simple tooling and an understanding of how client-server communication works.

---

## 🔎 Finding #1 — `ChangeColour` RemoteEvent Abuse

### Classification

* **Type:** RemoteEvent Abuse
* **Potential weakness:** Missing or insufficient rate limiting
* **Component:** `ChangeColour`
* **Potential impact:** Server-side performance degradation
* **Severity:** Dependent on server-side implementation

### Affected RemoteEvent

```text
workspace.VehicleFolder.EiLouissCar.Colour.ColourScript.ChangeColour
```

### Description

The `ChangeColour` RemoteEvent can be invoked directly by the client.

During testing, it was possible to repeatedly send color values to the server without an apparent effective server-side rate limit.

This behavior allows a client to generate a large number of requests to the same RemoteEvent.

### Proof of Concept

The proof of concept continuously invokes the RemoteEvent while cycling through different colors:

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

The PoC was created to demonstrate that the RemoteEvent could be repeatedly triggered from the client.

---

## 💥 Potential Impact

Depending on the server-side implementation, excessive RemoteEvent calls could cause:

* Increased server workload
* Unnecessary event processing
* Performance degradation
* Abuse of gameplay functionality

The ability to repeatedly invoke an event does **not automatically constitute a denial-of-service vulnerability**.

The actual severity depends on factors such as server-side processing, rate limiting, validation, and the measurable impact of the requests.

---

## 🛡️ Recommended Mitigations

Developers should treat all data received from clients as untrusted.

Recommended protections include:

* Server-side input validation
* Per-player rate limiting
* Cooldowns
* Data-type validation
* Rejecting malformed or unexpected values
* Ignoring redundant requests
* Monitoring abnormal RemoteEvent activity

Rate limiting should be implemented **server-side**, since client-side restrictions can be bypassed by modified clients.

---

## 🧪 Research Process

The discovery process was relatively straightforward:

1. Observe the game's client-side behavior.
2. Inspect accessible RemoteEvents.
3. Identify an event responsible for changing the vehicle's color.
4. Test whether the event could be triggered directly by the client.
5. Experiment with different parameters.
6. Test repeated invocation.
7. Document the behavior and potential impact.

No advanced exploit chain was required.

The main challenge was understanding the behavior of the RemoteEvent and determining whether the server adequately protected it.

---

## 📚 Research Goals

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

The repository exists to document security research, demonstrate potential weaknesses, and help developers understand how to mitigate them.

---

## 📌 Important

A proof-of-concept is not necessarily evidence of a critical vulnerability.

Severity should be evaluated based on:

1. What the server actually does with the received data.
2. Whether requests are rate-limited.
3. The amount of server-side processing involved.
4. Whether the behavior affects other players.
5. Whether measurable performance degradation occurs.

All testing should be performed only in environments where the researcher has permission.

---

## 📄 License

This repository is intended for educational and security research purposes.

By using material from this repository, you acknowledge that you are responsible for your own actions and for ensuring that your use complies with applicable laws, platform rules, and the authorization of the system being tested.
