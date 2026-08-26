# Rewriting a feature article as a task

An existing help centre article, and what section 1 through 5 do to it.

## Before

```markdown
# Notification Preferences

The Notification Preferences module allows users to configure their
notification settings. Users can simply access this from Account Settings.

Notification Preferences supports the following notification types:
- Order notifications
- Marketing notifications
- System notifications

To configure, navigate to Account Settings and select Notification
Preferences, then toggle the desired options and save your changes.

Note: Some notifications cannot be disabled.
```

## What is wrong

| Problem | Section |
|---|---|
| Titled after a module, not a task. Nobody searches for `notification preferences` when the actual problem is too many emails. | 1 |
| `simply` tells a reader who cannot find it that the fault is theirs. | 3 |
| System vocabulary: module, configure, notification types, toggle the desired options. | 3 |
| Steps are a paragraph, not numbered actions, and none says what the reader sees. | 2 |
| No result. The reader cannot tell whether it worked. | 2 |
| `Some notifications cannot be disabled` is the one thing the reader most needs, buried at the end, unspecified. | 5 |
| Nothing about what actually goes wrong. | 5 |
| One article for at least three tasks. | 1 |

## The tasks underneath

From six months of support tickets, three tasks, in the words used to report
them:

1. Stop receiving marketing emails
2. Stop receiving emails about orders someone else placed
3. Get order updates by text message instead of email

Three articles. The old one served none of them: someone searching *stop
marketing emails* never found *Notification Preferences*.

## After, article 1

```markdown
# Stop receiving marketing emails

Turns off product news, offers and newsletters. You will still receive emails
about your orders and your account, which cannot be turned off because they
are how we tell you about a delivery or a payment problem.

## Before you start

You need to be signed in. This applies to the email address you sign in with.
If you receive marketing emails at a different address, see Remove a second
email address.

## Steps

1. Select your name in the top right corner.
   A menu opens.
2. Select **Account settings**.
   The settings page opens on the **Profile** tab.
3. Select the **Emails** tab.
   You see three groups: **Orders**, **Account**, **News and offers**.
4. Turn off **News and offers**.
   The switch turns grey and a **Save** button appears at the bottom.
5. Select **Save**.
   A green banner reads *Your email settings have been saved.*

## How you know it worked

Return to the **Emails** tab. **News and offers** is off. You will receive no
further marketing emails, though one already sent may still arrive within 24
hours.

## If it did not work

**The Save button does not appear.**
Nothing changed. Check the switch actually moved; select it once, not twice.

**You still receive emails after 24 hours.**
They are probably about your orders, not marketing. Check the sender: order
emails come from orders@, marketing from news@. If they come from news@,
contact support with the date and subject line.

**Error: *We could not save your settings. Please try again.***
Your session expired while the page was open. Refresh the page, sign in again,
and repeat from step 3.

**You have more than one account with the same email.**
Settings apply per account. You need to repeat this for each one. To check,
see Find out which accounts use your email address.

## Related

- Stop receiving emails about someone else's orders
- Get order updates by text message instead of email
```

## What changed, and why it matters

| Change | Effect |
|---|---|
| Title is the task in the reader's words | findable by search, which is how help articles are reached |
| The unavoidable emails are stated in line 2, with the reason | this was the top ticket; hiding it at the end generated it |
| One action per step, with what appears afterwards | the reader can tell a slow step from a wrong one |
| Interface labels quoted exactly, in bold | no guessing which control is meant |
| A result the reader can observe | the article ends when they know, not when we stop typing |
| The 24 hour delay stated | this was the second ticket, and it was a non-problem reported as a bug |
| Error message quoted exactly | pasting it into search now finds this article |
| Four failures, all from real tickets | not imagined, so they are the ones that happen |
| `simply` removed | it was doing no work except assigning blame |

## Verification

Performed on a fresh account with no orders: steps 1 to 5 matched. Then on an
account with an open order, because the **Emails** tab renders a fourth group
in that state, which the first pass missed and which would have made step 3
wrong for most real readers.

Given to a colleague from finance with no product knowledge. One hesitation at
step 1, where `your name in the top right corner` shows initials rather than a
name on small screens. Fixed to `your name or initials in the top right
corner`.

That hesitation is the entire value of section 8 of the skill. It was
invisible to everyone who already knew where the menu was.
