#!/usr/bin/env bash
# ═══ setup_repos.sh — repo esterni integrati in Claude Code ═══
#
# Verifica (default, sola lettura) o ricrea su un nuovo dispositivo i repo
# elencati in Claude/Repository/README.md: clone, installazione dei tool e
# integrazione con Claude Code (plugin, server MCP).
#
# Uso:
#   ./setup_repos.sh                 menu interattivo
#   ./setup_repos.sh --check         verifica cosa manca (non modifica nulla)
#   ./setup_repos.sh --dry-run       mostra i comandi che verrebbero eseguiti
#   ./setup_repos.sh --apply         clona, installa e integra cio' che manca
#   ./setup_repos.sh --apply --yes   come sopra senza conferme [s/N]
#
# Requisiti: git, python3 (venv), node/npm, claude (CLI di Claude Code).

set -euo pipefail

VERSION="1.0.0"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="${CLAUDE_REPOS_HOME:-$HOME/.local/share/claude-repos}"
BIN_DIR="$HOME/.local/bin"

# ─── colori (solo su terminale) ───
if [[ -t 1 ]]; then
    VERDE=$'\e[32m'; ROSSO=$'\e[31m'; GIALLO=$'\e[33m'; CIANO=$'\e[36m'; RESET=$'\e[0m'
else
    VERDE=""; ROSSO=""; GIALLO=""; CIANO=""; RESET=""
fi
ok()   { echo "${VERDE}[OK]${RESET} $*"; }
err()  { echo "${ROSSO}[ERR]${RESET} $*" >&2; }
warn() { echo "${GIALLO}[!]${RESET} $*"; }
info() { echo "${CIANO}>>${RESET} $*"; }

MODE="check"; YES=0; NON_INTERACTIVE=0; MANCANTI=0; ERRORI=0
[[ -t 0 ]] || NON_INTERACTIVE=1

# ═══ HELP ═══
usage() {
    cat <<EOF
uso: setup_repos.sh [--check | --dry-run | --apply] [-y] [-n] [-h] [--version]

Verifica o ricrea i repo esterni integrati in Claude Code (Claude/Repository/).

Modalita':
  -c, --check            verifica cosa e' presente e cosa manca (default, sola lettura)
  -d, --dry-run          SIMULAZIONE: stampa i comandi esatti senza eseguirli
  -a, --apply            clona, installa e integra cio' che manca; aggiorna i clone esistenti

Esecuzione:
  -y, --yes              salta le conferme [s/N] (non attiva le modifiche: serve --apply)
  -n, --non-interactive  mai prompt; automatico se stdin non e' un terminale
  -h, --help, help       mostra questa guida
      --version          mostra la versione

═══ REPO GESTITI ═══
  omni-route       diegosouzapw/OmniRoute            CLI 'omniroute' (npm, prefix utente)
  frontend-design  anthropics/claude-plugins-official  plugin frontend-design@claude-plugins-official
  headroom         chopratejas/headroom              CLI 'headroom' (venv) + MCP 'headroom'
  mempalace        mempalace/mempalace               CLI 'mempalace' (venv) + plugin mempalace@mempalace
  playwright-mcp   microsoft/playwright-mcp          MCP 'playwright' (npx @playwright/mcp@latest)

═══ ESEMPI ═══
  Nuovo dispositivo, guidato:        ./setup_repos.sh
  Solo controllo:                    ./setup_repos.sh --check
  Anteprima dei comandi:             ./setup_repos.sh --dry-run
  Installazione completa:            ./setup_repos.sh --apply
  Automatico (cron/altri script):    ./setup_repos.sh --apply --yes --non-interactive

═══ FILE GENERATI ═══
  Claude/Repository/<repo>/          clone dei repo (esclusi dal backup git di Claude/)
  $TOOLS_DIR/venvs/                  virtualenv di headroom e mempalace
  $TOOLS_DIR/npm/                    installazione npm di omniroute
  $BIN_DIR/                          link a headroom, mempalace, mempalace-mcp, omniroute
  ~/.claude.json, ~/.claude/         configurazione MCP e plugin di Claude Code (scope utente)

  Variabile CLAUDE_REPOS_HOME: cambia la cartella dei tool (default ~/.local/share/claude-repos).

═══ CODICI DI USCITA ═══
  0  tutto presente / operazioni riuscite
  1  errore di esecuzione, oppure in --check manca qualcosa
  2  uso errato o dipendenza mancante
  130 interrotto con Ctrl+C
EOF
}

