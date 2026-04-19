from pathlib import Path
import sys


root = Path(sys.argv[1])


def replace_exact(text: str, old: str, new: str, file_name: str) -> str:
    if old not in text:
        raise RuntimeError(f"Expected text not found in {file_name}: {old[:120]!r}")
    return text.replace(old, new)


skill_path = root / "SKILL.md"
skill = skill_path.read_text(encoding="utf-8")
skill = replace_exact(
    skill,
    "across 10 stacks (React, Next.js, Vue, Svelte, SwiftUI, React Native, Flutter, Tailwind, shadcn/ui, and HTML/CSS)",
    "across multiple supported stacks",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "across 10 technology stacks.",
    "across multiple technology stacks.",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "- **Stack**: React Native (this project's only tech stack)",
    "- **Stack**: Choose the closest supported stack for the implementation surface (for example `react`, `nextjs`, `vue`, `react-native`, or `flutter`)",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "This creates:\n- `design-system/MASTER.md` — Global Source of Truth with all design rules\n- `design-system/pages/` — Folder for page-specific overrides",
    "This creates:\n- `design-system/<project-slug>/MASTER.md` — Global Source of Truth with all design rules\n- `design-system/<project-slug>/pages/` — Folder for page-specific overrides\n\n`<project-slug>` is derived from `-p/--project-name` by lowercasing and replacing spaces with `-`.",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "This also creates:\n- `design-system/pages/dashboard.md` — Page-specific deviations from Master",
    "This also creates:\n- `design-system/<project-slug>/pages/dashboard.md` — Page-specific deviations from Master",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "1. When building a specific page (e.g., \"Checkout\"), first check `design-system/pages/checkout.md`\n2. If the page file exists, its rules **override** the Master file\n3. If not, use `design-system/MASTER.md` exclusively",
    "1. When building a specific page (e.g., \"Checkout\"), first check `design-system/<project-slug>/pages/checkout.md`\n2. If the page file exists, its rules **override** the Master file\n3. If not, use `design-system/<project-slug>/MASTER.md` exclusively",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "I am building the [Page Name] page. Please read design-system/MASTER.md.\nAlso check if design-system/pages/[page-name].md exists.",
    "I am building the [Page Name] page. Please read design-system/[project-slug]/MASTER.md.\nAlso check if design-system/[project-slug]/pages/[page-name].md exists.",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    '| AI prompt / CSS keywords | `prompt` | `--domain prompt "minimalism"` |',
    '| Icon search / library usage | `icons` | `--domain icons "navigation settings outline"` |',
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "### Step 4: Stack Guidelines (React Native)\n\nGet React Native implementation-specific best practices:\n\n```bash\npython3 skills/ui-ux-pro-max/scripts/search.py \"<keyword>\" --stack react-native\n```",
    "### Step 4: Stack Guidelines\n\nGet stack-specific best practices for the framework you are actually using:\n\n```bash\npython3 skills/ui-ux-pro-max/scripts/search.py \"<keyword>\" --stack <stack>\n```",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "| `google-fonts` | Individual Google Fonts lookup | sans serif, monospace, japanese, variable font, popular |\n| `react` | React/Next.js performance | waterfall, bundle, suspense, memo, rerender, cache |\n| `web` | App interface guidelines (iOS/Android/React Native) | accessibilityLabel, touch targets, safe areas, Dynamic Type |\n| `prompt` | AI prompts, CSS keywords | (style name) |",
    "| `google-fonts` | Individual Google Fonts lookup | sans serif, monospace, japanese, variable font, popular |\n| `icons` | Icon search and usage guidance | navigation, settings, search, outline, filled |\n| `react` | React/Next.js performance | waterfall, bundle, suspense, memo, rerender, cache |\n| `web` | App interface guidelines (iOS/Android/React Native) | accessibilityLabel, touch targets, safe areas, Dynamic Type |",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "### Available Stacks\n\n| Stack | Focus |\n|-------|-------|\n| `react-native` | Components, Navigation, Lists |",
    "### Available Stacks\n\nSupported stacks: `react`, `nextjs`, `vue`, `svelte`, `astro`, `swiftui`, `react-native`, `flutter`, `nuxtjs`, `nuxt-ui`, `html-tailwind`, `shadcn`, `jetpack-compose`, `threejs`, `angular`, `laravel`",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "- Stack: React Native",
    "- Stack: `react` for a web homepage (or swap to another supported stack if needed)",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    'python3 skills/ui-ux-pro-max/scripts/search.py "list performance navigation" --stack react-native',
    'python3 skills/ui-ux-pro-max/scripts/search.py "list performance navigation" --stack react',
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "- Always add `--stack react-native` for implementation-specific guidance",
    "- Add `--stack <stack>` for implementation-specific guidance once you know the target framework",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "These are frequently overlooked issues that make UI look unprofessional:\nScope notice: The rules below are for App UI (iOS/Android/React Native/Flutter), not desktop-web interaction patterns.",
    "These are frequently overlooked issues that make UI look unprofessional:\nScope notice: The rules below emphasize app-style and cross-platform interface quality. For desktop-web specific interaction patterns, adapt the guidance to the conventions of your target stack.",
    "SKILL.md",
)
skill = replace_exact(
    skill,
    "Before delivering UI code, verify these items:\nScope notice: This checklist is for App UI (iOS/Android/React Native/Flutter).",
    "Before delivering UI code, verify these items:\nScope notice: This checklist is written for cross-platform UI work. Apply the mobile-specific items when building native/app-like surfaces, and adapt them for desktop-web when appropriate.",
    "SKILL.md",
)
skill_path.write_text(skill, encoding="utf-8")

