# iio-skills

Personal agent skills used with the Pivot repo: `unslop-code`, `unslop-writing`,
`product-thinking`, `council`, and the tstack delivery skills (`file-pr`,
`full-send`, `full-stop`, `modernize`), plus a few design and review skills.
Each skill is a folder with a `SKILL.md`.

## Install

```sh
git clone git@github.com:zmfltm/iio-skills.git ~/iio-skills
~/iio-skills/install.sh
git -C ~/iio-skills pull   # later, to update
```

`install.sh` links every skill into `~/.claude/skills` (Claude Code) and
`~/.agents/skills` (Codex). It skips names that already exist.

The tstack skills keep their own MIT license files.
