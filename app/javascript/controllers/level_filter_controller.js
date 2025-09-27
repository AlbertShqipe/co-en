// app/javascript/controllers/level_filter_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["style", "category", "level"] // level = WRAPPER div (not the select)

  connect() {
    const scope = this.element

    // Resolve SELECT elements (prefer targets, then scoped fallbacks)
    this.styleEl =
      (this.hasStyleTarget
        ? (this.styleTarget.tagName === "SELECT" ? this.styleTarget : this.styleTarget.querySelector("select"))
        : scope.querySelector('[data-level-filter-target="style"] select, #individual_form_style')) || null

    this.categoryEl =
      (this.hasCategoryTarget
        ? (this.categoryTarget.tagName === "SELECT" ? this.categoryTarget : this.categoryTarget.querySelector("select"))
        : scope.querySelector('[data-level-filter-target="category"] select, #individual_form_category')) || null

    const levelWrap =
      (this.hasLevelTarget ? this.levelTarget : scope.querySelector('[data-level-filter-target="level"]')) || null

    this.levelSelect =
      (levelWrap?.tagName === "SELECT" ? levelWrap : levelWrap?.querySelector?.("select")) || null

    // Localized prompt (Rails) BEFORE we rebuild
    const existingPrompt = this.levelSelect?.querySelector?.('option[value=""]')?.textContent?.trim()
    this.promptText =
      existingPrompt ||
      this.levelSelect?.dataset?.prompt ||
      levelWrap?.dataset?.prompt ||
      ""

    // Listeners
    this.styleEl?.addEventListener("change", () => this.update())
    this.categoryEl?.addEventListener("change", () => this.update())

    this.update()
  }

  update() {
    const sel = this.levelSelect
    if (!sel) return

    const style    = this.normalizeStyle(this.valueOf(this.styleEl))
    const category = this.valueOf(this.categoryEl)
    const allowed  = RULES[style]?.[category] || []

    const prev = sel.value
    sel.innerHTML = ""

    // Always insert localized prompt
    const ph = document.createElement("option")
    ph.value = ""
    ph.textContent = this.promptText
    sel.appendChild(ph)

    // Insert allowed options
    for (const lvl of allowed) {
      const opt = document.createElement("option")
      opt.value = opt.textContent = lvl
      sel.appendChild(opt)
    }

    // Restore previous if still valid; otherwise show prompt
    sel.value = allowed.includes(prev) ? prev : ""
  }

  valueOf(el) {
    if (!el) return ""
    return el.tagName === "SELECT" ? el.value : el.querySelector?.("select")?.value || el.value || ""
  }

  normalizeStyle(s) {
    const x = (s || "").toLowerCase().trim()
    if (["classique","caractère","caractere"].includes(x)) return "Classique"
    if (["contemporain","modern’jazz","modern'jazz","modern jazz","modernjazz"].includes(x)) return "Contemporain/Modern’Jazz"
    return ""
  }
}

// Minimal map of levels per (style, category)
const RULES = {
  "Classique": {
    "Loisir": ["Préparatoire","Élémentaire 1","Élémentaire 2","Moyen","Avancée","Supérieur"],
    "Pré-professionnelle": ["Préparatoire","Élémentaire 1","Élémentaire 2","Élémentaire 2 – Répertoire","Moyen","Moyen - Répertoire","Avancée","Supérieur","Interprète"]
  },
  "Contemporain/Modern’Jazz": {
    "Loisir": ["Préparatoire","Élémentaire 1","Élémentaire 2","Moyen","Avancée","Supérieur"],
    "Pré-professionnelle": ["Préparatoire","Élémentaire 1","Élémentaire 2","Moyen","Supérieur","Interprète"]
  }
}
