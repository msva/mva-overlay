# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit git-r3 vim-plugin

DESCRIPTION="vim plugin: 010 Editor template interpreter"
HOMEPAGE="https://github.com/d0c-s4vage/pfp-vim"
LICENSE="MIT"

EGIT_REPO_URI="https://github.com/d0c-s4vage/pfp-vim"

DEPEND="
	dev-python/pfp
	app-misc/010-editor-templates
"