search_path = root / "scripts" / "search.py"
search = search_path.read_text(encoding="utf-8")
search = replace_exact(
    search,
    "Domains: style, prompt, color, chart, landing, product, ux, typography, google-fonts\nStacks: react, nextjs, vue, svelte, astro, swiftui, react-native, flutter, nuxtjs, nuxt-ui, html-tailwind, shadcn, jetpack-compose, threejs\n\nPersistence (Master + Overrides pattern):\n  --persist    Save design system to design-system/MASTER.md\n  --page       Also create a page-specific override file in design-system/pages/",
    "Domains: style, color, chart, landing, product, ux, typography, icons, react, web, google-fonts\nStacks: react, nextjs, vue, svelte, astro, swiftui, react-native, flutter, nuxtjs, nuxt-ui, html-tailwind, shadcn, jetpack-compose, threejs, angular, laravel\n\nPersistence (Master + Overrides pattern):\n  --persist    Save design system to design-system/<project-slug>/MASTER.md\n  --page       Also create a page-specific override file in design-system/<project-slug>/pages/",
    "scripts/search.py",
)
search = replace_exact(
    search,
    '    parser.add_argument("--persist", action="store_true", help="Save design system to design-system/MASTER.md (creates hierarchical structure)")\n    parser.add_argument("--page", type=str, default=None, help="Create page-specific override file in design-system/pages/")',
    '    parser.add_argument("--persist", action="store_true", help="Save design system to design-system/<project-slug>/MASTER.md")\n    parser.add_argument("--page", type=str, default=None, help="Create page-specific override file in design-system/<project-slug>/pages/")',
    "scripts/search.py",
)
search = replace_exact(
    search,
    "            print(\"\\n\" + \"=\" * 60)\n            print(f\"✅ Design system persisted to design-system/{project_slug}/\")\n            print(f\"   📄 design-system/{project_slug}/MASTER.md (Global Source of Truth)\")\n            if args.page:\n                page_filename = args.page.lower().replace(' ', '-')\n                print(f\"   📄 design-system/{project_slug}/pages/{page_filename}.md (Page Overrides)\")\n            print(\"\")\n            print(f\"📖 Usage: When building a page, check design-system/{project_slug}/pages/[page].md first.\")\n            print(f\"   If exists, its rules override MASTER.md. Otherwise, use MASTER.md.\")\n            print(\"=\" * 60)",
    "            print(\"\\n\" + \"=\" * 60)\n            output_root = args.output_dir or \".\"\n            print(f\"✅ Design system persisted to {output_root}/design-system/{project_slug}/\")\n            print(f\"   📄 {output_root}/design-system/{project_slug}/MASTER.md (Global Source of Truth)\")\n            if args.page:\n                page_filename = args.page.lower().replace(' ', '-')\n                print(f\"   📄 {output_root}/design-system/{project_slug}/pages/{page_filename}.md (Page Overrides)\")\n            print(\"\")\n            print(f\"📖 Usage: When building a page, check {output_root}/design-system/{project_slug}/pages/[page].md first.\")\n            print(f\"   If exists, its rules override MASTER.md. Otherwise, use MASTER.md.\")\n            print(\"=\" * 60)",
    "scripts/search.py",
)
search_path.write_text(search, encoding="utf-8")

design_system_path = root / "scripts" / "design_system.py"
design_system = design_system_path.read_text(encoding="utf-8")
design_system = replace_exact(
    design_system,
    '    project = design_system.get("project_name", "PROJECT")\n    pattern = design_system.get("pattern", {})',
    """    project = design_system.get(\"project_name\", \"PROJECT\")
    project_slug = project.lower().replace(' ', '-')
    pattern = design_system.get(\"pattern\", {})""",
    "scripts/design_system.py",
)
design_system = replace_exact(
    design_system,
    '    lines.append(\"> **LOGIC:** When building a specific page, first check `design-system/pages/[page-name].md`.\")',
    '    lines.append(f\"> **LOGIC:** When building a specific page, first check `design-system/{project_slug}/pages/[page-name].md`.\")',
    "scripts/design_system.py",
)
design_system = replace_exact(
    design_system,
    '    project = design_system.get("project_name", "PROJECT")\n    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")',
    """    project = design_system.get(\"project_name\", \"PROJECT\")
    project_slug = project.lower().replace(' ', '-')
    timestamp = datetime.now().strftime(\"%Y-%m-%d %H:%M:%S\")""",
    "scripts/design_system.py",
)
design_system = replace_exact(
    design_system,
    '    lines.append(\"> ⚠️ **IMPORTANT:** Rules in this file **override** the Master file (`design-system/MASTER.md`).\")',
    '    lines.append(f\"> ⚠️ **IMPORTANT:** Rules in this file **override** the Master file (`design-system/{project_slug}/MASTER.md`).\")',
    "scripts/design_system.py",
)
design_system_path.write_text(design_system, encoding="utf-8")
