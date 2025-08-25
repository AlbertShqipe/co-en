// app/javascript/controllers/level_filter_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["style", "category", "level"] // level = the WRAPPER div

  connect() {
    // Prefer declared targets; fall back to scoped queries INSIDE this.element
    const scope = this.element

    this.styleEl =
      (this.hasStyleTarget ? this.styleTarget : scope.querySelector('[data-level-filter-target="style"], #style select, #style')) || null

    this.categoryEl =
      (this.hasCategoryTarget ? this.categoryTarget : scope.querySelector('[data-level-filter-target="category"], #categoryInput')) || null

    // levelTarget is the WRAPPER; get the actual <select> INSIDE it
    const levelWrap = this.hasLevelTarget ? this.levelTarget : scope.querySelector('[data-level-filter-target="level"], #level')
    this.levelSelect =
      (levelWrap?.querySelector?.('select')) ||
      (levelWrap?.tagName === 'SELECT' ? levelWrap : null)

    // Get localized prompt BEFORE rebuilding options
    const existingPrompt = this.levelSelect?.querySelector?.('option[value=""]')?.textContent?.trim()
    this.promptText =
      existingPrompt ||
      this.levelSelect?.dataset?.prompt ||
      levelWrap?.dataset?.prompt || // if you put data-prompt on the wrapper instead
      this.levelSelect?.getAttribute?.('placeholder') ||
      ""

    // Listeners
    this.styleEl?.addEventListener("change", () => this.update())
    this.categoryEl?.addEventListener("change", () => this.update())

    this.update()
  }

  update() {
    const sel = this.levelSelect
    if (!sel) return

    const style = this.normalizeStyle(this.valueOf(this.styleEl))
    const category = this.valueOf(this.categoryEl)
    const allowed = RULES[style]?.[category] || []

    const prev = sel.value
    sel.innerHTML = ""

    // prompt option (always insert; uses localized prompt)
    const ph = document.createElement("option")
    ph.value = ""
    ph.textContent = this.promptText
    sel.appendChild(ph)

    // allowed options
    for (const lvl of allowed) {
      const opt = document.createElement("option")
      opt.value = opt.textContent = lvl
      sel.appendChild(opt)
    }

    sel.value = allowed.includes(prev) ? prev : ""
  }

  valueOf(el) {
    if (!el) return ""
    return el.tagName === "SELECT" ? el.value : el.querySelector?.("select")?.value || el.value || ""
  }

  normalizeStyle(s) {
    const x = (s || "").toLowerCase().trim()
    if (["classique"].includes(x)) return "Classique"
    if (["contemporain","modern’jazz","modern'jazz","modern jazz","modernjazz"].includes(x)) return "Contemporain/Modern’Jazz"
    return ""
  }
}

// minimal map
const RULES = {
  "Classique": {
    "Loisir": ["Préparatoire","Élémentaire 1","Élémentaire 2","Moyen","Avancée","Supérieur"],
    "Pré-professionnelle": ["Préparatoire","Élémentaire 1","Élémentaire 2","Élémentaire 2 – Répertoire","Moyen","Moyen – Répertoire","Avancée","Supérieur","Interprète"]
  },
  "Contemporain/Modern’Jazz": {
    "Loisir": ["Préparatoire","Élémentaire 1","Élémentaire 2","Moyen","Avancée","Supérieur"],
    "Pré-professionnelle": ["Préparatoire","Élémentaire 1","Élémentaire 2","Moyen","Supérieur","Interprète"]
  }
}
