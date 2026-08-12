# Criteria map

What to check, which criterion it belongs to, and whether a tool can see it.
Reference: WCAG 2.2. Levels A and AA, which is the usual contractual target.

Tool column: `auto` means a scanner detects it reliably, `partial` means it
detects some instances, `manual` means only a person finds it.

| Check | Criterion | Level | Tool |
|---|---|---|---|
| images have appropriate alternative text | 1.1.1 Non-text Content | A | partial |
| decorative images are marked as such | 1.1.1 | A | manual |
| captions on prerecorded video | 1.2.2 Captions | A | manual |
| structure conveyed by markup, not styling | 1.3.1 Info and Relationships | A | partial |
| form fields have associated labels | 1.3.1 | A | auto |
| reading order matches meaning | 1.3.2 Meaningful Sequence | A | manual |
| instructions do not rely on shape or position | 1.3.3 Sensory Characteristics | A | manual |
| content works in both orientations | 1.3.4 Orientation | AA | manual |
| input purpose identified, such as autocomplete | 1.3.5 Identify Input Purpose | AA | partial |
| colour is not the only carrier of information | 1.4.1 Use of Color | A | manual |
| audio can be paused or muted | 1.4.2 Audio Control | A | manual |
| text contrast at least 4.5 to 1, large text 3 to 1 | 1.4.3 Contrast | AA | auto |
| text resizes to 200 percent without loss | 1.4.4 Resize Text | AA | manual |
| no text embedded in images | 1.4.5 Images of Text | AA | manual |
| reflow at 320 CSS pixels, no horizontal scroll | 1.4.10 Reflow | AA | partial |
| non-text contrast at least 3 to 1 | 1.4.11 Non-text Contrast | AA | partial |
| text spacing overrides do not clip content | 1.4.12 Text Spacing | AA | manual |
| hover and focus content is dismissable and persistent | 1.4.13 Content on Hover | AA | manual |
| everything operable by keyboard | 2.1.1 Keyboard | A | manual |
| no keyboard trap | 2.1.2 No Keyboard Trap | A | manual |
| single character shortcuts can be remapped or disabled | 2.1.4 Character Key Shortcuts | A | manual |
| time limits adjustable | 2.2.1 Timing Adjustable | A | manual |
| moving content can be paused | 2.2.2 Pause, Stop, Hide | A | manual |
| nothing flashes more than three times per second | 2.3.1 Three Flashes | A | manual |
| a way to skip repeated blocks | 2.4.1 Bypass Blocks | A | partial |
| page titles are descriptive and unique | 2.4.2 Page Titled | A | partial |
| focus order preserves meaning | 2.4.3 Focus Order | A | manual |
| link purpose clear from its text | 2.4.4 Link Purpose | A | partial |
| more than one way to reach a page | 2.4.5 Multiple Ways | AA | manual |
| headings and labels describe their content | 2.4.6 Headings and Labels | AA | manual |
| focus is visible | 2.4.7 Focus Visible | AA | partial |
| focused element is not obscured | 2.4.11 Focus Not Obscured | AA | manual |
| dragging has a single pointer alternative | 2.5.7 Dragging Movements | AA | manual |
| target size at least 24 by 24, or spaced | 2.5.8 Target Size | AA | partial |
| page language declared | 3.1.1 Language of Page | A | auto |
| language of passages declared | 3.1.2 Language of Parts | AA | partial |
| focus alone does not change context | 3.2.1 On Focus | A | manual |
| input alone does not change context | 3.2.2 On Input | A | manual |
| navigation is consistent across pages | 3.2.3 Consistent Navigation | AA | manual |
| components are identified consistently | 3.2.4 Consistent Identification | AA | manual |
| help is in a consistent place | 3.2.6 Consistent Help | A | manual |
| errors are identified in text | 3.3.1 Error Identification | A | partial |
| labels or instructions provided | 3.3.2 Labels or Instructions | A | partial |
| error correction is suggested where known | 3.3.3 Error Suggestion | AA | manual |
| reversible, checked or confirmed for legal and financial actions | 3.3.4 Error Prevention | AA | manual |
| authentication does not require a cognitive test | 3.3.8 Accessible Authentication | AA | manual |
| markup is parseable, identifiers unique | 4.1.1 Parsing | A | auto |
| name, role and value exposed for every component | 4.1.2 Name, Role, Value | A | partial |
| status messages announced without focus change | 4.1.3 Status Messages | AA | manual |

## What this table is for

Count the rows. The `manual` and `partial` rows are the majority, and they
contain every criterion that decides whether a person can complete a task.
That is the argument, in one page, for why a scanner report is a floor.

## Coverage record

```
target        WCAG 2.2 AA
pages         <in scope>
checked auto  <count> criteria, <tool and version>
checked manual <count> criteria
not checked   <criteria, with the reason: no video content, no drag
              interaction, no time limit in this product>
```

`not checked` is filled honestly. Most products legitimately have no video and
no drag interaction, and saying so is better than implying a sweep that never
happened.
