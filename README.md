# dot

[![Lint](https://github.com/zsltg/dot/actions/workflows/lint.yml/badge.svg)](https://github.com/zsltg/dot/actions/workflows/lint.yml)
[![Install](https://github.com/zsltg/dot/actions/workflows/install.yml/badge.svg)](https://github.com/zsltg/dot/actions/workflows/install.yml)
[![License: MIT-0](https://img.shields.io/github/license/zsltg/dot)](LICENSE)

Dotfiles and tool installs for Linux (Ubuntu) and macOS, managed with [chezmoi](https://www.chezmoi.io/).

## Install on a new machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply zsltg/dot
```

chezmoi asks these questions once. It keeps the answers in `~/.config/chezmoi/chezmoi.toml`.

| Prompt | What it does |
|---|---|
| `name`, `email` | Git author in `~/.gitconfig`. |
| `dev` | Installs the dev tools: linters, cargo tools, pnpm, bun, deno, gh, lazygit, act, ruff, oha. |
| `ai` | Installs claude-code, codex, pi, herdr and crit. |
| `docker` | Installs docker-ce from the Docker apt repo on Linux, or colima and the docker CLI on macOS. |

To change an answer, edit `~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.

On macOS, the first run can stop and ask you to install the Xcode Command Line Tools. Install them, then run `chezmoi apply` again.

## What installs what

- **Homebrew** installs the CLI tools on Linux and macOS. It installs their man pages and zsh completions too.
- **mise** installs node, ruby and go, and the tools that Homebrew does not have (`cargo:`, `go:`, `npm:`, `github:`, `pipx:` backends).
- **rustup** installs Rust.
- **antidote** loads the zsh plugins in `~/.zsh_plugins.txt`. These are some Oh My Zsh libraries and plugins, zsh-autosuggestions and zsh-syntax-highlighting.
- **Alacritty**: a script builds the latest release on Linux and macOS, because Homebrew has no Alacritty for Linux and disabled the macOS cask. The script also installs the terminfo, man pages and completion, and on Linux the desktop entry. On macOS it copies `Alacritty.app` to `/Applications`.
- **SauceCodePro Nerd Font Mono** comes from a Homebrew cask on macOS. On Linux, chezmoi downloads it to `~/.local/share/fonts`.

The package list is in `home/.chezmoidata/packages.yaml`. Add or remove a tool there, then run `chezmoi apply`. The install script runs again when the list changes.

## Installed tools

Each entry shows the command name, with a link to the source repository of the tool. The core tools install on each machine. The other groups install only when you select them (see the prompts at the start).

### Core: files, search, diff

- [bat](https://github.com/sharkdp/bat): Shows files with syntax highlighting and git changes, like `cat`.
- [bat-extras](https://github.com/eth-p/bat-extras): Adds scripts that use bat with other tools, for example `batgrep` and `batman`.
- [delta](https://github.com/dandavison/delta): Shows `git` and `diff` output with syntax highlighting and line numbers.
- [difft](https://github.com/Wilfred/difftastic): Compares files by their syntax, not line by line.
- [dust](https://github.com/bootandy/dust): Shows which directories use the most disk space, like `du`.
- [dysk](https://github.com/Canop/dysk): Shows the filesystems with their size and free space, like `df`.
- [eza](https://github.com/eza-community/eza): Lists files, as a maintained replacement for `ls`.
- [fd](https://github.com/sharkdp/fd): Finds files by name, as a fast and simple alternative to `find`.
- [hexyl](https://github.com/sharkdp/hexyl): Shows the bytes of a file in hexadecimal, with colors.
- [mc](https://github.com/MidnightCommander/mc): Manages files in two panels in the terminal.
- [ouch](https://github.com/ouch-org/ouch): Compresses and extracts archives in many formats with one command.
- [rg](https://github.com/BurntSushi/ripgrep): Searches the contents of files with a regular expression, fast and with `.gitignore` support.
- [rga](https://github.com/phiresky/ripgrep-all): Searches with ripgrep in PDFs, archives, Office documents and other file types.
- [sd](https://github.com/chmln/sd): Finds and replaces text with a simpler syntax than `sed`.

### Core: processes

- [btm](https://github.com/ClementTsang/bottom): Shows CPU, memory, network and process usage in a terminal dashboard.
- [procs](https://github.com/dalance/procs): Lists processes, as a modern replacement for `ps`.
- [witr](https://github.com/pranshuparmar/witr): Explains why a process or port is active, from its chain of parent processes.

### Core: structured data

- [fx](https://github.com/antonmedv/fx): Shows and explores JSON in the terminal.
- [gron](https://github.com/tomnomnom/gron): Converts JSON to single lines, so that you can search it with `grep`.
- [jaq](https://github.com/01mf02/jaq): Runs jq filters, with a focus on correctness, speed and simplicity.
- [jc](https://github.com/kellyjonbrazil/jc): Converts the output of common command-line tools to JSON.
- [jq](https://github.com/jqlang/jq): Queries and changes JSON data.
- [jqfmt](https://github.com/noperator/jqfmt): Formats jq filters.
- [jqp](https://github.com/noahgorstein/jqp): Gives an interactive terminal UI to write and try jq queries.
- [mlr](https://github.com/johnkerl/miller): Processes CSV, TSV and JSON records by field name, like `awk`, `sed`, `cut` and `sort`.
- [sq](https://github.com/neilotoole/sq): Queries databases and data files with a jq-like language.
- [yq](https://github.com/mikefarah/yq): Queries and changes YAML, JSON, XML, CSV and properties files.

### Core: other tools

- [bfif](https://github.com/trapexit/bfif) (Linux, x86_64): Finds images with a brute-force search.
- [biodiff](https://github.com/8051Enthusiast/biodiff): Compares binary files with alignment algorithms from biology.
- [ck](https://github.com/BeaconBay/ck): Searches code by meaning with embeddings, and by keywords.
- [croc](https://github.com/schollz/croc): Sends files from one computer to another computer securely.
- [dive](https://github.com/wagoodman/dive): Shows the layers of a Docker image and the files in each layer.
- [fq](https://github.com/wader/fq): Queries binary formats with a jq-like language.
- [glow](https://github.com/charmbracelet/glow): Shows Markdown files in the terminal.
- [harlequin](https://github.com/tconbeer/harlequin): Gives an SQL IDE in the terminal.
- [http](https://github.com/httpie/cli): Sends HTTP requests with a simple syntax, as an alternative to `curl`.
- [hyperfine](https://github.com/sharkdp/hyperfine): Measures and compares the run time of commands.
- [just](https://github.com/casey/just): Runs the commands of a project from a `justfile`.
- [magika](https://github.com/google/magika): Finds the content type of files with an AI model.
- [markitdown](https://github.com/microsoft/markitdown): Converts files such as PDF, Word and Excel documents to Markdown.
- [pandoc](https://github.com/jgm/pandoc): Converts documents between markup formats, for example Markdown, HTML and DOCX.
- [tldr](https://github.com/tldr-pages/tlrc): Shows short command examples from the tldr pages.

### Core: shell, editor, runtimes

- [antidote](https://github.com/mattmc3/antidote): Loads zsh plugins from a list and makes one static plugin file.
- [cargo-binstall](https://github.com/cargo-bins/cargo-binstall): Installs Rust binaries from release archives, without a build.
- [fzf](https://github.com/junegunn/fzf): Selects items from a list with fuzzy search, for example files and shell history.
- [go](https://github.com/golang/go): Compiles and runs programs in the Go programming language.
- [mise](https://github.com/jdx/mise): Installs runtimes and tools for each project, for example Node.js and Go.
- [node](https://github.com/nodejs/node) (LTS): Runs JavaScript outside of a browser.
- [nvim](https://github.com/neovim/neovim): Edits text, as a Vim fork with a focus on extensibility.
- [ruby](https://github.com/ruby/ruby) (3.3): Runs programs in the Ruby programming language.
- [starship](https://github.com/starship/starship): Shows a fast shell prompt with information about the current directory.
- [tmux](https://github.com/tmux/tmux): Runs many terminal sessions in one window and keeps them after you disconnect.
- [tree-sitter](https://github.com/tree-sitter/tree-sitter): Builds the tree-sitter parsers that Neovim uses for syntax highlighting.
- [uv](https://github.com/astral-sh/uv): Installs Python, Python packages and Python tools, fast.
- [zoxide](https://github.com/ajeetdsouza/zoxide): Changes to directories that you use frequently, as a smarter `cd`.

### dev group

- [act](https://github.com/nektos/act): Runs GitHub Actions workflows on your computer.
- [actionlint](https://github.com/rhysd/actionlint): Finds errors in GitHub Actions workflow files.
- [agg](https://github.com/asciinema/agg): Converts asciinema recordings to GIF files.
- [asciinema](https://github.com/asciinema/asciinema): Records terminal sessions and shares them.
- [ast-grep](https://github.com/ast-grep/ast-grep): Searches, lints and rewrites code by its syntax tree.
- [bun](https://github.com/oven-sh/bun): Runs, bundles, tests and installs JavaScript and TypeScript code.
- [cargo-auditable](https://github.com/rust-secure-code/cargo-auditable): Puts the dependency list into Rust binaries, so that you can audit them.
- [cargo-deny](https://github.com/EmbarkStudios/cargo-deny): Lints the dependencies of Rust projects, for example their licenses and security advisories.
- [cargo-fuzz](https://github.com/rust-fuzz/cargo-fuzz): Runs fuzz tests for Rust code.
- [cargo-geiger](https://github.com/geiger-rs/cargo-geiger): Finds unsafe Rust code in a crate and its dependencies.
- [cargo-insta](https://github.com/mitsuhiko/insta): Reviews and updates snapshot tests in Rust.
- [cargo-llvm-cov](https://github.com/taiki-e/cargo-llvm-cov): Measures the code coverage of Rust tests with LLVM.
- [cargo-machete](https://github.com/bnjbvr/cargo-machete): Finds unused dependencies in Rust projects.
- [cargo-mutants](https://github.com/sourcefrog/cargo-mutants): Adds bugs to Rust code to find out if the tests catch them.
- [ccache](https://github.com/ccache/ccache): Makes C and C++ builds faster with a compiler cache.
- [cloc](https://github.com/AlDanial/cloc): Counts the lines of code, comments and blank lines for each language.
- [cpanm](https://github.com/miyagawa/cpanminus): Installs Perl modules from CPAN. It installs Perl::Critic for the Perl language server in Neovim.
- [dagger](https://github.com/dagger/dagger): Runs CI/CD pipelines as code, on your computer and in CI.
- [deno](https://github.com/denoland/deno): Runs JavaScript and TypeScript in a secure runtime.
- [gh](https://github.com/cli/cli): Works with GitHub pull requests, issues and repositories from the terminal.
- [git-chglog](https://github.com/git-chglog/git-chglog): Makes a CHANGELOG from git tags and commits.
- [git-filter-repo](https://github.com/newren/git-filter-repo): Rewrites the history of a git repository.
- [gitleaks](https://github.com/gitleaks/gitleaks): Finds secrets, such as API keys, in git repositories.
- [gofumpt](https://github.com/mvdan/gofumpt): Formats Go code with stricter rules than `gofmt`.
- [goimports](https://github.com/golang/tools): Formats Go code and adds or removes import lines.
- [golangci-lint](https://github.com/golangci/golangci-lint): Runs many Go linters with one command.
- [govulncheck](https://github.com/golang/vuln): Finds known vulnerabilities in Go code and its dependencies.
- [gremlins](https://github.com/go-gremlins/gremlins): Runs mutation tests for Go code.
- [java](https://github.com/adoptium/temurin-build) (Temurin 21): Runs Java programs. The Java and Kotlin language servers in Neovim need it.
- [lazygit](https://github.com/jesseduffield/lazygit): Gives a terminal UI for git commands.
- [lightpanda](https://github.com/lightpanda-io/browser): Runs a headless browser for automation and AI agents.
- [mdbook](https://github.com/rust-lang/mdBook): Makes online books from Markdown files.
- [mdbook-mermaid](https://github.com/badboy/mdbook-mermaid): Adds Mermaid diagrams to mdBook.
- [oha](https://github.com/hatoo/oha): Sends HTTP load to a web server and shows the results live.
- [osv-scanner](https://github.com/google/osv-scanner): Finds known vulnerabilities in project dependencies with the OSV database.
- [perl](https://github.com/Perl/perl5): Runs programs in the Perl programming language.
- [pnpm](https://github.com/pnpm/pnpm): Installs JavaScript packages fast and with less disk space.
- [rubocop](https://github.com/rubocop/rubocop): Lints and formats Ruby code. Neovim uses it as a language server.
- [ruff](https://github.com/astral-sh/ruff): Lints and formats Python code, fast.
- [semgrep](https://github.com/semgrep/semgrep): Finds bugs and security problems in code with pattern rules.
- [shellcheck](https://github.com/koalaman/shellcheck): Finds bugs and unsafe code in shell scripts.
- [solargraph](https://github.com/castwide/solargraph): Gives editors Ruby language features through LSP.
- [svu](https://github.com/caarlos0/svu): Calculates the next semantic version from git tags and commits.
- [syft](https://github.com/anchore/syft): Makes a software bill of materials (SBOM) from container images and file systems.
- [taplo](https://github.com/tamasfe/taplo): Formats and validates TOML files.
- [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server): Gives editors TypeScript and JavaScript language features through LSP.
- [wasm-pack](https://github.com/wasm-bindgen/wasm-pack): Builds Rust code into WebAssembly packages for JavaScript.
- [yt-dlp](https://github.com/yt-dlp/yt-dlp): Downloads audio and video from many websites.
- [zizmor](https://github.com/zizmorcore/zizmor): Finds security problems in GitHub Actions workflows.

### ai group

- [caveman](https://github.com/JuliusBrussee/caveman): Wraps coding agents with context compression and token metering.
- [claude](https://github.com/anthropics/claude-code) (macOS: Homebrew cask, Linux: native installer): Runs the Anthropic coding agent in the terminal.
- [codex](https://github.com/openai/codex) (macOS: Homebrew cask, Linux: npm): Runs the OpenAI coding agent in the terminal.
- [crit](https://github.com/tomasz-tomczyk/crit): Shows agent plans and code changes locally, so that you can review them and give feedback.
- [herdr](https://github.com/herdrdev/herdr): Runs AI coding agents in a terminal multiplexer.
- [pi](https://github.com/earendil-works/pi): Runs a coding agent with read, bash, edit and write tools.

Agent skills go to `~/.agents/skills`. `~/.claude/skills` is a symlink to this folder. Claude Code, Codex and pi read the global instructions in `~/.agents/AGENTS.md`. chezmoi gets each skill from the default branch of its repo and refreshes it each week (`home/.chezmoiexternal.toml.tmpl`):

- [ast-grep](https://github.com/ast-grep/agent-skill): Writes ast-grep rules for structural code search.
- [ast-grep-outline](https://github.com/ast-grep/agent-skill): Shows a structural map of source files with `ast-grep outline`.
- [caveman](https://github.com/JuliusBrussee/caveman): Makes agent replies short, but keeps the technical content.
- [last30days](https://github.com/mvanhorn/last30days-skill): Finds what people said about a topic in the last 30 days, on Reddit, X, YouTube, Hacker News and other sites.
- [lightpanda](https://github.com/lightpanda-io/agent-skill): Uses the Lightpanda headless browser through MCP, CLI fetch or CDP, in place of Chrome.
- [pandascript](https://github.com/lightpanda-io/agent-skill): Writes PandaScript files, which Lightpanda replays with no LLM calls.

With the ai and dev groups, an install script also adds the Lightpanda MCP server (`lightpanda mcp`) to Claude Code, Codex and pi. The agents keep their MCP servers in files that also hold app state, so the repo does not keep these files.
- [security-audit](https://github.com/cloudflare/security-audit-skill): Finds security problems in a codebase and gives the evidence and the fix.
- [simple-english](https://github.com/AminBlg/SimpleEnglish): Writes technical text with the rules of ASD-STE100 Simplified Technical English.

### docker group

- [colima](https://github.com/abiosoft/colima) (macOS): Runs container runtimes in a virtual machine with minimal setup.
- [docker](https://github.com/docker/cli) (macOS): Builds, runs and manages containers from the terminal.
- [docker-buildx](https://github.com/docker/buildx) (macOS): Builds images with BuildKit, as a plugin for the Docker CLI.
- [docker-compose](https://github.com/docker/compose) (macOS): Runs applications with many containers from one YAML file.
- [dockerd](https://github.com/moby/moby) (Linux: docker-ce, with the CLI, containerd, buildx and compose): Runs containers.

### Other installs

- [alacritty](https://github.com/alacritty/alacritty) (source build): Runs a fast terminal emulator with GPU rendering.
- [nerd-fonts](https://github.com/ryanoasis/nerd-fonts): Adds the Source Code Pro font with Nerd Font icons for the terminal.
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh): Gives some zsh libraries and plugins that antidote loads, without the framework.
- [rustup](https://github.com/rust-lang/rustup): Installs and updates the Rust toolchain.
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions): Suggests commands from your history while you type.
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting): Highlights commands in the zsh prompt while you type.

## Update

```sh
chezmoi update       # pull this repo and apply it
brew upgrade         # CLI tools
mise upgrade         # runtimes and mise tools
rustup update
antidote update      # zsh plugins
chezmoi apply --refresh-externals   # font and agent skills, before the refresh period ends
```

The Alacritty script runs on each `chezmoi apply` and builds only when a new release exists.

## Machine-specific settings and secrets

Do not put secrets in this repo. Put them in these files, which the repo does not contain:

- `~/.zshenv.local`: environment variables and API keys.
- `~/.zshrc.local`: interactive shell settings for one machine.

Enable the gitleaks pre-commit hook once per clone:

```sh
git config core.hooksPath .githooks
```

## Checks

`scripts/check.sh` renders the templates for Linux and macOS, amd64 and arm64, and each palette. Then it lints the rendered scripts and zsh files, lints the GitHub workflows and finds secrets. The Lint workflow runs it on each push and pull request. Run it before you commit:

```sh
scripts/check.sh
```

It needs the dev group tools. Set `GH_TOKEN` to let zizmor also run its online audits.

The Install workflow installs the dotfiles on a new Ubuntu container (amd64 and arm64) and on macOS (arm64) with `scripts/install-test.sh`. The test fails when a second `chezmoi apply` has changes to make, when a tool is missing, or when zsh or Neovim writes errors on startup. It runs when the install files change and once a week.

## Repo layout

- `home/`: the chezmoi source state (see `.chezmoiroot`).
- `home/.chezmoiscripts/`: install scripts, in the order of their numbers.
- `scripts/check.sh`, `scripts/install-test.sh`: the repo checks and the install test. `.github/workflows/`: the CI workflows.
- `home/.lazy-lock.json`: the plugin versions for Neovim. `~/.config/nvim/lazy-lock.json` is a symlink to this file, so `:Lazy update` changes it in the repo. Commit the change.

## License

[MIT-0](LICENSE). You can copy, change, and share these files. You do not have to keep a copyright notice.

Some files come from other projects. These files keep their own license, which is in a comment at the top of the file:

- `home/private_dot_config/bat/themes/SolarizedDarkPatched.tmTheme`: MIT, from [braver/Solarized](https://github.com/braver/Solarized).
