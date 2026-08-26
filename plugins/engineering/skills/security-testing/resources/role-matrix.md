# Role matrix

Every protected resource against every caller, with the expected outcome
written before the test and the observed outcome written after.

## Building it

1. List every role the product defines, plus `anonymous` and `other tenant`.
2. List every protected resource and every action on it.
3. Fill the expected column from the requirements, not from the code.
4. Test each cell twice: through the interface, and by direct request.
5. Record the observed result, including the cells that behave correctly.

## Template

```
resource: /api/v1/documents/{id}

action  caller             expected  interface  direct    note
read    anonymous          deny      deny       deny      ok
read    viewer, owner      allow     allow      allow     ok
read    member, other doc  deny      deny       ALLOW     FINDING SEC-04
read    admin, same tenant allow     allow      allow     ok
read    admin, tenant B    deny      deny       ALLOW     FINDING SEC-04
update  viewer             deny      hidden     ALLOW     FINDING SEC-05
update  editor             allow     allow      allow     ok
delete  editor             deny      hidden     deny      ok
delete  admin              allow     allow      allow     ok
share   viewer             deny      hidden     ALLOW     FINDING SEC-05
export  member             allow     allow      allow     ok
export  admin, tenant B    deny      n/a        ALLOW     FINDING SEC-04
```

`hidden` in the interface column means the control is not displayed. It is
never a pass on its own; the direct column decides.

## The routes that must all be tested

One object is usually reachable through more than one route. Each is a
separate line in the matrix:

```
detail view
list endpoint, and its filters
search results
export and report generation
attachment or file download
print or share view
public link, if the product has one
admin interface
API, including an older version still deployed
webhook payload sent to a customer endpoint
background job output, such as a digest mail
```

## Escalation checks

```
can a caller change their own role, directly or through a profile update
can a caller add themselves to another tenant, group or project
does an invitation grant more than it displays
does a role change take effect immediately on existing sessions
does removing a member revoke their existing access, including open sessions,
  shared links and API tokens
can a lower role modify a field that only a higher role should set
```

## Recording a cell that fails

```
SEC-04  object level authorization missing on the documents API
Cells   read as member of another document, read and export as tenant B
Route   GET /api/v1/documents/{id}, GET /api/v1/documents/{id}/export
Proof   two accounts owned by the engagement, one request each, 200 with the
        document body. Evidence trimmed to the first line of the response.
Impact  any authenticated user can read any document in any tenant by
        identifier. Identifiers are sequential.
Fix     ownership and tenant check in the shared loader, not in each handler
Severity Critical, confidence Confirmed
```

## Completion rule

The matrix is complete when every cell has an observed value in both columns.
An empty cell is not a pass, and a matrix with empty cells is reported as
partial, with the cells named.
