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
