import type { Plugin } from "@opencode-ai/plugin"
import { readFile, writeFile } from "fs/promises"
import { join } from "path"

export const MacOSThemeSwitcher: Plugin = async ({ $ }) => {
  try {
    // Detect macOS appearance mode
    const result = await $`defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light"`.text()
    const isDark = result.trim() === "Dark"
    
    // Choose theme based on appearance
    const theme = isDark ? "catppuccin-macchiato" : "catppuccin"
    
    // Read current config
    const configPath = join(process.env.HOME || "~", ".config", "opencode", "opencode.json")
    const configContent = await readFile(configPath, "utf-8")
    const config = JSON.parse(configContent)
    
    // Only update if theme is different
    if (config.theme !== theme) {
      config.theme = theme
      await writeFile(configPath, JSON.stringify(config, null, 2) + "\n", "utf-8")
      console.log(`[macOS Theme Switcher] Updated theme to: ${theme}`)
    }
  } catch (error) {
    console.error("[macOS Theme Switcher] Failed to update theme:", error)
  }
  
  return {}
}
