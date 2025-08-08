# Housing Hope Infobase Design Language

## Page Templates

### 1. Process Guide Template (Prog, Entry, Exit style)
**Used for**: Step-by-step procedural guides

**Header Pattern**:
```css
.header-card {
    background: white;
    border-radius: 16px;
    padding: 2.5rem;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 4px 15px rgba(0, 0, 0, 0.05);
    display: flex;
    align-items: center;
    gap: 2rem;
}
.header-icon-area {
    width: 80px; height: 80px;
    background: linear-gradient(135deg, #4A90E2, #007AFF);
    border-radius: 20px;
}
```

**Step Cards**:
```css
.process-step {
    background: white;
    border-radius: 12px;
    padding: 2rem;
    margin: 1.5rem 0;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    border-left: 5px solid #007bff;
}
.step-number {
    background: #007bff;
    color: white;
    width: 35px; height: 35px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}
```

**Process Arrows** (Entry/Exit):
```css
.process-arrow span {
    font-size: 24px;
    color: white;
    background: rgba(0, 0, 0, 0.1);
    border-radius: 50%;
    width: 50px; height: 50px;
}
```

### 2. Reference Card Template (UnitDesignations style)
**Used for**: Dictionary/reference content with qualifications

**Two-Column Layout**:
```css
.card {
    background: white;
    border-radius: 12px;
    padding: 2rem;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    border-left: 5px solid #007bff;
}
.qualification {
    border-left: 5px solid #007bff;
    padding: 1.5rem;
    background: linear-gradient(135deg, #f8fbff, #e3f2fd);
    border-radius: 0 8px 8px 0;
}
```

**Badge System**:
```css
.badge.bg-primary    /* Blue for "Homeless" */
.badge.bg-danger     /* Red for "Chronically Homeless" */
```

### 3. Document Library Template (documents style)
**Used for**: File downloads and resource links

**Document Grid**:
```css
.document-link {
    display: flex;
    align-items: center;
    padding: 1.25rem;
    background: #f8f9fa;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    transition: all 0.3s ease;
}
.document-link:hover {
    background: #e3f2fd;
    border-color: #007bff;
    transform: translateX(5px);
}
```

### 4. Definition/Knowledge Template (definitions style)
**Used for**: Educational content with collapsible sections

**Grid Layout**:
```css
.definitions-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
    gap: 2rem;
}
```

**Collapsible Sections**:
```css
.key-points-toggle {
    background: #e3f2fd;
    color: #1976D2;
    border-radius: 8px;
    padding: 1rem;
    cursor: pointer;
}
```

### 5. Landing Hub Template (index style)
**Used for**: Main navigation pages

**Navigation Cards**:
```css
.nav-card {
    background: white;
    border-radius: 12px;
    padding: 2rem;
    height: 100%;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.nav-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15);
}
```

**Special Banners**:
```css
.resource-banner {
    background: white;
    border-radius: 12px;
    padding: 2rem;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    border-left: 5px solid #17a2b8;
}
```

### 6. Emergency Template (Crisis style)
**Used for**: Critical information pages

**Emergency Styling**:
```css
.call-911 {
    background: #d32f2f;
    color: white;
    border: 3px solid #b71c1c;
    padding: 1.5rem;
    font-weight: bold;
    text-align: center;
}
.call-kat, .call-monica {
    background: #ffe5e5;
    border: 2px solid #e53935;
    padding: 1rem;
    text-align: center;
}
```

## Color System

**Primary Gradients**:
- Main background: `linear-gradient(to right, #4A90E2, #007AFF)`
- Icon backgrounds: `linear-gradient(135deg, #4A90E2, #007AFF)`
- Definitions page: `linear-gradient(to right, #607D8B, #455A64)`

**Accent Colors**:
- Primary blue: `#007bff`
- Info blue: `#17a2b8` 
- Warning yellow: `#ffc107`
- Success green: `#28a745`
- Emergency red: `#d32f2f`

**Text Colors**:
- Primary: `#333`
- Secondary: `#495057`
- Headers: `#1a202c`
- Subtitles: `#4a5568`

## Component Patterns

**Form Links**:
```css
.form-guide-link {
    color: #007bff;
    padding: 0.5rem 1rem;
    background: rgba(0,123,255,0.1);
    border-radius: 6px;
    transition: all 0.3s ease;
}
.form-guide-link:hover {
    background: rgba(0,123,255,0.2);
    transform: translateX(3px);
}
```

**Alert Sections**:
```css
.alert-section {
    background: white;
    border-radius: 12px;
    padding: 2rem;
    border-left: 5px solid #ffc107;
    text-align: center;
}
```

**Home Navigation**:
```css
.nav-home {
    text-align: center;
    margin-top: 3rem;
    padding-top: 2rem;
    border-top: 2px solid rgba(255, 255, 255, 0.3);
}
.nav-home a {
    color: white;
    font-weight: 600;
    padding: 0.75rem 1.5rem;
    border: 2px solid white;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.1);
}
```

## Universal Elements

**Navbar Integration**: All pages except Crisis load `/navbar.html` into `#navbar-placeholder`

**Responsive**: `@media (max-width: 768px)` breakpoint for mobile stacking

**Typography**: Inter font family, line-height 1.6

**Container**: Max-width 900px-1000px, centered with 2rem padding