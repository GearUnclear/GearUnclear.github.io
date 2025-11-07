# Apricot Versions Style Guide

## Overview
This guide documents the rules and best practices for creating HTML and CSS elements that work in the Apricot Database software.

---

## Buttons

### CSS Rules for Buttons
**CRITICAL:** CSS MUST be inline ONLY for buttons. No external stylesheets or `<style>` blocks.

### Button Types

#### False Buttons (Non-linking)
Use a `<div>` element styled to look like a button. Contains text or a list.

**Structure:**
```html
<div style="padding: 10px 20px; background-color: #3498db; color: white; text-align: center; border-radius: 5px; cursor: pointer; font-size: 16px; display: inline-block;">
    Button Text
</div>
```

**With List:**
```html
<div style="padding: 10px 20px; background-color: #3498db; color: white; border-radius: 5px; font-size: 16px;">
    <ul style="margin: 0; padding-left: 20px;">
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
    </ul>
</div>
```

#### True Buttons (Linking)
Use a `<button>` element or `<a>` tag that links to a URL.

**Button Element:**
```html
<button onclick="window.location.href='https://example.com'" style="padding: 10px 20px; background-color: #3498db; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px;">
    Click Here
</button>
```

**Link styled as Button:**
```html
<a href="https://example.com" style="padding: 10px 20px; background-color: #3498db; color: white; text-decoration: none; border-radius: 5px; cursor: pointer; font-size: 16px; display: inline-block;">
    Click Here
</a>
```

### Common Inline Styles for Buttons
- `padding: 10px 20px;` - Interior spacing
- `background-color: #3498db;` - Background color
- `color: white;` - Text color
- `border: none;` - Remove default border
- `border-radius: 5px;` - Rounded corners
- `cursor: pointer;` - Hand cursor on hover
- `font-size: 16px;` - Text size
- `display: inline-block;` - Proper spacing behavior
- `text-decoration: none;` - Remove underline (for links)

### Hover Effects (Inline)
For inline hover effects, use `onmouseover` and `onmouseout`:
```html
<div
    style="padding: 10px 20px; background-color: #3498db; color: white; text-align: center; border-radius: 5px; cursor: pointer; font-size: 16px; display: inline-block; transition: background-color 0.3s;"
    onmouseover="this.style.backgroundColor='#2980b9'"
    onmouseout="this.style.backgroundColor='#3498db'">
    Hover Me
</div>
```

---

## Bulletins

### CSS Rules for Bulletins
CSS **can** be placed in a `<style>` block at the top of the document for bulletins.

### Half-Height Spacing Element
**ALWAYS use half-height paragraphs for vertical spacing** instead of full spacing:

```css
p.half-height {
    margin: 0;
    padding: 0.5em 0;
}
```

**Usage:**
```html
<p class="half-height">This paragraph has half spacing</p>
```

### Complete Bulletin Example

```html
<style type="text/css">
.bulletin-buttons-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
    margin-bottom: 30px;
}

.bulletin-button a::before {
    content: replace(attr(data-text), '|', '\A');
    color: #ffffff;
    white-space: pre-line;
    line-height: 1.2;
}

.bulletin-button.new-button a::before {
    content: contents;
}

p.half-height {
    margin: 0;
    padding: 0.5em 0;
}

.bulletin-button {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    background-color: #EFEFEF;
    color: transparent;
    text-decoration: none;
    font-size: 20px;
    transition: background-color 0.3s;
}

.bulletin-button:hover {
    background-color: #2980b9;
}

.recent-updates {
    max-width: 600px;
    margin: 0 auto;
    font-size: 16px;
    background-color: #2980b9;
}

.recent-updates h2 {
    color: transparent;
    text-align: center;
    margin-bottom: 20px;
}

.recent-updates h2::before {
    content: attr(data-text);
    color: white;
}

.arecent-updates h2 {
    text-align: center;
    margin-bottom: 20px;
    color: white;
}

@keyframes flashyAnimation {
    0% {background-color: #e74c3c;}
    50% {background-color: #f39c12;}
    100% {background-color: #e74c3c;}
}

.bulletin-button.new-button {
    background-color: #e74c3c;
    animation: flashyAnimation 1.5s infinite;
}

.bulletin-button.new-button:hover {
    animation: none;
    background-color: #c0392b;
}

.bulletin-button.new-button span {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
}
</style>

<div class="recent-updates">
    <h2 data-text="Recent Updates">Placeholder</h2>
    <p class="half-height">Update content goes here</p>
</div>

<div class="bulletin-buttons-container">
    <div class="bulletin-button">
        <a href="#" data-text="Button Text">Button</a>
    </div>
    <div class="bulletin-button new-button">
        <a href="#"><span>New Feature!</span></a>
    </div>
</div>
```

