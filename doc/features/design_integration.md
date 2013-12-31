# Design Integration

## Latest Notes

### [Ask Kyle]

* The lists are not the same size as the spans, which makes it impossible to use them for drop targets. Had to use more base 'draggable' code rather than sortable.
* no-bottom vs bottom-form-btn - Some pages use this, others don't. This is being added at the layout level, so its complicated to retain.
* Fonts for Dashboard table headers/menus are just less bold than in design.
* Icons for:
    - Links

## Sitemap

- Open folders as you hover
- Delay dragging
- Better icon for dragging.
- Update server side to place items in sections/reorder
- Disable access to sections for editors without permissions.
- Remove GlobalMenu
- Remove all unused selected element behavior

## Tasks

### Dashboard
* Publishing pages without selecting on throws an error.
* [New Feature] My Activity/All Activity

### Content
* [BUG] Optimistic locking for pages doesn't work.
* {BUG} Can't add content blocks to pages (javascript insert)
* [REFACTOR] New Page form - Remove all CSS classes from ERB so that new form generation is clean.
* [BUG] Dashboard is not correctly displaying draft pages.

## New Features

* [Feature] Make 'Assign' on Edit page work.
* [Feature] Section Selector: Allow editors to select the section they want to put a page into.

## Design Review

* Errors - Review the placement of errors on the form.
* Google Fonts - Can we include them in the project so it works locally with no internet access.
* On 'Add Page' - Draft should have stronger coloring.
* Selected link for Dropdowns looks off
* User name in small menu isn't flush right with Settings.
* Label/Text is missing left margin. Doesn't stretch to end.
* Inline checkboxes don't left align properly.

## IA Questions

* Where should "Settings" link take user to.
* Preview Pages - What should it do? [It would need to save, then show the form. How is this different than ]

