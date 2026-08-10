# Component checklist

Applied to every component before it is considered done.

## Before writing

- [ ] The design system was searched for an existing component.
- [ ] Two existing components were read to extract the convention.
- [ ] The file placement matches where similar components live.
- [ ] The styling approach matches the project, not a personal preference.

## States

- [ ] Loading state, without layout shift on resolve.
- [ ] Empty state, with an explanation and the action that fills it.
- [ ] Error state, saying what failed and whether retrying helps.
- [ ] Partial state, where some data can arrive without the rest.
- [ ] Success state, stable across short and long content.
- [ ] Space is reserved so the layout does not jump between states.

## State placement

- [ ] Nothing stored that can be derived.
- [ ] Local state is local.
- [ ] Shared state has exactly one owner.
- [ ] Filters, tabs, pagination and search live in the URL.
- [ ] Server data lives in the data layer, not in a global store.
- [ ] Global client state is limited to genuinely cross cutting concerns.

## Data

- [ ] Fetching follows the project pattern, with no second data layer.
- [ ] The request has loading, error and stale response handling.
- [ ] Out of order responses cannot overwrite fresher data.
- [ ] Lists are paginated or limited.
- [ ] Optimistic updates have a written rollback path.
- [ ] No fetch in a render body, no unguarded effect fetch.

## Forms

- [ ] Validation rules match the server, or are a subset.
- [ ] Submit is disabled while pending and safe against a double click.
- [ ] Errors are attached to their field and announced.
- [ ] Focus moves to the first invalid field on failed submit.
- [ ] Values survive a failed submit.
- [ ] Success feedback persists long enough to be read.
- [ ] Destructive actions confirm, and the confirmation names the object.

## Accessibility

- [ ] Semantic elements, no clickable div.
- [ ] Full keyboard operation, logical tab order.
- [ ] Visible focus on every interactive element.
- [ ] Focus managed on navigation and on dialog open and close.
- [ ] Every input has a programmatically associated label.
- [ ] Images have alternative text, empty when decorative.
- [ ] Meaning is never carried by colour alone.
- [ ] Contrast measured against the project target.
- [ ] Asynchronous changes announced where they matter.
- [ ] Dialogs trap focus, close on escape, restore focus on close.
- [ ] Reduced motion preference honoured.

## Responsive

- [ ] Verified at the narrowest supported width.
- [ ] Verified at the widest supported width.
- [ ] No horizontal page scroll.
- [ ] Wide content scrolls in its own container.
- [ ] Touch targets are large enough and spaced.
- [ ] Breakpoints come from the project configuration.

## Performance

- [ ] Memoisation added only where a re-render was observed.
- [ ] References passed to memoised children are stable.
- [ ] List keys are stable identifiers.
- [ ] Images are sized and go through the project pipeline.
- [ ] No whole library imported for one function.
- [ ] Rarely used heavy components are split.

## Closing

- [ ] Every server bound input is validated server side as well.
- [ ] Component tests cover the states, not only the success path.
- [ ] No console output left behind.
- [ ] No commented out markup.