trap 'echo; warn "Interrotto dall utente."; exit 130' INT

# ─── parsing flag ───
ARG_COUNT=$#
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--check) MODE="check" ;;
        -d|--dry-run) MODE="dry-run" ;;
        -a|--apply) MODE="apply" ;;
        -y|--yes) YES=1 ;;
        -n|--non-interactive) NON_INTERACTIVE=1 ;;
        -h|--help|help) usage; exit 0 ;;
        --version) echo "setup_repos.sh $VERSION"; exit 0 ;;
        *) err "Opzione non riconosciuta: $1 (vedi --help)"; exit 2 ;;
    esac
    shift
done

# ═══ HELPER ═══
ask_yesno() {
    # ask_yesno "domanda" -> 0 se si', default No
    [[ $YES -eq 1 ]] && return 0
    [[ $NON_INTERACTIVE -eq 1 ]] && return 1
    local r
    while true; do
        read -r -p "▶ $1 [s/N]: " r || return 1
        case "${r,,}" in
            s|si|sì) return 0 ;;
            ""|n|no) return 1 ;;
            *) echo "Risposta non valida — digitare 's' o 'n'" ;;
        esac
    done
}

# esegue un comando in base alla modalita' (check: non fa nulla; dry-run: stampa)
run() {
    case "$MODE" in
        dry-run) echo "  [SIMULAZIONE] $*" ;;
        apply)
            info "$*"
            if ! "$@"; then err "Comando fallito: $*"; ERRORI=$((ERRORI + 1)); return 1; fi ;;
    esac
    return 0
}

# segnala un elemento mancante e, se si applica, chiede conferma
manca() {
    warn "Manca: $1"
    MANCANTI=$((MANCANTI + 1))
    [[ "$MODE" == "check" ]] && return 1
    [[ "$MODE" == "dry-run" ]] && return 0
    ask_yesno "Procedo con: $1?"
}

claude_home() { (cd "$HOME" && "$@"); }  # evita che Claude legga .mcp.json della cartella corrente

