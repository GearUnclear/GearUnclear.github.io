# Housing Hope Workflow Page Format Standard

## Overview
This document defines the standardized visual design and formatting template used across workflow pages in the Housing Hope Data Team Infobase. This format has been successfully implemented on Entry.html and Exit.html pages to provide a consistent, professional user experience.

## Design Philosophy
- **Professional & Modern**: Clean, card-based design with sophisticated styling
- **Accessibility First**: High contrast, readable typography, and mobile-responsive
- **Visual Hierarchy**: Clear step progression with numbered badges and visual flow
- **Consistency**: Unified design language across all workflow pages

## Technical Foundation

### Required Dependencies
```html
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
```

### Typography
- **Primary Font**: Inter (Google Fonts)
- **Fallback**: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif
- **Line Height**: 1.6 for optimal readability
- **Color**: #333 for main text, #495057 for secondary text

## Visual Components

### 1. Background & Layout
```css
body {
    background: linear-gradient(to right, #4A90E2, #007AFF);
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    line-height: 1.6;
    color: #333;
}
```

### 2. Professional Card Header
**Structure:**
- White card with rounded corners (16px border-radius)
- Gradient icon area with Font Awesome icon
- Title and descriptive subtitle
- Sophisticated drop shadows

**CSS Classes:**
- `.page-header` - Container with spacing
- `.header-card` - Main card styling with flexbox layout
- `.header-icon-area` - Gradient icon container
- `.header-text-area` - Text content area

**Icon Selection Guidelines:**
- Entry/Add processes: `fa-user-plus`
- Exit processes: `fa-sign-out-alt`
- Updates: `fa-edit`
- Documents: `fa-file-text`

### 3. Process Steps
**Design Pattern:**
- White cards with subtle shadows
- Numbered circular badges (35px diameter)
- Left border accent in brand blue (#007bff)
- Hover effects with slight elevation

**CSS Classes:**
- `.process-step` - Main step container
- `.step-number` - Circular numbered badge
- Hover states with transform and shadow changes

### 4. Process Flow Arrows
**Styling:**
- Circular background (50px diameter)
- Semi-transparent background for contrast
- Centered with flexbox alignment
- Consistent spacing between steps

```css
.process-arrow span {
    background: rgba(0, 0, 0, 0.1);
    border-radius: 50%;
    width: 50px;
    height: 50px;
}
```

### 5. Form Links & Documentation
**Button-Style Links:**
- Background: `rgba(0,123,255,0.1)`
- Hover effects with color transition
- Consistent padding and border-radius
- Transform effects for interactivity

**CSS Class:** `.form-guide-link`

### 6. Alert/Notice Sections
**Styling:**
- White card background
- Left border accent (warning: #ffc107, info: #007bff)
- Centered content with proper spacing
- Icon + text + description structure

## Content Standards

### Page Structure Template
```html
<main class="container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-card">
            <div class="header-icon-area">
                <i class="fas fa-[icon-name]"></i>
            </div>
            <div class="header-text-area">
                <h1>[Page Title]</h1>
                <div class="subtitle">[Descriptive subtitle]</div>
            </div>
        </div>
    </div>

    <!-- Process Flow -->
    <div class="process-flow">
        <!-- Step 1 -->
        <div class="process-step">
            <h2>
                <span class="step-number">1</span>
                [Step Title]
            </h2>
            <p>[Step description]</p>
            [Additional content]
        </div>

        <div class="process-arrow">
            <span>↓</span>
        </div>

        <!-- Additional steps... -->
    </div>
    
    <!-- Alert/Notice (if applicable) -->
    <div class="alert-section">
        [Alert content]
    </div>
    
    <!-- Navigation -->
    <div class="nav-home">
        <a href="index.html">← Return to Home</a>
    </div>
</main>
```

## Image Guidelines

### Sizing Standards
- **Primary instructional images**: 70% width, max-width 600px
- **Secondary/reference images**: 38% width, max-width 300px
- **All images**: Block display with auto margins for centering

### Image CSS
```css
.scaled-image {
    border-radius: 8px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    display: block;
    margin: 1.5rem auto;
}
```

## Color Palette

### Primary Colors
- **Brand Blue**: #007bff
- **Gradient Start**: #4A90E2
- **Gradient End**: #007AFF

### Text Colors
- **Primary Text**: #333
- **Secondary Text**: #495057
- **Muted Text**: #6c757d
- **Link Text**: #007bff

### Background Colors
- **Card Background**: #ffffff
- **Form Background**: #f8f9fa
- **Alert Background**: rgba(255,255,255,0.2)

## Responsive Design

### Breakpoints
- **Mobile**: max-width 768px
- **Tablet**: 768px - 1024px
- **Desktop**: 1024px+

### Mobile Adaptations
- Header cards switch to column layout
- Reduced padding and font sizes
- Smaller icon areas and step numbers
- Maintained readability and touch targets

## Implementation Checklist

When creating new workflow pages:

- [ ] Include all required dependencies (Bootstrap, Inter font, Font Awesome)
- [ ] Implement professional card header with appropriate icon
- [ ] Use numbered process steps with consistent styling
- [ ] Add process flow arrows between steps
- [ ] Style form links with button-style design
- [ ] Include responsive design considerations
- [ ] Add navigation back to home
- [ ] Test on mobile devices
- [ ] Ensure color contrast meets accessibility standards
- [ ] Validate HTML and CSS

## Maintenance Notes

### Future Updates
- When updating this format, ensure changes are applied consistently across all workflow pages
- Test changes on both Entry.html and Exit.html as reference implementations
- Document any new patterns or components in this file

### File Dependencies
- This format relies on external CDN resources (Bootstrap, Google Fonts, Font Awesome)
- Consider fallback fonts if Google Fonts fails to load
- Monitor CDN availability and update versions as needed

---

**Last Updated**: July 2025  
**Pages Using This Format**: Entry.html, Exit.html  
**Maintained By**: Housing Hope Data Team