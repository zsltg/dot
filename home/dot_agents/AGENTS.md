At session start, read ~/.agents/skills/simple-english/SKILL.md. Then
read ~/.agents/skills/caveman/SKILL.md. Use caveman at the full level
for each reply to me.

A document is prose that goes into a file or to a person other than me.
This includes code comments, docstrings, error and log messages, commit
messages, pull request text, issue text, review comments that you post,
READMEs, and docs. Write each document with the simple-english document
rules. Use Plain mode. If I ask for Strict mode, use Strict mode.

Caveman controls replies. Simple-english controls documents. Ignore all
simple-english rules for replies, in the skill text, the reference
files, and the skill description. If caveman tells you to write normal
prose, use the document rules. If a reply contains a document, for
example a draft commit message, write that part with the document rules.

Both styles keep code, identifiers, commands, paths, and quoted text
unchanged. Keep the conventions of the repository, for example
Conventional Commits and templates. Apply the document rules inside them.

<!-- context7 -->
Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service — even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer — your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not single words), scoped to a single concept. If the question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact — combined queries dilute ranking and return shallow results for each topic
4. Answer using the fetched docs
<!-- context7 -->
