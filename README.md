# dot

Dotfiles and tool installs for Linux (Ubuntu) and macOS, managed with [chezmoi](https://www.chezmoi.io/).

## Install on a new machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply <github-user>/dot
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
- **mise** installs node, ruby and go, and the tools that Homebrew does not have (`cargo:`, `go:`, `npm:`, `ubi:`, `pipx:` backends).
- **rustup** installs Rust.
- **antidote** loads the zsh plugins in `~/.zsh_plugins.txt`. These are some Oh My Zsh libraries and plugins, zsh-autosuggestions and zsh-syntax-highlighting.
- **Alacritty** comes from a Homebrew cask on macOS. On Linux, a script builds the latest release and installs its terminfo, desktop entry, man pages and completion.
- **SauceCodePro Nerd Font Mono** comes from a Homebrew cask on macOS. On Linux, chezmoi downloads it to `~/.local/share/fonts`.

The package list is in `home/.chezmoidata/packages.yaml`. Add or remove a tool there, then run `chezmoi apply`. The install script runs again when the list changes.

## Installed tools

Each entry shows the command name, with a link to the source repository of the tool. The core tools install on each machine. The other groups install only when you select them (see the prompts at the start).

### Core: files, search, diff

- [fd](https://github.com/sharkdp/fd): Finds files by name, as a fast and simple alternative to `find`.
- [bat](https://github.com/sharkdp/bat): Shows files with syntax highlighting and git changes, like `cat`.
- [bat-extras](https://github.com/eth-p/bat-extras): Adds scripts that use bat with other tools, for example `batgrep` and `batman`.
- [rg](https://github.com/BurntSushi/ripgrep): Searches the contents of files with a regular expression, fast and with `.gitignore` support.
- [rga](https://github.com/phiresky/ripgrep-all): Searches with ripgrep in PDFs, archives, Office documents and other file types.
- [delta](https://github.com/dandavison/delta): Shows `git` and `diff` output with syntax highlighting and line numbers.
- [difft](https://github.com/Wilfred/difftastic): Compares files by their syntax, not line by line.
- [eza](https://github.com/eza-community/eza): Lists files, as a maintained replacement for `ls`.
- [sd](https://github.com/chmln/sd): Finds and replaces text with a simpler syntax than `sed`.
- [hexyl](https://github.com/sharkdp/hexyl): Shows the bytes of a file in hexadecimal, with colors.
- [dust](https://github.com/bootandy/dust): Shows which directories use the most disk space, like `du`.
- [dysk](https://github.com/Canop/dysk): Shows the filesystems with their size and free space, like `df`.
- [ouch](https://github.com/ouch-org/ouch): Compresses and extracts archives in many formats with one command.
- [mc](https://github.com/MidnightCommander/mc): Manages files in two panels in the terminal.

### Core: processes

- [btm](https://github.com/ClementTsang/bottom): Shows CPU, memory, network and process usage in a terminal dashboard.
- [witr](https://github.com/pranshuparmar/witr): Explains why a process or port is active, from its chain of parent processes.
- [procs](https://github.com/dalance/procs): Lists processes, as a modern replacement for `ps`.

### Core: structured data

- [jq](https://github.com/jqlang/jq): Queries and changes JSON data.
- [jaq](https://github.com/01mf02/jaq): Runs jq filters, with a focus on correctness, speed and simplicity.
- [jqp](https://github.com/noahgorstein/jqp): Gives an interactive terminal UI to write and try jq queries.
- [fx](https://github.com/antonmedv/fx): Shows and explores JSON in the terminal.
- [jc](https://github.com/kellyjonbrazil/jc): Converts the output of common command-line tools to JSON.
- [gron](https://github.com/tomnomnom/gron): Converts JSON to single lines, so that you can search it with `grep`.
- [jqfmt](https://github.com/noperator/jqfmt): Formats jq filters.
- [yq](https://github.com/mikefarah/yq): Queries and changes YAML, JSON, XML, CSV and properties files.
- [mlr](https://github.com/johnkerl/miller): Processes CSV, TSV and JSON records by field name, like `awk`, `sed`, `cut` and `sort`.
- [sq](https://github.com/neilotoole/sq): Queries databases and data files with a jq-like language.

### Core: other tools

- [glow](https://github.com/charmbracelet/glow): Shows Markdown files in the terminal.
- [just](https://github.com/casey/just): Runs the commands of a project from a `justfile`.
- [magika](https://github.com/google/magika): Finds the content type of files with an AI model.
- [dive](https://github.com/wagoodman/dive): Shows the layers of a Docker image and the files in each layer.
- [http](https://github.com/httpie/cli): Sends HTTP requests with a simple syntax, as an alternative to `curl`.
- [pandoc](https://github.com/jgm/pandoc): Converts documents between markup formats, for example Markdown, HTML and DOCX.
- [hyperfine](https://github.com/sharkdp/hyperfine): Measures and compares the run time of commands.
- [tldr](https://github.com/tldr-pages/tlrc): Shows short command examples from the tldr pages.
- [croc](https://github.com/schollz/croc): Sends files from one computer to another computer securely.
- [ck](https://github.com/BeaconBay/ck): Searches code by meaning with embeddings, and by keywords.
- [fq](https://github.com/wader/fq): Queries binary formats with a jq-like language.
- [biodiff](https://github.com/8051Enthusiast/biodiff): Compares binary files with alignment algorithms from biology.
- [markitdown](https://github.com/microsoft/markitdown): Converts files such as PDF, Word and Excel documents to Markdown.
- [harlequin](https://github.com/tconbeer/harlequin): Gives an SQL IDE in the terminal.
- [bfif](https://github.com/trapexit/bfif) (Linux, x86_64): Finds images with a brute-force search.

### Core: shell, editor, runtimes

- [antidote](https://github.com/mattmc3/antidote): Loads zsh plugins from a list and makes one static plugin file.
- [starship](https://github.com/starship/starship): Shows a fast shell prompt with information about the current directory.
- [fzf](https://github.com/junegunn/fzf): Selects items from a list with fuzzy search, for example files and shell history.
- [zoxide](https://github.com/ajeetdsouza/zoxide): Changes to directories that you use frequently, as a smarter `cd`.
- [nvim](https://github.com/neovim/neovim): Edits text, as a Vim fork with a focus on extensibility.
- [tree-sitter](https://github.com/tree-sitter/tree-sitter): Builds the tree-sitter parsers that Neovim uses for syntax highlighting.
- [tmux](https://github.com/tmux/tmux): Runs many terminal sessions in one window and keeps them after you disconnect.
- [mise](https://github.com/jdx/mise): Installs runtimes and tools for each project, for example Node.js and Go.
- [uv](https://github.com/astral-sh/uv): Installs Python, Python packages and Python tools, fast.
- [cargo-binstall](https://github.com/cargo-bins/cargo-binstall): Installs Rust binaries from release archives, without a build.
- [node](https://github.com/nodejs/node) (LTS): Runs JavaScript outside of a browser.
- [ruby](https://github.com/ruby/ruby) (3.3): Runs programs in the Ruby programming language.
- [go](https://github.com/golang/go): Compiles and runs programs in the Go programming language.

### dev group

- [gh](https://github.com/cli/cli): Works with GitHub pull requests, issues and repositories from the terminal.
- [ast-grep](https://github.com/ast-grep/ast-grep): Searches, lints and rewrites code by its syntax tree.
- [taplo](https://github.com/tamasfe/taplo): Formats and validates TOML files.
- [cloc](https://github.com/AlDanial/cloc): Counts the lines of code, comments and blank lines for each language.
- [gitleaks](https://github.com/gitleaks/gitleaks): Finds secrets, such as API keys, in git repositories.
- [golangci-lint](https://github.com/golangci/golangci-lint): Runs many Go linters with one command.
- [gofumpt](https://github.com/mvdan/gofumpt): Formats Go code with stricter rules than `gofmt`.
- [goimports](https://github.com/golang/tools): Formats Go code and adds or removes import lines.
- [govulncheck](https://github.com/golang/vuln): Finds known vulnerabilities in Go code and its dependencies.
- [osv-scanner](https://github.com/google/osv-scanner): Finds known vulnerabilities in project dependencies with the OSV database.
- [syft](https://github.com/anchore/syft): Makes a software bill of materials (SBOM) from container images and file systems.
- [semgrep](https://github.com/semgrep/semgrep): Finds bugs and security problems in code with pattern rules.
- [git-filter-repo](https://github.com/newren/git-filter-repo): Rewrites the history of a git repository.
- [ccache](https://github.com/ccache/ccache): Makes C and C++ builds faster with a compiler cache.
- [cargo-deny](https://github.com/EmbarkStudios/cargo-deny): Lints the dependencies of Rust projects, for example their licenses and security advisories.
- [cargo-llvm-cov](https://github.com/taiki-e/cargo-llvm-cov): Measures the code coverage of Rust tests with LLVM.
- [cargo-insta](https://github.com/mitsuhiko/insta): Reviews and updates snapshot tests in Rust.
- [cargo-mutants](https://github.com/sourcefrog/cargo-mutants): Adds bugs to Rust code to find out if the tests catch them.
- [cargo-fuzz](https://github.com/rust-fuzz/cargo-fuzz): Runs fuzz tests for Rust code.
- [cargo-geiger](https://github.com/geiger-rs/cargo-geiger): Finds unsafe Rust code in a crate and its dependencies.
- [cargo-auditable](https://github.com/rust-secure-code/cargo-auditable): Puts the dependency list into Rust binaries, so that you can audit them.
- [wasm-pack](https://github.com/wasm-bindgen/wasm-pack): Builds Rust code into WebAssembly packages for JavaScript.
- [pnpm](https://github.com/pnpm/pnpm): Installs JavaScript packages fast and with less disk space.
- [bun](https://github.com/oven-sh/bun): Runs, bundles, tests and installs JavaScript and TypeScript code.
- [deno](https://github.com/denoland/deno): Runs JavaScript and TypeScript in a secure runtime.
- [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server): Gives editors TypeScript and JavaScript language features through LSP.
- [dagger](https://github.com/dagger/dagger): Runs CI/CD pipelines as code, on your computer and in CI.
- [svu](https://github.com/caarlos0/svu): Calculates the next semantic version from git tags and commits.
- [asciinema](https://github.com/asciinema/asciinema): Records terminal sessions and shares them.
- [agg](https://github.com/asciinema/agg): Converts asciinema recordings to GIF files.
- [mdbook](https://github.com/rust-lang/mdBook): Makes online books from Markdown files.
- [yt-dlp](https://github.com/yt-dlp/yt-dlp): Downloads audio and video from many websites.
- [lazygit](https://github.com/jesseduffield/lazygit): Gives a terminal UI for git commands.
- [act](https://github.com/nektos/act): Runs GitHub Actions workflows on your computer.
- [ruff](https://github.com/astral-sh/ruff): Lints and formats Python code, fast.
- [oha](https://github.com/hatoo/oha): Sends HTTP load to a web server and shows the results live.
- [cargo-machete](https://github.com/bnjbvr/cargo-machete): Finds unused dependencies in Rust projects.
- [mdbook-mermaid](https://github.com/badboy/mdbook-mermaid): Adds Mermaid diagrams to mdBook.
- [git-chglog](https://github.com/git-chglog/git-chglog): Makes a CHANGELOG from git tags and commits.
- [gremlins](https://github.com/go-gremlins/gremlins): Runs mutation tests for Go code.
- [lightpanda](https://github.com/lightpanda-io/browser): Runs a headless browser for automation and AI agents.

### ai group

- [herdr](https://github.com/herdrdev/herdr): Runs AI coding agents in a terminal multiplexer.
- [crit](https://github.com/tomasz-tomczyk/crit): Shows agent plans and code changes locally, so that you can review them and give feedback.
- [claude](https://github.com/anthropics/claude-code) (macOS: Homebrew cask, Linux: native installer): Runs the Anthropic coding agent in the terminal.
- [codex](https://github.com/openai/codex) (macOS: Homebrew cask, Linux: npm): Runs the OpenAI coding agent in the terminal.
- [pi](https://github.com/earendil-works/pi): Runs a coding agent with read, bash, edit and write tools.
- [caveman](https://github.com/JuliusBrussee/caveman): Wraps coding agents with context compression and token metering.

### docker group

- [dockerd](https://github.com/moby/moby) (Linux: docker-ce, with the CLI, containerd, buildx and compose): Runs containers.
- [colima](https://github.com/abiosoft/colima) (macOS): Runs container runtimes in a virtual machine with minimal setup.
- [docker](https://github.com/docker/cli) (macOS): Builds, runs and manages containers from the terminal.
- [docker-compose](https://github.com/docker/compose) (macOS): Runs applications with many containers from one YAML file.
- [docker-buildx](https://github.com/docker/buildx) (macOS): Builds images with BuildKit, as a plugin for the Docker CLI.

### Other installs

- [rustup](https://github.com/rust-lang/rustup): Installs and updates the Rust toolchain.
- [alacritty](https://github.com/alacritty/alacritty) (macOS: Homebrew cask, Linux: source build): Runs a fast terminal emulator with GPU rendering.
- [SauceCodePro Nerd Font](https://github.com/ryanoasis/nerd-fonts): Adds the Source Code Pro font with Nerd Font icons for the terminal.
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh): Gives some zsh libraries and plugins that antidote loads, without the framework.
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions): Suggests commands from your history while you type.
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting): Highlights commands in the zsh prompt while you type.

## Update

```sh
chezmoi update       # pull this repo and apply it
brew upgrade         # CLI tools
mise upgrade         # runtimes and mise tools
rustup update
antidote update      # zsh plugins
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

## Repo layout

- `home/`: the chezmoi source state (see `.chezmoiroot`).
- `home/.chezmoiscripts/`: install scripts, in the order of their numbers.
- `home/.lazy-lock.json`: the plugin versions for Neovim. `~/.config/nvim/lazy-lock.json` is a symlink to this file, so `:Lazy update` changes it in the repo. Commit the change.