check_deps() {
    local mancanti=()
    for d in git python3 node npm npx claude; do
        command -v "$d" >/dev/null 2>&1 || mancanti+=("$d")
    done
    if [[ ${#mancanti[@]} -gt 0 ]]; then
        err "Dipendenze mancanti: ${mancanti[*]}"
        err "Installa: sudo apt install git python3-venv nodejs npm  ·  Claude Code: npm i -g @anthropic-ai/claude-code"
        exit 2
    fi
}

# ═══ STEP 1 — clone ═══
clone_repo() {
    local nome="$1" url="$2" sparse="${3:-}"
    local dir="$BASE_DIR/$nome"
    if [[ -d "$dir/.git" ]]; then
        ok "Clone presente: $nome"
        [[ "$MODE" != "check" ]] && run git -C "$dir" pull --ff-only --quiet || true
        return
    fi
    manca "clone di $nome ($url)" || return 0
    if [[ -n "$sparse" ]]; then
        run git clone --depth 1 --filter=blob:none --sparse "$url" "$dir" && \
        run git -C "$dir" sparse-checkout set "$sparse"
    else
        run git clone --depth 1 "$url" "$dir"
    fi
}

# ═══ STEP 2 — installazione tool ═══
install_venv() {
    local nome="$1" pacchetto="$2"; shift 2
    local venv="$TOOLS_DIR/venvs/$nome"
    if [[ -x "$venv/bin/$1" ]]; then
        ok "Tool installato: $nome ($venv)"
    elif manca "installazione $pacchetto in $venv"; then
        run python3 -m venv "$venv" && \
        run "$venv/bin/pip" install -q -U pip && \
        run "$venv/bin/pip" install -q "$pacchetto"
    fi
    for b in "$@"; do link_bin "$venv/bin/$b"; done
}

install_omniroute() {
    local bin="$TOOLS_DIR/npm/bin/omniroute"
    if [[ -x "$bin" ]]; then
        ok "Tool installato: omniroute ($bin)"
    elif manca "installazione npm di omniroute in $TOOLS_DIR/npm"; then
        run npm install -g --prefix "$TOOLS_DIR/npm" omniroute
    fi
    link_bin "$bin"
}

link_bin() {
    local src="$1" dst="$BIN_DIR/$(basename "$1")"
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then return; fi
    manca "link $dst" || return 0
    run mkdir -p "$BIN_DIR" && run ln -sf "$src" "$dst"
}

# ═══ STEP 3 — integrazione con Claude Code ═══
PLUGIN_LIST=""; MCP_LIST=""; MARKET_LIST=""
load_claude_state() {
    PLUGIN_LIST="$(claude_home claude plugin list 2>/dev/null || true)"
    MARKET_LIST="$(claude_home claude plugin marketplace list 2>/dev/null || true)"
    MCP_LIST="$(claude_home claude mcp list 2>/dev/null || true)"
}

integra_plugin() {
    local plugin="$1" marketplace="$2" sorgente="$3"
    if ! grep -q "$marketplace" <<<"$MARKET_LIST"; then
        manca "marketplace $marketplace ($sorgente)" && run claude_home claude plugin marketplace add "$sorgente"
    fi
    if grep -q "$plugin@$marketplace" <<<"$PLUGIN_LIST"; then
        ok "Plugin integrato: $plugin@$marketplace"
    elif manca "plugin $plugin@$marketplace"; then
        run claude_home claude plugin install "$plugin@$marketplace"
    fi
}

integra_mcp() {
    local nome="$1"; shift
    if grep -q "^$nome:" <<<"$MCP_LIST"; then
        ok "MCP integrato: $nome"
    elif manca "server MCP $nome"; then
        run claude_home "$@"
    fi
}

# ═══ MAIN ═══
esegui() {
    check_deps
    [[ "$MODE" == "apply" ]] && warn "MODALITA' APPLY — verranno apportate modifiche"
    [[ "$MODE" == "dry-run" ]] && warn "SIMULAZIONE — nessuna modifica"

    echo; info "STEP 1 — clone dei repo in $BASE_DIR"
    clone_repo omni-route      https://github.com/diegosouzapw/OmniRoute.git
    clone_repo frontend-design https://github.com/anthropics/claude-plugins-official.git plugins/frontend-design
    clone_repo headroom        https://github.com/chopratejas/headroom.git
    clone_repo mempalace       https://github.com/mempalace/mempalace.git
    clone_repo playwright-mcp  https://github.com/microsoft/playwright-mcp.git

    echo; info "STEP 2 — installazione dei tool"
    install_venv mempalace mempalace mempalace mempalace-mcp
    install_venv headroom "headroom-ai[mcp]" headroom
    install_omniroute

    echo; info "STEP 3 — integrazione con Claude Code"
    load_claude_state
    integra_plugin frontend-design claude-plugins-official anthropics/claude-plugins-official
    integra_plugin mempalace mempalace MemPalace/mempalace
    integra_mcp playwright claude mcp add -s user playwright -- npx @playwright/mcp@latest
    integra_mcp headroom "$TOOLS_DIR/venvs/headroom/bin/headroom" mcp install --agent claude

    echo
    case ":$PATH:" in *":$BIN_DIR:"*) ;; *) warn "$BIN_DIR non e' nel PATH: rifai il login o aggiungilo (serve agli hook di MemPalace)." ;; esac
    if [[ "$MODE" == "check" && $MANCANTI -gt 0 ]]; then
        warn "Mancano $MANCANTI elementi. Esegui: $0 --apply"; return 1
    fi
    if [[ $ERRORI -gt 0 ]]; then err "$ERRORI comandi falliti (vedi sopra)."; return 1; fi
    ok "Fatto. Riavvia Claude Code per caricare plugin e server MCP nuovi."
}

menu() {
    echo "═══ Repo esterni per Claude Code — v$VERSION ═══"
    echo "  1) Verifica cosa manca (sola lettura)"
    echo "  2) Simulazione (mostra i comandi)"
    echo "  3) Installa e integra cio' che manca"
    echo "  0) Esci"
    local s
    read -r -p "▶ Scelta [1]: " s || s=0
    case "${s:-1}" in
        1) MODE="check" ;;
        2) MODE="dry-run" ;;
        3) MODE="apply" ;;
        0) exit 0 ;;
        *) err "Scelta non valida"; exit 2 ;;
    esac
}

# senza argomenti da terminale -> menu
[[ $ARG_COUNT -eq 0 && $NON_INTERACTIVE -eq 0 ]] && menu
esegui
