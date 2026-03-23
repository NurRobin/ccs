VERSION := $(shell grep -oP 'CCS_VERSION="\K[^"]+' ccs)

.PHONY: build clean version bump-patch bump-minor bump-major

build:
	@bash build-deb.sh

clean:
	@rm -rf dist/

version:
	@echo $(VERSION)

bump-patch:
	@IFS='.' read -r ma mi pa <<< "$(VERSION)"; \
	NEW="$$ma.$$mi.$$((pa + 1))"; \
	sed -i "s/CCS_VERSION=\"$(VERSION)\"/CCS_VERSION=\"$$NEW\"/" ccs; \
	sed -i "s/^Version:.*/Version: $$NEW/" debian/control; \
	echo "$(VERSION) -> $$NEW"

bump-minor:
	@IFS='.' read -r ma mi pa <<< "$(VERSION)"; \
	NEW="$$ma.$$((mi + 1)).0"; \
	sed -i "s/CCS_VERSION=\"$(VERSION)\"/CCS_VERSION=\"$$NEW\"/" ccs; \
	sed -i "s/^Version:.*/Version: $$NEW/" debian/control; \
	echo "$(VERSION) -> $$NEW"

bump-major:
	@IFS='.' read -r ma mi pa <<< "$(VERSION)"; \
	NEW="$$((ma + 1)).0.0"; \
	sed -i "s/CCS_VERSION=\"$(VERSION)\"/CCS_VERSION=\"$$NEW\"/" ccs; \
	sed -i "s/^Version:.*/Version: $$NEW/" debian/control; \
	echo "$(VERSION) -> $$NEW"
