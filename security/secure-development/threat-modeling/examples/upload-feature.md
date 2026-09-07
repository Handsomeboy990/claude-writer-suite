# Example: threat-modeling a file upload feature

A feature that lets a signed-in user upload a profile photo, stored on object
storage, served back to other users. Modelled before it is built.

## Assets, ranked

```
1  other users' browsers        an uploaded file rendered to them is a delivery channel
2  the object storage bucket     write access to it is write access to what everyone sees
3  the uploading user's account  the entry point; a stolen session uploads as them
4  server availability           a decompression bomb or a flood denies the feature
```

## Adversary

```
authenticated user      the real case: a normal account uploading a hostile file
unauthenticated remote  cannot reach the endpoint; auth gates it. Out of scope.
```

## Data flow and boundaries

```
[user browser] --upload--> [server] --store--> [object storage] --serve--> [other browsers]
               boundary 1           boundary 2                  boundary 3
```

## Threats, by boundary

```
boundary 1, client to server
  tampering    a file whose extension says .png and whose bytes are HTML
               -> threat: stored XSS when served. Severity high (any user hits it).
  denial       a 4KB zip that expands to 4GB
               -> threat: resource exhaustion. Severity medium.
  elevation    a path in the filename: ../../etc/something
               -> threat: path traversal on write. Severity high if unmitigated.

boundary 3, storage to other browsers
  disclosure   the file served from the app's own origin, running as the app
               -> threat: any active content runs with the app's trust. Severity high.
```

## Decisions

```
stored XSS       mitigate: verify type by content, serve from a separate origin
                 with Content-Disposition, never from the app origin -> file-handling
resource bomb    mitigate: size limit enforced before parsing, dimension cap -> file-handling
path traversal   mitigate: generate the stored name, never use the client filename -> file-handling
availability     accept the residual after the size cap; recorded, product owner signed off
```

## What the model produced

Four concrete controls, each handed to `file-handling`, and one accepted
residual risk with an owner. Not a diagram: a work list and one recorded
decision. The upload feature is now buildable with its threats already answered.