### Key Bulletin Components

#### 1. Button Container
```css
.bulletin-buttons-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
    margin-bottom: 30px;
}
```

#### 2. Standard Bulletin Button
```css
.bulletin-button {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    background-color: #EFEFEF;
    color: transparent;
    text-decoration: none;
    font-size: 20px;
    transition: background-color 0.3s;
}

.bulletin-button:hover {
    background-color: #2980b9;
}
```

#### 3. "New" Button with Animation
```css
@keyframes flashyAnimation {
    0% {background-color: #e74c3c;}
    50% {background-color: #f39c12;}
    100% {background-color: #e74c3c;}
}

.bulletin-button.new-button {
    background-color: #e74c3c;
    animation: flashyAnimation 1.5s infinite;
}

.bulletin-button.new-button:hover {
    animation: none;
    background-color: #c0392b;
}
```

#### 4. Content Section
```css
.recent-updates {
    max-width: 600px;
    margin: 0 auto;
    font-size: 16px;
    background-color: #2980b9;
}

.recent-updates h2 {
    color: transparent;
    text-align: center;
    margin-bottom: 20px;
}

.recent-updates h2::before {
    content: attr(data-text);
    color: white;
}
```

---

## Best Practices

### For Buttons
1. **Always ask the user:** "Would you like a true button (linking) or false button (display only)?"
2. **Use inline styles exclusively** for buttons
3. **Provide hover effects** using `onmouseover`/`onmouseout` for interactive feedback
4. **Ensure accessibility** with proper contrast and cursor styles

### For Bulletins
1. **Use `<style>` blocks** at the top of the document
2. **Always use `p.half-height`** for vertical spacing
3. **Follow the proven pattern** from the example above
4. **Use flexbox** for button containers
5. **Implement animations** for "new" or important items
6. **Use `::before` pseudo-elements** for text replacement techniques

### Color Palette
- Primary Blue: `#3498db`
- Hover Blue: `#2980b9`
- Light Gray: `#EFEFEF`
- Alert Red: `#e74c3c`
- Dark Red: `#c0392b`
- Warning Orange: `#f39c12`
- White: `#ffffff`

---

## Quick Reference

| Element Type | CSS Location | Key Requirement |
|-------------|--------------|-----------------|
| Button | Inline only | Use `style=""` attribute |
| Bulletin | `<style>` block | Use `p.half-height` for spacing |
| False Button | Inline | Use `<div>` element |
| True Button | Inline | Use `<button>` or `<a>` element |
| Animations | `<style>` block | Use `@keyframes` |
| Hover Effects (buttons) | Inline | Use `onmouseover`/`onmouseout` |
| Hover Effects (bulletins) | `<style>` block | Use `:hover` pseudo-class |

---

## Workflow

When creating Apricot HTML elements:

1. **Identify the element type** (button vs bulletin)
2. **For buttons:**
   - Ask: "True button (linking) or false button (display)?"
   - Apply all CSS inline
   - Add hover effects with JavaScript events
3. **For bulletins:**
   - Create `<style>` block at top
   - Use `p.half-height` for spacing
   - Follow the proven bulletin pattern
   - Use flexbox for layouts
4. **Always reference this style guide** before creating elements
5. **Test in Apricot** to ensure compatibility

---

**Last Updated:** 2025-11-07
