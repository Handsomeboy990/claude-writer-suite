# Boundary input catalogue

Safe, controlled values whose purpose is to check that invalid input is
rejected cleanly. None of them is designed to exploit anything. Payloads with
that intent belong to `security-testing`, under contract.

## Strings

| Case | Value | Expected |
|---|---|---|
| empty | `""` | rejected on a required field, accepted on an optional one |
| whitespace only | `"   "` | treated as empty, not as content |
| leading and trailing space | `"  name  "` | trimmed or rejected, never stored inconsistently |
| minimum length | exactly the minimum | accepted |
| below minimum | minimum minus one | rejected with a field level message |
| maximum length | exactly the maximum | accepted and stored whole |
| above maximum | maximum plus one | rejected, not silently truncated |
| very long | 10000 characters | rejected with a clean error, never a 500 |
| newlines in a single line field | `"a\nb"` | rejected or normalised, never rendered raw |
| unicode scripts | Arabic, Japanese, Cyrillic, accented Latin | accepted where the product claims support |
| combining characters | a decomposed accent | length and comparison stay correct |
| emoji in a free text field | one emoji | accepted or rejected consistently, never a database error |

## Numbers

```
zero
negative where only positive is meaningful
the declared minimum, and one below
the declared maximum, and one above
a value with more decimal places than the field allows
a very large integer, beyond a 32 bit range
a numeric string with a leading zero
a value expressed in scientific notation
```

Money gets its own line: the smallest unit, a value that rounds badly in
binary floating point, and a negative amount on an operation that has no
meaning below zero.

## Dates and times

```
today
the boundary of the allowed window, and one second either side
a date in the far past and the far future
29 February on a leap year and on a non leap year
a date sent in a different timezone from the server's
the last day of a month, and the first
an end date before its start date
```

## Identifiers

```
an identifier that does not exist
an identifier of the right shape belonging to another owner, only within the
  accounts the contract authorises
an identifier of the wrong type: a string where an integer is expected
an empty identifier
an identifier with surrounding whitespace
```

The second line is where authorization defects surface. Within the campaign
accounts it is a validation check; beyond them it is security testing and it
needs the contract.

## Files

```
zero bytes
exactly the size limit
one byte over the limit
the correct extension with the wrong content
the wrong extension with correct content
a name with spaces, unicode, or a very long stem
a file that is still uploading when the form is submitted
```

## Collections

```
an empty array where one element is required
one element
exactly the page size
page size plus one
duplicated elements
elements in an unexpected order
```

## What every rejection must do

```
return the status the contract declares, not 500
name the field, not the database column
keep the rest of the submitted data
say what would be acceptable
never echo the input back into the page unescaped
```
